# SIM-AUD-003 Internal audit report 2026 (first cycle)

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-AUD-003 |
| Authored | 2026-11-10 |
| Scenario date | 2026-10-16 (report issued). Closing meeting 2026-10-09 |
| Participants | EMP-021 (auditor, author); recipients EMP-001 and EMP-002; closing meeting also EMP-003, EMP-004, EMP-005, EMP-013 |
| Procedure exercised | [Internal audit programme ISMS-AUD-01](../../../ISMS/09-internal-audit/audit-programme.md) section 4; [audit plan template ISMS-AUD-02](../../../ISMS/09-internal-audit/audit-plan.md) section 3 steps 4 and 5; [audit findings log ISMS-AUD-04](../../../ISMS/09-internal-audit/audit-findings-log.md) section 2 |
| Controls | ISO/IEC 27001:2022 clauses 9.2.2, 10.2; Annex A A.5.3, A.5.35, A.8.5, A.8.32; SOC 2 MO-02, MO-03, CM-05, AC-03, RA-01, AC-07 |

## 1. Engagement summary

- Engagement SIM-AUD-001. Plan, sampling and independence limits in SIM-AUD-001. Checklists and working papers in SIM-AUD-002.
- Criteria: documents approved on 2026-03-02 (SIM-GOV-001); ISO/IEC 27001:2022 clauses 4 to 10; Annex A per the SoA.
- Period: 2026-03-02 to 2026-09-30.
- Auditor: EMP-021. Independence limits: reporting line through EMP-004 to EMP-002; BSI-reporting step not tested (own role); KPI document owned by own department; single auditor; deputy Privacy Lead and participant in the RoPA review SIM-GDPR-002, so that review was not tested.

## 2. Conclusion, limited to tested scope

The ISMS has its parts in place: approved documents, a risk review, an access review, a supplier review, an incident handled end to end, a DR tabletop. Each was done once. What fails is **repetition and independence**. Scheduled reviews and agreed follow-ups did not recur because nobody owns the calendar. Changes and their compensating review rest on one person. These are not design gaps in a single control; they go to clauses 8.2, 9.1 and 10.2.

No opinion is given on operating effectiveness of any technical control. Nothing is deployed.

## 3. Nonconformities

| ID | Grade | Requirement | Objective evidence | Corrective action |
|---|---|---|---|---|
| NC-01 | **Major** | POL-CHG-01 section 10 (compensating control: monthly MD review of all merged changes); OBJ-03; ISO/IEC 27001:2022 A.5.3, A.8.32; SOC 2 CM-05 | 0 of 22 merged PRs approved by a person other than the author (OBJ-03 snapshot, 2026-10-14). 0 of 7 monthly reviews (March to September) recorded. Ruleset `protect-main` requires 0 approvals; both approval environments allow self-review ([document control procedure](../../../ISMS/00-context-and-governance/document-control-procedure.md) section 2, [gap analysis](../../../ISMS/04-controls-and-soa/control-gap-analysis.md) section 4). One owner-role account is the only CODEOWNER and the only required reviewer; the compensating reviewer (EMP-001) has no GitHub access. WP-01 | SIM-CAPA-005 |
| NC-02 | Minor | POL-AC-01 section 4.2 item 1 (MFA for every interactive login); OBJ-04; A.8.5; SOC 2 AC-03 | `enable_conditional_access` defaults to `false` in [`entra-id/variables.tf`](../../../../Internal-IT/platform/domains/identity/entra-id/variables.tf). Licence deferred on 2026-03-02 (SIM-GOV-001 R-04) and still undecided after the 2026-09-30 date set in SIM-SUP-001. Graded minor because no workload account or production system relies on the tenant yet; a resource deferral does not make it conforming. WP-02 | SIM-CAPA-006 |
| NC-03 | Minor | Clause 6.1.2 d) and 8.2 (risk assessment at planned intervals); risk criteria section 6 (90-day High review, Medium expiry); POL-AC-01 section 4.6 (quarterly access review); clause 10.2 (corrective action carried out and its effectiveness reviewed) | Risk review due 2026-06-12 not held; 203 days since the last one at 2026-10-05. RISK-007 High exception review (due 2026-06-12) not held. RISK-008 acceptance expired 2026-09-16 and is still shown as accepted. Q3 access review not held, so the effectiveness checks of SIM-CAPA-001 and SIM-CAPA-002 did not happen. Secret-scanning condition from SIM-SUP-001 (due 2026-07-31) not met. SIM-CAPA-004 document alignment overdue since 2026-09-30. WP-03 | SIM-CAPA-007 |

