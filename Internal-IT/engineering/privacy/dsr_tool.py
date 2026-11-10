"""Data subject request tool: find, export and erase one person's records.

Runs against a SQLite database whose tables are modelled on the data
categories in Governance/GDPR/record-of-processing-activities.md (PA-01 to
PA-04, PP-01). It is exercised against synthetic fixture data only. It is not
connected to any deployed system.

Rules built in:
- Strong identifiers (email, user id, employee id, username) match. A name
  alone is only a weak match: it is reported and never erased.
- A row with legal_hold = 1 is kept and reported, other rows are still erased.
- PP-01 rows (processor activity) are erased only when the caller states a
  documented controller instruction (Art. 28(3)(a)).
- The audit log holds request id, table, row id, outcome and counts. It never
  holds the identifier or any column value.
- Not searched, and said so in every report: backups, Git history, provider logs.
"""

import argparse
import json
import sqlite3
import sys
from datetime import datetime, timezone

# table -> activity, erase strategy, identifier columns (kind), free-text columns
SCHEMA = {
    "personnel": {
        "activity": "PA-01",
        "strategy": "delete",
        "columns": {"emp_id": "emp_id", "work_email": "email", "display_name": "name"},
        "freetext": [],
    },
    "repo_metadata": {
        "activity": "PA-02",
        # Git history cannot be deleted by a database tool: identity fields are replaced.
        "strategy": "anonymise",
        "anonymise": {"author_name": "erased", "author_email": "erased@example.invalid",
                      "github_username": "erased"},
        "columns": {"author_email": "email", "github_username": "username",
                    "author_name": "name"},
        "freetext": ["pr_comment"],
    },
    "security_logs": {
        "activity": "PA-03",
        "strategy": "delete",
        "columns": {"user_id": "user_id"},
        "freetext": [],
    },
    "training_records": {
        "activity": "PA-04",
        "strategy": "delete",
        "columns": {"emp_id": "emp_id", "display_name": "name"},
        "freetext": [],
    },
    "portal_users": {
        "activity": "PP-01",
        "strategy": "delete",
        "columns": {"user_id": "user_id", "email": "email", "name": "name"},
        "freetext": [],
    },
    "portal_evidence": {
        "activity": "PP-01",
        "strategy": "redact",
        "columns": {"uploaded_by": "user_id"},
        "freetext": ["notes"],
    },
}

NOT_SEARCHED = [
    "backups and snapshots",
    "Git history of the real repository",
    "provider-side logs (AWS, Microsoft, GitHub)",
    "copies outside the database (exports, tickets, laptops)",
]
STRONG = {"email", "user_id", "emp_id", "username"}
REDACTION = "[erased]"


class Subject:
    """Identifiers of the person making the request, as verified by the caller."""

    def __init__(self, emails=(), user_ids=(), emp_ids=(), usernames=(), names=()):
        self.values = {
            "email": {e.strip().lower() for e in emails if e.strip()},
            "user_id": {u.strip() for u in user_ids if u.strip()},
            "emp_id": {e.strip() for e in emp_ids if e.strip()},
            "username": {u.strip().lower() for u in usernames if u.strip()},
            "name": {n.strip().lower() for n in names if n.strip()},
        }
        if not any(self.values[k] for k in STRONG):
            raise ValueError("at least one strong identifier (email, user id, employee id, username) is required")

    def matches(self, kind, value):
        if value is None:
            return False
        v = str(value).strip()
        if kind in ("email", "username", "name"):
            v = v.lower()
        return v in self.values.get(kind, ())

    def freetext_terms(self):
        return sorted(self.values["email"] | self.values["username"])


def _now():
    return datetime.now(timezone.utc).isoformat(timespec="seconds")


def connect(path):
    conn = sqlite3.connect(path)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA secure_delete = ON")
    return conn


def _table_exists(conn, table):
    return conn.execute("SELECT 1 FROM sqlite_master WHERE type='table' AND name=?", (table,)).fetchone() is not None


