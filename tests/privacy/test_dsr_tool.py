"""DSR tool against synthetic fixture data. Not a test of any deployed system."""

import json
import sqlite3
import sys
from pathlib import Path

import pytest

REPO = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(REPO / "Internal-IT/engineering/privacy"))
import dsr_tool as t  # noqa: E402

FIXTURE = {
    "personnel": [
        {"emp_id": "T-001", "work_email": "alex.example@example.invalid", "display_name": "Alex Example", "role": "Tester"},
        {"emp_id": "T-002", "work_email": "alex.namesake@example.invalid", "display_name": "Alex Example", "role": "Other"},
    ],
    "repo_metadata": [
        {"commit_sha": "c1", "author_name": "Alex Example", "author_email": "alex.example@example.invalid",
         "github_username": "alex-x", "pr_comment": "ping alex.example@example.invalid for review"},
        {"commit_sha": "c2", "author_name": "Sam Other", "author_email": "sam@example.invalid",
         "github_username": "sam-o", "pr_comment": "looks fine"},
    ],
    "security_logs": [
        {"ts": "2026-01-01T00:00:00Z", "ip_address": "192.0.2.10", "user_id": "u-100", "request_path": "/a"},
        {"ts": "2026-01-01T00:01:00Z", "ip_address": "192.0.2.11", "user_id": "u-200", "request_path": "/b"},
    ],
    "training_records": [
        {"emp_id": "T-001", "display_name": "Alex Example", "course": "Awareness", "completed": "2026-02-01"},
    ],
    "portal_users": [
        {"customer_id": "cust-a", "user_id": "u-100", "name": "Alex Example", "email": "alex.example@example.invalid", "role": "viewer"},
        {"customer_id": "cust-a", "user_id": "u-200", "name": "Sam Other", "email": "sam@example.invalid", "role": "viewer"},
    ],
    "portal_evidence": [
        {"customer_id": "cust-a", "evidence_id": "e1", "uploaded_by": "u-100", "filename": "x.pdf",
         "notes": "Contact Alex.Example@example.invalid about this"},
        {"customer_id": "cust-a", "evidence_id": "e2", "uploaded_by": "u-200", "filename": "y.pdf", "notes": "none"},
        {"customer_id": "cust-a", "evidence_id": "e3", "uploaded_by": "u-100", "filename": "held.pdf",
         "notes": "under dispute", "legal_hold": 1, "hold_reason": "dispute"},
    ],
}
EMAIL = "alex.example@example.invalid"


@pytest.fixture
def conn(tmp_path):
    db = t.connect(str(tmp_path / "fixture.sqlite"))
    t.build_fixture(db, json.loads(json.dumps(FIXTURE)))
    return db


@pytest.fixture
def subject():
    return t.Subject(emails=[EMAIL], user_ids=["u-100"], emp_ids=["T-001"], usernames=["alex-x"])


def count(conn, table):
    return conn.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]


def snapshot(conn):
    return {tb: [tuple(r) for r in conn.execute(f"SELECT * FROM {tb} ORDER BY rowid")] for tb in t.SCHEMA}


def test_find_uses_strong_identifiers_across_tables(conn, subject):
    tables = {m["table"] for m in t.find(conn, subject) if m["strength"] == "strong"}
    assert tables == {"personnel", "repo_metadata", "security_logs", "training_records", "portal_users", "portal_evidence"}


def test_name_only_match_is_weak_and_not_erased(conn, tmp_path):
    only_name = t.Subject(emails=["nobody@example.invalid"], names=["Alex Example"])
    matches = t.find(conn, only_name)
    assert matches and all(m["strength"] == "weak" for m in matches)
    report = t.erase(conn, only_name, request_id="R-0", audit_log=tmp_path / "a.jsonl", controller_instruction=True)
    assert report["erased"] == [] and report["weak_not_erased"]
    assert count(conn, "personnel") == 2


def test_near_miss_email_is_untouched(conn, tmp_path):
    other = t.Subject(emails=["alex.example@example.invalid.evil"])
    assert t.find(conn, other) == []
    other2 = t.Subject(emails=["alex.exampl@example.invalid"])
    assert t.find(conn, other2) == []


