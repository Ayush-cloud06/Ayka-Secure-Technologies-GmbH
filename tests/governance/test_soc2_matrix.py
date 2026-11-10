"""SOC 2 control matrix: unique IDs, known statuses, honest summary counts, pack coverage."""

import re
from collections import Counter
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
SOC2 = REPO / "Governance/SOC2"
MATRIX = SOC2 / "03-control-matrix.md"
MAPPING = SOC2 / "02-trust-services-criteria-mapping.md"
PACK = SOC2 / "06-type1-readiness-pack.md"
VOCAB = [
    "Implemented", "Partial", "Simulated operation", "Gated design",
    "Designed", "Planned", "Carved out",
]


def cells(line):
    return [c.strip() for c in line.strip().strip("|").split("|")]


def control_rows():
    return [
        cells(line)
        for line in MATRIX.read_text(encoding="utf-8").splitlines()
        if re.match(r"\| [A-Z]{2}-\d\d \|", line)
    ]


def status(row):
    match = re.match(r"\*\*([^*]+)\*\*", row[-1])
    assert match, f"{row[0]}: last cell must start with a bold status"
    return match.group(1)


def test_ids_unique_and_65():
    ids = [r[0] for r in control_rows()]
    assert len(ids) == len(set(ids)) == 65


def test_status_in_vocabulary():
    for row in control_rows():
        assert status(row) in VOCAB, f"{row[0]}: {status(row)}"


def test_simulated_operation_links_a_record_and_implemented_does_not():
    for row in control_rows():
        text = row[-1]
        if status(row) == "Simulated operation":
            links = re.findall(r"\]\(([^)]*records/simulated/[^)]+)\)", text)
            assert links, f"{row[0]}: no simulated record linked"
            for target in links:
                assert (SOC2 / target).exists(), f"{row[0]}: {target}"
        if status(row) == "Implemented":
            assert "records/simulated" not in text, row[0]


def test_summary_matches_rows():
    text = MATRIX.read_text(encoding="utf-8")
    section = text.split("## 13. Summary")[1].split("## Revision history")[0]
    summary = {}
    for line in section.splitlines():
        if line.startswith("|") and not line.startswith("|---"):
            name, count = cells(line)
            summary[name.strip("*")] = count.strip("*")
    actual = Counter(status(r) for r in control_rows())
    for name in VOCAB:
        assert int(summary[name]) == actual.get(name, 0), name
    assert int(summary["Total"]) == sum(actual.values()) == 65


def test_criteria_summary_matches_mapping_table():
    text = MAPPING.read_text(encoding="utf-8")
    table = text.split("## 5. Criteria outside")[0]
    actual = Counter()
    for line in table.splitlines():
        if re.match(r"\| (?:CC\d|A1|C1)\.\d \|", line):
            actual[re.match(r"(Ready|Partly ready|Not ready)", cells(line)[-1])[1]] += 1
    summary = text.split("## 6. Summary")[1].split("## 7.")[0]
    stated = {}
    for line in summary.splitlines():
        m = re.match(r"\| (Ready|Partly ready|Not ready) \| (\d+)", line)
        if m:
            stated[m[1]] = int(m[2])
    assert stated == dict(actual) and sum(actual.values()) == 38
    readiness = (SOC2 / "04-readiness-assessment.md").read_text(encoding="utf-8")
    assert (
        f"{actual['Ready']} ready (CC2.1, CC5.2), {actual['Partly ready']} partly ready, "
        f"{actual['Not ready']} not ready (of 38)" in readiness
    )


def test_type1_pack_covers_every_control_once():
    ids = [r[0] for r in control_rows()]
    rows = [cells(l) for l in PACK.read_text(encoding="utf-8").splitlines()
            if re.match(r"\| [A-Z]{2}-\d\d \|", l)]
    assert sorted(r[0] for r in rows) == sorted(ids)
    results = Counter()
    for row in rows:
        m = re.match(r"\*\*(pass|fail|cannot test)\*\*", row[-1])
        assert m, row[0]
        results[m[1]] += 1
    text = PACK.read_text(encoding="utf-8")
    for name in ("pass", "fail", "cannot test"):
        assert re.search(rf"\| {name} \| {results[name]} \|", text), name