def find(conn, subject):
    """Return a list of match dicts. Never changes the database."""
    out = []
    for table, spec in SCHEMA.items():
        if not _table_exists(conn, table):
            continue
        for row in conn.execute(f"SELECT rowid AS _rid, * FROM {table}"):
            strong, weak, free = [], [], []
            for col, kind in spec["columns"].items():
                if subject.matches(kind, row[col]):
                    (strong if kind in STRONG else weak).append(col)
            for col in spec["freetext"]:
                text = (row[col] or "").lower()
                if any(t in text for t in subject.freetext_terms()):
                    free.append(col)
            if strong or free:
                strength = "strong"
            elif weak:
                strength = "weak"
            else:
                continue
            out.append({
                "table": table, "rowid": row["_rid"], "activity": spec["activity"],
                "strength": strength, "columns": strong + weak, "freetext_columns": free,
                "legal_hold": bool(row["legal_hold"]) if "legal_hold" in row.keys() else False,
            })
    return out


def export(conn, subject):
    """Access request: return the subject's strong-match rows. Changes nothing."""
    result = {}
    for m in find(conn, subject):
        if m["strength"] != "strong":
            continue
        row = conn.execute(f"SELECT * FROM {m['table']} WHERE rowid = ?", (m["rowid"],)).fetchone()
        result.setdefault(m["table"], []).append({k: row[k] for k in row.keys()})
    return {"records": result, "not_searched": NOT_SEARCHED,
            "weak_matches_for_manual_review": [
                {"table": m["table"], "rowid": m["rowid"]} for m in find(conn, subject) if m["strength"] == "weak"]}


def _redact_text(text, terms):
    out = text or ""
    for t in terms:
        low, start = out.lower(), 0
        while True:
            i = low.find(t, start)
            if i < 0:
                break
            out = out[:i] + REDACTION + out[i + len(t):]
            low = out.lower()
            start = i + len(REDACTION)
    return out


def erase(conn, subject, *, request_id, audit_log, controller_instruction=False, dry_run=False, now=_now):
    """Erase strong matches. Returns a report. Writes one audit line per decision."""
    report = {"request_id": request_id, "dry_run": dry_run, "erased": [], "held": [],
              "needs_instruction": [], "weak_not_erased": [], "not_searched": NOT_SEARCHED}
    events = []
    terms = subject.freetext_terms()
    for m in find(conn, subject):
        ref = {"table": m["table"], "rowid": m["rowid"], "activity": m["activity"]}
        spec = SCHEMA[m["table"]]
        if m["strength"] == "weak":
            report["weak_not_erased"].append(ref)
            events.append({**ref, "outcome": "weak_match_not_erased"})
            continue
        if m["legal_hold"]:
            report["held"].append(ref)
            events.append({**ref, "outcome": "kept_legal_hold"})
            continue
        if m["activity"] == "PP-01" and not controller_instruction:
            report["needs_instruction"].append(ref)
            events.append({**ref, "outcome": "refused_no_controller_instruction"})
            continue
        if not dry_run:
            if spec["strategy"] == "delete":
                conn.execute(f"DELETE FROM {m['table']} WHERE rowid = ?", (m["rowid"],))
            elif spec["strategy"] == "anonymise":
                sets = dict(spec["anonymise"])
                for col in spec["freetext"]:
                    cur = conn.execute(f"SELECT {col} FROM {m['table']} WHERE rowid=?", (m["rowid"],)).fetchone()[0]
                    sets[col] = _redact_text(cur, terms)
                _update(conn, m["table"], m["rowid"], sets)
            elif spec["strategy"] == "redact":
                sets = {}
                for col in spec["freetext"]:
                    cur = conn.execute(f"SELECT {col} FROM {m['table']} WHERE rowid=?", (m["rowid"],)).fetchone()[0]
                    sets[col] = _redact_text(cur, terms)
                # uploaded_by is a strong id: replace it so the row no longer points at the person
                for col, kind in spec["columns"].items():
                    if subject.matches(kind, conn.execute(
                            f"SELECT {col} FROM {m['table']} WHERE rowid=?", (m["rowid"],)).fetchone()[0]):
                        sets[col] = "erased"
                _update(conn, m["table"], m["rowid"], sets)
        report["erased"].append({**ref, "strategy": spec["strategy"]})
        events.append({**ref, "outcome": "would_erase" if dry_run else "erased", "strategy": spec["strategy"]})
    if not dry_run:
        conn.commit()
    remaining = [m for m in find(conn, subject) if m["strength"] == "strong" and not m["legal_hold"]
                 and not (m["activity"] == "PP-01" and not controller_instruction)]
    report["verified_clean"] = (not remaining) if not dry_run else None
    events.append({"outcome": "summary", "erased": len(report["erased"]), "held": len(report["held"]),
                   "needs_instruction": len(report["needs_instruction"]),
                   "weak_not_erased": len(report["weak_not_erased"]), "dry_run": dry_run})
    with open(audit_log, "a", encoding="utf-8") as fh:
        for ev in events:
            fh.write(json.dumps({"ts": now(), "request_id": request_id, **ev}, sort_keys=True) + "\n")
    return report


