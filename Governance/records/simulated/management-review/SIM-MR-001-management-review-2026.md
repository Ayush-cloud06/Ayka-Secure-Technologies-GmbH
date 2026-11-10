# SIM-MR-001 Management review minutes 2026

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-MR-001 |
| Authored | 2026-11-10 |
| Scenario date | 2026-10-26 |
| Participants | EMP-001 (Managing Director, chair, decides), EMP-002 (CISO, coordinator), EMP-004 (Compliance & Risk, GDPR Lead), EMP-005 (Security Operations), EMP-003 (Cloud Platform Engineering), EMP-016 (Supplier Risk Coordinator), EMP-012 (HR & Administration), EMP-021 (internal auditor, audit results only), EMP-018 (minutes) |
| Procedure exercised | [Management review agenda ISMS-MR-01](../../../ISMS/10-management-review/management-review-agenda.md) sections 2 to 4; [management review action log ISMS-MR-02](../../../ISMS/10-management-review/management-review-action-log.md) section 2 |
| Controls | ISO/IEC 27001:2022 clauses 9.3.1, 9.3.2, 9.3.3, 10.1, 7.1, 5.1; SOC 2 CE-06, MO-03, RA-01 |

Review period: 2026-03-02 (ISMS approval) to 2026-10-16 (audit report). Pre-read sent 2026-10-19, five business days before. Absent function: Product & Engineering (EMP-006); input given in writing.

## 1. Inputs (clause 9.3.2)

### a) Status of actions from previous management reviews

None. This is the first management review. Decisions taken outside a review (SIM-GOV-001, 2026-03-02) were checked instead: R-04 (licence) still undecided; R-05 (monthly change review) never operated.

### b) Changes in external and internal issues

- Internal: headcount 24 to 23 (EMP-023 left 2026-05-29, SIM-PPL-004). EMP-019 moved to Security Operations (SIM-PPL-005).
- Internal: one personal data incident, INC-2026-001 (SIM-INC-001).
- Internal: tfsec is being folded into Trivy upstream (SIM-TI-001); replacement evaluation open.
- External: Ayka is still not a NIS2 entity (NIS2-01). Management cybersecurity training held 2026-04-20 ([SIM-NIS2-001](../nis2/SIM-NIS2-001-management-cybersecurity-training.md)).
- Scope: unchanged.

### c) Changes in needs and expectations of interested parties

- Customer A (fictional) sent a supplier security questionnaire on 2026-10-12 asking for a 12-hour incident notice, EU hosting, MFA for all staff, an ISO/IEC 27001 certificate and audit rights ([SIM-NIS2-002](../nis2/SIM-NIS2-002-customer-supplier-security-assessment.md)). Ayka answered 24 hours, not 12.
- DPO: external DPO decided 2026-03-09 ([SIM-GDPR-001](../privacy/SIM-GDPR-001-dpo-decision-minutes.md)); not yet contracted.

### d) Feedback on information security performance

**d1) Nonconformities and corrective actions.**

| CAPA | Source | Grade | Status on 2026-10-26 |
|---|---|---|---|
| SIM-CAPA-001 | Access review, leaver | — | Awaiting effectiveness review; check missed in Q3 |
| SIM-CAPA-002 | Access review, mover exception | — | Action in progress; due 2026-11-30 |
| SIM-CAPA-003 | Incident, real data in fixture | — | Awaiting effectiveness review 2026-12-15 |
| SIM-CAPA-004 | Incident, 24 h notice missed | — | Action in progress; one part overdue |
| SIM-CAPA-005 | Audit NC-01 | Major | Opened 2026-10-16 |
| SIM-CAPA-006 | Audit NC-02 | Minor | Opened 2026-10-16 |
| SIM-CAPA-007 | Audit NC-03 | Minor | Opened 2026-10-16 |

Trend: 0 in Q1, 2 in Q2, 2 in Q3, 3 from the audit. None closed. M-09 has no percentage yet (no check due before cutoff was performed).

