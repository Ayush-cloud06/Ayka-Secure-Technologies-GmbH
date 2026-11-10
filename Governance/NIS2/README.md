# NIS2

> Simulated case study. Ayka Secure Technologies GmbH is fictional, has no customers and runs no deployed system. These documents show how a 24-person German SaaS company would handle NIS2 and its German implementation, the NIS2UmsuCG, which amended the BSI-Gesetz (BSIG) with effect from 2025-12-06.

## Completion position

Counted from the ten Art. 21(2) measures in the table "Where Ayka stands" below and in [NIS2-02](02-risk-management-measures.md), using the label the NIS2-02 summary counts (a compound label such as "Gated design + simulated record" counts as Gated design).

| Position | NIS2-02 label | Measures |
|---|---|---:|
| Real evidence | Implemented (1) and Partial (4) | 5 |
| Simulated walk-through | Simulated operation | 1 |
| Gated design | Gated design | 2 |
| Design only | Designed | 2 |
| Open | Planned | 0 |
| **Total** | | **10** |

Measure (i) has simulated people and access-review records (SIM-PPL-001 to 006, SIM-ACC-001) but keeps the weaker label, so it is counted under Design only; measure (j), MFA, is Designed and switched off. Simulated walk-throughs are not operating evidence. The one Implemented measure is secure development for infrastructure code; the four Partial measures are Partial only for the documents and CI parts that really exist. Nothing is deployed.

## The short answer

**Ayka is not a NIS2 entity.** Its SaaS platform most likely counts as a cloud computing service (Annex I, "Digital infrastructure"), but cloud providers are only in scope from 50 employees or more than EUR 10 m turnover and balance sheet. Ayka has 24 employees. No BSI registration, no mandatory BSI reporting, no §38 BSIG management duties.

**NIS2 still reaches Ayka through its customers.** Automotive and manufacturing customers with 50+ staff are in scope and must manage the security of their suppliers. They will put NIS2-style requirements into Ayka's contracts: fast incident notification, audit rights, supplier transparency.

**There is no transition period.** Ayka qualifies once it exceeds the thresholds in two consecutive financial years; from that day every duty applies. Preparation starts at 40 employees.

The full reasoning is in the [applicability assessment](01-applicability-assessment.md).

## Documents

Status: `Draft` = written, not approved (no real approver exists).

| ID | Document | NIS2 / BSIG reference | Status |
|---|---|---|---|
| NIS2-01 | [Applicability assessment](01-applicability-assessment.md) | Art. 2, 3, Annex I and II; §28, §33, §34 BSIG | Draft |
| NIS2-02 | [Risk-management measures: gap assessment](02-risk-management-measures.md) | Art. 21; §30 BSIG; IR 2024/2690 Annex | Draft |
| NIS2-03 | [Security incident reporting procedure](03-incident-reporting-procedure.md) | Art. 23; §32 BSIG; IR 2024/2690 Art. 3, 4, 7; GDPR Art. 33 | Draft |
| NIS2-04 | [Management accountability](04-management-accountability.md) | Art. 20; §38 BSIG; §43 GmbHG | Draft |
| NIS2-05 | [Supply-chain security](05-supply-chain-security.md) | Art. 21(2)(d), 21(3); §30(2) no. 4 BSIG | Draft |
| NIS2-06 | [Customer security addendum (template)](06-customer-security-addendum.md) | Art. 21(2)(d), 21(3), 23; §30, §32 BSIG | Draft |
| NIS2-07 | [Supplier questionnaire response](07-supplier-questionnaire-response.md) | Art. 21(2), 21(3) | Draft |
| NIS2-08 | [Applicability reassessment, November 2026](08-applicability-reassessment-2026-11.md) | §28 BSIG; NIS2-01 section 7 | Draft |
| NIS2-09 | [BSI registration dry run](09-bsi-registration-dry-run.md) | §33, §34 BSIG; Art. 27 | Draft. Not submitted, not required |

Records tied to this set: [REAL-SUP-001](../records/real/supplier/REAL-SUP-001-supplier-attestations.md) (public supplier pages read on 2026-11-10), [SIM-NIS2-001](../records/simulated/nis2/SIM-NIS2-001-management-cybersecurity-training.md) (management training walk-through) and [SIM-NIS2-002](../records/simulated/nis2/SIM-NIS2-002-customer-supplier-security-assessment.md) (customer assessment walk-through).

## How this relates to the rest of the repository

