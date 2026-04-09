import json
import os
import subprocess
import tempfile
import textwrap
import unittest
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parents[2]
SCRIPT_PATH = REPO_ROOT / "Internal-IT/engineering/ci-cd/scripts/evaluate-results.py"


CONTROL_MAPPING = textwrap.dedent(
    """\
    controls:
      EC2_OPEN_SSH:
        title: "Security groups must not allow public SSH access"
        severity: HIGH
        category: network_security
        domain: compute_security
        frameworks:
          iso27001: ["A.8.20"]
        enforcement:
          tool: opa
          control_id: EC2_OPEN_SSH
          policy_package: policies.terraform.aws_ec2
        message_patterns:
          - "allows ssh (22) from the internet"
        additional_enforcements:
          - tool: tfsec
            policy_id: AVD-AWS-0107
      S3_VERSIONING_DISABLED:
        title: "S3 bucket versioning should be enabled"
        severity: MEDIUM
        category: resilience
        domain: storage_resilience
        frameworks:
          iso27001: ["A.8.13"]
        enforcement:
          tool: checkov
          control_id: S3_VERSIONING_DISABLED
          policy_id: CKV_AWS_21
    """
)


class EvaluateResultsRegressionTests(unittest.TestCase):
    maxDiff = None

    def run_case(self, *, checkov, tfsec, opa):
        with tempfile.TemporaryDirectory() as temp_dir:
            temp_path = Path(temp_dir)
            output_dir = temp_path / "output"
            output_dir.mkdir()

            (output_dir / "checkov-result.json").write_text(
                json.dumps(checkov), encoding="utf-8"
            )
            (output_dir / "tfsec-result.json").write_text(
                json.dumps(tfsec), encoding="utf-8"
            )
            (output_dir / "opa-result.json").write_text(
                json.dumps(opa), encoding="utf-8"
            )

            control_mapping_file = temp_path / "control-mapping.yaml"
            control_mapping_file.write_text(CONTROL_MAPPING, encoding="utf-8")

            summary_file = output_dir / "compliance-summary.json"
            env = os.environ.copy()
            env.update(
                {
                    "COMPLIANCE_OUTPUT_DIR": str(output_dir),
                    "COMPLIANCE_CONTROL_MAPPING_FILE": str(control_mapping_file),
                    "COMPLIANCE_SUMMARY_FILE": str(summary_file),
                }
            )

            result = subprocess.run(
                ["python3", str(SCRIPT_PATH)],
                cwd=REPO_ROOT,
                env=env,
                capture_output=True,
                text=True,
            )

            summary = None
            if summary_file.exists():
                summary = json.loads(summary_file.read_text(encoding="utf-8"))

            return result, summary

    def test_mapped_high_finding_fails_pipeline(self):
        result, summary = self.run_case(
            checkov={"results": {"failed_checks": []}},
            tfsec={"results": []},
            opa=[
                {
                    "namespace": "policies.terraform.aws_ec2",
                    "failures": [
                        {
                            "msg": "[EC2_OPEN_SSH] Security group aws_security_group.open_ssh allows SSH (22) from the internet",
                            "metadata": {"resource": "aws_security_group.open_ssh"},
                        }
                    ],
                }
            ],
        )

        self.assertEqual(result.returncode, 1, result.stderr)
        self.assertEqual(summary["decision"], "fail")
        self.assertEqual(summary["totals"]["HIGH"], 1)
        self.assertEqual(summary["metadata_coverage"]["unmapped_findings"], 0)
        self.assertEqual(summary["findings"][0]["control_id"], "EC2_OPEN_SSH")
        self.assertEqual(summary["findings"][0]["severity_source"], "metadata")

    def test_unmapped_opa_finding_defaults_to_medium_and_requires_approval(self):
        result, summary = self.run_case(
            checkov={"results": {"failed_checks": []}},
            tfsec={"results": []},
            opa=[
                {
                    "namespace": "policies.terraform.aws_vpc",
                    "failures": [
                        {
                            "msg": "VPC aws_vpc.main does not have a mapped control",
                            "metadata": {"resource": "aws_vpc.main"},
                        }
                    ],
                }
            ],
        )

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(summary["decision"], "approval_required")
        self.assertTrue(summary["approval_required"])
        self.assertEqual(summary["totals"]["MEDIUM"], 1)
        self.assertEqual(summary["metadata_coverage"]["unmapped_findings"], 1)
        self.assertFalse(summary["findings"][0]["mapped"])
        self.assertEqual(summary["findings"][0]["mapping_method"], "opa_default")

    def test_mapped_checkov_finding_uses_metadata_severity(self):
        result, summary = self.run_case(
            checkov={
                "results": {
                    "failed_checks": [
                        {
                            "check_id": "CKV_AWS_21",
                            "check_name": "Ensure all data stored in the S3 bucket have versioning enabled",
                            "resource": "aws_s3_bucket.logs",
                            "severity": "LOW",
                        }
                    ]
                }
            },
            tfsec={"results": []},
            opa=[],
        )

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(summary["decision"], "approval_required")
        self.assertEqual(summary["totals"]["MEDIUM"], 1)
        self.assertEqual(summary["metadata_coverage"]["unmapped_findings"], 0)
        self.assertEqual(summary["findings"][0]["severity"], "MEDIUM")
        self.assertEqual(summary["findings"][0]["severity_source"], "metadata")
        self.assertEqual(summary["findings"][0]["control_id"], "S3_VERSIONING_DISABLED")


if __name__ == "__main__":
    unittest.main()
