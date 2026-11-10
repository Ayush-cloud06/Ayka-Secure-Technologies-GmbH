# SIM-PPL-004: Leaver: EMP-023 (HR Assistant), last day 2026-05-29

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-PPL-004 |
| Authored | 2026-11-10 (real date) |
| Scenario date | 2026-04-28 to 2026-06-22 |
| Participants | EMP-023 (leaver), EMP-012 (line manager, HR), EMP-002 (CISO), EMP-003 and EMP-013 (Cloud Platform), EMP-011 (asset custodian), EMP-020 (Security Operations verifier), EMP-004 (record transfer), EMP-001 |
| Procedure exercised | [Onboarding and offboarding procedure](../../../ISMS/01-organization/onboarding-and-offboarding-procedure.md) section 3; [Access control policy](../../../policies/access-control-policy.md) section 4.4; [User access procedure](../../../ISMS/06-operational-procedures/user-access-procedure.md) section 3, step 5 |
| Controls | ISO 27001:2022 A.6.5, A.5.11, A.5.18, A.5.10, A.8.2, A.7.10; SOC 2 AC-06, AC-18, CO-03; GDPR Art. 5(1)(e), Art. 32 |

## Scenario summary

EMP-023 resigned voluntarily. The last working day is Friday 2026-05-29. The rule is: all access disabled by the end of the last working day and removed within one business day (Monday 2026-06-01).

**What went wrong.** The Entra account was disabled on time. The Identity Center membership was removed on time. One GitHub organisation seat (team `docs-contributors`) was removed on 2026-06-10, 12 days after the disable deadline and 7 business days after the removal deadline. The checklist had no named owner for GitHub. EMP-013 closed the Entra and AWS work and treated GitHub as EMP-003's. EMP-003 was away from 2026-05-29 to 2026-06-09 (scenario). Nobody was assigned in his place. The gap was found when EMP-003 went through open tickets on his return. The Q2 access review (SIM-ACC-001, 2026-06-22) later flagged the late removal from the audit-log date. This record says what happened on the leaver path. The review's own findings are in SIM-ACC-001.

## Timeline

| Date (time) | Event | By |
|---|---|---|
| 2026-04-28 | Resignation received. Last day set to 2026-05-29. Notice recorded in the restricted HR record (voluntary leaver) | EMP-012 |
| 2026-05-26 | HR notifies the CISO and Cloud Platform Engineering of the effective departure time (2026-05-29, 17:00) over the restricted channel. Ticket LVR-2026-001 opened (scenario) | EMP-012 |
| 2026-05-29 (09:30) | Information handover: recruitment files and the open vacancy list moved to EMP-012. Personal copies on the laptop reviewed with EMP-012 and removed | EMP-023, EMP-012 |
| 2026-05-29 (16:40) | Laptop, power supply and paper personnel files returned to EMP-011. Returned items listed in the table below | EMP-023, EMP-011 |
| 2026-05-29 (17:15) | Entra account disabled. Sessions revoked. Sign-in disabled confirmed by a test sign-in refusal | EMP-013 |
| 2026-05-29 (17:30) | Confidentiality reminder given. Continuing obligation from the NDA (NDA-2026-023) explained. E-mail acknowledgement received (scenario text) | EMP-012 |
| 2026-06-01 | Terraform pull request removes emp-023 from the static Tier2 list in `memberships.tf`. Merged after the required checks. Identity Center membership gone. Ticket moved to "AWS and Entra done" | EMP-013 (author), EMP-003 not available, merged under the repository rules |
| 2026-06-02 | Laptop wiped by factory reset. Device marked reassignable | EMP-011 |
| 2026-06-03 | Security Operations check: Entra disabled, no Tier2 membership, no enabled Identity Center user. GitHub not checked | EMP-020 |
| 2026-06-10 | GitHub seat removed. Audit-log entry shows the removal on this date. Ticket closed | EMP-003 |
| 2026-06-22 | Q2 access review SIM-ACC-001 compares HR last day with GitHub removal date. Late removal raised in that record | Security Operations (as recorded in SIM-ACC-001) |

## Offboarding checklist

