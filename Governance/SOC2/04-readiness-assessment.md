# SOC 2 Readiness Assessment

| Field | Value |
|---|---|
| Document ID | SOC2-04 |
| Owner | CISO |
| Prepared by | Compliance and Risk |
| Version | 1.0 |
| Assessment date | 2026-10-06 |
| Basis | Repository `main` as of 2026-10-06; [control matrix](03-control-matrix.md); [risk register](../ISMS/03-risk-management/risk-register.md) |
| Status | Draft. Internal self-assessment, not an auditor's readiness review |

## 1. Conclusion

**Ayka is not ready for a SOC 2 Type I and should not engage an auditor yet.**

The reason is not paperwork. A SOC 2 examination reports on a system that runs, and the Ayka Portal has never been deployed: the pipeline applies nothing (`SIMULATED APPLY`), the workload uses mock credentials, and the platform roots have never been applied. An auditor can test the change-management pipeline today, but a report on the pipeline alone would not answer any customer's question about the service.

What is already strong is unusual for a company this size: every change to the `ayka-portal` workload is scanned by three tools against 38 mapped rules, decided fail-closed, recorded in a checksummed evidence bundle, and the gate proves on every run that it still catches known-bad configurations. Those controls (CA-01, CA-02, CM-01 to CM-04, MO-01, IC-01) would pass a Type I design test now and generate Type II evidence automatically. They do not yet cover the platform roots (G12).

## 2. Results by area

| Area | Criteria | Position |
|---|---|---|
| Change management | CC8.1, CC5.2, CC7.1 (IaC) | Close to ready. One structural gap: approvals are self-approvals |
| Configuration security | CC6.6, CC6.7, A1.2 | Designed well and checked by the gate, but never deployed |
| Identity and access | CC6.1 to CC6.3 | Designed in Terraform; not applied; MFA not enforceable on the current Entra licence; no access reviews |
| Detection and response | CC7.2 to CC7.5 | Logs designed; no alerting; incident plan written, never exercised |
| Governance and people | CC1, CC2 | Policies drafted; no approvals, acknowledgements, training records or management reporting |
| Risk and vendors | CC3, CC9 | Risk register real and dated; vendor reviews not started |
| Availability and confidentiality | A1, C1 | Infrastructure designed; no restore test, no uptime monitoring, no data deletion process run |

