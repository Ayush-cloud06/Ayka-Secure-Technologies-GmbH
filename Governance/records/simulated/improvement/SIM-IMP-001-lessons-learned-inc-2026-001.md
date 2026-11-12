# SIM-IMP-001 Lessons learned: INC-2026-001 post-incident review

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-IMP-001 |
| Authored | 2026-11-10 |
| Scenario date | 2026-08-25 |
| Participants | EMP-002 (IC, chair), EMP-005 (Incident Coordinator), EMP-004 (Privacy Lead), EMP-003 (Technical Lead), EMP-013, EMP-007, EMP-015, EMP-010, EMP-006 (Product Manager), EMP-018 (minutes) |
| Procedure exercised | [POL-IR-01](../../../policies/incident-response-plan.md) section 9 (post-incident review); [lessons learned log ISMS](../../../ISMS/11-improvement/lessons-learned-log.md) section 2 (review method) |
| Controls | ISO/IEC 27001:2022 Annex A A.5.27; clauses 10.1, 10.2; SOC 2 OP-07, MO-03 |

Blameless review of INC-2026-001 (SIM-INC-001). Held on 2026-08-25, inside the 10-business-day limit (due 2026-08-26).

## 1. Expected versus observed

| Step | Expected (plan) | Observed | Gap |
|---|---|---|---|
| Report | Security mailbox or on-call number | Engineering chat | No reporting channel exists |
| Triage within 30 min (SEV 2) | Record opened, severity set | 10:05 call, 10:12 record opened, SEV 2 at 11:30 | Met for opening; classification took 78 min because the source of the file had to be confirmed |
| Evidence before clean-up | Nothing deleted before capture | Branch deleted at 10:20 by the author | Missed. Saved by the pull-request ref |
| Customer notice | 24 h (NIS2-03) or 48 h (POL-IR-01) | 27 h 10 min | Missed the 24 h commitment |
| Management updates every 4 h | Rolling | 12.5 h overnight gap | Missed |
| Privacy decision | GDPR Lead decides | Done at 13:30; Art. 28(10) question left without legal input | Partly met |
| 72 h, one month, review | Per clocks | All on time | Met |

## 2. What helped

- EMP-015 looked at the data, not just the test result.
- GitHub keeps pull-request refs, so the evidence survived the deleted branch. The same feature keeps the data public until removed.
- The IC chose the stricter 24 h clock, so the miss was visible.

## 3. Contributing conditions

Process, not people:

1. No route for customer onboarding files. E-mail forwarding was the only way.
2. STD-MSK-01 forbids real data in fixtures, but nothing checks it.
3. Engineers are not told that "clean up" can destroy evidence.
4. No customer security contact is collected at contract signature.
5. Two documents give two customer deadlines.
6. No on-call rota, so "24 x 7" updates rest on goodwill.
7. No alerting. The incident was found by chance after about 42 hours.

## 4. Lessons and follow-up

| Lesson | Confidence | Follow-up | Owner |
|---|---|---|---|
| L-1 A rule without a check is not a control. Real data reached a fixture despite STD-MSK-01 | High | SIM-CHG-001 (CI check), SIM-CAPA-003 (onboarding file route) | EMP-013, EMP-006 |
| L-2 Clock commitments need the contact to exist before the incident | High | SIM-CAPA-004 | EMP-010 |
| L-3 Two deadlines for one duty cause hesitation | High | SIM-CAPA-004 | EMP-002 |
| L-4 Staff outside the response team need one rule: do not delete, tell the IC | High | Briefing by 2026-09-11 (SIM-INC-001 A-05) | EMP-005 |
| L-5 Public repositories keep pull-request refs after branch deletion | Medium (depends on host behaviour, to verify) | Add to the secure development policy as a known risk. Proposal for management review | EMP-003 |
| L-6 The first exercise should have been RISK-001, as POL-IR-01 section 11 says | Medium | Next tabletop to use RISK-001. Proposal for management review | EMP-002 |
| L-7 The 4-hourly update rule needs a rota or a lower frequency outside office hours | Medium | Proposal for management review (resources) | EMP-001 |

No-change decision: the SEV 2 classification was right. No change to the severity table.

## 5. Sharing

Summary to all engineering staff by EMP-005 on 2026-09-11 with the L-4 briefing. Proof of who attended belongs to the people area (other author), not here.

## Findings

1. **The review step has no template.** POL-IR-01 section 9 lists the content; the lessons log gives columns. Neither is a review agenda. This record built one from both.
2. **"Actions enter the risk treatment plan".** POL-IR-01 section 9 says so, but the corrective action procedure says nonconformities go to the NC/CA log. Lessons L-1 to L-4 went to corrective actions; the plan's instruction would have put them in the wrong register. Pick one.
3. **No rule on who attends.** The lessons log says "actual participants from the affected functions". The person whose action caused the incident (EMP-007) attended here; the plan does not say whether that is expected. Say so, to keep the review blameless and complete.
4. **No date for effectiveness of a lesson.** The log has an "Adoption and effectiveness evidence" column but no rule for when to check it.

## What this does not show

- No review was held. No incident occurred.
- The plan and the log are used as their text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
- The real [lessons learned log](../../../ISMS/11-improvement/lessons-learned-log.md) is still empty. That is correct.