| Checklist item (procedure section 3) | Responsible | Due | Done | Verified |
|---|---|---|---|---|
| Entra sign-in disabled, sessions revoked | Cloud Platform (EMP-013) | 2026-05-29 | 2026-05-29 | Yes, 2026-06-03 by EMP-020 |
| Identity Center roles, groups and assignments removed | Cloud Platform (EMP-013) | 2026-06-01 | 2026-06-01 | Yes, 2026-06-03 by EMP-020 |
| GitHub collaborator, team and environment access removed | Cloud Platform (no named person) | 2026-05-29 (disable), 2026-06-01 (removal) | **2026-06-10, late** | Not before 2026-06-22 |
| Tokens, keys and integrations held by the person revoked | Cloud Platform | 2026-06-01 | 2026-06-10: none found in the org token list; personal tokens cannot be listed | Partly |
| Shared secrets the person could reach rotated | Cloud Platform | 2026-06-01 | Not required: EMP-023 had no secret access (recorded by EMP-003) | Yes |
| Business records transferred | EMP-012 with EMP-004 | 2026-05-29 | 2026-05-29 | Yes, EMP-012 |
| Mailbox handled | EMP-012 | 2026-05-29 | Forwarded to EMP-012 for 30 days (scenario decision by EMP-012) | No |
| Device returned (laptop LT-023, scenario tag), power supply | EMP-011 | 2026-05-29 | 2026-05-29, condition good, custodian EMP-011 | Yes |
| Security key, badge, removable media | EMP-011 | 2026-05-29 | None issued | Yes, by EMP-011 |
| Device wipe recorded | Cloud Platform / EMP-011 | After return | 2026-06-02, reset done, no certificate issued | No |
| Confidentiality reminder, return and deletion request | EMP-012 | 2026-05-29 | 2026-05-29 | Yes |
| Independent removal verification | Security Operations | Not stated in the procedure | 2026-06-03, Entra and AWS only | Scope gap |
| CISO told of missed deadline | Cloud Platform to CISO | Immediately | Not done on 2026-06-10. EMP-002 learned on 2026-06-22 | No |

Asset return list: laptop LT-023, power supply, paper personnel files (HR cabinet). Asset IDs are scenario tags. The [asset ownership register](../../../ISMS/02-asset-management/asset-ownership-register.md) has no row for individual laptops.

## Findings

1. **The checklist has roles for systems but no person.** Section 3 of the onboarding procedure says "Cloud Platform Engineering" for Entra, GitHub and tokens. With two engineers and one on leave, the GitHub row had no owner. Each row needs a named person and a named deputy.
2. **No due or actual timestamp per system.** The lifecycle record (procedure section 4) lists "access events" without a planned time and an actual time for each. A late row looks the same as an on-time row. Nobody could see the lateness without comparing audit logs.
3. **No rule that reports a miss.** The procedure says the CISO "receives missed deadlines immediately", but nothing measures a deadline or says who sends it. The CISO heard on 2026-06-22.
4. **GitHub is not driven by the personnel source.** Entra and Identity Center are changed by one Terraform pull request. GitHub is separate and manual. The user access procedure says GitHub is not proven by an Entra diff but gives no source list for it.
5. **Static membership list.** `memberships.tf` lists users by name. Removing a leaver needs a pull request with five checks. Disabling Entra on the last day works, but the one-business-day removal depends on a code merge. On 2026-06-01 EMP-003 was away. The merge went ahead under the repository rules; the ruleset does not require an approving review, so one person could author and merge.
6. **The independent check has no scope or deadline.** "Security Operations independently verifies removal completion" does not list the systems to check or give a date. EMP-020 checked what he knew was in the Terraform list.
7. **No way to list personal access tokens.** The procedure asks to revoke tokens the person holds. The organisation token list does not show personal tokens used by integrations.
8. **Device wipe has no certificate format.** SOC 2 AC-18 expects a recorded certificate. The procedure says "authorized wipe/reset record and verification". Nobody had a template.
9. **Mailbox rule is missing.** The [retention policy](../../../policies/records-and-data-retention-policy.md) has no period for a departed person's mailbox. The 30 days was a scenario decision.
10. **No window-activity check.** Nothing says to check whether the account was used between the deadline and the removal. A late removal should trigger it.
11. **Access policy says "removed within 1 business day" and "disabled by end of the last working day" for the same event.** The two clocks produced a different lateness figure (12 days or 7 business days) depending on which was read. Pick one.

## What this does not show

- That the GitHub seat was used after 2026-05-29. The activity check was not part of the checklist and is not recorded here.
- Any real device, wipe tool, GitHub audit log or Entra sign-in log. Times are scenario values.
- An involuntary or urgent leaver. That path of the procedure is not exercised.
- The cost of the delay or any incident. None is recorded.
- A signature or written statement by the leaver.