def test_export_changes_nothing(conn, subject):
    before = snapshot(conn)
    out = t.export(conn, subject)
    assert snapshot(conn) == before
    assert out["records"]["personnel"][0]["emp_id"] == "T-001"
    assert out["not_searched"]


def test_dry_run_changes_nothing_and_writes_audit(conn, subject, tmp_path):
    before = snapshot(conn)
    log = tmp_path / "a.jsonl"
    r = t.erase(conn, subject, request_id="R-1", audit_log=log, controller_instruction=True, dry_run=True)
    assert snapshot(conn) == before and r["erased"] and r["verified_clean"] is None
    assert log.read_text().strip()


def test_erase_with_instruction_leaves_others_and_respects_hold(conn, subject, tmp_path):
    log = tmp_path / "a.jsonl"
    r = t.erase(conn, subject, request_id="R-2", audit_log=log, controller_instruction=True)
    assert count(conn, "personnel") == 1  # namesake T-002 kept
    assert conn.execute("SELECT emp_id FROM personnel").fetchone()[0] == "T-002"
    assert count(conn, "security_logs") == 1 and count(conn, "training_records") == 0
    assert count(conn, "portal_users") == 1
    # git-history style table is anonymised, not deleted
    row = conn.execute("SELECT * FROM repo_metadata WHERE commit_sha='c1'").fetchone()
    assert row["author_email"] == "erased@example.invalid" and "example.invalid" not in row["pr_comment"].replace("erased@", "")
    assert EMAIL not in row["pr_comment"].lower()
    # free text redacted and pointer replaced
    e1 = conn.execute("SELECT * FROM portal_evidence WHERE evidence_id='e1'").fetchone()
    assert EMAIL not in e1["notes"].lower() and e1["uploaded_by"] == "erased"
    # held row kept intact and reported
    e3 = conn.execute("SELECT * FROM portal_evidence WHERE evidence_id='e3'").fetchone()
    assert e3["uploaded_by"] == "u-100" and len(r["held"]) == 1
    # unrelated subject's rows untouched
    assert conn.execute("SELECT notes FROM portal_evidence WHERE evidence_id='e2'").fetchone()[0] == "none"
    assert r["verified_clean"] is True


def test_pp01_needs_controller_instruction(conn, subject, tmp_path):
    r = t.erase(conn, subject, request_id="R-3", audit_log=tmp_path / "a.jsonl")
    assert r["needs_instruction"]
    assert count(conn, "portal_users") == 2  # processor data untouched
    assert count(conn, "personnel") == 1      # controller data erased


def test_audit_log_has_no_identifier_or_values(conn, subject, tmp_path):
    log = tmp_path / "a.jsonl"
    t.erase(conn, subject, request_id="R-4", audit_log=log, controller_instruction=True,
            now=lambda: "2026-11-10T00:00:00+00:00")
    text = log.read_text()
    for secret in (EMAIL, "u-100", "T-001", "alex-x", "Alex Example", "192.0.2.10"):
        assert secret.lower() not in text.lower()
    lines = [json.loads(x) for x in text.splitlines()]
    assert all(x["request_id"] == "R-4" and x["ts"] == "2026-11-10T00:00:00+00:00" for x in lines)
    assert lines[-1]["outcome"] == "summary" and lines[-1]["held"] == 1


def test_subject_without_strong_identifier_is_refused():
    with pytest.raises(ValueError):
        t.Subject(names=["Alex Example"])


def test_secure_delete_pragma_is_on(conn):
    assert conn.execute("PRAGMA secure_delete").fetchone()[0] == 1


def test_cli_find(tmp_path, capsys):
    path = tmp_path / "cli.sqlite"
    c = t.connect(str(path))
    t.build_fixture(c, json.loads(json.dumps(FIXTURE)))
    c.close()
    assert t.main(["find", "--db", str(path), "--email", EMAIL]) == 0
    assert "personnel" in capsys.readouterr().out
