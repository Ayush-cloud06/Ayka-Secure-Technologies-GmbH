#!/usr/bin/env python3
import json
from collections import Counter, defaultdict
import os
from pathlib import Path
import re
import sys

import yaml


OUTPUT_DIR = Path(os.environ.get("COMPLIANCE_OUTPUT_DIR", "output"))
CHECKOV_FILE = Path(
    os.environ.get("COMPLIANCE_CHECKOV_FILE", OUTPUT_DIR / "checkov-result.json")
)
OPA_FILE = Path(os.environ.get("COMPLIANCE_OPA_FILE", OUTPUT_DIR / "opa-result.json"))
TFSEC_FILE = Path(
    os.environ.get("COMPLIANCE_TFSEC_FILE", OUTPUT_DIR / "tfsec-result.json")
)
SUMMARY_FILE = Path(
    os.environ.get("COMPLIANCE_SUMMARY_FILE", OUTPUT_DIR / "compliance-summary.json")
)
CONTROL_MAPPING_FILE = Path(
    os.environ.get(
        "COMPLIANCE_CONTROL_MAPPING_FILE",
        "Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml",
    )
)
OPA_CONTROL_PREFIX = re.compile(r"^\[(?P<control_id>[A-Z0-9_]+)\]\s*(?P<message>.*)$")


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


def normalize_severity(value):
    normalized = (value or "LOW").upper()
    if normalized == "CRITICAL":
        return "HIGH"
    if normalized in {"HIGH", "MEDIUM", "LOW"}:
        return normalized
    return "LOW"


def control_projection(control_id, control):
    if not control_id or not control:
        return None
    return {
        "id": control_id,
        "title": control.get("title"),
        "domain": control.get("domain"),
        "category": control.get("category"),
        "frameworks": control.get("frameworks", {}),
    }


def build_control_indexes(control_mapping):
    controls = control_mapping.get("controls", {})
    by_checkov_policy = {}
    by_tfsec_policy = {}
    by_opa_control_id = {}
    by_opa_package = defaultdict(list)

    for control_id, metadata in controls.items():
        enforcements = []
        if metadata.get("enforcement"):
            enforcements.append(metadata["enforcement"])
        enforcements.extend(metadata.get("additional_enforcements", []))

        for enforcement in enforcements:
            tool = enforcement.get("tool")
            if tool == "checkov" and enforcement.get("policy_id"):
                by_checkov_policy[enforcement["policy_id"]] = control_id
            elif tool == "tfsec" and enforcement.get("policy_id"):
                by_tfsec_policy[enforcement["policy_id"]] = control_id
            elif tool == "opa":
                explicit_id = enforcement.get("control_id", control_id)
                by_opa_control_id[explicit_id] = control_id
                if enforcement.get("policy_package"):
                    by_opa_package[enforcement["policy_package"]].append(
                        {
                            "control_id": control_id,
                            "message_patterns": metadata.get("message_patterns", []),
                        }
                    )

    return controls, by_checkov_policy, by_tfsec_policy, by_opa_control_id, by_opa_package


def build_finding(
    *,
    tool,
    source,
    severity,
    severity_source,
    message,
    resource,
    mapped,
    mapping_method,
    control_id=None,
    control=None,
    unmapped_reason=None,
):
    finding = {
        "tool": tool,
        "source": source,
        "severity": severity,
        "severity_source": severity_source,
        "message": message,
        "resource": resource,
        "mapped": mapped,
        "mapping_method": mapping_method,
    }
    if control_id:
        finding["control_id"] = control_id
    control_view = control_projection(control_id, control)
    if control_view:
        finding["control"] = control_view
        finding["remediation"] = control.get("remediation", {})
    if unmapped_reason:
        finding["unmapped_reason"] = unmapped_reason
    return finding


def resolve_scanner_mapping(index, source, controls, fallback_severity, fallback_source):
    control_id = index.get(source)
    if not control_id:
        return {
            "mapped": False,
            "control_id": None,
            "control": None,
            "severity": normalize_severity(fallback_severity),
            "severity_source": fallback_source,
            "mapping_method": "scanner_default",
            "unmapped_reason": "No control mapping entry matched this scanner rule.",
        }

    control = controls.get(control_id, {})
    return {
        "mapped": True,
        "control_id": control_id,
        "control": control,
        "severity": normalize_severity(control.get("severity")),
        "severity_source": "metadata",
        "mapping_method": "policy_id",
        "unmapped_reason": None,
    }


