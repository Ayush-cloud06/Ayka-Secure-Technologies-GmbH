# SIM-PPL-005: Mover: EMP-019, Junior DevOps Engineer to Security Operations (SOC), 2026-06-01

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-PPL-005 |
| Authored | 2026-11-10 (real date) |
| Scenario date | 2026-05-12 to 2026-06-19 |
| Participants | EMP-019 (mover), EMP-013 (releasing manager), EMP-005 (receiving manager and approver), EMP-012 (HR), EMP-002 (CISO), EMP-003 (implementer), EMP-020 (verifier) |
| Procedure exercised | [Onboarding and offboarding procedure](../../../ISMS/01-organization/onboarding-and-offboarding-procedure.md) section 2, stage "Role change"; [User access procedure](../../../ISMS/06-operational-procedures/user-access-procedure.md) section 3, step 5; [Access control policy](../../../policies/access-control-policy.md) section 4.4; [Competence matrix](../../../ISMS/01-organization/competence-matrix.md) |
| Controls | ISO 27001:2022 A.5.15, A.5.18, A.8.2, A.6.3, clause 7.2; SOC 2 AC-06, AC-07, CE-05; GDPR Art. 5(1)(f) |

## Scenario summary

EMP-019 moves from Engineering (manager EMP-013) to Security Operations (manager EMP-005) with effect from Monday 2026-06-01. Tier stays Tier 2. The rule: old access removed within 5 business days of the change (by 2026-06-08); new access approved by someone other than the requester and the recipient; changed training needs recorded.

Everything on the access side was done on time. The two findings that matter are about what the groups can and cannot express, and about training.

## Timeline

| Date | Event | By |
|---|---|---|
| 2026-05-12 | HR records the planned role change. Request MVR-2026-001 opened (scenario). Requester is HR, not the recipient | EMP-012 |
| 2026-05-14 | Receiving function owner confirms the minimum new access and the old access to remove (lists below) | EMP-005 |
| 2026-05-14 | Releasing manager confirms the removal list and that no open Engineering work needs the old access | EMP-013 |
| 2026-05-19 | Approval of the new access. Scenario decision by EMP-005. The CISO was informed (SOC reports to the CISO) and raised no objection | EMP-005, EMP-002 |
| 2026-06-01 | Entra department group swapped, GitHub teams swapped. Before and after membership recorded on the ticket | EMP-003 |
| 2026-06-02 | Read-only effective-membership check on Entra, Identity Center and GitHub. Matches the lists below | EMP-020 |
| 2026-06-02 | Ticket closed. Removal done on business day 2 of 5 | EMP-003 |
| 2026-06-19 | Role training for Security Operations completed. Competence outcome: competent for supervised work | EMP-005 (assessor), EMP-019 |

## Entitlement change

| System | Before (Engineering) | After (Security Operations) | Action date | Note |
|---|---|---|---|---|
| Entra department group | grp-dept-engineering | grp-dept-security-operations | 2026-06-01 | Security role group grp-sec-standard-user unchanged |
| Entra tier group | grp-tier-tier2 | grp-tier-tier2 | none | Same tier |
| Identity Center | Tier2 (Tier2-Workload, WorkloadOperatorRole) | Tier2 (no change) | none | See Findings 1 and 2. Open item with an exception |
| GitHub | Team engineering (write) | Team security-ops (read) | 2026-06-01 | Repository write removed. No approval-environment reviewer role was held |
| CI/CD secrets, deploy environments | None held | None | none | Checked by EMP-013 |
| Line manager in HR record | EMP-013 | EMP-005 | 2026-06-01 | Register not updated (Finding 6) |

Exception for the Identity Center item: the Tier2-Workload permission set stays because no group exists that separates SOC from developers. Approved by EMP-002 on 2026-05-19 as a written exception under access control policy section 6. Compensating measure: the item is listed in the quarterly access review. End date 2026-11-30, the six-month maximum. Scenario decision by EMP-002. Renewal or a new group has not been decided at 2026-11-10 (the date this record was authored).

## Training and competence

The competence matrix requires, for Security Operations, an incident tabletop and an access-review sample "before operational duty". EMP-019 started SOC duty on 2026-06-01 and completed the exercise on 2026-06-19. For 18 days he worked as supervised, shadowing EMP-020. The outcome "competent for supervised work" is the second level in the matrix. Reassessment for "assigned work" is due by 2026-09-01 (scenario decision by EMP-005). The 2026-06-22 access review (SIM-ACC-001) is a separate record.

## Findings

1. **The group model cannot show a department move in AWS.** The tier is Tier 2 on both sides, so Identity Center membership does not change. Department is not mapped as a session attribute (`session-controls.tf` maps AccessTier and CostCenter only), so the ABAC Department rule has nothing to evaluate. The move changed Entra and GitHub, and nothing in AWS.
2. **Old access that cannot be removed.** "Old access removed" cannot be met for WorkloadOperatorRole. The policy has an exception route, so one was used. The exception is the only evidence that the procedure was followed.
3. **No permission set for Security Operations.** SOC analysts (EMP-020, EMP-017 and now EMP-019) sit in Tier 2. SecurityAuditRole is reached only through Tier1-Ops. The access control policy says Security Operations exports and reviews access, which needs read access that Tier 2 does not give.
4. **The approval step does not say who approves a mover.** The user access procedure says "relevant function owner". The policy table puts approval with the line manager. The releasing manager has no stated role, so EMP-013's confirmation of the removal list was a scenario choice.
5. **Training timing conflicts with starting duty.** The competence matrix says before operational duty. The mover procedure only says "revised competence/training needs". An 18-day supervised period was needed. The matrix does not define supervised work as allowed.
6. **The personnel register has no change history.** The register (last updated 2026-02-19) still shows Junior DevOps Engineer and manager EMP-013. The register says role changes require formal documentation but gives no form and no owner. `organization/personnel.json` records the move in a `changes` list. The identity source `personnel.json` under the Entra module was not changed by this record, so it still carries the old department.
7. **Five business days is long for access that is not needed.** Removing repository write rights for a person who no longer works in Engineering took one day here. The procedure would also have accepted day 5.
8. **No link to quarterly review.** A mover's changes are not listed for the next access review. The CISO has no field to see the exception end date.

## What this does not show

- A mover who changes tier, or one who moves into Tier 0 or Tier 1.
- Any real permission test of what WorkloadOperatorRole allows a SOC analyst.
- That EMP-019 or EMP-013 agreed to anything in writing.
- A change of the employment contract or pay (outside the ISMS procedures).