**d2) Monitoring and measurement results.** SIM-MON-001 (Q1) and SIM-MON-002 (Q2). M-01, M-02, M-10 met in sample. M-03 0 % both quarters. M-04 one overdue removal. M-06 not measurable: no deployed system. **Q3 results were not compiled**; the KPI document sets no due date for them. Training completion: presented by EMP-012 from [SIM-PPL-003](../people/SIM-PPL-003-training-completion.md); not reproduced here.

**d3) Audit results.** SIM-AUD-003: 1 major and 2 minor nonconformities, 4 observations, 2 opportunities. Presented by EMP-021. Independence limits stated in SIM-AUD-001 accepted by EMP-001.

**d4) Fulfilment of objectives.**

| Objective | Status |
|---|---|
| OBJ-03 independent change approval | Missed all year |
| OBJ-04 MFA for privileged access | Not met; licence undecided until today |
| OBJ-07 access reviews per quarter | 1 of 2 due held (Q2 yes, Q3 no) |
| OBJ-09 EU Region only | Missed; 11 files name `ap-south-1` |
| OBJ-10 risk cycle at most 92 days | Missed; last review 2026-03-16 |
| Others | Not measured in the simulated records |

### e) Feedback from interested parties

- Customer A (fictional): its questionnaire (input c) is the only customer feedback. No complaint recorded about INC-2026-001; the notices were drafts in the fiction.
- Staff: engineering asked for a synthetic test-data generator after INC-2026-001 (SIM-IMP-001).
- Data subjects: one request handled through Customer A (fictional) ([SIM-DSR-001](../privacy/SIM-DSR-001-access-and-erasure-request.md)).
- Authorities: none.

### f) Results of risk assessment and status of the risk treatment plan

- Only one risk review held (SIM-RISK-001, 2026-03-16). RISK-007 exception review and RISK-008 acceptance both lapsed (SIM-CAPA-007).
- DPIA for security logging signed off 2026-10-02 ([SIM-GDPR-003](../privacy/SIM-GDPR-003-dpia-sign-off.md)).
- Treatments TRT-001 to TRT-013: none complete. Four Critical risks remain avoided, not accepted.

### g) Opportunities for continual improvement

SIM-AUD-003 OFI-01 (generate change metrics from GitHub) and OFI-02 (RISK-001 tabletop with break-glass). SIM-IMP-001 lessons L-5 to L-7. SIM-BCP-001 proposal on Region-loss recovery. SIM-CAPA-001 CA-4 (tie GitHub to Entra ID).

## 2. Decisions and outputs (clause 9.3.3)

| Decision | Content | Decided by |
|---|---|---|
| DEC-1 | Grading of NC-01 as major stands | EMP-001 |
| DEC-2 | Resources: licences with Conditional Access for every Tier 0 and Tier 1 holder; 10 % of EMP-014's time as change reviewer; no new hire | EMP-001 |
| DEC-3 | RISK-008 is treated as not accepted until the risk review on 2026-11-06 decides again | EMP-001 |
| DEC-4 | GitHub-to-Entra link (SIM-CAPA-001 CA-4): not funded this year. Manual checklist with named owners stays | EMP-001 |
| DEC-5 | Region-loss recovery: the 8-hour RTO is stated as not met for Region loss until a cross-Region copy exists. Cross-Region copy is a condition of any deployment budget | EMP-001 |
| DEC-6 | Customer incident notice stays 24 hours from awareness; Ayka will not offer 12 hours. POL-IR-01 to match | EMP-001 |
| DEC-7 | ISMS changes: scope and objectives unchanged. Quarterly CISO report to the MD (CE-06) starts in Q4. Next management review 2027-04-26 | EMP-001 |

## 3. Action list

