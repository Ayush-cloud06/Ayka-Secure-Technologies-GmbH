# SIM-CAPA-002 Corrective action: mover kept an engineering permission set without a working compensating control

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-CAPA-002 |
| Authored | 2026-11-10 |
| Scenario date | 2026-06-22 (opened). Last update 2026-10-26 |
| Participants | EMP-005 (reporter, exception register owner), EMP-002 (CISO, exception approver), EMP-003 (action owner, permission set), EMP-001 (informed) |
| Procedure exercised | [Corrective action procedure ISMS-OPS-08](../../../ISMS/06-operational-procedures/corrective-action-procedure.md) sections 2 to 5 |
| Controls | ISO/IEC 27001:2022 clause 10.2; Annex A A.5.3, A.5.15, A.5.18, A.8.2; SOC 2 AC-04, AC-07, MO-03 |

## 1. Confirm and contain

| Field | Content |
|---|---|
| Source and date | Access review SIM-ACC-001, exception E-2, 2026-06-22. Mover path: [SIM-PPL-005](../people/SIM-PPL-005-mover-emp-019.md) |
| Requirement | [POL-AC-01](../../../policies/access-control-policy.md) section 4.4 (old access removed within five business days) and section 6 (an exception needs a compensating control and is listed in the quarterly report to the Managing Director) |
| Objective evidence | EMP-019 moved to Security Operations on 2026-06-01. Identity Center Tier2 kept, with Tier2-Workload and WorkloadOperatorRole. Exception by EMP-002 dated 2026-05-19, ending 2026-11-30, compensating control "listed in the quarterly access review". At the review the exception was on no list; Security Operations did not know of it. No quarterly report to the MD exists |
| Consequence | For three weeks the compensating control existed only on paper. A SOC analyst holds operator rights in the account he monitors (segregation of duties, A.5.3) |
| Validated | Yes, by EMP-002 on 2026-06-22 |
| Correction | Exception entered on a new exception list held by EMP-005 on 2026-06-22. EMP-001 informed the same day |

## 2. Cause

- The tier model cannot express a department move: SOC and developers share Tier2, and no SOC permission set exists (SIM-PPL-005 findings 1 and 3). The exception was the only way to "follow" the procedure.
- The exception approval had no step to hand it to the people who run the compensating control.
- The quarterly MD report that section 6 relies on does not exist (SOC 2 CE-06; SIM-AUD-003 O-04).

Similar exposure: the other SOC analysts (EMP-017, EMP-020) and EMP-005 also sit in Tier2 with the same permission set, by design rather than by exception. EMP-002 noted this as the same segregation question, outside this nonconformity, for the risk review (RISK-003).

## 3. Plan

| Element | Content |
|---|---|
| Correction versus prevention | Correction done. Prevention below |
| Action and owner | CA-1: exception register owned by Security Operations; every POL-AC-01 exception is entered on approval. Owner EMP-005. CA-2: a read-only SOC permission set and group, so movers into SOC leave Tier2-Workload. Owner EMP-003 |
| Due date | CA-1 2026-07-15. CA-2 before the exception ends: 2026-11-30 |
| Verification | On 2026-11-30: EMP-019 either no longer holds WorkloadOperatorRole or has a renewed, listed exception. At the Q4 access review on 2026-12-14: every open exception appears on the register. Reviewer EMP-005, checked by EMP-002 |
| Risk/doc changes | RISK-003 and RISK-004 notes. POL-AC-01 section 6 wording proposed |

## 4. Progress

| Date | Event |
|---|---|
| 2026-07-15 | CA-1 done (scenario value) |
| 2026-09-30 | Planned interim check at the Q3 access review. **Not held** (SIM-AUD-003 NC-03) |
| 2026-10-26 | Management review: CA-2 stays due 2026-11-30; renewal of the exception is not pre-approved (SIM-MR-001 A-12) |

Status on 2026-10-26: **Action in progress** (CA-2 open). Not closed. As SIM-PPL-005 records, no renewal or new group had been decided by 2026-11-10.

## Findings

1. **An exception is not a closure.** The corrective action procedure does not say whether an approved policy exception counts as conformity. Here it did not, because its own condition failed. State that an exception is conforming only while its conditions operate.
2. **Small populations make effectiveness hard to show.** One mover a quarter proves little. Set a minimum count or period.

## What this does not show

- No role change happened. Dates and counts are scenario values.
- The real [personnel register](../../../../organization/personnel-register.md) still shows EMP-019 in Engineering.
- The procedure is used as its text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
