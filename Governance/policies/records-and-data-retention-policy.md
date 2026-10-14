# Records and data retention policy

| Field | Value |
|---|---|
| Document ID | POL-RET-01 |
| Owner | Compliance & Risk Management |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or a legal change, new record category, hold or deletion failure |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company. These are proposed requirements; a written policy is not evidence that its controls operate.

## 1. Purpose and scope

Protect records while needed, and dispose of data when its purpose and applicable obligations end. Covers ISO/IEC 27001:2022 A.5.33, A.8.10 and the retention part of A.5.34. Applies to documents, CI evidence, customer data, security logs, personnel records, exports, backups and copies held by suppliers. Classification follows [POL-DATA-01](data-classification-and-confidentiality-policy.md).

Periods below are proposed internal requirements unless a legal source is cited. A storage setting is not proof of compliant retention or deletion.

## 2. Schedule

| Category | Retention trigger and period | Owner role | Current provision and gap |
|---|---|---|---|
| Current ISMS policies and procedures | While effective; retain superseded versions through the relevant audit period plus 12 months, minimum 18 months from supersession | CISO | Partial: [document control](../ISMS/00-context-and-governance/document-control-procedure.md) uses Git history; no independent retained archive |
| CI evidence and audit, access-review, restore-test and risk-decision records | Relevant report/review period plus 12 months; at least 18 months from creation | CISO | Partial: GitHub artifacts currently 90 days per [document control](../ISMS/00-context-and-governance/document-control-procedure.md); external retained copy Planned, RISK-007 |
| Customer data and evidence | Contract term plus 30 days for active data; earlier deletion when required and lawful | Product & Engineering | Designed requirement; no tenant deletion implementation or customer records |
| Backups containing deleted customer data | Maximum further 35 days proposed, subject to verified design and contract | Cloud Platform Engineering | Gated design only: RDS automated retention 7 days, S3 noncurrent versions 30 days. Manual/final snapshots and current S3 objects have no corresponding deletion automation. The 35-day promise in POL-DATA-01 cannot be substantiated today |
| Application, ALB, S3 access and security logs | 365 days from event, subject to purpose-specific privacy review before collection | Security Operations | Gated design for selected [workload logs](logging-and-monitoring-standard.md); log-bucket current-version expiration exists, noncurrent-version expiration missing |
| CloudTrail | 1 year online plus 6 years archive proposed security target | Security Operations | Designed only in [logging standard](logging-and-monitoring-standard.md); this is not a blanket statutory retention period, and proportionality needs review before operation |
| Commercial books, inventories and annual accounts | Normally 10 years; statutory start-of-period rules apply | Managing Director | No records exist; classification and start date must be confirmed under section 3 |
| Accounting vouchers | Normally 8 years; special-sector/transition rules must be checked | Managing Director | No records exist; do not use the older blanket 6-year archive statement for these records |
| Received/sent business letters and other relevant tax records | Normally 6 years, subject to specific category and open tax matters | Managing Director | No records exist; legal category must be confirmed |
| Personnel, confidentiality, disciplinary and training records | Record-specific schedule required before collection: purpose, legal basis, employment-event trigger and exact expiry | HR & Administration | Planned; no blanket employment retention period approved. No real staff records belong in this repository |
| Incident and vulnerability investigation records | Case closure plus 18 months proposed; reviewed for minimisation and extended only on a recorded legal/contract basis | Security Operations | Designed by this policy; private record store absent |
| Device media and working exports | Delete at end of authorised purpose or before reassignment/disposal | Cloud Platform Engineering | Planned; [endpoint disposal](user-endpoint-device-policy.md) requires verified sanitisation |

## 3. Legal periods and precedence

The official [HGB §257](https://www.gesetze-im-internet.de/hgb/__257.html) and [AO §147](https://www.gesetze-im-internet.de/ao_1977/__147.html), read 2026-10-14, specify category-dependent 10-, 8- and 6-year periods. HGB §257(5) and AO §147(4) generally start the clock at the end of the calendar year of the relevant event; the exact event depends on the record. AO §147(3) can prolong retention for open tax matters. Special-sector provisions, transitions and record categorisation require confirmation before disposal. Retain required readability and, where applicable, machine evaluability.

Compliance & Risk Management records the applicable rule, source version, trigger and calculated expiry per category. The Managing Director arranges tax/legal validation. A contractual or audit preference does not automatically justify keeping all personal information longer. Reconcile conflicting duties, retain only necessary data and document the decision. Unresolved legal schedules block real collection or disposal decisions, not completion of these draft documents.

## 4. Protection and legal holds

1. Store non-public records in an access-controlled system; keep owner, classification, creation date, retention trigger and expiry metadata. Back up the register and verify retrieval and readability annually.
2. Preserve evidence integrity with hashes, access logs and an independently retained copy. A hash detects changes only if its trusted reference survives. Git history alone is not a protected evidence archive.
3. A legal hold records case ID, basis, scope, custodians, approver, start date and review date. Compliance & Risk Management coordinates it with the Managing Director and relevant advice. Suspend only affected deletion, including supplier copies.
4. Review holds at least quarterly. Document release, then recalculate expiry and remove data whose retention is no longer justified. No hold exists today.

## 5. Disposition and verification

At least monthly once records exist, owners review due items and holds. Cloud Platform Engineering performs authorised deletion and verifies active objects, versions, replicas, snapshots, exports and supplier copies. Keep a minimal deletion record: category, scope, authority, method, date, result, remaining copies and their expiry. Do not keep the deleted content as evidence of deletion.

Backups may age out only within an approved, tested maximum. Isolate them from normal use; on restore, reapply deletion instructions before returning data to service. Deleting an S3 current object can leave prior versions; deleting a KMS key serving multiple records can destroy data still subject to retention. Neither is a substitute for scoped, verified deletion.

## 6. Monitoring and current gaps

Report overdue disposal, unclassified records, expired holds, failed retrieval and evidence nearing expiry quarterly through [KPIs](../ISMS/08-monitoring-and-measurement/kpis-and-metrics.md). No disposal, hold or retrieval record exists.

Before production or an audit observation period: approve schedules, establish private records storage and retained CI exports, implement tenant deletion and backup expiry, and test restore/deletion interactions. [POL-DATA-01](data-classification-and-confidentiality-policy.md) and [SOC2-05](../SOC2/05-audit-approach-and-evidence.md) contain earlier retention statements; the gaps above must be reconciled by their owners before making customer commitments.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
