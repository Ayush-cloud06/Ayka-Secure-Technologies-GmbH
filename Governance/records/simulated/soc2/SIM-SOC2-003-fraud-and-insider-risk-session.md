# SIM-SOC2-003: Fraud and insider-risk assessment session

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-SOC2-003 |
| Authored | 2026-11-10 (real date) |
| Scenario date | 2026-04-21 |
| Participants | EMP-002 (CISO, owner of the assessment), EMP-001 (Managing Director, approver), EMP-018 (Governance & Risk Analyst, scores and scribe), EMP-014 (Security Engineer), EMP-016 (Finance & Procurement Officer, FRD-07), EMP-012 (HR & Administration, FRD-05 and FRD-08) |
| Procedure exercised | [Fraud and insider-risk assessment RA-FRD-01](../../../policies/fraud-and-insider-risk-assessment.md) sections 1 to 4; [SOC2-08](../../../SOC2/08-control-designs.md#2-governance-people-and-risk) row RA-02 |
| Controls | SOC 2 RA-02 (CC3.3); ISO/IEC 27001:2022 clause 6.1.2; related RA-01, CM-05, AC-06, AC-08 |

## Scenario

Seven weeks after the ISMS approvals ([SIM-GOV-001](../governance/SIM-GOV-001-management-commitment-and-approvals.md)) and five weeks after the first risk review ([SIM-RISK-001](../risk/SIM-RISK-001-risk-review-and-acceptance-minutes.md), 2026-03-16), EMP-002 takes the ten scenarios of RA-FRD-01 to a 90-minute session. The text is used as it stands on the Authored date and treated as in force on 2026-04-21. As in SIM-RISK-001, facts dated after the scenario date are not used for any decision (see Finding 1).

## 1. Scenario by scenario

Scores are likelihood x impact on the 1 to 5 scales of the risk criteria. "Register" is the row of the [risk register](../../../ISMS/03-risk-management/risk-register.md) that already holds the same risk.

| ID | Proposed | Session score | Register | Outcome |
|---|---|---|---|---|
| FRD-01 Self-approved change | 16 | 16 | RISK-005 | Unchanged. EMP-014 points out the monthly review (check 1) has no owner who is not an author; it is the compensating review chosen in SIM-RISK-001 D-05 |
| FRD-02 Exception abuse | 12 | 12 | none | New register row needed |
| FRD-03 Break-glass misuse | 15 | 15 | RISK-013 | Unchanged. The check "review within 24 hours by a person other than the user" has no named person when the user is EMP-002 or EMP-001 |
| FRD-04 Staff data exfiltration | 15 | 15 | none | New register row needed. RISK-003 is about permissions, not about intent |
| FRD-05 Privilege creep, ghost accounts | 16 | 16 | RISK-004 | Unchanged. EMP-012 confirms the leaver step lives in the offboarding procedure only; no leaver has left yet |
| FRD-06 Evidence tampering | 12 | 12 | RISK-007 | Unchanged |
| FRD-07 Supplier or payment fraud | 6 | **9** | none | EMP-016 selects suppliers and approves invoices; EMP-024 reports to EMP-016 (personnel register), so there is no independent second approver. Likelihood raised from 2 to 3 |
| FRD-08 Expense and time fraud | 4 | 4 | none | Kept as out of scope |
| FRD-09 Management override | 12 | 12 | none | See Finding 3 |
| FRD-10 Insider sabotage | 10 | 10 | partly RISK-002 | RISK-002 is about state custody, not sabotage. New row needed |

## 2. Decisions

- Scenario decision by EMP-001: accept the assessment as the basis for the register. Four scenarios map to existing rows (FRD-01, 03, 05, 06); four need new rows (FRD-02, 04, 09, 10) and one (FRD-07) a row only if the score stays at 9 or above. EMP-002 to copy them.
- FRD-09 is left as recorded: "applies in full once a second person exists". EMP-001 notes that the scenario is about the role EMP-001 holds.
- The detective checks of section 3 get first due dates: monthly change review 2026-05-10, exception review by 2026-06-30, access review per ISMS-OPS-02, break-glass review per use, supplier conflict check at the next supplier onboarding, whistleblowing channel test by 2026-12-31.

## 3. Operating test of the design

The test in SOC2-08 is "the current version is approved within the last 12 months, and each periodic check due in the period has a record". On the session day: the version is approved by scenario decision (this record). No check was due yet. The first records that would test it fall due on 2026-05-10 and 2026-06-30, so the control cannot show anything until then.

## Findings

Defects in RA-FRD-01 and the RA-02 design as written:

1. **The assessment cites facts from after the session.** Version 1.0 uses the repository facts of REAL-SOC2-001 (17 pull requests, 0 approvals) and counts that exist only from October (111 exceptions, 13 entries expiring on one day). On 2026-04-21 none of this was known. The session had to score from the register alone. An assessment that quotes dated evidence needs the evidence date next to each figure.
2. **The register copy step is vague.** "The CISO copies accepted scenarios to the risk register" does not say which: four map to existing rows and the document does not say whether to extend those rows or add new ones. There is no mapping column.
3. **The approver is the subject of FRD-09.** The assessment's approver is the Managing Director, who holds risk acceptance authority and is the role that could override. No one above that role acts; the personnel register names "Board" only as the line manager of that role. The design needs an approver that is not the subject of the scenario, or a statement that this scenario cannot be approved independently.
4. **Checks have no start dates or recording places.** Section 3 gives frequencies but no first due date, and for the whistleblowing and supplier conflict checks the "where recorded" is "test note" or "supplier record", neither of which exists.
5. **Break-glass reviewer for the reviewer.** The check needs a second person; when the user is the CISO or the Managing Director the review falls to the other of the two, who are in a reporting line.
6. **No scoring rule for a single person doing two roles.** FRD-07 turned on whether a subordinate counts as a second approver. The design does not say it does not.
7. **The annual review has no start date.** "Annually" runs from the assessment date 2026-11-10 in the document and from this session's date in the scenario.

## What this does not show

- That a session took place, or that anyone said what the table shows.
- That the register has any new row. The risk register in the repository was not changed; the "new row needed" outcomes exist only in this record.
- That a fraud check ever ran. No monthly review, exception review or whistleblowing test is recorded here (the real monthly review is [REAL-SOC2-001](../../real/soc2/REAL-SOC2-001-change-review-2026-10.md), performed by the repository owner for October 2026).
- A tabletop is not an instance for a SOC 2 test. RA-02 would still fail a Type I (SOC2-06).
