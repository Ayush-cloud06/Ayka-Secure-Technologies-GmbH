"""The compliance report prints SOC 2 criteria next to ISO references (SOC 2 readiness, section 4)."""
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

import yaml

REPO_ROOT = Path(__file__).resolve().parents[2]
SCRIPT = REPO_ROOT / "Internal-IT/engineering/ci-cd/scripts/generate-report.py"
MAPPING = REPO_ROOT / "Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml"
TSC = {"CC1", "CC2", "CC3", "CC4", "CC5", "CC6", "CC7", "CC8", "CC9", "A1", "C1", "PI1", "P1",
       "P2", "P3", "P4", "P5", "P6", "P7", "P8"}


class Soc2MappingTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.controls = yaml.safe_load(MAPPING.read_text(encoding="utf-8"))["controls"]

    def test_every_control_keeps_iso_and_has_soc2(self):
        missing = [cid for cid, c in self.controls.items()
                   if not c["frameworks"].get("iso27001") or not c["frameworks"].get("soc2")]
        self.assertEqual(missing, [])

    def test_soc2_ids_are_trust_services_criteria(self):
        bad = [(cid, crit) for cid, c in self.controls.items() for crit in c["frameworks"]["soc2"]
               if crit.split(".")[0] not in TSC or not crit.split(".")[-1].isdigit()]
        self.assertEqual(bad, [])


class Soc2ReportTests(unittest.TestCase):
    def render(self, summary):
        with tempfile.TemporaryDirectory() as tmp:
            src, out = Path(tmp) / "summary.json", Path(tmp) / "report.md"
            src.write_text(json.dumps(summary), encoding="utf-8")
            subprocess.run([sys.executable, str(SCRIPT), str(src), str(out)], check=True, capture_output=True)
            return out.read_text(encoding="utf-8")

    def test_report_prints_soc2_per_control_and_touched_criteria(self):
        fw = {"iso27001": ["A.8.20"], "soc2": ["CC6.6", "CC6.1"]}
        summary = {
            "decision": "fail", "schema_version": "2.2", "totals": {"HIGH": 1},
            "by_control": {"EC2_OPEN_SSH": {"title": "SSH", "severity": "HIGH", "frameworks": fw,
                                            "total_findings": 1, "resources": ["aws_security_group.a"]}},
            "mapped_findings": [{"control_id": "EC2_OPEN_SSH", "control": {"id": "EC2_OPEN_SSH", "frameworks": fw}}],
            "excepted_findings": [{"control_id": "S3_VERSIONING_DISABLED", "tool": "checkov", "source": "CKV_AWS_21",
                                   "control": {"id": "S3_VERSIONING_DISABLED",
                                               "frameworks": {"iso27001": ["A.8.13"], "soc2": ["A1.2"]}},
                                   "exception": {}}],
        }
        report = self.render(summary)
        self.assertIn("| ISO 27001 | SOC 2 |", report)
        self.assertIn("| A.8.20 | CC6.6, CC6.1 |", report)
        touched = report.split("## SOC 2 Criteria Touched")[1]
        self.assertLess(touched.index("| CC6.1 |"), touched.index("| CC6.6 |"))
        self.assertLess(touched.index("| CC6.6 |"), touched.index("| A1.2 |"))
        self.assertIn("| A1.2 | S3_VERSIONING_DISABLED |", touched)

    def test_report_without_findings_says_so(self):
        report = self.render({"decision": "pass", "totals": {}, "by_control": {}})
        self.assertIn("_No mapped finding in this run._", report)


if __name__ == "__main__":
    unittest.main()
