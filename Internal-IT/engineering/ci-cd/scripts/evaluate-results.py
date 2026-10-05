#!/usr/bin/env python3
import json
from collections import Counter, defaultdict
from datetime import date
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
EXCEPTIONS_FILE = Path(
    os.environ.get(
        "COMPLIANCE_EXCEPTIONS_FILE",
        "Internal-IT/engineering/policy-as-code/metadata/exceptions.yaml",
    )
)
OPA_CONTROL_PREFIX = re.compile(r"^\[(?P<control_id>[A-Z0-9_]+)\]\s*(?P<message>.*)$")
TOOLS = ("checkov", "opa", "tfsec")
# ADR-0011: a finding nobody has mapped yet is at least MEDIUM, so a human sees it.
UNMAPPED_MIN_SEVERITY = "MEDIUM"
SEVERITY_ORDER = ["LOW", "MEDIUM", "HIGH"]


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


def normalize_severity(value, tool="scanner"):
    """No severity means LOW (unmapped findings are raised to MEDIUM later).
    A severity we don't recognise is malformed input, not LOW."""
    if value is None or value == "":
        return "LOW"
    normalized = str(value).upper()
    if normalized == "CRITICAL":
        return "HIGH"
    if normalized in {"INFO", "INFORMATIONAL"}:
        return "LOW"
    if normalized in SEVERITY_ORDER:
        return normalized
    reject_input(tool, f"unknown severity {value!r}")


def at_least(severity, floor):
    return max(severity, floor, key=SEVERITY_ORDER.index)


def reject_input(tool, reason):
    print(f"Invalid {tool} result: {reason}", file=sys.stderr)
    sys.exit(1)


def validate_checkov(data):
    if not isinstance(data, dict) or not isinstance(data.get("results"), dict):
        reject_input("checkov", "no 'results' object (summary-only output means nothing was scanned)")
    results = data["results"]
    if not isinstance(results.get("failed_checks"), list):
        reject_input("checkov", "'results.failed_checks' is missing or not a list")
    if results.get("parsing_errors"):
        reject_input("checkov", f"parsing_errors: {results['parsing_errors']}")
    # "Nothing failed" only means something if something was checked.
    summary = data.get("summary")
    if not isinstance(summary, dict):
        reject_input("checkov", "no 'summary' object, cannot prove anything was scanned")
    if not summary.get("resource_count") or not (summary.get("passed", 0) + summary.get("failed", 0)):
        reject_input("checkov", f"scanned nothing (resource_count={summary.get('resource_count')}, "
                                f"passed={summary.get('passed')}, failed={summary.get('failed')})")


def validate_tfsec(data):
    if not isinstance(data, dict) or not isinstance(data.get("results"), list):
        reject_input("tfsec", "'results' is missing or not a list")


def validate_opa(data, opa_package_index):
    if isinstance(data, dict) and data.get("status") == "error":
        return  # handled by normalize_opa with the full error payload
    if not isinstance(data, list) or not data:
        reject_input("opa", "expected a non-empty list of namespace results")
    if not all(isinstance(item, dict) for item in data):
        reject_input("opa", "every namespace result must be an object")
    errored = {item.get("namespace"): item["errors"] for item in data if item.get("errors")}
    if errored:
        reject_input("opa", f"policy evaluation errors: {errored}")
    seen = {item.get("namespace") for item in data}
    missing = sorted(set(opa_package_index) - seen)
    if missing:
        reject_input("opa", f"no result for mapped policy packages: {missing}")
    # A mapped package with no passes and no failures ran no rules at all.
    evaluated = {
        item.get("namespace"): item.get("successes", 0) + len(item.get("failures") or [])
        + len(item.get("warnings") or []) + len(item.get("exceptions") or [])
        for item in data
    }
    idle = sorted(ns for ns in opa_package_index if not evaluated.get(ns))
    if idle:
        reject_input("opa", f"mapped policy packages evaluated no rules: {idle}")


def validate_control_mapping(controls):
    """The mapping decides the gate, so a typo in it must stop the run, not become LOW."""
    bad = {cid: c.get("severity") for cid, c in controls.items()
           if not isinstance(c, dict) or c.get("severity") not in SEVERITY_ORDER}
    if bad:
        print(f"Invalid control mapping: severity must be one of {SEVERITY_ORDER}: {bad}", file=sys.stderr)
        sys.exit(1)


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
            "severity": at_least(normalize_severity(fallback_severity), UNMAPPED_MIN_SEVERITY),
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


def load_exceptions(today):
    """ADR-0014: accepted findings live in one reviewed file, each with an owner and an expiry."""
    if not EXCEPTIONS_FILE.exists():
        return []
    entries = (load_yaml(EXCEPTIONS_FILE) or {}).get("exceptions") or []
    active = []
    for entry in entries:
        missing = [k for k in ("policy_id", "resource", "reason", "owner", "expires") if not entry.get(k)]
        if missing:
            print(f"Exception entry {entry.get('policy_id')} is missing {missing}", file=sys.stderr)
            sys.exit(1)
        if date.fromisoformat(str(entry["expires"])) < today:
            print(f"Exception expired, finding counts again: {entry['policy_id']} on {entry['resource']}", file=sys.stderr)
            continue
        active.append(entry)
    return active


def split_excepted(findings, exceptions):
    kept, excepted = [], []
    for finding in findings:
        match = next(
            (e for e in exceptions if e["policy_id"] == finding["source"] and e["resource"] == finding["resource"]),
            None,
        )
        if match:
            excepted.append(dict(finding, exception={k: str(match[k]) for k in ("reason", "owner", "expires")}))
        else:
            kept.append(finding)
    return kept, excepted


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
    for tool in sorted(set(TOOLS) | {finding["tool"] for finding in findings}):
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


def build_summary(findings, excepted=()):
    by_tool_groups = {tool: [] for tool in TOOLS}  # ADR-0011: every scanner is listed, even with 0 findings
    for finding in findings:
        by_tool_groups.setdefault(finding["tool"], []).append(finding)

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
            "excepted_findings": len(excepted),
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
        "excepted_findings": list(excepted),
    }
    for finding in excepted:
        summary["by_tool"][finding["tool"]].setdefault("excepted_findings", 0)
        summary["by_tool"][finding["tool"]]["excepted_findings"] += 1

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

    validate_control_mapping(controls)
    validate_checkov(checkov_data)
    validate_tfsec(tfsec_data)
    validate_opa(opa_data, opa_package_index)

    findings = (
        normalize_checkov(checkov_data, controls, checkov_index)
        + normalize_opa(opa_data, controls, opa_control_index, opa_package_index)
        + normalize_tfsec(tfsec_data, controls, tfsec_index)
    )

    findings, excepted = split_excepted(findings, load_exceptions(date.today()))
    summary = build_summary(findings, excepted)
    SUMMARY_FILE.parent.mkdir(parents=True, exist_ok=True)
    SUMMARY_FILE.write_text(json.dumps(summary, indent=2), encoding="utf-8")

    print("Compliance decision summary:")
    print(json.dumps(summary, indent=2))

    if summary["decision"] == "fail":
        sys.exit(1)


if __name__ == "__main__":
    main()