- The **ISMS** ([index](../ISMS/README.md)) is the management system that runs these measures. NIS2-02 maps each NIS2 measure to ISO/IEC 27001:2022 controls and to the ISMS documents that exist.
- The **GDPR** documents ([index](../GDPR/README.md)) share the supplier list ([processor register](../GDPR/processor-register.md)) and the breach route in NIS2-03.
- The **compliance gate** ([README](../../README.md)) is the strongest evidence Ayka has for NIS2 Art. 21(2)(e), secure development. It is also the only operating evidence: everything else depends on infrastructure that has not been deployed.

## Where Ayka stands, in one table

Status on 2026-11-10, per NIS2 Art. 21(2) measure. Detail and evidence in [NIS2-02](02-risk-management-measures.md). Order of strength: Planned < Designed < Gated design < Simulated operation < Partial < Implemented ([ADR-0006](../ADR/0006-simulated-operating-records.md)). Gated design and Simulated operation are not counted as Implemented or Partial.

| Measure | 2026-10-06 | 2026-11-10 |
|---|---|---|
| (a) Risk analysis and security policies | Partial | Partial |
| (b) Incident handling | Planned | Gated design + simulated record [SIM-INC-001](../records/simulated/incident/SIM-INC-001-inc-2026-001-customer-export-in-public-ci.md) |
| (c) Business continuity, backup | Designed | Gated design + simulated record [SIM-BCP-001](../records/simulated/continuity/SIM-BCP-001-restore-and-dr-tabletop.md) |
| (d) Supply-chain security | Partial | Partial |
| (e) Secure development, vulnerability handling | Implemented (infrastructure code) | Implemented (infrastructure code); application checks and disclosure files added; the checks ran once locally, not on GitHub |
| (f) Effectiveness assessment | Partial | Partial (+ simulated records [SIM-AUD-001](../records/simulated/audit/SIM-AUD-001-internal-audit-plan-2026.md), [SIM-MR-001](../records/simulated/management-review/SIM-MR-001-management-review-2026.md)) |
| (g) Cyber hygiene and training | Planned | [Simulated operation](../records/simulated/nis2/SIM-NIS2-001-management-cybersecurity-training.md) (training only) |
| (h) Cryptography | Partial | Partial |
| (i) HR security, access, assets | Designed (identity) / Implemented (IAM gate) | Designed (identity) / Implemented (IAM gate) + simulated records [SIM-PPL-001](../records/simulated/people/SIM-PPL-001-joiner-batch.md) to [006](../records/simulated/people/SIM-PPL-006-role-holder-appointments.md) and [SIM-ACC-001](../records/simulated/access/SIM-ACC-001-q2-2026-access-review.md), counted as Designed; `aws-iam-core` is now scanned, Identity Center in source mode, Entra ID by no scanner; asset inventory of planned resources exists |
| (j) MFA, secured communications | Designed, switched off | Designed, **still switched off** (Conditional Access disabled in Terraform) |

Gated design rows depend on Terraform added on 2026-11-10 that has never been applied to any account. Biggest gaps: detection and alerting not running, no tested backups, MFA not enforced. The Region in the Terraform was moved to `eu-central-1` on the same date and checked in source ([REAL-INFRA-003](../records/real/infra/REAL-INFRA-003-region-migration-verification.md)); no EU-location claim is made until something is deployed, and the backup vault sits in the workload account.

## Rules for these documents

- Each measure carries the weakest true label from the [README yardstick](../../README.md#4-capability-status).
- Records (registrations, incident reports, training attendance, supplier assessments, management decisions) appear as templates with "no entries yet" in the documents. Walk-throughs and real readings are kept in separate, bannered stores under `Governance/records/`; see [ADR-0006](../ADR/0006-simulated-operating-records.md).
- Legal statements cite the article or paragraph they rest on. Statements about providers' certifications are marked **to verify** until checked against the provider's current documents.
- Reassess applicability every six months and on the triggers in NIS2-01 section 7.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-06 | Index of NIS2-01 to NIS2-05 |
| 1.1 | 2026-11-10 | Added NIS2-06 to NIS2-09 and the three records; status table per measure; records rule now points to ADR-0006 |
| 1.2 | 2026-11-10 | Completion position added. Documents 01, 02, 03, 05 to 09 revised after checking against the files and records (see their revision tables) |
| 1.3 | 2026-11-10 | Measure (i) cites the people and access-review tabletops; counts unchanged. Measure (j) unchanged |
