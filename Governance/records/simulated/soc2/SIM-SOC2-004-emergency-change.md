# SIM-SOC2-004: Emergency change during incident INC-2026-001

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-SOC2-004 |
| Authored | 2026-11-10 (real date) |
| Scenario date | 2026-08-12 (change) to 2026-08-25 (retrospective review). Review due 2026-08-14 |
| Participants | EMP-002 (Incident Commander and CISO, approves by phone), EMP-013 (DevOps Engineer, author and merger), EMP-014 (Security Engineer, retrospective reviewer), EMP-005 (Incident Coordinator, records the incident), EMP-004 (Compliance Analyst, quarterly compare) |
| Procedure exercised | [Change management policy POL-CHG-01](../../../policies/change-management-policy.md) section 6 (emergency changes) and section 9; [SOC2-08](../../../SOC2/08-control-designs.md#3-compensating-monthly-change-review-cm-05-g3) section 3.3 step 6 |
| Controls | SOC 2 CM-06 (CC8.1); ISO/IEC 27001:2022 A.8.32; related CM-05, OP-06 |

## Scenario

During [SIM-INC-001](../incident/SIM-INC-001-inc-2026-001-customer-export-in-public-ci.md) the IC wants the CI to stop printing assertion values while the fixture check ([SIM-CHG-001](../improvement/SIM-CHG-001-ci-check-for-personal-data-in-fixtures.md)) is built. The cause of the leak was a failing test that printed six rows of a customer file into a public log. Any new fixture mistake before 2026-08-27 would do it again. All dates and times (UTC) are scenario values.

## 1. Walk through section 6 of the policy

| Step | Policy text | What happened | Result |
|---|---|---|---|
| 1 Declare | The Incident Commander declares the emergency in the incident record | EMP-002 says "emergency change" to EMP-013 in the incident call at about 17:30 on 2026-08-12. Nothing is written in the incident record at the time. The record's timeline for the day has no entry for the change | **Not met** |
| 2 Pull request, all scans | The change goes through a pull request and all scans run. Only the second-reviewer wait may be skipped. The CISO or Managing Director may approve by phone, noted in the pull request | EMP-013 opens PR-SIM-02 at 18:10: in the `unit-tests` job of `.github/workflows/test.yml` pytest runs with `--tb=no`, so failing tests print no values. The five required checks run and are green at 18:50. EMP-002 approves by phone at 18:40. EMP-013 writes "approved by phone, EMP-002, 18:40" in the pull request description at 18:42 | Met in form |
| 3 HIGH finding | A HIGH finding still blocks | The change touches no Terraform; the gate decision is unchanged | n/a |
| 4 Merge | Author does not approve | EMP-013 merges at 18:55. Author and merger are the same person. The ruleset requires 0 approving reviews and does not require CODEOWNERS review of `.github/`, so GitHub allowed it | Allowed by settings, not by the policy's intent |
| 5 Retrospective | Within 2 business days a reviewer other than the author reviews the merged change; the review is linked from the incident record | Due by end of 2026-08-14 (Friday). EMP-005 does not know of the change. No one is assigned. EMP-014 reviews it on **2026-08-25**, during the lessons-learned meeting ([SIM-IMP-001](../improvement/SIM-IMP-001-lessons-learned-inc-2026-001.md)), when the change appears on EMP-013's list. **7 business days late** | **Not met** |

## 2. The retrospective review (2026-08-25, EMP-014)

| Check | Result |
|---|---|
| Diff matches what the pull request says | Yes: one line in one job |
| All required checks green at the merge commit | Yes (run history) |
| Side effects | `--tb=no` applies to every test in the job, including the policy regression tests. A failing regression now shows its name only. Debugging a red build needs a local re-run |
| Phone approval verifiable | No. The only record is the author's own sentence in the pull request. EMP-002 confirms it from memory |
| Reverted or expired | Not reverted. Nothing in the pull request or the policy sets an end date. Scenario decision by EMP-002: keep until SIM-CHG-001 merges (2026-08-27), then revert. EMP-013 reverts on 2026-09-02, six days after |
| Link from the incident record | None. The incident was closed on 2026-09-15 without a link |

Result recorded by EMP-014: the change was proportionate and did not weaken any gate rule; the control was not followed in steps 1 and 5.

## 3. Detection by the quarterly compare

Policy section 9 has Compliance and Risk compare merged pull requests against approvals each quarter to confirm every emergency change has a retrospective review. EMP-004's Q3 compare is made after 2026-09-30. It starts from a list of emergency changes. No such list exists (the matrix names an "emergency change log"; there is no template, no location and no owner). The only source is the incident record, which does not mention the change. The compare would not have found it. The review of 2026-08-25 happened only because someone remembered.

## Findings

Defects in the CM-06 design (POL-CHG-01 section 6, matrix row, SOC2-08 section 3.3 step 6):

1. **No emergency change log exists.** The matrix names it as evidence; no document defines its fields, location or owner. Without it neither the quarterly compare (section 9) nor the monthly review (step 6) has a population.
2. **Declaration in the incident record is easy to skip** and the incident record template (POL-IR-01 section 10) has no field for it. Here it was missing and the later compare could not rely on it.
3. **No owner for the 2-business-day clock.** The policy says "a reviewer other than the author reviews" but names no person who assigns the reviewer or watches the date. The incident team did not know of the change.
4. **Phone approval cannot be checked.** The policy allows it and asks for a note, but the note is written by the author. Require the approver to confirm in writing (a comment, a chat message kept as evidence) within the same day.
5. **Author can merge.** Section 6 says only the wait for a second reviewer may be skipped. The ruleset enforces nothing about who merges. Whether author and merger being the same person is allowed in an emergency is not stated.
6. **No expiry for the emergency change itself.** Section 6.3 limits a HIGH exception to 7 days, but a temporary change such as this one has no end date or revert owner.
7. **Is a CI workflow change "elevated"?** `test.yml` defines a required check. The policy's elevated class names "the gate itself"; SIM-CHG-001 finding 2 already notes that workflows are classed Standard. The emergency path did not resolve it.
8. **The incident record SIM-INC-001 has no entry for this change** and none of its six actions mention it. The retrospective review could not be linked from it. That record belongs to another author; the gap is noted here and not fixed here.

## What this does not show

- That a pull request, a workflow change, a phone call or a review exists. The repository has no PR-SIM-02.
- That `--tb=no` would stop a leak of values (pytest can still print values through other output). This is not tested.
- That the monthly or quarterly review ever ran in the scenario. The real monthly review [REAL-SOC2-001](../../real/soc2/REAL-SOC2-001-change-review-2026-10.md) was performed by the repository owner for October 2026 and had no emergency change to examine.
- A tabletop is not an instance for a SOC 2 test. CM-06 would still fail a Type I (SOC2-06).