| Action | Description | Owner | Due | Link |
|---|---|---|---|---|
| A-01 | Risk review, including new decisions on RISK-007 and RISK-008 | EMP-002 | 2026-11-06 | SIM-CAPA-007 |
| A-02 | ISMS calendar of all dated commitments, with reminders | EMP-018 | 2026-11-13 | SIM-CAPA-007 |
| A-03 | Change reviewer EMP-014 with GitHub read access; 1 required approval; self-review off on both environments | EMP-002 (owner role), prepared by EMP-013 | 2026-11-30 | SIM-CAPA-005 |
| A-04 | Retrospective review of the 22 merged PRs by EMP-014 | EMP-014 | 2026-11-13 | SIM-CAPA-005 |
| A-05 | Entra security defaults now; licences and `enable_conditional_access` in design | EMP-003 | 2026-11-06 / 2026-12-01 | SIM-CAPA-006 |
| A-06 | GitHub secret scanning and push protection on | EMP-002 (owner role) | 2026-11-06 | SIM-CAPA-007 |
| A-07 | GitHub plan with a DPA, or recorded reason to stay on personal terms (overdue from SIM-SUP-001) | EMP-016 | 2026-11-30 | SIM-SUP-001 |
| A-08 | Check whether the Customer A (fictional) contract promises EU data location (O-02) | EMP-004 | 2026-11-13 | SIM-AUD-003 |
| A-09 | Minimal alerting design before any deployment (O-01) | EMP-005 | 2026-12-15 | SIM-AUD-003 |
| A-10 | Incident tabletop on RISK-001 with break-glass exercise; also verifies SIM-CAPA-004 | EMP-005 | 2026-12-15 | SIM-CAPA-004 |
| A-11 | Q4 access review; runs the SIM-CAPA-001 and SIM-CAPA-002 checks | EMP-005 | 2026-12-14 | SIM-CAPA-001 |
| A-12 | SOC permission set so EMP-019 leaves Tier2-Workload; exception renewal not pre-approved | EMP-003 | 2026-11-30 | SIM-CAPA-002 |
| A-13 | First quarterly CISO report to the MD, including the exception list | EMP-002 | 2027-01-15 | SIM-AUD-003 O-04 |
| A-14 | POL-IR-01 section 8 and OP-06 changed to 24 hours (DEC-6) | EMP-002 | 2026-11-13 | SIM-CAPA-004 |
| A-15 | Document headers show the approval of 2026-03-02 (O-03) | EMP-018 | 2026-11-30 | SIM-AUD-003 |
| A-16 | Script for M-02, M-03 and OBJ-03 from GitHub (OFI-01) | EMP-013 | 2027-01-31 | SIM-AUD-003 |
| A-17 | Compile Q3 KPI results late, and set a due date for each quarter | EMP-018 | 2026-11-13 | — |

Minutes circulated 2026-10-28 for factual check. Confirmed as scenario decision by EMP-001 on 2026-10-30.

## Findings

1. **The agenda does not follow clause 9.3.2 item by item.** It merges audit results, nonconformities and objectives into separate rows but has no row for "feedback from interested parties" separate from their needs, and adds "operations" which is not an input. A reviewer cannot tick off a–g. Order the agenda by the clause.
2. **No rule for a first review.** Item a) assumes a previous review. The agenda should say to review decisions taken outside a review (here SIM-GOV-001) instead.
3. **Pre-read deadline exists, input deadlines do not.** The CISO asks five business days before, but the KPI document sets no date for quarterly results. Q3 results were missing.
4. **The action log ID scheme is reserved for real events.** The log uses `MR-<year>-<sequence>` after a real decision. These minutes use A-01 to A-17, scoped to SIM-MR-001.
5. **"Absent function" has no consequence.** The agenda says to record absent functions. It does not say whether a decision affecting that function can be taken without it.

## What this does not show

- No meeting took place. No decision, licence, budget or appointment exists.
- Documents are used as their text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
- Records owned by other authors (people, privacy, NIS2) are cited for their existence and headline only; their content is theirs.
- The real [management review action log](../../../ISMS/10-management-review/management-review-action-log.md) is still empty. That is correct.
