# GDPR

> Simulated case study. Ayka Secure Technologies GmbH is fictional, has no customers and runs no deployed system. These documents show how the GDPR would be applied to the design in this repository, and record the few places where the repository itself really processes personal data.

## Completion position

Counted from the sixteen documents in the Documents table below, each placed by the strongest evidence its own row or status line cites; a document is counted once.

| Position | Documents |
|---|---:|
| Real evidence (a configured setting or real operating record, repository rows only) | 2 |
| Simulated walk-through | 13 |
| Gated design (Terraform planned and scanned, never applied) | 1 |
| Design only (draft or template, no record) | 0 |
| Open (not written) | 0 |
| **Total** | **16** |

Placement: real evidence are the segregation-of-duties TOMs and the identity TOMs (both cite the ruleset and CODEOWNERS rows as Implemented for the repository); simulated are the RoPA, DPO register, DPIA, rights procedure and the breach procedure in NIS2-03, and, since 2026-11-10, the processor register ([SIM-GDPR-007](../records/simulated/privacy/SIM-GDPR-007-processor-register-and-tom-review.md)), the transfer assessment ([SIM-GDPR-005](../records/simulated/privacy/SIM-GDPR-005-transfer-assessment-review.md)), the legitimate interests assessment and both privacy notices ([SIM-GDPR-006](../records/simulated/privacy/SIM-GDPR-006-privacy-notice-issue-and-lia-review.md)), the DPA template ([SIM-GDPR-004](../records/simulated/privacy/SIM-GDPR-004-dpa-conclusion-customer-a.md)), the DPIA screening (already walked in SIM-GDPR-003) and the retention schedule ([SIM-INF-002](../records/simulated/information/SIM-INF-002-customer-data-deletion-at-contract-end.md)); gated design is the encryption, logging and backup TOMs, whose rows rest on scanned Terraform and plan checks. The annual TOM review in SIM-GDPR-007 does not move any TOM document: a review of a text is not an operating record, so the encryption TOMs stay Gated design and the two real-evidence TOMs stay as placed. Simulated walk-throughs are not operating evidence, and no document here describes a processing activity that runs for customers: no customer exists and nothing is deployed.

## Ayka's roles under the GDPR

| Processing | Ayka's role | Why |
|---|---|---|
| Employee identity and access data | Controller (Art. 4(7)) | Ayka decides why and how staff data is used for access provisioning |
| Customer data stored in the SaaS platform (`ayka-portal`) | Processor (Art. 4(8), Art. 28) | Customers decide what they store; Ayka processes it on their instructions. Planned: no customer exists |
| Repository and CI metadata (commit authors, workflow logs) | Controller | The repository owner runs the repository |

## Region

Target Region for all personal data: **`eu-central-1` (Frankfurt)** ([ADR-0003](../ADR/0003-target-region.md)). The Terraform roots and the region-restriction SCP ([`restrict-region.json`](../../Internal-IT/platform/foundation/aws-organization/modules/scp/restrict-region.json)) name `eu-central-1`; no Terraform, variable, JSON, YAML, Python or shell file names `ap-south-1` ([REAL-INFRA-003](../records/real/infra/REAL-INFRA-003-region-migration-verification.md), rechecked 2026-11-10). Two identity documents ([`identity-source.md`](../../Internal-IT/platform/domains/identity/docs/identity-source.md), [`scim.md`](../../Internal-IT/platform/domains/identity/docs/scim.md)) still mention `ap-south-1` as history: the Identity Center instance made through the console sits there and must be re-created in `eu-central-1`. Nothing is applied and no account holds data, so no "data stays in the EU" claim is supported by an operating system (RISK-011, TRT-011 in the [risk register](../ISMS/03-risk-management/risk-register.md)). The other GDPR documents point here for the state of the source.

## Documents

Status: `Draft` = written, not approved (no real approver exists) · `Template` = text to be filled per customer · `Planned` = not written yet. "Simulated" means a bannered tabletop record exists (see [ADR-0006](../ADR/0006-simulated-operating-records.md)).

