from collections import Counter
from pathlib import Path
import unittest

import yaml

MAPPING = Path(__file__).resolve().parents[2] / "Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml"


class ControlMappingTests(unittest.TestCase):
    """The mapping decides severity, so it is tested like code (ADR-0014)."""

    @classmethod
    def setUpClass(cls):
        cls.controls = yaml.safe_load(MAPPING.read_text(encoding="utf-8"))["controls"]

    def test_every_severity_is_valid(self):
        bad = {cid: c.get("severity") for cid, c in self.controls.items()
               if c.get("severity") not in {"HIGH", "MEDIUM", "LOW"}}
        self.assertEqual(bad, {})

    def test_no_policy_id_maps_to_two_controls(self):
        ids = []
        for control in self.controls.values():
            for enf in [control.get("enforcement", {})] + control.get("additional_enforcements", []):
                if enf.get("policy_id"):
                    ids.append(enf["policy_id"])
        self.assertEqual([i for i, n in Counter(ids).items() if n > 1], [])

    @unittest.skip("enable once every control has a rationale")
    def test_every_control_has_a_rationale(self):
        missing = [cid for cid, c in self.controls.items() if not c.get("rationale")]
        self.assertEqual(missing, [])
