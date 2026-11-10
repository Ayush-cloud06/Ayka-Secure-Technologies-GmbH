# SIM-ACC-001 Q2 2026 access review

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-ACC-001 |
| Authored | 2026-11-10 |
| Scenario date | 2026-06-22 (closeout). Export cutoff 2026-06-15 09:00 CEST |
| Participants | EMP-005 (runs the review), EMP-020 (second collector), EMP-002 (CISO: Tier 0 rows, closeout), EMP-001 (reviewer of the CISO's own access); function owners attesting: EMP-003, EMP-004, EMP-009, EMP-012, EMP-013, EMP-014, EMP-016, EMP-006; EMP-011 (Entra export), EMP-003 (Identity Center and GitHub exports) |
| Procedure exercised | [Access review procedure ISMS-OPS-02](../../../ISMS/06-operational-procedures/access-review-procedure.md); [user access procedure ISMS-OPS-01](../../../ISMS/06-operational-procedures/user-access-procedure.md) section 3 step 5; [POL-AC-01](../../../policies/access-control-policy.md) sections 4.4 to 4.6 and 6 |
| Controls | ISO/IEC 27001:2022 Annex A A.5.15, A.5.16, A.5.18, A.8.2; clause 9.1; SOC 2 AC-06, AC-07, AC-09 |

## 1. Review frame

| Field | Value |
|---|---|
| Review ID | SIM-ACC-001 |
| Period | 2026-03-02 (ISMS approval) to 2026-06-15 |
| Collectors | EMP-011 for Entra ID; EMP-003 for IAM Identity Center and GitHub. Read-only exports kept outside the repository |
| HR roster | 23 active staff at cutoff. Leaver in period: EMP-023, last day 2026-05-29 ([SIM-PPL-004](../people/SIM-PPL-004-leaver-emp-023.md)). Mover in period: EMP-019, Engineering to Security Operations on 2026-06-01 ([SIM-PPL-005](../people/SIM-PPL-005-mover-emp-019.md)) |
| Access source | Joiner grants as in [SIM-PPL-001](../people/SIM-PPL-001-joiner-batch.md) |
| Attestation deadline | 2026-06-19 |

## 2. Population

| Population | Rows | Source | Note |
|---|---:|---|---|
| Entra ID accounts | 30 | Tenant user export | 23 enabled staff, 1 disabled (EMP-023), 4 admin accounts (EMP-002, EMP-003, EMP-013, EMP-014), 2 emergency access accounts |
| Entra ID group memberships | 73 | Group export | 23 active staff x 3 groups (department, security role, tier), plus 4 admin accounts in `grp-tier-tier0` |
| IAM Identity Center tier memberships | 25 | Identity Center export | Tier0: 2. Tier1: 6. Tier2: 17. No workload account is deployed; these are workforce sign-in memberships only |
| GitHub organization seats | 14 | Organization member export | EMP-023's seat no longer present (removed 2026-06-10) |
| GitHub approval-environment reviewers | 2 | Both environments | One reviewer row each for `manual-apply-approval` and `medium-risk-approval`; both are the owner-role account held by EMP-002 |
| **Total reviewed** | **144** | | |
| Leavers and movers in period (separate check) | 2 events | HR record against audit-log dates | See section 4 |
| SaaS tools with their own logins | 0 | — | Not in the procedure's population table. Not exported. Recorded as a limitation |

EMP-005 reconciled every export to the HR roster on 2026-06-15. Row counts and SHA-256 of each export are in the restricted review folder.

## 3. Decisions

| Decision | Rows | Who decided |
|---|---:|---|
| Retain | 141 | Line managers; EMP-002 for Tier 0 rows; EMP-001 for EMP-002's own rows |
| Retain under exception | 1 | EMP-019 Identity Center Tier2 (Tier2-Workload, WorkloadOperatorRole); exception by EMP-002, ends 2026-11-30 (section 4, E-2) |
| Investigate | 2 | Both emergency access accounts: no custody record exists (RISK-013). Still open at closeout |
| Remove | 0 | — |

Nonresponse: EMP-009 had not attested for EMP-010 and EMP-022 by 2026-06-19. Reminder sent; attested 2026-06-22. Nonresponse is unconfirmed access, not approval; it was resolved inside five business days.

Self-review check: nobody decided their own rows. EMP-005's rows were decided by EMP-002. EMP-002's rows (including the owner-role GitHub account and both environment-reviewer rows) by EMP-001. EMP-001's rows by EMP-002, who reports to EMP-001: a recorded independence limit.

## 4. Exceptions found

**E-1 Leaver kept a GitHub seat (EMP-023).**

- Last working day 2026-05-29. POL-AC-01 section 4.4: disabled by the end of that day, removed within one business day (2026-06-01).
- Entra ID was disabled and Identity Center membership removed on time (SIM-PPL-004).
- The GitHub organization seat (team `docs-contributors`) was removed by EMP-003 on **2026-06-10**, 12 days after the disable deadline. SIM-PPL-004 counts 7 business days after the removal deadline; the count is 6 if the Baden-Württemberg holiday on 2026-06-04 is excluded.
- The review found it by comparing the HR last day with the removal date in the GitHub audit log. The CISO had not been told before 2026-06-22.
- Account use between 2026-05-29 and 2026-06-10: not checked by the leaver process. EMP-005 checked the audit log at review: no activity (scenario value).
- Raised as nonconformity **SIM-CAPA-001**.

**E-2 Mover kept an engineering permission set (EMP-019).**

- Moved to Security Operations on 2026-06-01. Entra department group and GitHub team were swapped on 2026-06-01 (SIM-PPL-005).
- Identity Center Tier2 stayed. In Tier2 he keeps the Tier2-Workload permission set with WorkloadOperatorRole, the engineering operator role for the workload account. A SOC analyst can therefore operate what he is meant to monitor.
- EMP-002 approved an exception on 2026-05-19, ending 2026-11-30, with "listed in the quarterly access review" as the compensating control.
- The exception was **not passed to Security Operations** and was **not on any exception list** given to the review. EMP-005 found it only by reconciling the mover against the tier export. POL-AC-01 section 6 also requires exceptions to be listed in the quarterly report to the Managing Director; no such report exists.
- Decision by EMP-005 with EMP-002: retain under the exception to 2026-11-30; add it to the review's exception list; report it to EMP-001 now.
- Raised as nonconformity **SIM-CAPA-002**: the exception's compensating control was not in place when it was needed.

## 5. Verification and closeout

- 2026-06-22: exception list created and E-2 entered. EMP-001 informed by EMP-002 the same day.
- 2026-06-22: EMP-002 closeout as scenario decision. Review **stays open** for the two emergency-account rows. Findings reported to metrics (SIM-MON-002, M-04) and to management review.

## Findings

1. **The review cannot find SaaS seats.** Section 2 covers Entra, AWS and GitHub only. Tools with their own logins are not listed. Add "SaaS tools with local accounts, from the asset register".
2. **No leaver/mover reconciliation step.** The procedure reviews current access. A leaver whose access was removed late before the cutoff does not appear in any export. E-1 was found only because EMP-005 added a check of removal dates. Add "for every leaver and mover in the period, compare HR date with removal date".
3. **Exceptions do not reach the reviewer.** Section 2 lists "expired exceptions" as a population but says nothing about where open exceptions are kept or who hands them over. Name an exception register owned by Security Operations.
4. **"CISO signs the review summary".** Section 3 step 5 says "signs". Records use dated decisions, not signatures. Reword to "records a dated closeout decision".
5. **No rule for the Managing Director's own access.** Step 1 covers the CISO's access, not the MD's. Here the CISO, who reports to the MD, reviewed it.
6. **Two removal deadlines.** POL-AC-01 says one business day for leavers; this procedure only cites "five business days" for unconfirmed access. A reader of this procedure alone would think 5 days is fine for a leaver.
7. **Business days are not defined.** SIM-PPL-004 and this record count the same delay differently because nothing says whether regional public holidays count.

## What this does not show

- No export was taken and no account exists. Counts and times are scenario values.
- The procedures are used as their text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
- The real [personnel register](../../../../organization/personnel-register.md) still lists EMP-019 as Junior DevOps and EMP-023 as current staff. The move and the departure exist only in the simulated store.
- This is not a runtime recertification. No AWS workload account exists.
