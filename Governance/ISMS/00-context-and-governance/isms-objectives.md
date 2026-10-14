# Information security objectives and resources

| Field | Value |
|---|---|
| Document ID | ISMS-00-06 |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, at each management review, or when an objective is met, missed or no longer measurable |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company. Nothing is deployed. Section 5 distinguishes the 2026-10-14 API and artifact observations from metrics not yet measured. A job pass does not establish that findings are absent.

## 1. Purpose

ISO/IEC 27001:2022 clause 6.2 asks for information security objectives that are consistent with the [information security policy](information-security-policy.md), measurable where practicable, monitored, communicated and updated, with a plan for what will be done, by whom, by when and how results are evaluated. Clause 7.1 asks Ayka to determine and provide the resources the ISMS needs (section 4).

## 2. Rules

- Each objective traces to a bullet in the [information security policy §3](information-security-policy.md) or, where marked, to a risk or a legal requirement.
- Each objective names a data source that exists today or names what has to be built before it can be measured.
- A current value is given only when it was measured from that source. Otherwise: **Not yet measured**.
- Measurements over time are recorded in [KPIs and metrics](../08-monitoring-and-measurement/kpis-and-metrics.md), the measurement record for clause 9.1. This document sets the targets; it does not keep the history.
- Objectives are reviewed at the management review ([agenda](../10-management-review/management-review-agenda.md)). No management review has taken place yet.

## 3. Objectives

