#!/bin/bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"
echo "Evaluating security results..."

OUTPUT_DIR="output"
CHECKOV_FILE="$OUTPUT_DIR/checkov-result.json"
OPA_FILE="$OUTPUT_DIR/opa-result.json"
SUMMARY_FILE="$OUTPUT_DIR/compliance-summary.json"

for file in "$CHECKOV_FILE" "$OPA_FILE"; do
  if [ ! -f "$file" ]; then
    echo "Required result file missing: $file"
    exit 1
  fi
done

python3 - <<'PY'
import json
from collections import Counter, defaultdict
from pathlib import Path
import sys

output_dir = Path("output")
checkov_file = output_dir / "checkov-result.json"
opa_file = output_dir / "opa-result.json"
summary_file = output_dir / "compliance-summary.json"


def load_json(path: Path):
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:
        print(f"Failed to parse JSON from {path}: {exc}", file=sys.stderr)
        sys.exit(1)


def normalize_checkov(data):
    findings = []
    failed_checks = data.get("results", {}).get("failed_checks", [])
    for item in failed_checks:
        findings.append(
            {
                "tool": "checkov",
                "source": item.get("check_id", "unknown"),
                "severity": item.get("severity", "LOW"),
                "message": item.get("check_name", "Checkov policy violation"),
                "resource": item.get("resource"),
            }
        )
    return findings


OPA_NAMESPACE_SEVERITY = {
    "policies.terraform.aws_ec2": "HIGH",
    "policies.terraform.aws_s3": "HIGH",
    "policies.terraform.aws_iam": "HIGH",
    "policies.terraform.aws_vpc": "HIGH",
    "policies.aws.ec2": "LOW",
    "policies.aws.s3": "LOW",
}


def normalize_opa(data):
    if isinstance(data, dict) and data.get("status") == "error":
        print("OPA execution failed before producing findings JSON.", file=sys.stderr)
        print(json.dumps(data, indent=2), file=sys.stderr)
        sys.exit(1)

    if not isinstance(data, list):
        print("OPA results are not in the expected list format.", file=sys.stderr)
        sys.exit(1)

    findings = []
    for namespace_result in data:
        namespace = namespace_result.get("namespace", "unknown")
        severity = OPA_NAMESPACE_SEVERITY.get(namespace, "MEDIUM")
        for failure in namespace_result.get("failures", []):
            findings.append(
                {
                    "tool": "opa",
                    "source": namespace,
                    "severity": severity,
                    "message": failure.get("msg", "OPA policy violation"),
                    "resource": failure.get("metadata", {}).get("resource"),
                }
            )
    return findings


def count_by_severity(findings):
    counter = Counter()
    for finding in findings:
        counter[finding["severity"]] += 1
    return {
        "HIGH": counter.get("HIGH", 0),
        "MEDIUM": counter.get("MEDIUM", 0),
        "LOW": counter.get("LOW", 0),
    }


checkov_data = load_json(checkov_file)
opa_data = load_json(opa_file)

checkov_findings = normalize_checkov(checkov_data)
opa_findings = normalize_opa(opa_data)
all_findings = checkov_findings + opa_findings

by_tool = defaultdict(list)
for finding in all_findings:
    by_tool[finding["tool"]].append(finding)

summary = {
    "decision": "pass",
    "approval_required": False,
    "totals": count_by_severity(all_findings),
    "by_tool": {},
    "findings": all_findings,
}

for tool, findings in by_tool.items():
    summary["by_tool"][tool] = count_by_severity(findings)

high_count = summary["totals"]["HIGH"]
medium_count = summary["totals"]["MEDIUM"]

if high_count > 0:
    summary["decision"] = "fail"
elif medium_count > 0:
    summary["decision"] = "approval_required"
    summary["approval_required"] = True

summary_file.write_text(json.dumps(summary, indent=2), encoding="utf-8")

print("Compliance decision summary:")
print(json.dumps(summary, indent=2))

if summary["decision"] == "fail":
    sys.exit(1)

sys.exit(0)
PY

