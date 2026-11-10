# REAL-SOC2-001: Retrospective review of merged changes, October 2026

> **REAL RECORD.** Performed on the date shown. Scope and limits are stated below.

| Field | Value |
|---|---|
| Record ID | REAL-SOC2-001 |
| Performed | 2026-11-10 |
| Performed by | Repository owner, AI-assisted tool run (`git` and `gh` queries, tabulated by script) |
| Period reviewed | 2026-10-01 to 2026-10-31 |
| Controls | CM-05 (compensating detective review, G3), CM-01, CM-02, AC-09 |
| Design | [SOC2-08, section 3](../../../SOC2/08-control-designs.md#3-compensating-monthly-change-review-cm-05-g3) |
| Reviewer is author | Yes. See [Limits](#limits) |

## 1. What was done

The monthly review procedure of SOC2-08 section 3 was run for the first time, for October 2026: every change that reached `main` in the month was listed from `git log`, matched to its pull request on GitHub, and tested for four things: it came through a pull request, the five required checks passed at the head of that pull request, the ruleset enforced them at merge, and anyone other than the author approved it. Changes that touch the gate or the pipeline are flagged for a diff read.

Population basis: commits reachable from `origin/main` whose committer date falls from 2026-10-01 to 2026-10-31 in the commit's own time zone (+05:30). `origin/main` is used because the local `main` branch is stale (it ends at `500a263`, 2026-10-06; `origin/main` ends at `3e6b06f`, 2026-10-14). Dates in the tables are those local dates. GitHub times in section 2 are UTC.

Reproduce:

```
git log origin/main --since=2026-10-01T00:00:00+05:30 --until=2026-11-01T00:00:00+05:30 --format='%h|%cd|%s' --date=format:%Y-%m-%d
gh pr view <n> --json mergedAt,mergedBy,author,reviews,statusCheckRollup,mergeCommit
gh run list --workflow test.yml --branch main --event push --limit 40
gh api repos/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/rulesets/24482491
```

## 2. Result in numbers

| Measure | Value |
|---|---:|
| Commits on `origin/main` in October | 53 |
| of which merge commits (one per pull request) | 16 |
| of which commits inside a merged pull request | 37 |
| Commits that reached `main` without a pull request | 0 (every commit is reachable from a merge commit's second parent) |
| Pull requests merged to `main` per GitHub | 17 (#7, #8, #25 to #39) |
| Pull requests reconciled to a merge commit in the clone | 16 (all but #7) |
| Pull requests with the five required checks successful at head | 17 of 17 |
| Pull requests where the ruleset enforced those checks at merge | 15 of 17 (#7 and #8 merged before the ruleset existed) |
| Pull requests with an approving review by anyone | 0 of 17 |
| Pull requests where author and merger are the same account | 17 of 17 |
| Push-to-`main` workflow runs ending green | 5 of 20 (all up to 2026-10-05 04:06 UTC); 14 failed at the `apply` job; 1 is still waiting |

## 3. Pull requests

Check status is read from the head commit of each pull request (`statusCheckRollup`). Commits inside a pull request have no check run of their own; they inherit the pull request's result. Ruleset `protect-main` was created 2026-10-05T04:24:02Z (09:54 +05:30). "Other reviews" counts reviews by `chatgpt-codex-connector` with state COMMENTED, which is not an approval.

| PR | Merge commit | Merged (UTC) | Author / merger | Approvals | Other reviews | 5 required checks at head | Enforced at merge | Push run on `main` | Files in merge | Gate or pipeline files |
|---|---|---|---|---:|---:|---|---|---|---:|---:|
| #7 | `7ff1e16` (not in clone) | 2026-10-05 03:36 | Ayush-cloud06 / Ayush-cloud06 | 0 | 0 | 5 of 5 success | no (before ruleset) | 37260097825 success | n/a | n/a |
| #8 | `0cabd74` | 2026-10-05 04:06 | Ayush-cloud06 / Ayush-cloud06 | 0 | 0 | 5 of 5 success | no (before ruleset) | 37262086972 success | 7 | 0 |
| #25 | `62e578f` | 2026-10-05 04:33 | Ayush-cloud06 / Ayush-cloud06 | 0 | 0 | 5 of 5 success | yes | 37264036408 failure | 13 | 10 |
| #26 | `5b9a6cf` | 2026-10-05 04:36 | Ayush-cloud06 / Ayush-cloud06 | 0 | 1 | 5 of 5 success | yes | 37264235258 failure | 6 | 4 |
| #27 | `3e4b6bb` | 2026-10-05 04:38 | Ayush-cloud06 / Ayush-cloud06 | 0 | 1 | 5 of 5 success | yes | 37264416085 failure | 2 | 1 |
| #28 | `0ff3441` | 2026-10-05 04:38 | Ayush-cloud06 / Ayush-cloud06 | 0 | 0 | 5 of 5 success | yes | 37264423672 failure | 3 | 2 |
| #29 | `9f2bf92` | 2026-10-05 04:41 | Ayush-cloud06 / Ayush-cloud06 | 0 | 1 | 5 of 5 success | yes | 37264633484 failure | 9 | 7 |
| #30 | `e12b1de` | 2026-10-05 04:47 | Ayush-cloud06 / Ayush-cloud06 | 0 | 1 | 5 of 5 success | yes | 37265025165 failure | 4 | 2 |
| #31 | `5286026` | 2026-10-05 04:47 | Ayush-cloud06 / Ayush-cloud06 | 0 | 0 | 5 of 5 success | yes | 37265010745 failure | 8 | 1 |
| #32 | `26d08f1` | 2026-10-05 04:50 | Ayush-cloud06 / Ayush-cloud06 | 0 | 1 | 5 of 5 success | yes | 37265256207 failure | 8 | 1 |
| #33 | `0a4ff8a` | 2026-10-05 04:56 | Ayush-cloud06 / Ayush-cloud06 | 0 | 1 | 5 of 5 success | yes | 37265644060 failure | 3 | 0 |
| #34 | `2d25412` | 2026-10-05 04:59 | Ayush-cloud06 / Ayush-cloud06 | 0 | 1 | 5 of 5 success | yes | 37265819819 failure | 7 | 4 |
| #35 | `cc41927` | 2026-10-05 05:02 | Ayush-cloud06 / Ayush-cloud06 | 0 | 0 | 5 of 5 success | yes | 37266017890 failure | 2 | 0 |
| #36 | `f297d2d` | 2026-10-06 04:42 | Ayush-cloud06 / Ayush-cloud06 | 0 | 1 | 5 of 5 success | yes | 37414960072 failure | 6 | 0 |
| #37 | `61e4499` | 2026-10-06 04:44 | Ayush-cloud06 / Ayush-cloud06 | 0 | 1 | 5 of 5 success | yes | 37415104033 failure | 13 | 0 |
| #38 | `500a263` | 2026-10-06 16:43 | Ayush-cloud06 / Ayush-cloud06 | 0 | 1 | 5 of 5 success | yes | 37498007502 failure | 1 | 0 |
| #39 | `3e6b06f` | 2026-10-14 11:50 | Ayush-cloud06 / Ayush-cloud06 | 0 | 0 | 5 of 5 success | yes | 38559367091 waiting | 71 | 1 |

## 4. All commits

`PR` is the pull request through which the commit reached `main`. `Files` is the number of files the commit changes against its first parent (for a merge commit: the whole pull request). The last column repeats the pull request's check result.

| Commit | Date | Type | PR | Subject | Files | Required checks (via PR) |
|---|---|---|---|---|---:|---|
| `3e6b06f` | 2026-10-14 | merge | #39 | Complete ISMS documentation and evidence baseline | 71 | 5 of 5 success; enforced |
| `96d2f13` | 2026-10-14 | commit | #39 | docs(isms): complete evidence-linked governance baseline | 63 | 5 of 5 success; enforced |
| `8b83257` | 2026-10-14 | commit | #39 | docs(governance): move company policies to Governance/policies | 18 | 5 of 5 success; enforced |
| `500a263` | 2026-10-06 | merge | #38 | Merge pull request #38 from Ayush-cloud06/claude/project-thread-osbvpl | 1 | 5 of 5 success; enforced |
| `1e6706b` | 2026-10-06 | commit | #38 | docs(42001): note main ruleset now requires status checks | 1 | 5 of 5 success; enforced |
| `537fc64` | 2026-10-06 | commit | #38 | docs(42001): add AIMS working paper scratch notes | 1 | 5 of 5 success; enforced |
| `61e4499` | 2026-10-06 | merge | #37 | Merge pull request #37 from Ayush-cloud06/docs/soc2 | 13 | 5 of 5 success; enforced |
| `2bc2d59` | 2026-10-06 | commit | #37 | docs(soc2): scope gate claims, fix log retention gap, tighten Type I exit and GitHub outage path | 5 | 5 of 5 success; enforced |
| `f297d2d` | 2026-10-06 | merge | #36 | Merge pull request #36 from Ayush-cloud06/nis2/governance-docs | 6 | 5 of 5 success; enforced |
| `561b2d7` | 2026-10-06 | commit | #36 | docs(nis2): apply the two-year size rule and the prospective incident thresholds | 4 | 5 of 5 success; enforced |
| `85cd122` | 2026-10-06 | commit | #37 | docs(soc2): system description, TSC mapping, control matrix, readiness and policies | 13 | 5 of 5 success; enforced |
| `bd40606` | 2026-10-06 | commit | #36 | docs(nis2): applicability assessment, measures, reporting, management and supply chain | 6 | 5 of 5 success; enforced |
| `cc41927` | 2026-10-05 | merge | #35 | Merge pull request #35 from Ayush-cloud06/audit/readme-positioning | 2 | 5 of 5 success; enforced |
| `7819b5c` | 2026-10-05 | commit | #35 | docs(readme): lead with the demonstrated result and state the plan-only scope | 2 | 5 of 5 success; enforced |
| `2d25412` | 2026-10-05 | merge | #34 | Merge pull request #34 from Ayush-cloud06/audit/toolchain-bootstrap | 7 | 5 of 5 success; enforced |
| `ad636fc` | 2026-10-05 | commit | #34 | feat(ci): one-command pinned toolchain and a version check before local runs | 7 | 5 of 5 success; enforced |
| `0a4ff8a` | 2026-10-05 | merge | #33 | Merge pull request #33 from Ayush-cloud06/audit/control-chain | 3 | 5 of 5 success; enforced |
| `3a8bf89` | 2026-10-05 | commit | #33 | docs(isms): trace S3 encryption end to end, risk to residual-risk decision | 3 | 5 of 5 success; enforced |
| `26d08f1` | 2026-10-05 | merge | #32 | Merge pull request #32 from Ayush-cloud06/audit/workload-deploy-fixes | 8 | 5 of 5 success; enforced |
| `e12b1de` | 2026-10-05 | merge | #30 | Merge pull request #30 from Ayush-cloud06/audit/coverage-dedupe | 4 | 5 of 5 success; enforced |
| `5286026` | 2026-10-05 | merge | #31 | Merge pull request #31 from Ayush-cloud06/audit/suppression-inventory | 8 | 5 of 5 success; enforced |
| `8cb22f9` | 2026-10-05 | commit | #32 | fix(ayka-portal): ALB log delivery, SNS topic policy and the KMS key account | 8 | 5 of 5 success; enforced |
| `69b58bd` | 2026-10-05 | commit | #30 | feat(evaluator): distinct findings across tools and an honest coverage metric | 4 | 5 of 5 success; enforced |
| `5b75e76` | 2026-10-05 | commit | #31 | docs(readme): scenarios table row says MEDIUM 34 | 1 | 5 of 5 success; enforced |
| `223115b` | 2026-10-05 | commit | #31 | docs(readme): ayka-portal totals after moving inline skips | 1 | 5 of 5 success; enforced |
| `9570a66` | 2026-10-05 | commit | #31 | fix(exceptions): one place to set a finding aside; inline skips were ignored | 8 | 5 of 5 success; enforced |
| `9f2bf92` | 2026-10-05 | merge | #29 | Merge pull request #29 from Ayush-cloud06/audit/evidence-manifest | 9 | 5 of 5 success; enforced |
| `0ff3441` | 2026-10-05 | merge | #28 | Merge pull request #28 from Ayush-cloud06/audit/iam-wildcard | 3 | 5 of 5 success; enforced |
| `3e4b6bb` | 2026-10-05 | merge | #27 | Merge pull request #27 from Ayush-cloud06/audit/severity-rationale | 2 | 5 of 5 success; enforced |
| `aa28ad2` | 2026-10-05 | commit | #29 | feat(evidence): run manifest and checksums over the whole evidence bundle | 9 | 5 of 5 success; enforced |
| `5b9a6cf` | 2026-10-05 | merge | #26 | Merge pull request #26 from Ayush-cloud06/audit/evaluator-fail-closed | 6 | 5 of 5 success; enforced |
| `dc12acd` | 2026-10-05 | commit | #28 | fix(opa): IAM wildcard rule handles Action lists, *:*, service wildcards and NotAction | 3 | 5 of 5 success; enforced |
| `8f22b74` | 2026-10-05 | commit | #27 | docs(controls): record a severity rationale for every control | 2 | 5 of 5 success; enforced |
| `462c904` | 2026-10-05 | commit | #26 | docs(readme): record branch ruleset and apply reviewer | 1 | 5 of 5 success; enforced |
| `7cabad1` | 2026-10-05 | commit | #26 | fix(ci): local runner propagates the decision and builds report and evidence | 4 | 5 of 5 success; enforced |
| `8449634` | 2026-10-05 | commit | #26 | fix(evaluator): fail closed when a scanner errored or scanned nothing | 3 | 5 of 5 success; enforced |
| `62e578f` | 2026-10-05 | merge | #25 | Merge pull request #25 from Ayush-cloud06/audit/policy-correctness | 13 | 5 of 5 success; enforced |
| `04b0dcd` | 2026-10-05 | commit | #25 | docs(readme): drop hard-coded test counts that go stale | 1 | 5 of 5 success; enforced |
| `b13d38b` | 2026-10-05 | commit | #25 | test(opa): cover root and nested reference binding and the IAM MFA rule | 3 | 5 of 5 success; enforced |
| `c070ee2` | 2026-10-05 | commit | #25 | docs(readme): scenarios now report MEDIUM 34 (new flow-log finding) | 1 | 5 of 5 success; enforced |
| `4f2a1de` | 2026-10-05 | commit | #25 | docs(readme): update Rego test count and OPA capability row | 1 | 5 of 5 success; enforced |
| `4777eb3` | 2026-10-05 | commit | #25 | fix(opa): security-group rules cover port ranges, all-protocol, IPv6 and rule resources | 3 | 5 of 5 success; enforced |
| `0a074ea` | 2026-10-05 | commit | #25 | fix(opa): bind related resources to their own parent via plan references | 7 | 5 of 5 success; enforced |
| `cddeada` | 2026-10-05 | commit | #25 | fix(opa): evaluate resources in every module, not just first-level children | 7 | 5 of 5 success; enforced |
| `3edb4f0` | 2026-10-05 | commit | #25 | chore(repo): ignore local planning docs | 1 | 5 of 5 success; enforced |
| `0cabd74` | 2026-10-05 | merge | #8 | Merge pull request #8 from Ayush-cloud06/governance | 7 | 5 of 5 success; not enforced |
| `52e41b1` | 2026-10-05 | commit | #8 | docs(gdpr): add GDPR index with controller/processor roles and Region target | 1 | 5 of 5 success; not enforced |
| `8c5f298` | 2026-10-05 | commit | #8 | docs(gdpr): add processor and sub-processor register | 1 | 5 of 5 success; not enforced |
| `7801a35` | 2026-10-05 | commit | #8 | docs(gdpr): add Record of Processing Activities | 1 | 5 of 5 success; not enforced |
| `22b1f75` | 2026-10-05 | commit | #8 | docs(gdpr): rewrite segregation of duties against what the repo enforces | 1 | 5 of 5 success; not enforced |
| `048bf89` | 2026-10-05 | commit | #8 | docs(gdpr): note Entra licence limits on Conditional Access and PIM | 1 | 5 of 5 success; not enforced |
| `5032e42` | 2026-10-05 | commit | #8 | docs(gdpr): rewrite identity TOMs with evidence labels | 1 | 5 of 5 success; not enforced |
| `ff48fb3` | 2026-10-05 | commit | #8 | test(governance): check Governance/ links resolve and no stub docs | 2 | 5 of 5 success; not enforced |

## 5. Findings

| # | Finding | Effect on the control |
|---|---|---|
| F1 | No pull request in October had an approval. Author and merger are the same account in all 17. The only other reviews are COMMENTED reviews from `chatgpt-codex-connector`. | CM-05 is not met: the ruleset requires 0 approvals and the owner is the only maintainer. This review detects, it does not prevent |
| F2 | PR #7 (merged 2026-10-05 03:36 UTC, merge commit `7ff1e16`) cannot be reconciled with git. The commit is not in the clone and not reachable from `origin/main`. Push runs exist for `7ff1e16`, `1d0f3dd` and `faa6fec`, none of which is in the clone, and a later push run is for `9e1e6c7` (a 2026-09-28 commit). This looks like `main` was reset before the ruleset existed (inferred, not verified). | Population from git and population from GitHub differ by one change. The 41 commits of #7 cannot be listed from git |
| F3 | PR #7 and PR #8 merged at 03:36 and 04:06 UTC, before the ruleset was created at 04:24 UTC. Their checks passed, but nothing required them. | Two of 17 changes were not subject to CM-01 and CM-02 enforcement when they merged |
| F4 | 14 of the 20 push-to-`main` runs since 2026-10-01 ended `failure` and run 38559367091 (PR #39, 2026-10-14) is still `waiting`. In every one of them the five required jobs succeeded and only the `apply` job failed (`medium-risk-approval` skipped). The annotation on run 37498007502 reads "The deployment was rejected or didn't satisfy other protection rules"; the other 13 were not read. The five green runs are those up to 2026-10-05 04:06 UTC; the apply approval reviewer was configured the same day (inferred as the cause of the change, not verified). The README's cited run 37265256207 is one of the 14. | The `apply` job, which holds CM-04 (checksum verification before the simulated apply), completed only in those five early runs. Since then it has stopped at the environment, so CM-04 is not exercised on current runs. Cause of each rejection is not investigated here |
| F5 | Changes to the gate or the pipeline: PRs #25 (10), #26 (4), #27 (1), #28 (2), #29 (7), #30 (2), #31 (1), #32 (1), #34 (4), #39 (1) touch files under `.github/` or `Internal-IT/engineering/`. | Their diffs have not been read in this run. They are listed in section 6 for the owner |
| F6 | All 37 non-merge commits are inside a merged pull request. No direct push to `main` is visible in October. | Supports CM-01 for the commits that exist in the clone |

## 6. Follow-up for the owner

Open until the owner does them; nobody writes these on the owner's behalf.

1. Read the diffs of the gate and pipeline pull requests in F5, with `exceptions.yaml` and `control-mapping.yaml` changes first. Record the result as an addendum to this file.
2. Find out why the `apply` deployments are rejected (GitHub: repository, Actions, run, the `apply` job, deployment review history) and decide whether the failure is intended. A red push run on `main` is the first thing an auditor sees.
3. Decide whether PR #7 and the apparent reset of `main` on 2026-10-05 need an entry in the risk register or the improvement register.
4. When a second maintainer exists, set `required_approving_review_count` to 1 on `protect-main` and close the gap this review only detects.

## Limits

- **Reviewer equals author.** The repository owner wrote and merged every change and also ran this review. It cannot show segregation of duties. It shows only that the facts above can be listed from GitHub and git, and that an independent reviewer could repeat it.
- **Metadata only.** Hashes, dates, subjects, file counts, check results, approvals and merge accounts were tested. No diff was read. A change that passed every check can still be wrong.
- **Check results are those GitHub reports now.** They were not re-run. A check that was re-run and replaced would show only its latest result.
- **October only.** Changes after 2026-10-31 and the unmerged branch `sim/operating-baseline` are outside the population.
- **Not a test of a deployed system.** Nothing here concerns AWS. The pipeline plans and never applies.
