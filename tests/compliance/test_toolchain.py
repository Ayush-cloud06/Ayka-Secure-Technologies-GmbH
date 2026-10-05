"""CI and the local toolchain must pin the same versions and checksums (issue #21)."""
from pathlib import Path
import re
import unittest

REPO_ROOT = Path(__file__).resolve().parents[2]
GITHUB = REPO_ROOT / ".github"


def pins():
    text = (REPO_ROOT / "Internal-IT/engineering/ci-cd/toolchain.versions").read_text(encoding="utf-8")
    return dict(re.findall(r"^([A-Z0-9_]+)=(\S+)$", text, re.MULTILINE))


def ci_text():
    return "\n".join(p.read_text(encoding="utf-8") for p in sorted(GITHUB.rglob("*.yml")))


class ToolchainTests(unittest.TestCase):
    def setUp(self):
        self.pins, self.ci = pins(), ci_text()

    def test_versions_match_ci(self):
        expected = [
            f"terraform_version: {self.pins['TERRAFORM_VERSION']}",
            f"tflint_version: v{self.pins['TFLINT_VERSION']}",
            f"conftest/releases/download/v{self.pins['CONFTEST_VERSION']}/",
            f"opa/releases/download/v{self.pins['OPA_VERSION']}/",
            f"tfsec/releases/download/v{self.pins['TFSEC_VERSION']}/",
            f"checkov=={self.pins['CHECKOV_VERSION']}",
        ]
        self.assertEqual([e for e in expected if e not in self.ci], [])

    def test_checksums_match_ci(self):
        for key in ("CONFTEST_SHA256", "OPA_SHA256", "TFSEC_SHA256"):
            self.assertIn(self.pins[key], self.ci, key)

    def test_no_other_terraform_version_in_ci(self):
        versions = set(re.findall(r"terraform_version: ['\"]?([0-9.]+)", self.ci))
        versions |= set(re.findall(r"TERRAFORM_VERSION: ['\"]?([0-9.]+)", self.ci))
        self.assertEqual(versions, {self.pins["TERRAFORM_VERSION"]})


if __name__ == "__main__":
    unittest.main()
