# SIM-CAPA-003 Corrective action: real customer data used as a test fixture

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-CAPA-003 |
| Authored | 2026-11-10 |
| Scenario date | 2026-08-25 (opened at the post-incident review). Last update 2026-10-26 |
| Participants | EMP-002 (CISO), EMP-006 (action owner, onboarding route), EMP-013 (action owner, CI check), EMP-005 (similar-exposure search), EMP-004 (privacy check) |
| Procedure exercised | [Corrective action procedure ISMS-OPS-08](../../../ISMS/06-operational-procedures/corrective-action-procedure.md) sections 2 to 5 |
| Controls | ISO/IEC 27001:2022 clause 10.2; Annex A A.8.11, A.8.33, A.5.12, A.5.34; SOC 2 CO-05, MO-03; GDPR Art. 28(3), 32 |

## 1. Confirm and contain

| Field | Content |
|---|---|
| Source and date | Incident INC-2026-001 (SIM-INC-001), review SIM-IMP-001 lesson L-1 |
| Requirement | [STD-MSK-01](../../../policies/data-masking-standard.md) rule 1: production personal data is not copied into test, CI or fixtures. SOC 2 CO-05 |
| Objective evidence | Customer A (fictional) list of 137 people committed as `tests/fixtures/customer_a_users.csv` on 2026-08-10 |
| Consequence | Personal data breach; customer notified; see SIM-INC-001 |
| Correction | Logs deleted 2026-08-12; copies deleted 2026-08-13; import work moved to synthetic data 2026-08-14 |

## 2. Cause

- No route for customer onboarding files. E-mail forwarding to an engineer was the only way.
- The masking rule existed, but nothing checked it.
- The build log prints full assertion diffs, so any fixture value can end up in a public log.

Similar exposure, searched by EMP-005 on 2026-08-27: all files under `tests/` and their Git history for e-mail addresses outside reserved example domains. None found (scenario value). Already known and recorded elsewhere: the personnel file under PA-01 holds one real identity; it is not a fixture and stays with its own record.

## 3. Plan

| Element | Content |
|---|---|
| Correction versus prevention | Correction above. Prevention below |
| Action and owner | CA-1: CI check for e-mail addresses in fixtures (SIM-CHG-001). Owner EMP-013. CA-2: route for customer onboarding files: restricted folder, named handlers, purpose, deletion date; no forwarding by e-mail. Owner EMP-006. CA-3: pytest set to shorten assertion output in CI. Owner EMP-013 |
| Due date | CA-1 2026-08-28; CA-2 2026-09-30; CA-3 2026-09-30 |
| Verification | (a) Seeded known-bad fixture fails CI on a fixed date. (b) The next customer onboarding file follows the route, checked by EMP-004. Check date **2026-12-15** |
| Risk/doc changes | RISK-011 note. Secure development policy reference to STD-MSK-01 check |

## 4. Progress

| Date | Event |
|---|---|
| 2026-08-27 | CA-1 merged (SIM-CHG-001) |
| 2026-09-28 | CA-2 in place (scenario value) |
| 2026-09-29 | CA-3 done (scenario value) |
| 2026-10-26 | Management review notes the open check (SIM-MR-001) |

Status on 2026-10-26: **Awaiting effectiveness review** on 2026-12-15.

## Findings

1. **No owner for the "similar exposure" search.** The procedure tells the action owner to check other assets. The search needed Security Operations' skills, not the owner's. Let CISO assign the search separately.
2. **Effectiveness may wait for an event that never comes.** Check (b) needs a new customer onboarding file. If none comes by 2026-12-15, the procedure does not say whether to close on (a) alone or to extend.

## What this does not show

- No data was committed. No CI check exists in the repository.
- The procedure is used as its text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
