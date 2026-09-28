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


# A clean conftest result for the one policy package the test mapping uses.
OPA_CLEAN = [
    {"filename": "output/tfplan.json", "namespace": "policies.terraform.aws_ec2", "successes": 1}
]
CHECKOV_CLEAN = {"results": {"failed_checks": [], "parsing_errors": []}}
TFSEC_CLEAN = {"results": []}


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
            opa=OPA_CLEAN + [
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
            opa=OPA_CLEAN,
        )

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(summary["decision"], "approval_required")
        self.assertEqual(summary["totals"]["MEDIUM"], 1)
        self.assertEqual(summary["metadata_coverage"]["unmapped_findings"], 0)
        self.assertEqual(summary["findings"][0]["severity"], "MEDIUM")
        self.assertEqual(summary["findings"][0]["severity_source"], "metadata")
        self.assertEqual(summary["findings"][0]["control_id"], "S3_VERSIONING_DISABLED")

    def test_mapped_tfsec_finding_uses_metadata_severity(self):
        result, summary = self.run_case(
            checkov={"results": {"failed_checks": []}},
            tfsec={
                "results": [
                    {
                        "rule_id": "AVD-AWS-0107",
                        "description": "Security group rule allows ingress from 0.0.0.0/0 to port 22.",
                        "resource": "aws_security_group.open_ssh",
                        "severity": "LOW",
                    }
                ]
            },
            opa=OPA_CLEAN,
        )

        self.assertEqual(result.returncode, 1, result.stderr)
        self.assertEqual(summary["decision"], "fail")
        self.assertEqual(summary["totals"]["HIGH"], 1)
        self.assertEqual(summary["metadata_coverage"]["unmapped_findings"], 0)
        self.assertTrue(summary["findings"][0]["mapped"])
        self.assertEqual(summary["findings"][0]["tool"], "tfsec")
        self.assertEqual(summary["findings"][0]["mapping_method"], "policy_id")
        self.assertEqual(summary["findings"][0]["severity"], "HIGH")
        self.assertEqual(summary["findings"][0]["severity_source"], "metadata")
        self.assertEqual(summary["findings"][0]["control_id"], "EC2_OPEN_SSH")

    def test_unmapped_tfsec_low_finding_is_raised_to_medium(self):
        # ADR-0011 changed the policy on purpose: an unmapped finding is at least MEDIUM.
        result, summary = self.run_case(
            checkov={"results": {"failed_checks": []}},
            tfsec={
                "results": [
                    {
                        "rule_id": "AVD-AWS-9999",
                        "description": "Synthetic unmapped tfsec finding for regression coverage.",
                        "resource": "aws_security_group.example",
                        "severity": "LOW",
                    }
                ]
            },
            opa=OPA_CLEAN,
        )

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(summary["decision"], "approval_required")
        self.assertEqual(summary["totals"]["MEDIUM"], 1)
        self.assertEqual(summary["metadata_coverage"]["unmapped_findings"], 1)
        self.assertFalse(summary["findings"][0]["mapped"])
        self.assertEqual(summary["findings"][0]["tool"], "tfsec")
        self.assertEqual(summary["findings"][0]["mapping_method"], "scanner_default")
        self.assertEqual(summary["findings"][0]["severity"], "MEDIUM")
        self.assertEqual(summary["findings"][0]["severity_source"], "scanner_default")
        self.assertEqual(
            summary["findings"][0]["unmapped_reason"],
            "No control mapping entry matched this scanner rule.",
        )

    def test_unmapped_checkov_finding_without_severity_needs_approval(self):
        result, summary = self.run_case(
            checkov={
                "results": {
                    "failed_checks": [
                        {"check_id": "CKV_AWS_24", "check_name": "SSH open", "resource": "aws_security_group.x", "severity": None}
                    ]
                }
            },
            tfsec=TFSEC_CLEAN,
            opa=OPA_CLEAN,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(summary["decision"], "approval_required")
        self.assertEqual(summary["findings"][0]["severity"], "MEDIUM")

    def test_unmapped_tfsec_high_finding_stays_high(self):
        result, summary = self.run_case(
            checkov=CHECKOV_CLEAN,
            tfsec={"results": [{"rule_id": "AVD-AWS-0053", "resource": "aws_lb.app", "severity": "HIGH"}]},
            opa=OPA_CLEAN,
        )
        self.assertEqual(result.returncode, 1, result.stderr)
        self.assertEqual(summary["decision"], "fail")

    def assert_rejected(self, *, checkov, tfsec, opa, message):
        result, summary = self.run_case(checkov=checkov, tfsec=tfsec, opa=opa)
        self.assertEqual(result.returncode, 1, result.stderr)
        self.assertIsNone(summary, "no summary may be written for rejected input")
        self.assertIn(message, result.stderr)

    def test_checkov_parsing_errors_fail_closed(self):
        self.assert_rejected(
            checkov={"results": {"failed_checks": [], "parsing_errors": ["output/tfplan.json"]}},
            tfsec=TFSEC_CLEAN,
            opa=OPA_CLEAN,
            message="parsing_errors",
        )

    def test_checkov_summary_only_output_fails_closed(self):
        self.assert_rejected(
            checkov={"passed": 0, "failed": 0, "skipped": 0, "parsing_errors": 0, "resource_count": 0},
            tfsec=TFSEC_CLEAN,
            opa=OPA_CLEAN,
            message="Invalid checkov result",
        )

    def test_tfsec_without_results_list_fails_closed(self):
        self.assert_rejected(checkov=CHECKOV_CLEAN, tfsec={}, opa=OPA_CLEAN, message="Invalid tfsec result")

    def test_empty_opa_list_fails_closed(self):
        self.assert_rejected(checkov=CHECKOV_CLEAN, tfsec=TFSEC_CLEAN, opa=[], message="Invalid opa result")

    def test_opa_without_mapped_package_fails_closed(self):
        self.assert_rejected(
            checkov=CHECKOV_CLEAN,
            tfsec=TFSEC_CLEAN,
            opa=[{"namespace": "policies.aws.s3", "successes": 1}],
            message="policies.terraform.aws_ec2",
        )

    def test_all_three_tools_listed_even_without_findings(self):
        result, summary = self.run_case(checkov=CHECKOV_CLEAN, tfsec=TFSEC_CLEAN, opa=OPA_CLEAN)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(sorted(summary["by_tool"]), ["checkov", "opa", "tfsec"])
        self.assertEqual(sorted(summary["metadata_coverage"]["by_tool"]), ["checkov", "opa", "tfsec"])

if __name__ == "__main__":
    unittest.main()
