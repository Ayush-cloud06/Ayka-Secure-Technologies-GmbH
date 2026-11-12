import json
import os
import sys

def criterion_sort_key(criterion):
    """CC1.1 < CC6.1 < CC6.10 < A1.2 < C1.1: series first, then numbers."""
    prefix = criterion.rstrip("0123456789.")
    numbers = [int(n) for n in criterion[len(prefix):].split(".") if n.isdigit()]
    order = {"CC": 0, "A": 1, "C": 2, "PI": 3, "P": 4}
    return (order.get(prefix, 9), prefix, numbers)


def soc2_criteria(summary):
    """SOC 2 criterion -> control IDs, from counted and excepted mapped findings."""
    criteria = {}
    findings = list(summary.get('mapped_findings', [])) + list(summary.get('excepted_findings', []))
    for finding in findings:
        control = finding.get('control') or {}
        for criterion in (control.get('frameworks') or {}).get('soc2', []):
            criteria.setdefault(criterion, set()).add(finding.get('control_id') or control.get('id'))
    for cid, details in (summary.get('by_control') or {}).items():
        for criterion in (details.get('frameworks') or {}).get('soc2', []):
            criteria.setdefault(criterion, set()).add(cid)
    return criteria


def generate_markdown_report(summary_path, output_path):
    if not os.path.exists(summary_path):
        print(f"Error: {summary_path} not found")
        sys.exit(1)

    with open(summary_path, 'r') as f:
        summary = json.load(f)

    decision = summary.get('decision', 'unknown').upper()
    decision_color = "🟢" if decision == "PASS" else "🟡" if decision == "APPROVAL_REQUIRED" else "🔴"
    
    report = []
    report.append(f"# Compliance Report {decision_color}")
    report.append(f"**Decision:** {decision}")
    report.append(f"**Schema Version:** {summary.get('schema_version', '1.0')}")
    if summary.get('workload_dir'):
        report.append(f"**Workload:** `{summary['workload_dir']}`")
    mode = summary.get('scan_mode', 'plan')
    if mode == 'source':
        report.append("**Scan mode:** source (no Terraform plan; Checkov and tfsec read the source)")
    else:
        report.append(f"**Scan mode:** {mode}")
    report.append("")
    if summary.get('tools_not_run'):
        report.append("## Tools Not Run")
        report.append("A tool listed here produced no result for this run. Its controls are **not** checked here.")
        report.append("")
        for tool, reason in summary['tools_not_run'].items():
            report.append(f"- **{tool}:** {reason}")
        report.append("")
    
    report.append("## Summary Totals")
    totals = summary.get('totals', {})
    distinct = summary.get('distinct_totals')
    if distinct is None:
        for sev in ("HIGH", "MEDIUM", "LOW"):
            report.append(f"- **{sev}:** {totals.get(sev, 0)}")
    else:
        report.append("Raw findings count every report from every tool; distinct issues count one issue on one resource once.")
        report.append("")
        report.append("| Severity | Distinct issues | Raw findings |")
        report.append("|----------|-----------------|--------------|")
        for sev in ("HIGH", "MEDIUM", "LOW"):
            report.append(f"| {sev} | {distinct.get(sev, 0)} | {totals.get(sev, 0)} |")
    report.append("")

    report.append("## Mapping Coverage")
    coverage = summary.get('metadata_coverage', {})
    if coverage.get('description'):
        report.append(f"_{coverage['description']}_")
        report.append("")
    share = coverage.get('findings_mapped_percentage', coverage.get('mapped_percentage'))
    report.append(f"- **Reported findings:** {coverage.get('total_findings', 0)}")
    report.append(f"- **Mapped to a control:** {coverage.get('mapped_findings', 0)}")
    report.append(f"- **Unmapped:** {coverage.get('unmapped_findings', 0)}")
    report.append(f"- **Share mapped:** {'n/a (no findings)' if share is None else f'{share}%'}")
    report.append("")

    if summary.get('distinct_findings'):
        report.append("## Distinct Issues")
        report.append("| Issue | Resource | Severity | Tools | Reports |")
        report.append("|-------|----------|----------|-------|---------|")
        for item in summary['distinct_findings']:
            report.append(f"| {item['issue']} | {item.get('resource') or '-'} | {item['severity']} | {', '.join(item['tools'])} | {item['reports']} |")
        report.append("")

    report.append("## Findings by Control")
    by_control = summary.get('by_control', {})
    if not by_control:
        report.append("_No findings reported._")
    else:
        report.append("| Control ID | Title | Severity | ISO 27001 | SOC 2 | Findings | Resources |")
        report.append("|------------|-------|----------|-----------|-------|----------|-----------|")
        for cid, details in by_control.items():
            resources = ", ".join(details.get('resources', []))
            if len(resources) > 100:
                resources = resources[:97] + "..."
            fw = details.get('frameworks') or {}
            iso = ", ".join(fw.get('iso27001', [])) or "-"
            soc2 = ", ".join(fw.get('soc2', [])) or "-"
            report.append(f"| {cid} | {details.get('title')} | {details.get('severity')} | {iso} | {soc2} | {details.get('total_findings')} | {resources} |")
    report.append("")

    criteria = soc2_criteria(summary)
    report.append("## SOC 2 Criteria Touched")
    report.append("_Criteria of controls with a counted or excepted finding in this run. Supported by the plan check, not met by it._")
    report.append("")
    if not criteria:
        report.append("_No mapped finding in this run._")
    else:
        report.append("| Criterion | Controls |")
        report.append("|-----------|----------|")
        for criterion in sorted(criteria, key=criterion_sort_key):
            report.append(f"| {criterion} | {', '.join(sorted(criteria[criterion]))} |")
    report.append("")

    if summary.get('unmapped_findings'):
        report.append("## Unmapped Findings")
        report.append("| Tool | Source | Severity | Message | Resource |")
        report.append("|------|--------|----------|---------|----------|")
        for finding in summary.get('unmapped_findings', []):
            report.append(f"| {finding.get('tool')} | {finding.get('source')} | {finding.get('severity')} | {finding.get('message')} | {finding.get('resource')} |")
        report.append("")

    if summary.get('excepted_findings'):
        report.append("## Excepted Findings (accepted with a reason, not counted)")
        report.append("| Tool | Source | Resource | Reason | Owner | Expires |")
        report.append("|------|--------|----------|--------|-------|---------|")
        for finding in summary['excepted_findings']:
            exc = finding.get('exception', {})
            report.append(f"| {finding.get('tool')} | {finding.get('source')} | {finding.get('resource')} | {exc.get('reason')} | {exc.get('owner')} | {exc.get('expires')} |")
        report.append("")

    with open(output_path, 'w') as f:
        f.write("\n".join(report))
    print(f"Report generated at {output_path}")

if __name__ == "__main__":
    sum_path = "output/compliance-summary.json"
    out_path = "output/compliance-report.md"
    if len(sys.argv) > 1:
        sum_path = sys.argv[1]
    if len(sys.argv) > 2:
        out_path = sys.argv[2]
    
    generate_markdown_report(sum_path, out_path)
