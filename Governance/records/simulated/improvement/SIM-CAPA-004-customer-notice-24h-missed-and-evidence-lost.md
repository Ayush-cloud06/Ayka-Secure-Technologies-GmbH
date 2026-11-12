# SIM-CAPA-004 Corrective action: 24-hour customer notice missed and evidence deleted before capture

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-CAPA-004 |
| Authored | 2026-11-10 |
| Scenario date | 2026-08-25 (opened at the post-incident review). Last update 2026-10-26 |
| Participants | EMP-002 (CISO, action owner for documents), EMP-010 (action owner, contacts), EMP-005 (action owner, briefing), EMP-001 (approver of document changes) |
| Procedure exercised | [Corrective action procedure ISMS-OPS-08](../../../ISMS/06-operational-procedures/corrective-action-procedure.md) sections 2 to 5 |
| Controls | ISO/IEC 27001:2022 clause 10.2; Annex A A.5.24, A.5.26, A.5.28; SOC 2 OP-06, IC-02, MO-03; GDPR Art. 33(2) |

## 1. Confirm and contain

| Field | Content |
|---|---|
| Source and date | INC-2026-001 (SIM-INC-001, SIM-INC-002), review SIM-IMP-001 lessons L-2 to L-4 |
| Requirement | (1) [NIS2-03](../../../NIS2/03-incident-reporting-procedure.md) sections 5 and 6: customer notice within 24 h of awareness. (2) [POL-IR-01](../../../policies/incident-response-plan.md) section 7.5: preserve evidence before cleaning up |
| Objective evidence | (1) Notice ready 07:45, would have been sent 14:40 on 2026-08-13: T0 + 27 h 10 min. (2) Branch deleted at 10:20 on 2026-08-12, before any capture |
| Consequence | Controller learned 3 h 10 min later than promised. Evidence survived only because the host kept the pull-request ref |
| Correction | None possible for the past notice. Evidence: captured at 10:35 from the ref |

## 2. Cause

- No customer security contact was recorded at contract signature. Finding the right person took 5 hours.
- Two deadlines: POL-IR-01 says 48 h, NIS2-03 says 24 h. The 24 h commitment was not in anyone's head until the IC chose it at 16:00.
- Staff outside the response team were never told "do not delete, tell the IC".

Similar exposure: one customer exists. Its contact is now recorded. Other procedures with two different deadlines for one duty: the leaver removal (one business day versus five business days), see SIM-ACC-001 finding 6.

## 3. Plan

| Element | Content |
|---|---|
| Action and owner | CA-1: "security contact" field in the contract template and a customer contact list. Owner EMP-010. CA-2: one customer deadline (24 h) in POL-IR-01 section 8 and SOC 2 OP-06, same as NIS2-03. Owner EMP-002, approver EMP-001. CA-3: one-page "do not delete, tell the IC" rule in staff onboarding and a briefing. Owner EMP-005 |
| Due date | CA-1 2026-09-30; CA-2 2026-09-30; CA-3 2026-09-11 |
| Verification | Next incident tabletop (RISK-001 scenario) measures time from T0 to a ready-to-send customer notice; target under 24 h, contact found in under 30 min, nothing deleted before capture. Check date **2026-12-15**. Reviewer: EMP-021 or another person outside the response team |
| Risk/doc changes | POL-IR-01, OP-06 wording; communication plan contact list |

## 4. Progress

| Date | Event |
|---|---|
| 2026-09-11 | CA-3 briefing held (scenario value). Attendance proof in the people area (other author) |
| 2026-09-22 | CA-1 done: field added, Customer A (fictional) contact recorded (scenario value) |
| 2026-09-30 | CA-2 due. **Not done** (SIM-AUD-003 NC-03) |
| 2026-10-26 | Management review sets CA-2 to 2026-11-13 (SIM-MR-001 A-14). Original date and reason kept here |

Status on 2026-10-26: **Action in progress**, CA-2 overdue. Not closed.

## Findings

1. **Document changes from a corrective action have no fast route.** CA-2 is a one-line change to an approved policy. The document control procedure gives no faster path for a corrective change, so it waited for an approval slot and went overdue.
2. **A missed deadline in a procedure is an NC, but which document is wrong?** The procedure asks for "exact applicable requirement/version". With two conflicting documents, the requirement itself was disputed. Add a step: "if requirements conflict, record both and let the CISO decide which applies until fixed".

## What this does not show

- No notice was due and no evidence was lost. Times are scenario values.
- The real [POL-IR-01](../../../policies/incident-response-plan.md) still says 48 hours and [NIS2-03](../../../NIS2/03-incident-reporting-procedure.md) still says 24 hours. That conflict is true of the repository.
- The procedure is used as its text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