Criterion-level ratings: 3 ready, 17 partly ready, 18 not ready (of 38). See the [mapping](02-trust-services-criteria-mapping.md#6-summary).

## 3. Blocking gaps, ranked

Each gap names the criteria it blocks, why an auditor would care, and the fix.

| # | Gap | Criteria | Why it blocks | Fix | Owner |
|---|---|---|---|---|---|
| G1 | No production system: nothing is deployed, state is local, the apply is simulated | All | Controls over a system that does not run cannot be "implemented" (Type I) or "operating" (Type II) | Remote state with locking (RISK-002), a documented bootstrap order (RISK-012), real apply from the approved pipeline, first production release | Cloud Platform Engineering |
| G2 | Production Region is `ap-south-1`, while the commitment is EU residency | CC2.3, C1.1, system description | The description would contradict the Terraform; a description that misstates the system leads to a qualified opinion | Move all roots and the region SCP to `eu-central-1` before go-live (RISK-011) | Cloud Platform Engineering |
| G3 | Change approver can be the change author (0 required approvals; environment self-review allowed) | CC8.1, CC5.1, CC6.3 | Segregation of duties in change management is the most-tested SOC 2 control; self-approval is an exception in every sample | Require 1 approval from someone other than the author on `protect-main` and on both environments once a second maintainer exists; until then, a monthly retrospective review of all merged changes by the Managing Director as a compensating detective control | CISO |
| G4 | MFA is not enforced: Conditional Access is disabled because the tenant is on Entra ID Free | CC6.1 | Auditors test MFA on every administrative path. Without it, CC6.1 fails | Licence Entra ID P1 for staff with AWS access, or use Security Defaults (free, all-users MFA) as an interim; require MFA in IAM Identity Center | CISO |
| G5 | Bootstrap passwords remain in public Git history; tenant check and rotation pending | CC6.1, CC7.3 | An open credential exposure is an incident the description must disclose (DC 4) | Complete RISK-001: confirm whether the accounts exist, rotate, review sign-in logs, record the outcome | Identity owner |
| G6 | No security alerting: the `security-alerts` SNS topic has no publisher; GuardDuty, Security Hub and AWS Config are absent; the break-glass procedure promises an alert that does not exist | CC7.2, CC7.3, AC-08 | CC7.2 needs evidence that anomalies are detected and acted on | GuardDuty and EventBridge rules (root and break-glass use, CloudTrail and IAM changes) into the topic, routed to on-call; test each rule once and keep the test record | Security Operations |
| G7 | CI evidence expires after 90 days | CC2.1, CC8.1, all automated controls | A Type II period is 6 to 12 months and the report is issued months later; samples from the start of the period would be gone | Copy each run's evidence bundle to a dedicated S3 bucket with Object Lock (compliance mode, 18 months minimum). GitHub Actions caps artifact retention at 90 days for public repositories, so `retention-days` alone cannot fix this (**to verify** for the plan in use) | Cloud Platform Engineering |
| G8 | No recurring people-process records: access reviews, training, background checks, NDAs, vendor reviews, quarterly management reports | CC1, CC2, CC6.2, CC6.3, CC9.2 | Type II samples each occurrence; a control without records is a control that did not operate | Run each process from the start of the observation period using the templates in [SOC2-05](05-audit-approach-and-evidence.md#7-record-templates) | Process owners |
| G9 | Policies not approved and not acknowledged | CC1.1, CC2.2, CC5.3 | Auditors check approval dates and staff acknowledgement before testing anything else | Managing Director approves via a merged pull request; staff acknowledge in the HR system | CISO |
| G10 | No vulnerability scanning beyond infrastructure code; container image referenced by mutable tag | CC7.1, CC6.8 | CC7.1 covers newly discovered vulnerabilities in the running system, not only misconfiguration | Pin images by digest; add image and dependency scanning to CI; Amazon Inspector for ECR | Product and Engineering |
| G11 | No restore test and no uptime monitoring | A1.1, A1.3 | Availability claims need tested recovery and measured uptime | Quarterly automated restore of the latest RDS snapshot into an isolated account; external uptime checks | Cloud Platform Engineering |
| G12 | Platform roots (organization, landing zone, identity) are not scanned by the gate | CC7.1, CC8.1 | The most privileged infrastructure bypasses the strongest control | Add the platform roots as gated workloads in `test.yml` | Repository owner |
| G13 | The access-log bucket is versioned, but its lifecycle rule only expires current versions, so noncurrent ALB and S3 access-log versions would be kept indefinitely | CC7.2, C1.2 | The 365-day retention stated in OP-04 and POL-DATA-01 would not hold, and personal data in logs would be kept longer than stated | Add `noncurrent_version_expiration` to the `access_logs` lifecycle rule in [`storage/main.tf`](../../Internal-IT/workloads/ayka-portal/modules/storage/main.tf) | Cloud Platform Engineering |

## 4. Non-blocking observations

- The gate's control mapping is ISO-only. Adding SOC 2 criteria to each rule in `control-mapping.yaml` would let the compliance report show criterion coverage per run.
- `exceptions.yaml` has 13 entries that all expire on 2027-03-31. Staggering expiry dates avoids a single day on which 13 findings return and block every change.
- `S3_REPLICATION_DISABLED` is LOW and open. For a 99.5 % availability target this is acceptable; if the commitment rises, cross-Region backup copies become necessary.
- The personnel register has 24 people while most real control evidence points at one maintainer. For an actual audit, every role holder in the description must be a real person who can be interviewed.
- With 24 staff, Ayka is below the 50-employee threshold of the German Whistleblower Protection Act (HinSchG). A reporting channel (IC-03) is still good practice and helps CC2.2.

## 5. Remediation roadmap

Months are counted from the decision to proceed. They are sequencing, not commitments.

| Phase | When | Work | Exit criterion |
|---|---|---|---|
| 1. Foundations | Months 1 to 2 | G2 Region move, G1 remote state and bootstrap order, G5 credential closure, G4 MFA, G9 policy approval | Platform applied in `eu-central-1`; MFA enforced; RISK-001 closed with evidence |
| 2. Production and detection | Months 2 to 4 | G1 first production release through the gate, G6 alerting, G7 evidence archive, G10 image scanning, G12 gate the platform roots, G13 access-log expiry | Portal live; one tested alert per rule; evidence lands in Object Lock |
| 3. People processes | Months 3 to 4 | G8: first quarterly access review, training campaign, vendor reviews, first management report; G3 second approver or compensating review | One complete cycle of each recurring control on record |
| 4. Readiness check | Month 5 | Optional auditor readiness review; internal self-assessment (MO-02); fix findings Every control in the matrix is Implemented or carved out; any exception is written into the system description with the reason it is not needed for the in-scope criteria |
| 5. Type I | Month 6 | Type I as of a date | Report issued |
| 6. Type II | Months 6 to 12 | 6-month observation period, then fieldwork | Report issued around month 14 |

**Indicative external cost** (to verify with quotes): a Type I for a company of Ayka's size is typically quoted in the low tens of thousands of euros, and a Type II somewhat higher; a compliance automation platform and a penetration test add to that. These figures vary widely by firm and scope.

## 6. Re-assessment

This assessment is repeated at the end of each roadmap phase, and its date and conclusion are updated in the same pull request as the control matrix.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-06 | First issue |
