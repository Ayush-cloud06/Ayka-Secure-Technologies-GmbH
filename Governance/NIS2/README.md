# NIS2

> Simulated case study. Ayka Secure Technologies GmbH is fictional, has no customers and runs no deployed system. These documents show how a 24-person German SaaS company would handle NIS2 and its German implementation, the NIS2UmsuCG, which amended the BSI-Gesetz (BSIG) with effect from 2025-12-06.

## The short answer

**Ayka is not a NIS2 entity.** Its SaaS platform most likely counts as a cloud computing service (Annex I, "Digital infrastructure"), but cloud providers are only in scope from 50 employees or more than EUR 10 m turnover and balance sheet. Ayka has 24 employees. No BSI registration, no mandatory BSI reporting, no §38 BSIG management duties.

**NIS2 still reaches Ayka through its customers.** Automotive and manufacturing customers with 50+ staff are in scope and must manage the security of their suppliers. They will put NIS2-style requirements into Ayka's contracts: fast incident notification, audit rights, supplier transparency.

**There is no transition period.** If Ayka reaches 50 employees, every duty applies from that day. Preparation starts at 40.

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

## How this relates to the rest of the repository

- The **ISMS** ([index](../ISMS/README.md)) is the management system that runs these measures. NIS2-02 maps each NIS2 measure to ISO/IEC 27001:2022 controls and to the ISMS documents that exist.
- The **GDPR** documents ([index](../GDPR/README.md)) share the supplier list ([processor register](../GDPR/processor-register.md)) and the breach route in NIS2-03.
- The **compliance gate** ([README](../../README.md)) is the strongest evidence Ayka has for NIS2 Art. 21(2)(e), secure development. It is also the only operating evidence: everything else depends on infrastructure that has not been deployed.

## Where Ayka stands, in one table

| NIS2 measure | Status |
|---|---|
| Secure development and change control (infrastructure code) | Implemented |
| Risk policies, supply chain, effectiveness testing, encryption | Partial |
| Business continuity, access control, MFA | Designed only; MFA switched off |
| Incident detection and handling, training | Planned |

Biggest gaps: no detection or alerting, no tested backups, MFA not enforced, workload Region outside the EU.

## Rules for these documents

- Each measure carries the weakest true label from the [README yardstick](../../README.md#4-capability-status).
- Records (registrations, incident reports, training attendance, supplier assessments, management decisions) appear as templates with "no entries yet". None has been invented.
- Legal statements cite the article or paragraph they rest on. Statements about providers' certifications are marked **to verify** until checked against the provider's current documents.
- Reassess applicability every six months and on the triggers in NIS2-01 section 7.
