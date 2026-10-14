"""Keep the dated control lookup structurally aligned with the evaluator metadata.

This does not revalidate the remote artifact or claim detection coverage. A new
mapping must prompt a human refresh of the evidence index instead of silently
leaving controls out of the register.
"""
import re
from pathlib import Path

import yaml


ROOT = Path(__file__).resolve().parents[2]
MAPPING = ROOT / "Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml"
INDEX = ROOT / "Governance/ISMS/07-technical-evidence/control-evidence-index.md"


def test_evidence_index_covers_each_mapped_control_once():
    controls = yaml.safe_load(MAPPING.read_text())["controls"]
    rows = [line.split("|")[1:-1] for line in INDEX.read_text().splitlines()
            if re.match(r"^\| `[A-Z][A-Z0-9_]+` \|", line)]
    identifiers = [row[0].strip().strip("`") for row in rows]
    assert len(identifiers) == len(set(identifiers)), "Duplicate control rows"
    assert set(identifiers) == set(controls), "Refresh the dated index for changed metadata"
    for row, identifier in zip(rows, identifiers):
        assert len(row) == 7, identifier
        metadata = controls[identifier]
        assert set(re.findall(r"A\.\d+\.\d+", row[1])) == set(metadata["frameworks"]["iso27001"])
        for rule in [metadata["enforcement"]] + metadata.get("additional_enforcements", []):
            rule_id = rule.get("policy_id", rule.get("control_id", identifier))
            assert f"{rule['tool']}: {rule_id}" in row[2], identifier
        assert row[3].strip() == f"`output/{metadata['evidence']['artifact']}`"
        assert all(re.fullmatch(r"\d+", cell.strip()) for cell in row[4:]), identifier
