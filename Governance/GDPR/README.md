# GDPR

> Simulated case study. Ayka Secure Technologies GmbH is fictional, has no customers and runs no deployed system. These documents show how the GDPR would be applied to the design in this repository, and record the few places where the repository itself really processes personal data.

## Ayka's roles under the GDPR

| Processing | Ayka's role | Why |
|---|---|---|
| Employee identity and access data | Controller (Art. 4(7)) | Ayka decides why and how staff data is used for access provisioning |
| Customer data stored in the SaaS platform (`ayka-portal`) | Processor (Art. 4(8), Art. 28) | Customers decide what they store; Ayka processes it on their instructions. Planned: no customer exists |
| Repository and CI metadata (commit authors, workflow logs) | Controller | The repository owner runs the repository |

## Region

Target Region for all personal data: **`eu-central-1` (Frankfurt)**. The Terraform does not match this yet: most roots, and the region-restriction SCP ([`restrict-region.json`](../../Internal-IT/platform/foundation/aws-organization/modules/scp/restrict-region.json)), name `ap-south-1` (Mumbai). Until that is migrated no "data stays in the EU" claim is supported (RISK-011, TRT-011 in the [risk register](../ISMS/03-risk-management/risk-register.md)).

## Documents

Status: `Draft` = written, not approved (no real approver exists) · `Planned` = not written yet.

| Document | GDPR article | Status |
|---|---|---|
| [Record of Processing Activities](record-of-processing-activities.md) | Art. 30 | Draft |
| [Processor and sub-processor register](processor-register.md) | Art. 28 | Draft |
| [TOMs: identity and access](technical-and-organization-measures/identity-and-access-toms.md) | Art. 25, 32 | Draft |
| [TOMs: segregation of duties](technical-and-organization-measures/segregation-of-duties.md) | Art. 32 | Draft |
| Data-flow map and international transfer assessment | Art. 44–49 | Planned |
| DPIA screening | Art. 35 | Planned |
| Data subject rights procedure | Art. 12–22 | Planned |
| Personal data breach procedure | Art. 33, 34 | Planned |
| Data retention schedule | Art. 5(1)(e) | Planned |
| DPO decision and legal-basis register | Art. 6, 37 | Planned |
| TOMs: encryption, logging, backup | Art. 32 | Planned |

## Rules for these documents

- Every measure carries the weakest true label from the [README yardstick](../../README.md#2-yardstick-capability-status): Implemented, Simulated, Planned (design-only), or Not designed.
- No invented records: no signed DPAs, DPIA approvals, breach notifications or data subject requests.
- Facts about real providers' contracts are marked **to verify** until checked against the provider's current terms.
