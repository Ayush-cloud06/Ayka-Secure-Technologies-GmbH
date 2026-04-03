#!/bin/bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"
echo "Evaluating security results..."

OUTPUT_DIR="output"
CHECKOV_FILE="$OUTPUT_DIR/checkov-result.json"
OPA_FILE="$OUTPUT_DIR/opa-result.json"
TFSEC_FILE="$OUTPUT_DIR/tfsec-result.json"
SUMMARY_FILE="$OUTPUT_DIR/compliance-summary.json"

for file in "$CHECKOV_FILE" "$OPA_FILE" "$TFSEC_FILE"; do
  if [ ! -f "$file" ]; then
    echo "Required result file missing: $file"
    exit 1
  fi
done

python3 - <<'PY'
import json
from collections import Counter, defaultdict
from pathlib import Path
import re
import sys

import yaml

output_dir = Path("output")
checkov_file = output_dir / "checkov-result.json"
opa_file = output_dir / "opa-result.json"
tfsec_file = output_dir / "tfsec-result.json"
summary_file = output_dir / "compliance-summary.json"
control_mapping_file = Path("Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml")


def load_json(path: Path):
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:
        print(f"Failed to parse JSON from {path}: {exc}", file=sys.stderr)
        sys.exit(1)


def load_yaml(path: Path):
    try:
        return yaml.safe_load(path.read_text(encoding="utf-8"))
    except Exception as exc:
        print(f"Failed to parse YAML from {path}: {exc}", file=sys.stderr)
        sys.exit(1)


def build_control_indexes(control_mapping):
    controls = control_mapping.get("controls", {})
    by_checkov_policy = {}
    by_tfsec_policy = {}
    by_opa_control_id = {}

    for control_id, metadata in controls.items():
        enforcement = metadata.get("enforcement", {})
        tool = enforcement.get("tool")
        if tool == "checkov" and enforcement.get("policy_id"):
            by_checkov_policy[enforcement["policy_id"]] = control_id
        elif tool == "tfsec" and enforcement.get("policy_id"):
            by_tfsec_policy[enforcement["policy_id"]] = control_id
        elif tool == "opa":
            by_opa_control_id[enforcement.get("control_id", control_id)] = control_id

    return controls, by_checkov_policy, by_tfsec_policy, by_opa_control_id


def build_finding(tool, source, severity, message, resource, control_id=None, control=None):
    finding = {
        "tool": tool,
        "source": source,
        "severity": severity,
        "message": message,
        "resource": resource,
    }
    if control_id:
        finding["control_id"] = control_id
    if control:
        finding["control"] = {
            "title": control.get("title"),
            "domain": control.get("domain"),
            "category": control.get("category"),
        }
    return finding


def normalize_checkov(data, controls, checkov_index):
    findings = []
    failed_checks = data.get("results", {}).get("failed_checks", [])
    for item in failed_checks:
        source = item.get("check_id", "unknown")
        control_id = checkov_index.get(source)
        control = controls.get(control_id, {})
        findings.append(
            build_finding(
                tool="checkov",
                source=source,
                severity=control.get("severity", item.get("severity", "LOW")),
                message=item.get("check_name", "Checkov policy violation"),
                resource=item.get("resource"),
                control_id=control_id,
                control=control if control_id else None,
            )
        )
    return findings


def normalize_tfsec(data, controls, tfsec_index):
    findings = []
    for item in data.get("results", []):
        source = item.get("rule_id") or item.get("long_id", "unknown")
        control_id = tfsec_index.get(source)
        control = controls.get(control_id, {})
        findings.append(
            build_finding(
                tool="tfsec",
                source=source,
                severity=control.get("severity", item.get("severity", "LOW")),
                message=item.get("description")
                or item.get("rule_description")
                or "tfsec policy violation",
                resource=item.get("resource"),
                control_id=control_id,
                control=control if control_id else None,
            )
        )
    return findings


OPA_CONTROL_PREFIX = re.compile(r"^\[(?P<control_id>[A-Z0-9_]+)\]\s*(?P<message>.*)$")


def normalize_opa(data, controls, opa_index):
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
        for failure in namespace_result.get("failures", []):
            raw_message = failure.get("msg", "OPA policy violation")
            match = OPA_CONTROL_PREFIX.match(raw_message)
            control_id = None
            message = raw_message
            if match:
                control_id = match.group("control_id")
                message = match.group("message")

            mapped_control_id = opa_index.get(control_id) if control_id else None
            control = controls.get(mapped_control_id, {})
            findings.append(
                build_finding(
                    tool="opa",
                    source=namespace,
                    severity=control.get("severity", "MEDIUM"),
                    message=message,
                    resource=failure.get("metadata", {}).get("resource"),
                    control_id=mapped_control_id or control_id,
                    control=control if mapped_control_id else None,
                )
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
tfsec_data = load_json(tfsec_file)
control_mapping_data = load_yaml(control_mapping_file)

controls, checkov_index, tfsec_index, opa_index = build_control_indexes(control_mapping_data)

checkov_findings = normalize_checkov(checkov_data, controls, checkov_index)
opa_findings = normalize_opa(opa_data, controls, opa_index)
tfsec_findings = normalize_tfsec(tfsec_data, controls, tfsec_index)
all_findings = checkov_findings + opa_findings + tfsec_findings

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