| ID | Objective | Traces to | Metric | Target | Due | Owner role | What will be done |
|---|---|---|---|---|---|---|---|
| OBJ-01 | Every Annex A:2022 control has an applicability decision, a status label and, if not Planned, an evidence link | Policy §3 "ISO/IEC 27001 alignment" | Controls with a complete SoA row, out of 93 | 93 of 93 | 2026-12-31 | CISO | Complete the [Statement of Applicability](../04-controls-and-soa/statement-of-applicability.md) and keep its test green |
| OBJ-02 | Every change to `main` passes the compliance gate and the regression scenarios before merge | Policy §3 "ISO/IEC 27001 alignment" and "remediation of vulnerabilities"; [POL-CHG-01 §5](../../policies/change-management-policy.md#5-rules) | Share of completed pull-request pipeline runs since the ruleset (2026-10-05) that concluded success; merged PRs bypassing the five required checks | 100 % of merged PRs with all five checks green; 0 bypasses | Continuous; reviewed quarterly | Cloud Platform Engineering | Keep ruleset `protect-main` active with the five required checks; keep the regression scenarios failing on the expected controls |
| OBJ-03 | Changes are reviewed and approved by someone other than the author | Policy §3 "least privilege"; [POL-CHG-01 §10](../../policies/change-management-policy.md#10-current-gaps); RISK-005 | Merged PRs with an approving review by a second person, out of all merged PRs | 100 % for gate paths, `.github/` and `Governance/` | When a second maintainer joins; no date can be set today | CISO | Recruit or appoint a second maintainer, then set required approvals to 1 and require code-owner review. Until then, a monthly Managing Director review is proposed in POL-CHG-01 §10; none has occurred |
| OBJ-04 | MFA is required for all privileged access | Policy §3 "MFA for all privileged access"; [POL-AC-01 §4.2](../../policies/access-control-policy.md#42-authentication) | Privileged identities covered by an active Conditional Access MFA policy, out of all privileged identities | 100 % | Before first deployment | Cloud Platform Engineering | Licence a tier that supports Conditional Access (or use security defaults) and switch on `enable_conditional_access` ([NIS2-02](../../NIS2/02-risk-management-measures.md) priority 2) |
| OBJ-05 | Identified vulnerabilities are fixed or formally excepted in time | Policy §3 "timely remediation of identified vulnerabilities" | (a) Unexcepted findings that block the gate on `ayka-portal` at `main`; (b) exceptions past expiry in `exceptions.yaml`; (c) application vulnerabilities fixed within 7 days (critical) or 30 days (high), per [NIS2-05 A.2](../../NIS2/05-supply-chain-security.md#a2-aykas-standard-positions) | (a) 0; (b) 0; (c) 100 % | (a), (b) continuous; (c) before first deployment | Cloud Platform Engineering; Product & Engineering for (c) | Keep the gate blocking; renew or fix every exception before 2027-03-31; add application dependency and code scanning, see the [vulnerability and patch management policy](../../policies/vulnerability-and-patch-management-policy.md) |
| OBJ-06 | Cloud logging is configured in every gated design and security events reach a person | Policy §3 "secure logging and monitoring" | (a) Open findings for the logging controls `S3_LOGGING_DISABLED`, `VPC_FLOW_LOGS_MISSING`, `CLOUDWATCH_LOG_GROUP_KMS_ENCRYPTION`, `WAF_LOGGING_DISABLED` on `ayka-portal` at `main`; (b) alert routes to an on-call person | (a) 0 unexcepted; (b) one tested route per alert source | (a) 2026-12-31; (b) before first deployment | Cloud Platform Engineering; Security Operations for (b) | Read (a) from the evidence bundle each quarter; build detection per [STD-LOG-01](../../policies/logging-and-monitoring-standard.md#6-alerting) |
| OBJ-07 | Access rights are reviewed regularly | Policy §3 "regular access reviews" | Completed and recorded access reviews per quarter, per [POL-AC-01 §4.6](../../policies/access-control-policy.md#46-access-reviews) | 4 per year, the first within 3 months of a live identity tenant | First review: 3 months after the identity tenant goes live | Security Operations | Follow the [access review procedure](../06-operational-procedures/access-review-procedure.md); record on the [SOC2-05 §7.1](../../SOC2/05-audit-approach-and-evidence.md#71-quarterly-access-review-ac-07) template |
| OBJ-08 | Audit evidence is retained for an audit period plus 12 months | Policy §6 "compliance obligations"; RISK-007; [SOC2-05 §6](../../SOC2/05-audit-approach-and-evidence.md#6-evidence-sources-and-retention) | Retention of CI evidence bundles, in days | At least 18 months, outside the pipeline that produced them | Before an audit period starts | Cloud Platform Engineering | Copy each `compliance-evidence` bundle to storage with write-once retention, see the [records and data retention policy](../../policies/records-and-data-retention-policy.md) |
| OBJ-09 | Infrastructure code targets only the approved EU Region | Policy §6 "compliance obligations" (GDPR); RISK-011; legal register [LR-01](legal-and-regulatory-register.md) | Terraform files and SCP documents that name a Region other than `eu-central-1` | 0 | Before any customer contract promises EU data location | Cloud Platform Engineering | Migrate every root to `eu-central-1` per the [cloud security policy](../../policies/cloud-security-policy.md) |
| OBJ-10 | Risks are reassessed on a fixed cycle | Policy §3 "documented risk management processes"; §5 | Days between dated entries in the risk register review history | At most 92 days | Continuous | CISO | Quarterly review per the [risk management methodology](../03-risk-management/risk-management-methodology.md) |
| OBJ-11 | All staff complete security awareness training, and role-specific tool-use obligations | Policy §4 "all personnel"; clause 7.3; legal register where applicable | Staff with a completion record for the current year, out of all staff | 100 % | Before production access; remaining onboarding within 3 months of hire; annual refresh | HR & Administration | Run the [training programme](../../../organization/training-and-awareness.md) and keep records |

## 4. Resources (clause 7.1)

What each objective needs, and whether it exists. Resource decisions are the Managing Director's ([roles](../../../organization/roles-and-responsibilities.md), section 2).

| Resource | Needed for | Exists today? |
|---|---|---|
| People: one maintainer holding every role | All | Yes. This is also the main constraint: no segregation of duties (RISK-005) |
| A second maintainer or reviewer | OBJ-03, independent internal audit | No |
| GitHub repository, Actions minutes, rulesets and environments | OBJ-02, OBJ-03, OBJ-05 | Yes (public repository) |
| Pinned scanner toolchain | OBJ-02, OBJ-05, OBJ-06 | Yes ([`toolchain.versions`](../../../Internal-IT/engineering/ci-cd/toolchain.versions)) |
| Entra ID licence tier with Conditional Access, or security defaults | OBJ-04 | No: lab tenant on Entra ID Free (processor register SUP-02) |
| Application code and dependency scanner | OBJ-05 (c) | No |
| Detection and alerting services (for example GuardDuty, Security Hub, alert routing) | OBJ-06 (b) | No: designed only ([NIS2-02](../../NIS2/02-risk-management-measures.md) No. 2) |
| Write-once evidence storage outside GitHub | OBJ-08 | No |
| An AWS account in `eu-central-1` | OBJ-04, OBJ-06, OBJ-07, OBJ-09 | No evidence of one; CI uses mock credentials |
| Training material and a record system | OBJ-11 | No |
| Budget | Licences, AWS cost, training | Not recorded. No budget decision exists |

## 5. Measurement: data sources and current values

| ID | Data source | How measured on 2026-10-14 | Current value |
|---|---|---|---|
| OBJ-01 | [SoA](../04-controls-and-soa/statement-of-applicability.md) and [test](../../../tests/governance/test_soa.py) | Counted all Annex A rows and ran the linked structural test on 2026-10-14; this does not test effectiveness | 93 of 93 controls have applicability, status, evidence/related design and remaining work; management approval pending |
| OBJ-02 | GitHub Actions run history of `PR Compliance Pipeline`; ruleset `protect-main` | `gh run list` (read-only); `gh api .../rulesets/24482491` | 28 of 28 completed pull-request runs from 2026-10-05 to 2026-10-06 concluded success; 16 PRs merged in that window. The ruleset is active with the five required checks and no bypass actors. 14 runs on `main` are still waiting on `manual-apply-approval` and are not counted |
| OBJ-03 | Pull request reviews | `gh pr list --state merged --limit 100 --json author,reviews` | 0 of 22 merged PRs approved by a second person in the rechecked 2026-10-14 snapshot; automated comments are not approving reviews |
| OBJ-04 | Entra ID Conditional Access configuration and sign-in logs (none exist); Terraform default `enable_conditional_access = false` in [`entra-id/variables.tf`](../../../Internal-IT/platform/domains/identity/entra-id/variables.tf) | Not measurable: no tenant export | Not yet measured. The design switches the MFA policy off by default |
| OBJ-05 | `compliance-evidence` artifact of each run; [`exceptions.yaml`](../../../Internal-IT/engineering/policy-as-code/metadata/exceptions.yaml) | (a) job results of [run 37498007502](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/37498007502), the last run on `main`; (b) expiry dates read from the file | (a) Artifact verified: 0 active HIGH/MEDIUM, 6 active LOW and 14 excepted findings; see [evidence index](../07-technical-evidence/control-evidence-index.md). (b) 0 of 13 entries expired as of 2026-10-14 (all expire 2027-03-31). (c) Not yet measured: no application scanner |
| OBJ-06 | `compliance-evidence` artifact; alert configuration (none) | Parsed `output/compliance-summary.json` for run 37498007502; source/hash in [evidence index](../07-technical-evidence/control-evidence-index.md) | (a) 3 active LOW findings for `CLOUDWATCH_LOG_GROUP_KMS_ENCRYPTION`; the other listed logging controls have no active finding in this snapshot. (b) No tested alert route exists |
| OBJ-07 | Access review records | Checked for records | No access review record exists (RISK-010) |
| OBJ-08 | GitHub repository setting | `gh api .../actions/permissions/artifact-and-log-retention` | 90 days, the maximum this repository allows |
| OBJ-09 | Terraform source | `rg -l ap-south-1` over `*.tf`, `*.tfvars` and JSON in `Internal-IT/` | 10 Terraform files and 1 SCP document ([`restrict-region.json`](../../../Internal-IT/platform/foundation/aws-organization/modules/scp/restrict-region.json)) name `ap-south-1` |
| OBJ-10 | [Risk register review history](../03-risk-management/risk-register.md#review-history) | Read the dated entries | Prior entries 2026-08-23, 2026-09-28 and 2026-10-05 were within 92 days. Current review status must be read from the linked register; document edits alone are not a management risk review |
| OBJ-11 | Training records ([training programme §5](../../../organization/training-and-awareness.md#5-training-records)) | Checked for records | No training record exists (RISK-010) |

## 6. Communication and review

- Objectives and progress are communicated as set out in the [communication plan](communication-plan.md): to the Managing Director in the quarterly security report and at the management review, to staff through the training programme.
- The CISO updates sections 3 and 5 when a measurement is taken; history goes into [KPIs and metrics](../08-monitoring-and-measurement/kpis-and-metrics.md).
- An objective that is missed goes to the [nonconformity and corrective action log](../11-improvement/nonconformity-and-corrective-action-log.md); a new objective needs the Managing Director's approval.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
