# SIM-CAPA-001 Corrective action: leaver kept a GitHub seat for 12 days

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-CAPA-001 |
| Authored | 2026-11-10 |
| Scenario date | 2026-06-22 (opened). Last update 2026-10-26 |
| Participants | EMP-005 (reporter), EMP-002 (CISO, assigns and approves plan), EMP-012 (action owner, checklist), EMP-003 and EMP-013 (Cloud Platform, action owners) |
| Procedure exercised | [Corrective action procedure ISMS-OPS-08](../../../ISMS/06-operational-procedures/corrective-action-procedure.md) sections 2 to 5 |
| Controls | ISO/IEC 27001:2022 clause 10.2; Annex A A.5.18, A.6.5, A.8.2; SOC 2 AC-06, AC-07, MO-03 |

## 1. Confirm and contain

| Field | Content |
|---|---|
| Source and date | Access review SIM-ACC-001, exception E-1, 2026-06-22. Leaver path: [SIM-PPL-004](../people/SIM-PPL-004-leaver-emp-023.md) |
| Requirement | [POL-AC-01](../../../policies/access-control-policy.md) section 4.4: leaver access disabled by end of last working day, removed within one business day |
| Objective evidence | EMP-023, last working day 2026-05-29. GitHub seat (team `docs-contributors`) removed 2026-06-10 by EMP-003, 12 days after the disable deadline |
| Consequence | Read/triage access to documentation repositories for 12 days after leaving. No activity found in the audit log (scenario value) |
| Validated | Yes, by EMP-002 on 2026-06-22 |
| Correction | Already done on 2026-06-10. CISO informed 2026-06-22, 12 days after the fact |

## 2. Cause

- The offboarding checklist gives GitHub to "Cloud Platform Engineering", a function, not a person. EMP-013 did Entra and AWS and took GitHub to be EMP-003's job. EMP-003 was away from 2026-05-29 to 2026-06-09 with no deputy (SIM-PPL-004).
- GitHub membership is managed by hand. It is not driven by the personnel source, so disabling Entra ID did not remove it.
- The Security Operations check on 2026-06-03 had no system list and did not include GitHub.
- No rule told anyone to report the missed deadline to the CISO.

Similar exposure: all 14 GitHub seats at the 2026-06-15 export matched the roster. Tools with their own logins outside Entra ID were **not** examined; the access review has no population for them (SIM-ACC-001 finding 1).

## 3. Plan

| Element | Content |
|---|---|
| Correction versus prevention | Correction done. Prevention below |
| Action and owner | CA-1: each checklist row names a person and a deputy. Owner EMP-012. CA-2: the Security Operations check uses a fixed system list including GitHub and every tool with its own login. Owner EMP-005. CA-3: missed leaver deadline goes to the CISO the same day. Owner EMP-003. CA-4: proposal to tie GitHub membership to Entra ID; needs a plan change and money, so it goes to management review |
| Due date | CA-1 to CA-3 by 2026-07-15. CA-4 at the first management review |
| Verification | At the next quarterly access review: every leaver in the quarter has every seat removed within one business day, and any miss reached the CISO the same day. Reviewer EMP-005, checked by EMP-002 |
| Risk/doc changes | RISK-004 note. Offboarding procedure update proposed |

## 4. Progress

| Date | Event |
|---|---|
| 2026-07-15 | CA-1 to CA-3 done (scenario value) |
| 2026-09-30 | Effectiveness check due at the Q3 access review. **The Q3 review was not held.** Check did not happen (SIM-AUD-003 NC-03) |
| 2026-10-26 | Management review resets the check to the Q4 access review on 2026-12-14 (SIM-MR-001 A-11). CA-4 not funded this year (SIM-MR-001) |

Status on 2026-10-26: **Awaiting effectiveness review.** Not closed.

## Findings

1. **The effectiveness check depends on another process happening.** The procedure lets the check be "at the next review". When that review was skipped, nothing flagged the check as missed. A check date should be a calendar date.
2. **No rule for corrective actions that need money.** CA-4 needs a management decision. Section 3 says the Managing Director "decides material resources" but gives no route or date for asking.
3. **"Similar exposure" can be limited by what the process can see.** The procedure asks to "record the population examined", not what was left out. This record added it.

## What this does not show

- No person left and no seat existed. Dates and counts are scenario values.
- The procedure is used as its text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
- The real [NC/CA log](../../../ISMS/11-improvement/nonconformity-and-corrective-action-log.md) is still empty. That is correct.
