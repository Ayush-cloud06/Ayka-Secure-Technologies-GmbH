# SIM-AUD-001 Internal audit plan 2026 (first cycle)

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-AUD-001 |
| Authored | 2026-11-10 |
| Scenario date | 2026-10-05 (opening meeting). Fieldwork 2026-10-05 to 2026-10-09 |
| Participants | EMP-021 (auditor), EMP-001 (sponsor), EMP-002 (CISO, coordinator and auditee), auditees interviewed: EMP-003, EMP-004, EMP-005, EMP-013, EMP-016, EMP-018 |
| Procedure exercised | [Internal audit programme ISMS-AUD-01](../../../ISMS/09-internal-audit/audit-programme.md) sections 2 to 4; [internal audit plan template ISMS-AUD-02](../../../ISMS/09-internal-audit/audit-plan.md) sections 1 to 3 |
| Controls | ISO/IEC 27001:2022 clauses 9.2.1, 9.2.2; Annex A A.5.35, A.5.36; SOC 2 MO-02 |

## 1. Engagement (template section 1)

| Field | Value |
|---|---|
| Engagement ID | SIM-AUD-001 |
| Dates | Opening 2026-10-05 09:00 CEST; fieldwork to 2026-10-09; closing meeting 2026-10-09 15:00 CEST |
| Sponsor | EMP-001. Coordinator EMP-002 |
| Auditor | EMP-021, appointed on 2026-03-02 (SIM-GOV-001 R-01) |
| Scope | ISMS clauses 4 to 10; Annex A areas A-01 to A-12 of the checklist; repository and CI controls; the simulated operating records from 2026-03-02 to 2026-09-30 |
| Period and cutoff | 2026-03-02 to 2026-09-30. Evidence cutoff 2026-09-30 for records; repository files read as they stand on the Authored date (branch `sim/operating-baseline`, base commit `509f4b2`) |
| Criteria | Documents approved on 2026-03-02 (SIM-GOV-001), ISO/IEC 27001:2022 clauses 4 to 10 and Annex A as listed in the SoA |
| Exclusions | Live AWS, Entra ID and GitHub settings not re-read by the auditor; dated observations already in the repository are used instead and labelled. No operating-effectiveness opinion |
| Resources | 5 days of EMP-021. Read-only access to the repository and the simulated records |
| Reporting | Report by 2026-10-16 (SIM-AUD-003). Input to management review on 2026-10-26 |

## 2. Independence and its limits

EMP-021 did not design, implement or operate the records audited here, except as listed below. He took no part in SIM-GOV-001 to SIM-BCP-001 except being appointed in SIM-GOV-001. That is the basis for independence.

Limits, stated before fieldwork:

1. **Reporting line.** EMP-021 reports to EMP-004, who reports to EMP-002. EMP-004 took part in the KPI records, the supplier review and the incident (Privacy Lead). EMP-002 is the ISMS owner. Findings against either were issued with that line in view; EMP-001 receives the report directly.
2. **Own role in incident reporting.** NIS2-03 names EMP-021 as the BSI reporting role. The BSI route was not triggered in INC-2026-001, so he did nothing in it. The checklist step that tests the BSI reporting decision (A-04, part) is **not tested by him** and is left open.
3. **Own department's documents.** Compliance & Risk Management owns the KPI document and the audit checklists. C-09 (metrics) is tested with this limit recorded.
4. **Single auditor.** No second auditor reviewed the working papers.
5. **Privacy deputy role.** [SIM-PPL-006](../people/SIM-PPL-006-role-holder-appointments.md) makes EMP-021 deputy Privacy Lead and deputy data protection contact. He was not called on in INC-2026-001, but he took part in the RoPA review [SIM-GDPR-002](../privacy/SIM-GDPR-002-ropa-annual-review.md) on 2026-09-28. That review is **not tested** by him.

## 3. Evidence and sampling plan (template section 2)

| Population | Size at cutoff | Selection | Reason |
|---|---:|---|---|
| Governing documents and SoA | All documents in the [ISMS register](../../../ISMS/README.md); 93 SoA rows | Approval trail for 6 documents: scope, IS policy, POL-AC-01, POL-CHG-01, POL-IR-01, SoA | The ones the year's records depend on |
| Risks | 13 risks, 2 acceptances | All 13 for status; reperform scores of RISK-007 and RISK-008; both acceptances | Both acceptances are the only risk decisions with dates |
| Merged changes | 22 merged pull requests (snapshot in [ISMS objectives](../../../ISMS/00-context-and-governance/isms-objectives.md), OBJ-03 measurement, 2026-10-14) | All 22, from the existing measurement; not re-queried | Population is small. Judgement sample is not needed |
| Monthly MD change reviews (POL-CHG-01 section 10) | 7 due (March to September) | All 7 | Compensating control for RISK-005 |
| Simulated change records | 1 (SIM-CHG-001) | All | Only change with a change record |
| Access review rows | 144 rows in SIM-ACC-001, plus 2 leaver/mover events | Both events, the exception row, both "investigate" rows, 10 retained rows picked one per population and function | Exceptions plus a spread |
| Quarterly access reviews due | 2 (Q2, Q3) | Both | Frequency test |
| Incidents | 1 (INC-2026-001), 6 records plus SIM-IMP-001 | All | Small population |
| Supplier reviews | 3 suppliers in SIM-SUP-001 | All, plus every condition with a due date | Small population |
| Corrective actions | 4 open at cutoff (SIM-CAPA-001 to SIM-CAPA-004) | All | Small population |
| Restore and DR | 1 tabletop (SIM-BCP-001) | All | Small population |
| KPI reports | 2 (SIM-MON-001, SIM-MON-002) | Recompute M-03, M-04 and OBJ-10 | The ones with a missed target |

Missing or unreachable evidence is a limitation or a finding. It is never a pass.

## 4. Opening meeting, 2026-10-05

Attended: EMP-001, EMP-002, EMP-021. Agreed scope, criteria, contacts and the four independence limits above. EMP-002 asked to exclude the incident area because "it is still fresh". EMP-021 declined; EMP-001 agreed with him. Escalation route for disputes: EMP-001.

## Findings

1. **The programme has no rule for an auditor named in another procedure.** NIS2-03 gives the internal auditor an operational role (BSI submitter). The programme's independence rule ("did not design, implement or operate") would bar him from that step. The programme should list known role conflicts.
2. **"Within 12 months of ISMS approval" is the only timing rule.** The programme sets no month. The first audit came 7 months after approval, with no reason recorded for that date.
3. **No rule for reusing existing measurements.** The plan reused the OBJ-03 count of 22 PRs instead of re-querying. The plan template should say when an auditor may rely on someone else's dated measurement.
4. **Reporting line not addressed.** The programme says "Managing Director appoints a competent auditor" but not to whom the auditor reports. Here the auditor reports, through one manager, to the ISMS owner he audits.

## What this does not show

- No audit was held. EMP-021 is a role in the fictional register.
- The programme and plan template are used as their text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
- The real [audit findings log](../../../ISMS/09-internal-audit/audit-findings-log.md) is still empty. That is correct.