| Document | GDPR article | Status |
|---|---|---|
| [Record of Processing Activities](record-of-processing-activities.md) | Art. 30 | Draft v1.1. PA-05, PA-06 added. Retention not approved. Simulated review: [SIM-GDPR-002](../records/simulated/privacy/SIM-GDPR-002-ropa-annual-review.md) |
| [Processor and sub-processor register](processor-register.md) | Art. 28 | Draft. No DPA or attestation retrieved. Simulated annual review: [SIM-GDPR-007](../records/simulated/privacy/SIM-GDPR-007-processor-register-and-tom-review.md) |
| [TOMs: identity and access](technical-and-organization-measures/identity-and-access-toms.md) | Art. 25, 32 | Draft v2.1. `aws-iam-core` rows labelled Gated design. Annual review walked in [SIM-GDPR-007](../records/simulated/privacy/SIM-GDPR-007-processor-register-and-tom-review.md); stale statements found, not yet corrected |
| [TOMs: segregation of duties](technical-and-organization-measures/segregation-of-duties.md) | Art. 32 | Draft |
| [TOMs: encryption, logging, backup, rights tooling](technical-and-organization-measures/encryption-logging-backup-toms.md) | Art. 32 | Draft v1.2. Plan checks and fixture tests are labelled separately; scanned platform Terraform is labelled Gated design |
| [Data-flow map and international transfer assessment](data-flow-and-transfer-assessment.md) | Art. 44 to 49 | Draft v1.1. Chapter V position selected per supplier (DPF where certified, SCCs as fallback). Certification to verify. Simulated review: [SIM-GDPR-005](../records/simulated/privacy/SIM-GDPR-005-transfer-assessment-review.md) |
| [Legitimate interests assessment](legitimate-interests-assessment.md) | Art. 6(1)(f) | Draft. PA-02 and PA-03. Simulated review: [SIM-GDPR-006](../records/simulated/privacy/SIM-GDPR-006-privacy-notice-issue-and-lia-review.md) |
| [DPO decision and legal-basis register](dpo-and-legal-basis.md) | Art. 6, 37 | Draft v1.1. DPO designation recommended (external); not appointed. Bases reviewed by the owner with AI help, not counsel. Simulated: [SIM-GDPR-001](../records/simulated/privacy/SIM-GDPR-001-dpo-decision-minutes.md) |
| [DPIA screening](dpia-screening.md) | Art. 35 | Draft. Screening. Simulated: walked in [SIM-GDPR-003](../records/simulated/privacy/SIM-GDPR-003-dpia-sign-off.md) |
| [DPIA: security logging and portal design](dpia-ayka-portal.md) | Art. 35 | Draft. PA-03 assessed on the design; DPO advice outstanding. Simulated: [SIM-GDPR-003](../records/simulated/privacy/SIM-GDPR-003-dpia-sign-off.md) |
| [Data subject rights procedure](data-subject-rights-procedure.md) | Art. 12 to 22 | Draft v1.1. No real request. Simulated: [SIM-DSR-001](../records/simulated/privacy/SIM-DSR-001-access-and-erasure-request.md). Tool tested on fixture data: [REAL-PRIV-001](../records/real/privacy/REAL-PRIV-001-dsr-tool-test-run.md) |
| [Privacy notice: employees](privacy-notice-employees.md) | Art. 13, 14, 21 | Draft. Not issued. Fictional controller details; DPO contact and retention open. Simulated issue: [SIM-GDPR-006](../records/simulated/privacy/SIM-GDPR-006-privacy-notice-issue-and-lia-review.md) |
| [Privacy notice: website](privacy-notice-website.md) | Art. 13, 14, 21 | Draft. Not published. No website exists. Simulated publication: [SIM-GDPR-006](../records/simulated/privacy/SIM-GDPR-006-privacy-notice-issue-and-lia-review.md) |
| [Customer DPA template](data-processing-agreement-template.md) | Art. 28(3) | Template. No signed instance. Simulated preparation and handover for Customer A (fictional): [SIM-GDPR-004](../records/simulated/privacy/SIM-GDPR-004-dpa-conclusion-customer-a.md) |
| [Personal data breach procedure](../NIS2/03-incident-reporting-procedure.md) | Art. 33, 34 | Draft, in NIS2-03 including template T-4 |
| [Data retention schedule](../policies/records-and-data-retention-policy.md) | Art. 5(1)(e) | Draft proposal in POL-RET-01. Configured CI retention is 90 days. The 18-month copy is not built. Simulated deletion at contract end: [SIM-INF-002](../records/simulated/information/SIM-INF-002-customer-data-deletion-at-contract-end.md) |

## Rules for these documents

- Every measure carries the weakest true label from the [README yardstick](../../README.md#4-capability-status): Implemented, Simulated, Gated design (plan check, scanned Terraform), Planned (design-only), or Not designed. "Simulated operation" is used only with a linked record under `records/simulated/`.
- Simulated records exist, in their own bannered store, and are never evidence of operation: see [ADR-0006](../ADR/0006-simulated-operating-records.md). No signed DPAs, DPIA approvals, breach notifications or data subject requests are claimed as real. The `Template` DPA is unsigned by design.
- Real events (tool runs, an official text read) go in `records/real/privacy/`: [REAL-PRIV-001](../records/real/privacy/REAL-PRIV-001-dsr-tool-test-run.md), [REAL-PRIV-002](../records/real/privacy/REAL-PRIV-002-bdsg-38-reading.md).
- Facts about real providers' contracts are marked **to verify** unless a REAL record names the URL and retrieval date.
