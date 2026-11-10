# SIM-GDPR-002: Annual review of the record of processing activities

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-GDPR-002 |
| Authored | 2026-11-10 (real date) |
| Scenario date | 2026-09-28 |
| Participants | EMP-004 (GDPR Lead, owner), EMP-002 (CISO), EMP-012 (HR & Administration), EMP-010 (Customer Success Manager), EMP-003 (Cloud Platform Engineer), EMP-021 (Compliance Officer) |
| Procedure exercised | [Record of processing activities](../../../GDPR/record-of-processing-activities.md) section 5 (Review), version 1.0 |
| Controls | GDPR Art. 30(1), 30(2), 5(2); ISO/IEC 27001:2022 A.5.34, A.5.9 |

## Scenario

EMP-004 reviews the RoPA against what each owner says the company now does. The review text in version 1.0 says "review when a new data flow, system, processor or Region enters scope, and at least annually". It gives no steps, so EMP-004 improvises a checklist.

| Check | Result in the scenario |
|---|---|
| Does each activity still exist and is its reality column right | PA-01 to PA-04, PP-01 confirmed. Reality columns kept (no deployment) |
| Data subjects and counts against the people records | The joiners recorded in SIM-PPL-001 and the leaver in SIM-PPL-004 change who is in PA-01 and PA-04. The RoPA states no counts, so the change cannot be seen in it |
| Processors against the supplier review | The register entries were compared with what REAL-SUP-001 recorded. Differences belong to that record |
| Breach log against the RoPA | The incident SIM-INC-001 (scenario date 2026-08-12) has a row in the incident log. EMP-004 asks only whether the affected system appears in a PA row. Its personal-data outcome is recorded in that record, not here |
| Legal bases | Compared with the legal-basis register. Consistent |
| Retention | PA-01 to PA-04 say "not approved". No period can be checked |
| Missing activities | EMP-010 and EMP-012 name three activities nobody recorded: website and enquiries, customer contact and billing, applicants. Scenario decision by EMP-004: add the first two now; applicants later |

## Findings

1. **Two controller activities were missing.** Website and contact enquiries, and customer contacts and billing. Closed in RoPA version 1.1 (PA-05, PA-06). Applicants are still missing.
2. **The review has no procedure.** No checklist, no evidence requirement, no list of owners to ask. This record's table is the improvised version.
3. **Art. 30(1)(f) wants envisaged time limits.** Every activity says "not approved", so the RoPA is incomplete until retention is approved.
4. **Art. 30(2)(a) wants the controller's name and contact and the DPO's** for PP-01. The entry has no field for either. Still open.
5. **Stale statement found:** PA-01 said the personnel file has 47 entries; it has 24. Corrected in RoPA version 1.1. This is a defect of the repository, not only of the scenario.
6. **No link from the incident log to the RoPA**, so the incident check depends on someone remembering.
7. **No version number or review date in the RoPA header** that shows a review took place without a content change.

## What this does not show

- That a review meeting took place or that any owner said anything. The answers are scenario answers.
- What SIM-INC-001 or REAL-SUP-001 concluded. This record refers to them by ID only.
- That the RoPA is complete. Applicants and recruitment are missing.
- No signatures or approval.