def resolve_opa_mapping(namespace, raw_message, controls, opa_control_index, opa_package_index):
    match = OPA_CONTROL_PREFIX.match(raw_message)
    if match:
        explicit_id = match.group("control_id")
        control_id = opa_control_index.get(explicit_id)
        if control_id:
            control = controls.get(control_id, {})
            return {
                "message": match.group("message"),
                "mapped": True,
                "control_id": control_id,
                "control": control,
                "severity": normalize_severity(control.get("severity")),
                "severity_source": "metadata",
                "mapping_method": "control_id_prefix",
                "unmapped_reason": None,
            }
        return {
            "message": match.group("message"),
            "mapped": False,
            "control_id": explicit_id,
            "control": None,
            "severity": "MEDIUM",
            "severity_source": "opa_default",
            "mapping_method": "control_id_prefix_unmapped",
            "unmapped_reason": "OPA finding declared a control ID that is not present in control-mapping.yaml.",
        }

    candidates = opa_package_index.get(namespace, [])
    normalized_message = raw_message.lower()
    for candidate in candidates:
        for pattern in candidate.get("message_patterns", []):
            if pattern.lower() in normalized_message:
                control_id = candidate["control_id"]
                control = controls.get(control_id, {})
                return {
                    "message": raw_message,
                    "mapped": True,
                    "control_id": control_id,
                    "control": control,
                    "severity": normalize_severity(control.get("severity")),
                    "severity_source": "metadata",
                    "mapping_method": "policy_package_message_pattern",
                    "unmapped_reason": None,
                }

    return {
        "message": raw_message,
        "mapped": False,
        "control_id": None,
        "control": None,
        "severity": "MEDIUM",
        "severity_source": "opa_default",
        "mapping_method": "opa_default",
        "unmapped_reason": "OPA finding did not include a mapped control ID or a matching message pattern.",
    }


def normalize_checkov(data, controls, checkov_index):
    findings = []
    failed_checks = data.get("results", {}).get("failed_checks", [])
    for item in failed_checks:
        source = item.get("check_id", "unknown")
        mapping = resolve_scanner_mapping(
            checkov_index,
            source,
            controls,
            item.get("severity", "LOW"),
            "scanner_default",
        )
        findings.append(
            build_finding(
                tool="checkov",
                source=source,
                severity=mapping["severity"],
                severity_source=mapping["severity_source"],
                message=item.get("check_name", "Checkov policy violation"),
                resource=item.get("resource"),
                mapped=mapping["mapped"],
                mapping_method=mapping["mapping_method"],
                control_id=mapping["control_id"],
                control=mapping["control"],
                unmapped_reason=mapping["unmapped_reason"],
            )
        )
    return findings


def normalize_tfsec(data, controls, tfsec_index):
    findings = []
    for item in data.get("results", []):
        source = item.get("rule_id") or item.get("long_id", "unknown")
        mapping = resolve_scanner_mapping(
            tfsec_index,
            source,
            controls,
            item.get("severity", "LOW"),
            "scanner_default",
        )
        findings.append(
            build_finding(
                tool="tfsec",
                source=source,
                severity=mapping["severity"],
                severity_source=mapping["severity_source"],
                message=item.get("description")
                or item.get("rule_description")
                or "tfsec policy violation",
                resource=item.get("resource"),
                mapped=mapping["mapped"],
                mapping_method=mapping["mapping_method"],
                control_id=mapping["control_id"],
                control=mapping["control"],
                unmapped_reason=mapping["unmapped_reason"],
            )
        )
    return findings


