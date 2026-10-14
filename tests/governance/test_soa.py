"""Keep Annex A selection and gate traceability complete without scoring compliance."""

from collections import Counter, defaultdict
from pathlib import Path
import re

import yaml

REPO = Path(__file__).resolve().parents[2]
SOA = REPO / "Governance/ISMS/04-controls-and-soa/statement-of-applicability.md"
MAPPING = REPO / "Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml"
GAPS = SOA.with_name("control-gap-analysis.md")
STATUS = {"Implemented", "Partial", "Gated design", "Designed", "Planned"}
OWNERS = {
    "Managing Director", "CISO", "Cloud Platform Engineering",
    "Compliance & Risk Management", "Security Operations",
    "Product & Engineering", "HR & Administration",
}
EXPECTED = {
    f"A.{group}.{number}"
    for group, count in ((5, 37), (6, 8), (7, 14), (8, 34))
    for number in range(1, count + 1)
}


def control_rows():
    return [
        [cell.strip() for cell in line.strip().strip("|").split("|")]
        for line in SOA.read_text(encoding="utf-8").splitlines()
        if re.match(r"\| A\.\d+\.\d+ \|", line)
    ]


def test_all_annex_a_controls_have_one_selection():
    rows = control_rows()
    assert len(rows) == len(EXPECTED)
    assert Counter(row[0] for row in rows) == Counter({key: 1 for key in EXPECTED})
    for row in rows:
        assert len(row) == 7, row
        control, label, selection, status, evidence, owner, remaining = row
        assert label, control
        assert re.fullmatch(r"(?:Yes|No) — \S.+", selection), control
        assert status in STATUS, control
        assert owner in OWNERS, control
        if status != "Planned":
            assert re.search(r"\[[^\]]+\]\([^)]+\)", evidence), control
        if selection.startswith("No"):
            assert "exclu" in selection.lower(), f"{control}: explain the exclusion"
        if status != "Implemented":
            match = re.match(r"(G\d{2}): \S.+", remaining)
            assert match, f"{control}: name the gap and missing evidence"
            assert f"| {match[1]} |" in GAPS.read_text(encoding="utf-8")


def test_gate_mapping_is_bidirectionally_traceable():
    controls = yaml.safe_load(MAPPING.read_text(encoding="utf-8"))["controls"]
    expected_mapping = defaultdict(set)
    for control, definition in controls.items():
        for annex_id in definition["frameworks"]["iso27001"]:
            assert annex_id in EXPECTED, f"Unknown Annex A ID on {control}"
            expected_mapping[annex_id].add(control)

    # A deleted, added or reassigned metadata control must change its SoA row.
    for row in control_rows():
        cited = set(re.findall(r"`([A-Z][A-Z0-9_]+)`", row[4]))
        assert cited == expected_mapping[row[0]], row[0]

    # Keep the second traceability table synchronized too; a prose count alone
    # would miss relationships silently disappearing from the gap analysis.
    gap_rows = [
        [cell.strip() for cell in line.strip().strip("|").split("|")]
        for line in GAPS.read_text(encoding="utf-8").splitlines()
        if re.match(r"\| A\.\d+\.\d+ \|", line)
    ]
    mapped = {key: value for key, value in expected_mapping.items() if value}
    assert Counter(row[0] for row in gap_rows) == Counter({key: 1 for key in mapped})
    for row in gap_rows:
        assert set(re.findall(r"`([A-Z][A-Z0-9_]+)`", row[1])) == mapped[row[0]]


def test_status_summary_matches_selection_rows():
    actual = Counter(row[3] for row in control_rows())
    text = SOA.read_text(encoding="utf-8")
    for status in STATUS:
        matches = re.findall(rf"^\| {re.escape(status)} \| (\d+) \|$", text, re.M)
        assert matches == [str(actual[status])], status
