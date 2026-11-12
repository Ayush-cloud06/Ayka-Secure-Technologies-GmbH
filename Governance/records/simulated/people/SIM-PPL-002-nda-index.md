# SIM-PPL-002: Confidentiality agreement index

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-PPL-002 |
| Authored | 2026-11-10 (real date) |
| Scenario date | 2026-01-01 to 2026-04-02 |
| Participants | EMP-012 (keeps the index), EMP-004 (template and clause review), EMP-001 (signatory for the company), all 24 staff as parties |
| Procedure exercised | [NDA template](../../../ISMS/01-organization/nda-template.md) sections 2 to 4; [Onboarding and offboarding procedure](../../../ISMS/01-organization/onboarding-and-offboarding-procedure.md) section 2 |
| Controls | ISO 27001:2022 A.6.6, A.6.2, A.5.14; SOC 2 CO-03, C1.1; GDPR Art. 5(1)(f), Art. 88 with BDSG section 26 (to verify) |

## Scenario summary

The [NDA template](../../../ISMS/01-organization/nda-template.md) says to keep an index with: agreement ID, parties, purpose, executed date, versions, expiry, reviewer and storage location. This is that index for the 24 staff. It holds references only. The signed documents would sit in a private HR system, not in this repository.

Every employee signed a confidentiality clause in the employment contract on the start date. The template was approved only with the other ISMS documents on 2026-03-02. On 2026-03-06 EMP-004 compared the clause with the template (scenario decision by EMP-004). The clause had no permitted-purpose field, no return and deletion term, no protected-disclosure carve-out and no contact for notices. Scenario decision by EMP-001 on 2026-03-06: every employee signs a standalone NDA on template v1.0. 23 staff signed between 2026-03-10 and 2026-03-12. EMP-017 signed on 2026-04-02.

Fields common to all rows: template v1.0 (see Findings on its status), purpose "employment duties", company signatory EMP-001, reviewer EMP-004, storage "private HR system (scenario)". Term: employment plus 24 months, scenario decision by EMP-001, no legal review.

## Index

| NDA ref (scenario) | Party | Capacity | Contract clause | Standalone NDA signed | Term | Status |
|---|---|---|---|---|---|---|
| NDA-2026-001 | EMP-001 | Managing Director | MD service agreement clause, 2026-01-01 | Not signed (no counterparty) | Not applicable | Open: see Findings |
| NDA-2026-002 | EMP-002 | Employee | Contract clause, 2026-01-01 | 2026-03-10 | Employment plus 24 months | In force |
| NDA-2026-003 | EMP-003 | Employee | Contract clause, 2026-01-10 | 2026-03-10 | Employment plus 24 months | In force |
| NDA-2026-004 | EMP-004 | Employee | Contract clause, 2026-01-12 | 2026-03-10 | Employment plus 24 months | In force |
| NDA-2026-005 | EMP-005 | Employee | Contract clause, 2026-01-15 | 2026-03-10 | Employment plus 24 months | In force |
| NDA-2026-006 | EMP-006 | Employee | Contract clause, 2026-01-18 | 2026-03-10 | Employment plus 24 months | In force |
| NDA-2026-007 | EMP-007 | Employee | Contract clause, 2026-01-20 | 2026-03-10 | Employment plus 24 months | In force |
| NDA-2026-008 | EMP-008 | Employee | Contract clause, 2026-01-20 | 2026-03-10 | Employment plus 24 months | In force |
| NDA-2026-009 | EMP-009 | Employee | Contract clause, 2026-01-22 | 2026-03-11 | Employment plus 24 months | In force |
| NDA-2026-010 | EMP-010 | Employee | Contract clause, 2026-01-22 | 2026-03-11 | Employment plus 24 months | In force |
| NDA-2026-011 | EMP-011 | Employee | Contract clause, 2026-01-25 | 2026-03-11 | Employment plus 24 months | In force |
| NDA-2026-012 | EMP-012 | Employee | Contract clause, 2026-01-25 | 2026-03-11 | Employment plus 24 months | In force |
| NDA-2026-013 | EMP-013 | Employee | Contract clause, 2026-01-28 | 2026-03-11 | Employment plus 24 months | In force |
| NDA-2026-014 | EMP-014 | Employee | Contract clause, 2026-01-28 | 2026-03-11 | Employment plus 24 months | In force |
| NDA-2026-015 | EMP-015 | Employee | Contract clause, 2026-01-30 | 2026-03-11 | Employment plus 24 months | In force |
| NDA-2026-016 | EMP-016 | Employee | Contract clause, 2026-02-01 | 2026-03-11 | Employment plus 24 months | In force |
| NDA-2026-017 | EMP-017 | Employee | Contract clause, 2026-02-05 | 2026-04-02 | Employment plus 24 months | In force. Standalone NDA signed 2026-04-02, after Identity Center and GitHub access (2026-03-18) |
| NDA-2026-018 | EMP-018 | Employee | Contract clause, 2026-02-05 | 2026-03-12 | Employment plus 24 months | In force |
| NDA-2026-019 | EMP-019 | Employee | Contract clause, 2026-02-08 | 2026-03-12 | Employment plus 24 months | In force |
| NDA-2026-020 | EMP-020 | Employee | Contract clause, 2026-02-09 | 2026-03-12 | Employment plus 24 months | In force |
| NDA-2026-021 | EMP-021 | Employee | Contract clause, 2026-02-10 | 2026-03-12 | Employment plus 24 months | In force |
| NDA-2026-022 | EMP-022 | Employee | Contract clause, 2026-02-16 | 2026-03-12 | Employment plus 24 months | In force. Clause signed 5 days after start |
| NDA-2026-023 | EMP-023 | Employee | Contract clause, 2026-02-12 | 2026-03-12 | Employment plus 24 months | Continuing obligation after 2026-05-29 (SIM-PPL-004) |
| NDA-2026-024 | EMP-024 | Employee | Contract clause, 2026-02-13 | 2026-03-12 | Employment plus 24 months | In force |

## Findings

1. **The template is a draft with an unknown term.** It says to set a proportionate duration after legal review. No review is part of any written step. The 24-month term here was a founder's choice. G01 stays open for the same reason.
2. **No rule for agreements that predate the template.** Nothing in the template or the onboarding procedure covers people who already signed an older clause. The re-sign decision on 2026-03-06 was improvised.
3. **Version is not an index field in the access gate.** The user access procedure and the access control policy say "confirm the NDA". Neither says which version. EMP-017 received access on 2026-03-18 with a clause on file but before the standalone NDA. The gate passed because an agreement existed.
4. **Late signature has no stop rule.** EMP-022 signed the clause five days after starting and already had a mailbox. The onboarding procedure lists NDA as completion evidence for "confirm engagement" but does not say that account creation waits for it.
5. **The Managing Director cannot sign with himself.** The template assumes a party other than the company. EMP-001 has no NDA. The register says "confidentiality agreements apply to all employees". The template needs a founder or officer case.
6. **Reviewer role is thin.** The template gives completeness to HR, scope to the information owner, and legal overlap to Compliance. In practice EMP-004 did all three. No row records who was information owner.
7. **No end-of-agreement step in the index.** The template says remind leavers of continuing obligations. The index has no "ended" or "reminded on" field. SIM-PPL-004 had to hold that fact.

## What this does not show

- That any person signed anything. There are no signatures anywhere in this repository.
- Whether the clause or the NDA text is lawful or enforceable in Germany. No counsel was involved.
- Any breach, request for return, or disclosure under the NDAs.