def normalize_opa(data, controls, opa_control_index, opa_package_index):
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
            mapping = resolve_opa_mapping(
                namespace, raw_message, controls, opa_control_index, opa_package_index
            )
            findings.append(
                build_finding(
                    tool="opa",
                    source=namespace,
                    severity=mapping["severity"],
                    severity_source=mapping["severity_source"],
                    message=mapping["message"],
                    resource=failure.get("metadata", {}).get("resource"),
                    mapped=mapping["mapped"],
                    mapping_method=mapping["mapping_method"],
                    control_id=mapping["control_id"],
                    control=mapping["control"],
                    unmapped_reason=mapping["unmapped_reason"],
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


def build_tool_summary(findings):
    return {
        "totals": count_by_severity(findings),
        "total_findings": len(findings),
        "mapped_findings": sum(1 for finding in findings if finding["mapped"]),
        "unmapped_findings": sum(1 for finding in findings if not finding["mapped"]),
    }


def build_control_summary(findings):
    by_control = {}
    grouped = defaultdict(list)
    for finding in findings:
        if finding.get("control_id"):
            grouped[finding["control_id"]].append(finding)

    for control_id, control_findings in grouped.items():
        control = control_findings[0].get("control", {})
        by_control[control_id] = {
            "title": control.get("title"),
            "severity": control_findings[0]["severity"],
            "total_findings": len(control_findings),
            "tools": sorted({finding["tool"] for finding in control_findings}),
            "resources": sorted(
                {finding["resource"] for finding in control_findings if finding["resource"]}
            ),
        }
    return by_control


def build_metadata_coverage(findings):
    total_findings = len(findings)
    mapped_findings = sum(1 for finding in findings if finding["mapped"])
    unmapped_findings = total_findings - mapped_findings

    by_tool = {}
    for tool in sorted({finding["tool"] for finding in findings}):
        tool_findings = [finding for finding in findings if finding["tool"] == tool]
        total = len(tool_findings)
        mapped = sum(1 for finding in tool_findings if finding["mapped"])
        by_tool[tool] = {
            "total_findings": total,
            "mapped_findings": mapped,
            "unmapped_findings": total - mapped,
            "mapped_percentage": round((mapped / total) * 100, 2) if total else 100.0,
        }

    return {
        "total_findings": total_findings,
        "mapped_findings": mapped_findings,
        "unmapped_findings": unmapped_findings,
        "mapped_percentage": round((mapped_findings / total_findings) * 100, 2)
        if total_findings
        else 100.0,
        "by_tool": by_tool,
    }


def build_summary(findings):
    by_tool_groups = defaultdict(list)
    for finding in findings:
        by_tool_groups[finding["tool"]].append(finding)

    totals = count_by_severity(findings)
    mapped_findings = [finding for finding in findings if finding["mapped"]]
    unmapped_findings = [finding for finding in findings if not finding["mapped"]]

    summary = {
        "schema_version": "2.0",
        "decision": "pass",
        "approval_required": False,
        "decision_basis": {
            "high_findings": totals["HIGH"],
            "medium_findings": totals["MEDIUM"],
            "low_findings": totals["LOW"],
            "unmapped_findings": len(unmapped_findings),
        },
        "totals": totals,
        "by_tool": {
            tool: build_tool_summary(tool_findings)
            for tool, tool_findings in sorted(by_tool_groups.items())
        },
        "by_control": build_control_summary(mapped_findings),
        "metadata_coverage": build_metadata_coverage(findings),
        "mapped_findings": mapped_findings,
        "unmapped_findings": unmapped_findings,
        "findings": findings,
    }

    if totals["HIGH"] > 0:
        summary["decision"] = "fail"
    elif totals["MEDIUM"] > 0:
        summary["decision"] = "approval_required"
        summary["approval_required"] = True

    return summary


def main():
    checkov_data = load_json(CHECKOV_FILE)
    opa_data = load_json(OPA_FILE)
    tfsec_data = load_json(TFSEC_FILE)
    control_mapping_data = load_yaml(CONTROL_MAPPING_FILE)

    (
        controls,
        checkov_index,
        tfsec_index,
        opa_control_index,
        opa_package_index,
    ) = build_control_indexes(control_mapping_data)

    findings = (
        normalize_checkov(checkov_data, controls, checkov_index)
        + normalize_opa(opa_data, controls, opa_control_index, opa_package_index)
        + normalize_tfsec(tfsec_data, controls, tfsec_index)
    )

    summary = build_summary(findings)
    SUMMARY_FILE.parent.mkdir(parents=True, exist_ok=True)
    SUMMARY_FILE.write_text(json.dumps(summary, indent=2), encoding="utf-8")

    print("Compliance decision summary:")
    print(json.dumps(summary, indent=2))

    if summary["decision"] == "fail":
        sys.exit(1)


if __name__ == "__main__":
    main()