def _update(conn, table, rowid, sets):
    cols = ", ".join(f"{c} = ?" for c in sets)
    conn.execute(f"UPDATE {table} SET {cols} WHERE rowid = ?", (*sets.values(), rowid))


def build_fixture(conn, data):
    """Create tables and load rows from a dict {table: [row dicts]} (loaded from JSON)."""
    ddl = {
        "personnel": "emp_id TEXT, work_email TEXT, display_name TEXT, role TEXT, department TEXT, start_date TEXT",
        "repo_metadata": "commit_sha TEXT, author_name TEXT, author_email TEXT, github_username TEXT, pr_comment TEXT",
        "security_logs": "ts TEXT, ip_address TEXT, user_id TEXT, request_path TEXT",
        "training_records": "emp_id TEXT, display_name TEXT, course TEXT, completed TEXT",
        "portal_users": "customer_id TEXT, user_id TEXT, name TEXT, email TEXT, role TEXT",
        "portal_evidence": "customer_id TEXT, evidence_id TEXT, uploaded_by TEXT, filename TEXT, notes TEXT",
    }
    for table, cols in ddl.items():
        conn.execute(f"CREATE TABLE {table} ({cols}, legal_hold INTEGER DEFAULT 0, hold_reason TEXT)")
        for row in data.get(table, []):
            keys = list(row)
            conn.execute(f"INSERT INTO {table} ({', '.join(keys)}) VALUES ({', '.join('?' * len(keys))})",
                         [row[k] for k in keys])
    conn.commit()


def main(argv=None):
    p = argparse.ArgumentParser(description="Find, export or erase one data subject's records (fixture data only)")
    p.add_argument("action", choices=["find", "export", "erase"])
    p.add_argument("--db", required=True)
    p.add_argument("--email", action="append", default=[])
    p.add_argument("--user-id", action="append", default=[])
    p.add_argument("--emp-id", action="append", default=[])
    p.add_argument("--username", action="append", default=[])
    p.add_argument("--request-id", default="")
    p.add_argument("--audit-log", default="dsr-audit.jsonl")
    p.add_argument("--controller-instruction", action="store_true",
                   help="a documented controller instruction exists for PP-01 data (Art. 28(3)(a))")
    p.add_argument("--dry-run", action="store_true")
    a = p.parse_args(argv)
    subject = Subject(emails=a.email, user_ids=a.user_id, emp_ids=a.emp_id, usernames=a.username)
    conn = connect(a.db)
    if a.action == "find":
        out = find(conn, subject)
    elif a.action == "export":
        out = export(conn, subject)
    else:
        if not a.request_id:
            p.error("--request-id is required for erase")
        out = erase(conn, subject, request_id=a.request_id, audit_log=a.audit_log,
                    controller_instruction=a.controller_instruction, dry_run=a.dry_run)
    json.dump(out, sys.stdout, indent=2)
    sys.stdout.write("\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
