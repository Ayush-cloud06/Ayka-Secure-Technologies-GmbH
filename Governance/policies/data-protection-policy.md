# Data protection policy

| Field | Value |
|---|---|
| Document ID | POL-PRIV-01 |
| Owner | Compliance & Risk Management |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or a new processing purpose, processor, transfer or personal-data incident |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company. These are proposed requirements; a written policy is not evidence that its controls operate.

## 1. Purpose and boundaries

Protect personal information across its life cycle and support ISO/IEC 27001:2022 A.5.31 and A.5.34. The company is designed to act as controller for employment/business administration and processor for customer-uploaded evidence. The [record of processing activities](../GDPR/record-of-processing-activities.md) distinguishes actual repository metadata from future processing. No customer processing operates today.

This policy sets responsibilities and launch prerequisites. The [GDPR document index](../GDPR/README.md) remains the register for detailed privacy work; it is not made complete by this policy.

## 2. Required decisions before processing

| Decision | Required record | Accountable role |
|---|---|---|
| Purpose, controller/processor role, data categories, people affected and recipients | Updated processing record; distinguish contract instructions from Ayka's own purposes | Compliance & Risk Management |
| Lawful basis and transparency | Reasoned basis per purpose, privacy notice and delivery method; do not default to employee consent | Compliance & Risk Management |
| Necessity and minimisation | Only fields required for the purpose; redact customer evidence and logs; no secrets in tickets | Product & Engineering |
| Retention and deletion | Record-specific period, trigger, storage locations, deletion mechanism and hold process | Compliance & Risk Management |
| Risk and privacy by design | DPIA screening before new/high-impact processing; complete any required assessment before launch | CISO |
| Supplier and transfers | Processor terms, subprocessors, support access locations, transfer mechanism and assessment where needed | Compliance & Risk Management |
| Oversight | Document whether a DPO is required, who handles requests and how that function is contacted | Managing Director |

Legal basis, DPO requirement, DPIA necessity and transfer mechanism require assessment of actual processing. Open legal decisions are in the [legal register](../ISMS/00-context-and-governance/legal-and-regulatory-register.md); none is implied by a fictional headcount or an EU Region setting.

## 3. Handling rules

- Treat personal information as Confidential by default under [classification](data-classification-and-confidentiality-policy.md); sensitive material may require Restricted handling.
- Use named, least-privilege access under [access control](access-control-policy.md). Review both customer access boundaries and administrative access. Do not use live personal data in development or test.
- Use approved encryption under [cryptography](cryptography-policy.md). Pseudonymised data remains protected; encryption does not by itself remove privacy obligations.
- Publish no real personnel, customer, incident or request records to this public repository. Templates contain no real identities or signatures. Existing personnel entries are labelled fictional; verify any disputed identity before retaining it.
- Target hosting is `eu-central-1`, while Terraform still names `ap-south-1` (RISK-011). No EU-location promise may be made until actual hosting, support access and transfers are assessed.
- Process customer data only on documented instructions, with agreed assistance, return/deletion and subprocessor arrangements. Escalate a suspected unlawful instruction for legal assessment before acting.

## 4. Requests, incidents and evidence

| Event | Required response | Record and limit |
|---|---|---|
| Access, correction, deletion, restriction, objection or portability request | Record receipt; verify identity proportionately; determine controller role and applicable response deadline; locate relevant systems; assess exceptions; respond securely | Private request register with date, scope, due date, decision and completion. A processor promptly passes requests to its customer and assists; it does not independently decide the customer's response |
| Suspected personal-data breach | Immediately use [incident response](incident-response-plan.md) and the GDPR path in [NIS2-03](../NIS2/03-incident-reporting-procedure.md); assess notification without waiting for full investigation | Private breach record including awareness time, risk, decision reasons, notices and follow-up. Confirm applicable legal deadlines and current authority channel |
| Contract end or verified deletion request | Apply [retention](records-and-data-retention-policy.md); address versions, backups, logs and subprocessors; identify lawful holds | Deletion record states what was removed, exceptions and remaining backup expiry; no absolute deletion claim before verification |
| New purpose or material design change | Repeat section 2, update notices and processing record before use | Decision and change evidence |

The detailed rights-request procedure, DPIA screening, transfer assessment and DPO decision remain Planned in the [GDPR index](../GDPR/README.md). These require completion before relevant real processing begins.

## 5. Sources, current status and review

Primary legal source: [GDPR, Regulation (EU) 2016/679](https://eur-lex.europa.eu/eli/reg/2016/679/oj), notably Articles 5–6, 12–22, 25, 28, 30, 32–39 and 44–49. The online text was unavailable during this document review; exact applicability and deadlines are **to verify** against the current text before operational use. Do not treat this draft as an opinion on compliance.

Status: Designed, evidenced by this policy, the [processing record](../GDPR/record-of-processing-activities.md), [processor register](../GDPR/processor-register.md) and [technical and organisational measures](../GDPR/technical-and-organization-measures/identity-and-access-toms.md). No request, breach, deletion or training evidence exists. Compliance & Risk Management reviews the records annually and before each processing change; unresolved prerequisites go to the CISO and Managing Director.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
