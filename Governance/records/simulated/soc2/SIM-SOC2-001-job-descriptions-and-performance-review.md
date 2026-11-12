# SIM-SOC2-001: Job descriptions and the security section of the performance review

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-SOC2-001 |
| Authored | 2026-11-10 (real date) |
| Scenario date | 2026-07-13 |
| Participants | EMP-012 (HR & Administration, operator), EMP-002 (CISO, content owner), EMP-001 (Managing Director, decides), EMP-003, EMP-005 (line managers completing trial forms), EMP-007 and EMP-019 (the two employees in the trial; EMP-003 is the third trial subject and is reviewed by EMP-002) |
| Procedure exercised | [SOC2-08](../../../SOC2/08-control-designs.md#2-governance-people-and-risk) row CE-07, built from the [roles and responsibilities](../../../../organization/roles-and-responsibilities.md) |
| Controls | SOC 2 CE-07 (CC1.5); ISO/IEC 27001:2022 A.6.2; related CE-02, CE-05 |

## Scenario

On 2026-07-13 EMP-012 tries the CE-07 design for the first time. The design has two halves: a job description for every role that carries a security clause, and an annual review form with a security section of four items. The 23 active staff all started between 2026-01-01 and 2026-02-13 (the 24th, EMP-023, left on 2026-05-29: SIM-PPL-004). Nobody has been employed for 12 months. Scenario decision by EMP-012 with EMP-002: run the review form once now as a trial on three people so the form is tested before the first real annual cycle in January 2027.

## 1. Building job descriptions from the roles document (design step 1)

The design says every description is "built from" the roles document. That document has one section per function plus a section for all employees. Each of the 23 active positions was matched to a section by EMP-012.

| Match | Positions | Count |
|---|---|---:|
| Clear match to one function section | EMP-001 (s.2), EMP-002 (s.3), EMP-003 (s.4), EMP-004, EMP-018, EMP-021 (s.5), EMP-005, EMP-019 after the move, EMP-020 (s.6), EMP-006, EMP-007, EMP-008, EMP-015 (s.7), EMP-012 (s.8) | 14 |
| Two sections fit | EMP-013 (DevOps: s.4 or s.7), EMP-014 and EMP-017 (department "Security", which is not a section name; s.6 or s.7) | 3 |
| No section | EMP-009 (Sales Manager), EMP-010 (Customer Success), EMP-011 (IT Support), EMP-016 (Finance and Procurement), EMP-022 (Marketing), EMP-024 (Financial Controller) | 6 |

For the six unmatched positions the only security text available is section 9 (all employees). EMP-002 drafts one extra line each by hand: EMP-011 as asset custodian, EMP-016 as supplier coordinator (both are named security roles in the personnel register), EMP-009 and EMP-010 as customer-facing roles that receive customer data by e-mail (the INC-2026-001 route was not known yet: that incident is on 2026-08-12), EMP-022 and EMP-024 nothing beyond section 9.

The clause required by the design has three parts: the role's responsibilities, the duty to follow the code of conduct, the duty to report incidents. Scenario result: the clause text is written once by EMP-002 and placed at the end of each description. Reporting channel named in the clause: "the security mailbox". No such mailbox exists (IC-03 is Designed), so EMP-012 writes "your line manager or EMP-002" and flags it.

## 2. Review form trial (design step 2)

Three people, chosen by EMP-012 to cover a standard user, a mover and a privileged administrator. Evidence for each item comes from other records; the form itself holds the manager's judgement.

| Item | EMP-007 (Backend Engineer, manager EMP-003) | EMP-019 (SOC since 2026-06-01, manager EMP-005) | EMP-003 (Tier 1, manager EMP-002) |
|---|---|---|---|
| 1 Policy acknowledgements current | Acceptable use policy acknowledged 2026-03-05 (SIM-PPL-001). Code of conduct: not available, so **not current** | AUP 2026-03-11. Code of conduct not available | AUP 2026-03-03. Code of conduct not available |
| 2 Training complete | Baseline passed on retake, 2026-03-16 (SIM-PPL-003) | Baseline 2026-03-18; SOC role training 2026-06-19 (SIM-PPL-005) | Baseline 2026-03-06 and Tier 1 role training (SIM-PPL-003) |
| 3 Security concerns raised or handled | Manager notes none raised (scenario value) | Manager notes one question about the Tier 2 permission set he kept | None recorded |
| 4 Access hygiene (no unused access) | Manager cannot tell: no sign-in data is available to him | **Not clean by design:** keeps Tier2-Workload under EMP-002's exception to 2026-11-30 (SIM-ACC-001 E-2). Manager records it, does not mark it as a fault | Manager is also the one who approves the reviewer's own Tier 0 admin account; EMP-002 notes the circularity |

## 3. Decisions

- Scenario decision by EMP-001: the clause text and the form are approved for the first annual cycle starting 2027-01. The three trial forms are kept in the HR system and not used for any employment decision.
- Scenario decision by EMP-012: the six hand-written lines are kept until the roles document has sections for them.

## Findings

Defects in the CE-07 design as written:

1. **The annual rule has nothing to run on in the first year.** The operating test is "each person employed for 12 months has a review form". With joiners from January and February 2026, the population is empty until January 2027. A first-year review (probation or six months) is not in the design.
2. **The roles document does not cover six of 23 positions** (Sales, Customer Success, IT Support, Finance and Procurement, Marketing, Financial Controller) and is ambiguous for three more. "Built from the roles document" cannot be followed for them.
3. **The clause names a channel that does not exist.** "Report incidents" needs the security mailbox (IC-03), which is Designed only.
4. **The clause depends on a code of conduct nobody has acknowledged** (CE-02). Item 1 of the form fails for every person until that control runs.
5. **"No unused access" is undefined.** There is no data source for "unused" (Entra ID Free retains sign-in logs only briefly, to verify) and no rule on who looks. A manager cannot answer item 4 from what they can see.
6. **Conflict with the legitimate-interests assessment.** [GDPR-13](../../../GDPR/legitimate-interests-assessment.md) says security logs are not used for performance review. Item 4 invites exactly that use. The design must say the form records the access-review result (AC-07), not log data.
7. **A mover or a leaver of the period has no form.** EMP-019's job description changed on 2026-06-01; the design says nothing about reissuing a description on a role change.
8. **Reviewer circularity for privileged staff.** The line manager of a Tier 1 engineer is also the approver of that person's access.

## What this does not show

- That any job description or review form exists. No file in the repository changed.
- That any manager said or wrote what the table shows. The answers are scenario values.
- That a performance review process exists at Ayka beyond this design. German employment-law requirements for appraisals and for staff representation (none recorded) were not examined; counsel has not reviewed.
- A tabletop is not an instance for a SOC 2 test. CE-07 would still fail a Type I (SOC2-06).
