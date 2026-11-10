"""ADR-0006: simulated records are bannered and never support an Implemented claim."""

import re
from pathlib import Path

import pytest

REPO = Path(__file__).resolve().parents[2]
GOVERNANCE = REPO / "Governance"
SIMULATED = sorted(
    p for p in (GOVERNANCE / "records/simulated").rglob("*.md") if p.name != "README.md"
)
REAL = sorted(
    p for p in (GOVERNANCE / "records/real").rglob("*.md") if p.name != "README.md"
)
DOCS = sorted(GOVERNANCE.rglob("*.md"))
EMPLOYEES = set(
    re.findall(r"EMP-\d{3}", (REPO / "organization/personnel-register.md").read_text(encoding="utf-8"))
)


def head(path, lines=8):
    return "\n".join(path.read_text(encoding="utf-8").splitlines()[:lines])


def cells(line):
    return [c.strip().strip("*") for c in line.strip().strip("|").split("|")]


@pytest.mark.parametrize("record", SIMULATED, ids=lambda p: p.name)
def test_simulated_record_is_labelled(record):
    text = record.read_text(encoding="utf-8")
    assert "**SIMULATED RECORD.**" in head(record), "banner missing under the title"
    assert record.name.startswith("SIM-")
    for field in ("Record ID", "Authored", "Scenario date", "Procedure exercised"):
        assert re.search(rf"^\| {field} \|", text, re.M), f"field missing: {field}"
    assert "## What this does not show" in text
    unknown = set(re.findall(r"EMP-\d{3}", text)) - EMPLOYEES
    assert not unknown, f"not in the personnel register: {sorted(unknown)}"


@pytest.mark.parametrize("record", REAL, ids=lambda p: p.name)
def test_real_record_is_labelled(record):
    text = record.read_text(encoding="utf-8")
    assert "**REAL RECORD.**" in head(record), "banner missing under the title"
    assert record.name.startswith("REAL-")
    for field in ("Record ID", "Performed", "Performed by"):
        assert re.search(rf"^\| {field} \|", text, re.M), f"field missing: {field}"
    assert "SIMULATED RECORD" not in text


@pytest.mark.parametrize("doc", DOCS, ids=lambda p: str(p.relative_to(REPO)))
def test_status_rows_cite_the_right_store(doc):
    for line in doc.read_text(encoding="utf-8").splitlines():
        if not line.startswith("|"):
            continue
        row = cells(line)
        if "Implemented" in row:
            assert "records/simulated" not in line, f"Implemented row cites a simulated record: {line[:80]}"
        if "Simulated operation" in row and not doc.match("**/ADR/*") and len(row) > 3:
            assert "records/simulated/" in line, f"no simulated record linked: {line[:80]}"
