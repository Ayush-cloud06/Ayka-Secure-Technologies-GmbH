# SIM-CAPA-007 Corrective action: scheduled reviews and agreed follow-ups missed

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-CAPA-007 |
| Authored | 2026-11-10 |
| Scenario date | 2026-10-16 (opened from the audit report). Last update 2026-10-26 |
| Participants | EMP-021 (auditor, reporter), EMP-002 (CISO, approves plan; GitHub owner role for the secret-scanning setting), EMP-018 (action owner, ISMS calendar), EMP-005 |
| Procedure exercised | [Corrective action procedure ISMS-OPS-08](../../../ISMS/06-operational-procedures/corrective-action-procedure.md) sections 2 to 5 |
| Controls | ISO/IEC 27001:2022 clauses 6.1.2, 6.1.3, 8.2, 9.1, 10.2; Annex A A.5.18, A.5.36; SOC 2 RA-01, AC-07, MO-03 |

## 1. Confirm and contain

| Field | Content |
|---|---|
| Source and date | Internal audit SIM-AUD-003, NC-03 (minor), 2026-10-16. Working paper WP-03 |
| Requirement | Risk review quarterly (methodology section 4.7); High exception review within 90 days and Medium acceptance expiry (risk criteria section 6); quarterly access review (POL-AC-01 section 4.6); corrective actions done and checked on time (clause 10.2) |
| Objective evidence | Six missed commitments: risk review due 2026-06-12; RISK-007 exception review due 2026-06-12; RISK-008 acceptance expired 2026-09-16 and still shown accepted; Q3 access review due by 2026-09-30 (so SIM-CAPA-001 and SIM-CAPA-002 checks did not run); secret scanning by 2026-07-31 (SIM-SUP-001); SIM-CAPA-004 CA-2 due 2026-09-30 |
| Consequence | Two risk decisions ran on without authority. Two corrective actions have no effectiveness evidence |
| Correction | Risk review on 2026-11-06 decides RISK-007 and RISK-008 (SIM-MR-001 A-01). Until then RISK-008 is treated as **not accepted**. Secret scanning and push protection on by 2026-11-06 (A-06). Q4 access review on 2026-12-14 covers the missed checks (A-11) |

## 2. Cause

- No single list of dated ISMS commitments. Each document and record sets its own dates; nobody owns the whole.
- Reminders depend on memory. The CISO said in July she would "schedule" the overdue review (SIM-MON-002 section 4); nothing held her to it.
- Missed KPI targets do not open an action (SIM-MON-002 finding 1).

Similar exposure: all dated commitments in the simulated records from 2026-03-02 to 2026-10-16 were listed by EMP-018 on 2026-10-20: 31 found (scenario value), 6 missed (above), 2 more at risk (SIM-CAPA-002 CA-2 on 2026-11-30; SIM-CAPA-003 check on 2026-12-15).

## 3. Plan

| Element | Content |
|---|---|
| Action and owner | CA-1: one ISMS calendar holding every dated commitment from approved documents and records, with owner and source. Owner EMP-018. CA-2: reminder 10 business days before each date; overdue items to the CISO the next day. Owner EMP-018. CA-3: CISO reviews the calendar monthly and reports overdue items in M-09. Owner EMP-002 |
| Due date | CA-1 and CA-2 by 2026-11-13 (SIM-MR-001 A-02). CA-3 from November 2026 |
| Verification | Every commitment due November 2026 to January 2027 done on time, or moved by its decision maker before the due date with the reason recorded. Check date **2027-01-29**. Reviewer EMP-021 |
| Risk/doc changes | RISK-010 note. Methodology and KPI document changes proposed |

Status on 2026-10-26: **Action in progress.**

## Findings

1. **No ISMS-wide calendar is required by any procedure.** Clause 6.2 and 9.1 imply one; none of the ISMS documents names an owner for it. This is the root of NC-03 and part of NC-01.
2. **Containment for an expired acceptance is undefined.** The criteria say an accepted risk "returns to treatment" when it expires, but not who records that, or what the status shows meanwhile. This record had to decide.

## What this does not show

- No calendar, review or setting exists. The 31 commitments are a scenario count.
- Secret scanning and push protection are really disabled in the repository; nothing here changes that.
- The procedure is used as its text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