Nonconformities raised earlier in the year and verified by this audit (not new findings): SIM-CAPA-001 (leaver), SIM-CAPA-002 (mover), SIM-CAPA-003 (real data in fixture), SIM-CAPA-004 (24 h customer notice missed). Corrections confirmed; effectiveness not yet shown.

## 4. Observations

| ID | Observation | Evidence | Further evidence needed |
|---|---|---|---|
| O-01 | No detection or alerting. INC-2026-001 was found by a reviewer by chance after about 42 hours. OP-05 and A.8.16 remain designed only | SIM-INC-001 section 5; [POL-IR-01](../../../policies/incident-response-plan.md) section 12; [NIS2-03](../../../NIS2/03-incident-reporting-procedure.md) section 8 | None. Becomes a nonconformity once anything is deployed |
| O-02 | Objectives missed two quarters running with no change to plans or resources: OBJ-03 0 %, OBJ-09 11 files with `ap-south-1`, OBJ-10 114 days at 2026-07-08 | SIM-MON-001, SIM-MON-002; [`ayka-portal/variables.tf`](../../../../Internal-IT/workloads/ayka-portal/variables.tf) | Whether the Customer A (fictional) pilot contract promises EU data location. If yes, OBJ-09 becomes a nonconformity |
| O-03 | Approved documents still carry "Draft. Not approved" headers. A reader cannot tell from the document that it is in force | SIM-GOV-001; every policy header; document control procedure section 5 | None |
| O-04 | SOC 2 CE-06 asks for a quarterly CISO report to the Managing Director with minuted decisions. KPI results went to the CISO only; no quarterly report to EMP-001 is minuted | SIM-MON-001, SIM-MON-002 (participants) | None |

## 5. Opportunities for improvement

| ID | Opportunity | Benefit |
|---|---|---|
| OFI-01 | Produce M-02, M-03 and OBJ-03 each month from the GitHub API with one script, kept in the repository | Removes manual sampling choices (SIM-MON-001 finding 4); gives the monthly MD review its input |
| OFI-02 | Run the next incident tabletop on RISK-001, as POL-IR-01 section 11 recommends, and include a break-glass exercise | Tests the scenario the plan itself names, and RISK-013 together |

## 6. Closing meeting, 2026-10-09

All findings presented. No factual dispute. EMP-002 asked that NC-01 be graded minor because "the policy expects a single maintainer". EMP-021 kept it major: the compensating control written for that case never operated in seven months. EMP-001 accepted the grading. Due dates were agreed in the CAPA records and are carried to management review (SIM-MR-001).

## Findings

1. **No grading rule.** The findings log defines Nonconformity, Observation and Improvement, but not major and minor. The grade of NC-01 was argued at the closing meeting with no criterion to settle it. Add one, for example: major when a required control did not operate at all over the period, or when a requirement fails systemically.
2. **No report deadline.** The programme and plan do not say how soon after the closing meeting the report is due. One week was chosen here.
3. **Prior findings have no place in the report.** The programme says "follow up prior findings". In a first audit, nonconformities from operations (SIM-CAPA-001 to 004) needed a section the template does not have.
4. **The findings log ID scheme is reserved for real events.** The log uses `AUD-<year>-<sequence>` "only when creating a real finding". This simulated report therefore uses NC-01 and so on, scoped to SIM-AUD-003.

## What this does not show

- No audit was held. No auditor exists. No opinion on Ayka or the repository is given by any person.
- Documents are used as their text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
- The repository facts cited (22 PRs, ruleset, Terraform default, Region, disabled secret scanning) are true of the repository; treating them as Ayka's operating evidence is fiction.
- The real [audit findings log](../../../ISMS/09-internal-audit/audit-findings-log.md) is still empty. That is correct.
