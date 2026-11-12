# SIM-CAPA-005 Corrective action: no independent change approval and the compensating review never ran

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-CAPA-005 |
| Authored | 2026-11-10 |
| Scenario date | 2026-10-16 (opened from the audit report). Last update 2026-10-26 |
| Participants | EMP-021 (auditor, reporter and later verifier), EMP-002 (CISO, action owner), EMP-001 (Managing Director, resources), EMP-002 (also GitHub owner role, makes the settings change), EMP-013 (prepares the settings change), EMP-014 (appointed change reviewer) |
| Procedure exercised | [Corrective action procedure ISMS-OPS-08](../../../ISMS/06-operational-procedures/corrective-action-procedure.md) sections 2 to 5 |
| Controls | ISO/IEC 27001:2022 clause 10.2; Annex A A.5.3, A.8.32, A.8.4; SOC 2 CM-01, CM-05, MO-03 |

## 1. Confirm and contain

| Field | Content |
|---|---|
| Source and date | Internal audit SIM-AUD-003, NC-01 (major), 2026-10-16. Working paper WP-01 in SIM-AUD-002 |
| Requirement | [POL-CHG-01](../../../policies/change-management-policy.md) section 10: monthly Managing Director review of all merged changes while one maintainer approves. OBJ-03: changes approved by someone other than the author |
| Objective evidence | 0 of 22 merged PRs approved by a second person (OBJ-03 snapshot, 2026-10-14). 0 of 7 monthly reviews recorded (March to September). Ruleset needs 0 approvals; both approval environments allow self-review. EMP-001 has no GitHub access (SIM-PPL-001) |
| Consequence | Every change to the gate, mappings and exceptions in the period rests on one account. A wrong or malicious change would not be caught by a second person |
| Validated | Yes, at the closing meeting on 2026-10-09; graded major |
| Correction | Retrospective review of all 22 merged PRs by EMP-014, who did not author them, by 2026-11-13 |

## 2. Cause

- The compensating control names a reviewer (the MD) who has neither access nor an input list. It was never scheduled.
- GitHub settings make a second approval optional (0 approvals, self-review allowed).
- Missed M-03 targets in Q1 and Q2 produced no action (SIM-MON-002 finding 1).
- No ISMS calendar held the monthly date (same cause as SIM-CAPA-007).

Similar exposure: other "monthly" or "quarterly" human checks that depend on one person: CE-06 quarterly CISO report (not held, SIM-AUD-003 O-04), break-glass 24 h review (never needed). Recorded for SIM-CAPA-007.

## 3. Plan

| Element | Content |
|---|---|
| Correction versus prevention | Correction: retrospective review (above). Prevention below |
| Action and owner | CA-1: EMP-014 named as change reviewer with GitHub read access; second CODEOWNER for gate paths. Owner EMP-002. CA-2: ruleset requires 1 approving review on `main`; `prevent_self_review` on both approval environments. Prepared by EMP-013, applied by EMP-002 as owner-role holder, through a settings change record. CA-3: POL-CHG-01 section 10 rewritten: reviewer may be neither author nor approver; input is a generated list of merged changes (SIM-AUD-003 OFI-01). Owner EMP-002, approver EMP-001 |
| Due date | CA-1 and CA-2 by 2026-11-30 (SIM-MR-001 A-03). CA-3 by 2026-11-30 |
| Verification | M-03 at 100 % for gate paths, `.github/` and `Governance/` over December 2026 to February 2027, recomputed by EMP-021 from GitHub. Check date **2027-03-05** |
| Risk/doc changes | RISK-005 rescore after verification. CM-05 status reviewed. SoA A.8.32 note |

## 4. Progress

| Date | Event |
|---|---|
| 2026-10-26 | Management review approves 10 % of EMP-014's time and the settings change (SIM-MR-001 A-03, A-04) |

Status on 2026-10-26: **Action in progress.**

## Findings

1. **Verifier for an audit finding is undefined when the auditor is busy.** The findings log says "only the auditor or another independent competent reviewer verifies closure". EMP-021 is the only internal auditor. If he is unavailable on 2027-03-05, nobody qualifies.
2. **A settings change has no change record.** CA-2 changes GitHub settings. The change procedure covers pull requests only (SIM-CHG-001 finding 1). This action needed a workaround.

## What this does not show

- No review, setting or appointment happened. The 22 PRs and the ruleset are real repository facts; using them as Ayka's evidence is fiction.
- The real ruleset still requires 0 approvals and self-review is still allowed. Nothing here changes that.
- The procedure is used as its text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
