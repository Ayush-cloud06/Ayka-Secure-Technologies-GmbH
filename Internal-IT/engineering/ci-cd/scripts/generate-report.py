import json
import os
import sys

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
    report.append("")
    
    report.append("## Summary Totals")
    totals = summary.get('totals', {})
    report.append(f"- **HIGH:** {totals.get('HIGH', 0)}")
    report.append(f"- **MEDIUM:** {totals.get('MEDIUM', 0)}")
    report.append(f"- **LOW:** {totals.get('LOW', 0)}")
    report.append("")

    report.append("## Metadata Coverage")
    coverage = summary.get('metadata_coverage', {})
    report.append(f"- **Total Findings:** {coverage.get('total_findings', 0)}")
    report.append(f"- **Mapped Findings:** {coverage.get('mapped_findings', 0)}")
    report.append(f"- **Unmapped Findings:** {coverage.get('unmapped_findings', 0)}")
    report.append(f"- **Coverage Percentage:** {coverage.get('mapped_percentage', 0)}%")
    report.append("")

    report.append("## Findings by Control")
    by_control = summary.get('by_control', {})
    if not by_control:
        report.append("_No findings reported._")
    else:
        report.append("| Control ID | Title | Severity | Findings | Resources |")
        report.append("|------------|-------|----------|----------|-----------|")
        for cid, details in by_control.items():
            resources = ", ".join(details.get('resources', []))
            if len(resources) > 100:
                resources = resources[:97] + "..."
            report.append(f"| {cid} | {details.get('title')} | {details.get('severity')} | {details.get('total_findings')} | {resources} |")
    report.append("")

    if summary.get('unmapped_findings'):
        report.append("## Unmapped Findings")
        report.append("| Tool | Source | Severity | Message | Resource |")
        report.append("|------|--------|----------|---------|----------|")
        for finding in summary.get('unmapped_findings', []):
            report.append(f"| {finding.get('tool')} | {finding.get('source')} | {finding.get('severity')} | {finding.get('message')} | {finding.get('resource')} |")
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
