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
# Real checkov output always carries a summary; the evaluator needs it to prove a scan happened.
CHECKOV_SUMMARY = {"passed": 10, "failed": 0, "skipped": 0, "parsing_errors": 0, "resource_count": 5}
CHECKOV_CLEAN = {"results": {"failed_checks": [], "parsing_errors": []}, "summary": CHECKOV_SUMMARY}
TFSEC_CLEAN = {"results": []}


class EvaluateResultsRegressionTests(unittest.TestCase):
    maxDiff = None

    def run_case(self, *, checkov, tfsec, opa, exceptions=None, mapping=CONTROL_MAPPING):
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
            control_mapping_file.write_text(mapping, encoding="utf-8")

            # Always point at a temp file so the repository's real exceptions never leak into tests.
            exceptions_file = temp_path / "exceptions.yaml"
            if exceptions is not None:
                exceptions_file.write_text(exceptions, encoding="utf-8")

            summary_file = output_dir / "compliance-summary.json"
            env = os.environ.copy()
            env.update(
                {
                    "COMPLIANCE_OUTPUT_DIR": str(output_dir),
                    "COMPLIANCE_CONTROL_MAPPING_FILE": str(control_mapping_file),
                    "COMPLIANCE_SUMMARY_FILE": str(summary_file),
                    "COMPLIANCE_EXCEPTIONS_FILE": str(exceptions_file),
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
            checkov=CHECKOV_CLEAN,
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
            checkov=CHECKOV_CLEAN,
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
                },
                "summary": CHECKOV_SUMMARY,
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
            checkov=CHECKOV_CLEAN,
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
            checkov=CHECKOV_CLEAN,
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
                },
                "summary": CHECKOV_SUMMARY,
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

    # Issue #13: "nothing failed" must not pass when nothing was evaluated.
    def test_checkov_that_scanned_no_resources_fails_closed(self):
        empty = {"results": {"failed_checks": []}, "summary": dict(CHECKOV_SUMMARY, passed=0, resource_count=0)}
        self.assert_rejected(checkov=empty, tfsec=TFSEC_CLEAN, opa=OPA_CLEAN, message="scanned nothing")

    def test_checkov_without_summary_fails_closed(self):
        self.assert_rejected(
            checkov={"results": {"failed_checks": []}}, tfsec=TFSEC_CLEAN, opa=OPA_CLEAN, message="no 'summary'"
        )

    def test_opa_namespace_with_errors_fails_closed(self):
        opa = [{"namespace": "policies.terraform.aws_ec2", "successes": 0, "errors": [{"msg": "evaluation failed"}]}]
        self.assert_rejected(checkov=CHECKOV_CLEAN, tfsec=TFSEC_CLEAN, opa=opa, message="policy evaluation errors")

    def test_opa_mapped_package_that_ran_no_rules_fails_closed(self):
        opa = [{"namespace": "policies.terraform.aws_ec2", "successes": 0}]
        self.assert_rejected(checkov=CHECKOV_CLEAN, tfsec=TFSEC_CLEAN, opa=opa, message="evaluated no rules")

    def test_unknown_scanner_severity_fails_closed(self):
        tfsec = {"results": [{"rule_id": "AVD-AWS-9999", "long_id": "x", "description": "x",
                              "severity": "HGIH", "location": {"filename": "main.tf"}}]}
        self.assert_rejected(checkov=CHECKOV_CLEAN, tfsec=tfsec, opa=OPA_CLEAN, message="unknown severity")

    def test_invalid_mapping_severity_fails_closed(self):
        result, summary = self.run_case(
            checkov=CHECKOV_CLEAN, tfsec=TFSEC_CLEAN, opa=OPA_CLEAN,
            mapping=CONTROL_MAPPING.replace("severity: MEDIUM", "severity: MEDUIM"),
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIsNone(summary)
        self.assertIn("Invalid control mapping", result.stderr)

    def test_all_three_tools_listed_even_without_findings(self):
        result, summary = self.run_case(checkov=CHECKOV_CLEAN, tfsec=TFSEC_CLEAN, opa=OPA_CLEAN)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(sorted(summary["by_tool"]), ["checkov", "opa", "tfsec"])
        self.assertEqual(sorted(summary["metadata_coverage"]["by_tool"]), ["checkov", "opa", "tfsec"])

    # Issue #16: one problem reported by several tools is one distinct issue.
    def test_same_issue_from_three_tools_is_one_distinct_finding(self):
        checkov = {"results": {"failed_checks": [{"check_id": "CKV_AWS_24", "check_name": "ssh",
                                                  "resource": "module.sg.aws_security_group.web", "severity": None}]},
                   "summary": CHECKOV_SUMMARY}
        mapping = CONTROL_MAPPING.replace("        policy_id: AVD-AWS-0107",
                                          "        policy_id: AVD-AWS-0107\n      - tool: checkov\n        policy_id: CKV_AWS_24")
        self.assertIn("CKV_AWS_24", mapping)
        opa = [{"namespace": "policies.terraform.aws_ec2", "successes": 0, "failures": [
            {"msg": "[EC2_OPEN_SSH] Security group module.sg.aws_security_group.web allows SSH (22) from the internet"}]}]
        result, summary = self.run_case(checkov=checkov, tfsec=self.OPEN_SSH_TFSEC, opa=opa, mapping=mapping)
        self.assertEqual(result.returncode, 1, result.stderr)
        self.assertEqual(summary["totals"]["HIGH"], 3)
        self.assertEqual(summary["distinct_totals"]["HIGH"], 1)
        self.assertEqual(summary["distinct_findings"], [{
            "issue": "EC2_OPEN_SSH", "resource": "module.sg.aws_security_group.web", "severity": "HIGH",
            "tools": ["checkov", "opa", "tfsec"], "reports": 3}])

    def test_opa_finding_carries_the_resource_from_its_message(self):
        opa = [{"namespace": "policies.terraform.aws_ec2", "successes": 0, "failures": [
            {"msg": "[EC2_OPEN_SSH] Security group module.a[0].aws_security_group.x allows SSH (22) from the internet"}]}]
        _, summary = self.run_case(checkov=CHECKOV_CLEAN, tfsec=TFSEC_CLEAN, opa=opa)
        self.assertEqual(summary["findings"][0]["resource"], "module.a[0].aws_security_group.x")

    def test_mapped_share_is_undefined_without_findings(self):
        _, summary = self.run_case(checkov=CHECKOV_CLEAN, tfsec=TFSEC_CLEAN, opa=OPA_CLEAN)
        coverage = summary["metadata_coverage"]
        self.assertIsNone(coverage["findings_mapped_percentage"])
        self.assertIn("not detection coverage", coverage["description"])
        self.assertEqual(summary["schema_version"], "2.1")

    OPEN_SSH_TFSEC = {"results": [{"rule_id": "AVD-AWS-0107", "resource": "module.sg", "severity": "HIGH"}]}

    def exception_yaml(self, expires, owner="Ayush-cloud06"):
        return textwrap.dedent(
            f"""\
            exceptions:
              - policy_id: AVD-AWS-0107
                resource: module.sg
                reason: test
                owner: "{owner}"
                expires: {expires}
            """
        )

    def test_active_exception_excludes_finding_from_decision(self):
        result, summary = self.run_case(
            checkov=CHECKOV_CLEAN, tfsec=self.OPEN_SSH_TFSEC, opa=OPA_CLEAN,
            exceptions=self.exception_yaml("2999-12-31"),
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(summary["decision"], "pass")
        self.assertEqual(summary["decision_basis"]["excepted_findings"], 1)
        self.assertEqual(summary["excepted_findings"][0]["exception"]["owner"], "Ayush-cloud06")

    def test_expired_exception_counts_again(self):
        result, summary = self.run_case(
            checkov=CHECKOV_CLEAN, tfsec=self.OPEN_SSH_TFSEC, opa=OPA_CLEAN,
            exceptions=self.exception_yaml("2020-01-01"),
        )
        self.assertEqual(result.returncode, 1, result.stderr)
        self.assertEqual(summary["decision"], "fail")
        self.assertIn("Exception expired", result.stderr)

    def test_exception_without_owner_is_rejected(self):
        result, summary = self.run_case(
            checkov=CHECKOV_CLEAN, tfsec=self.OPEN_SSH_TFSEC, opa=OPA_CLEAN,
            exceptions=self.exception_yaml("2999-12-31", owner=""),
        )
        self.assertEqual(result.returncode, 1, result.stderr)
        self.assertIsNone(summary)
        self.assertIn("missing ['owner']", result.stderr)


if __name__ == "__main__":
    unittest.main()
