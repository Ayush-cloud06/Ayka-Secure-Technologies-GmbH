# Threat intelligence procedure

| Field | Value |
|---|---|
| Document ID | ISMS-OPS-09 |
| Owner | Security Operations |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or when a source, pinned tool or supplier notice changes |
| Status | Draft. Not approved: no approval record exists (simulated company) |

Ayka Secure Technologies GmbH is a simulated company. This procedure defines how relevant threats are noticed and fed into risk and change decisions. It does not record a subscription, a membership or a completed assessment.

## 1. Purpose and boundary

ISO/IEC 27001:2022 A.5.7 requires information about threats to be collected and analysed so that controls stay relevant. A.5.6 (contact with security groups) is a separate duty: this procedure does not create a membership.

The [vulnerability and patch policy](../../policies/vulnerability-and-patch-management-policy.md) owns remediation deadlines. This procedure owns the question that comes first: which external report is relevant to a component Ayka actually uses, and does it change a [threat scenario](../03-risk-management/threat-scenarios-catalog.md) or a [risk](../03-risk-management/risk-register.md)?

## 2. Sources

A source is in scope only when it can name a component, a supplier or a scenario already in this repository. General news is not a source.

| Source | What it can show | What is true on 2026-10-14 |
|---|---|---|
| Advisories for pinned CI tools | Defects in Terraform, TFLint, conftest/OPA, tfsec, Checkov and the GitHub Actions that the workflows pin | Versions and checksums are in [`toolchain.versions`](../../../Internal-IT/engineering/ci-cd/toolchain.versions). No advisory review is recorded |
| Advisories for pinned Actions and Terraform providers | Compromise or vulnerability of a commit Ayka has pinned | Pins exist. Licences and advisory review do not ([legal register](../00-context-and-governance/legal-and-regulatory-register.md) LR-08) |
| GitHub security advisories for this repository | Vulnerable dependencies and exposed secrets in the repository GitHub hosts | Secret scanning and push protection are disabled ([secure development policy](../../policies/secure-development-policy.md), GitHub API on 2026-10-14). No Dependabot or code-scanning workflow is in [`.github/`](../../../.github/) |
| AWS security bulletins for services in the workload and landing-zone design | Service-specific weaknesses in S3, RDS, ECS, IAM, KMS, CloudTrail and WAF | No AWS account is evidenced. No bulletin subscription exists |
| Supplier notices for GitHub and Microsoft | Incidents in source hosting or the designed identity provider | [Processor register](../../GDPR/processor-register.md) SUP-02 and SUP-03. No notice subscription is recorded |
| Internal catalogue | Scenarios already judged relevant to this repository | [Threat scenarios catalogue](../03-risk-management/threat-scenarios-catalog.md), Designed. It is an input, not an intelligence feed |

Security Operations may add a source only with a named component, an owner and a place the output will be written. Adding a source is not itself an assessment.

## 3. Triage

| Step | Responsible role | Required result |
|---|---|---|
| Notice | Whoever sees the report, the same day | Send the link and the suspected component to Security Operations. Do not put exploit steps or customer data in a public issue ([communication plan](../00-context-and-governance/communication-plan.md)) |
| Relevance | Security Operations, within two working days; immediately if exploitation is reported | State whether a pinned version, a designed service or an open risk is affected. "Not our component" is a recorded decision |
| Severity | Security Operations | Use the [vulnerability policy](../../policies/vulnerability-and-patch-management-policy.md) targets when a weakness is confirmed. An unscored bulletin does not wait for a perfect score |
| Where it goes | Security Operations | One of: no change; a finding under the [scanning procedure](vulnerability-scanning-procedure.md); a [change](change-management-procedure.md); an update to the threat catalogue or the risk register |
| Urgent compromise | CISO | [Incident response](../../policies/incident-response-plan.md) when the report describes active misuse of something Ayka holds, including historical credentials (RISK-001) |

The weekly review of advisories for pinned tools is the standing requirement. It has not been performed. There is no on-call rota that would make "immediately" a staffed response.

## 4. Assessment record

Write each assessment, including "not relevant", in restricted storage. Do not backfill this public repository with imagined reviews.

| Field | Content |
|---|---|
| Date and reviewer role | When the decision was made, and who made it |
| Source | URL or bulletin identity, retrieved on that date |
| Component | Pinned version, designed service or scenario ID |
| Decision | No change, finding, change, risk update or incident |
| Destination | Risk ID, pull request, finding ID or "none" |
| Residual | What remains true after the decision |

No row exists. A subscription confirmation, a mailing-list membership or a saved bulletin is not an assessment.

## 5. Status

Designed by this procedure. G10 stays open: no source is subscribed, no community contact is appointed, and no dated assessment has been written. The plan gate remains a configuration check. It is not threat intelligence.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
