# SOC 2 Observation Period Log

| Field | Value |
|---|---|
| Document ID | SOC2-07 |
| Owner | Cloud Platform Engineering, for the CISO |
| Approver | CISO |
| Version | 1.2 |
| Observation start | 2026-11-10 |
| Next review | Monthly, at the monthly change review ([SOC2-08](08-control-designs.md#3-compensating-monthly-change-review-cm-05-g3)) |
| Status | Draft. Started 2026-11-10. Simulated entity: the period is practice, not a SOC 2 period |

> Ayka Secure Technologies GmbH is a simulated company and `ayka-portal` has never been deployed. This log is the evidence trail of the automated controls that really run in this repository's CI. The period is "Type II-style": it shows how an auditor's sample would be drawn. No auditor has defined a period, and nothing here is a report.

## 1. Controls observed

| Control | What runs | Why it can be observed now |
|---|---|---|
| CM-01 | Every change through a pull request to `main` | GitHub ruleset and pull request history |
| CM-02 | Five required checks before merge | `test.yml` and check results |
| CM-03 | HIGH fails, MEDIUM needs approval | Evaluator decision in each run |
| CM-04 | Apply job verifies evidence checksums | Apply job in each push run (see G14: it is not completing) |
| MO-01 | Regression job on every run | `regression` job and artifact |
| IC-01 | Evidence bundle with manifest and checksums | `compliance-evidence` artifact |

The other controls in the matrix are not in this log: they are manual, or they need a deployed system.

## 2. What is collected per run

| Item | Source | Where it lands | Control |
|---|---|---|---|
| Run ID, commit, event, conclusion, time | `gh run list --workflow test.yml --branch main --event push` | Entry in section 5 | CM-02 |
| Result of each job (the five required checks, `apply`, `medium-risk-approval`) | `gh run view <id> --json jobs` | Entry in section 5 | CM-02, CM-03, CM-04, MO-01 |
| Gate decision and counts (HIGH, MEDIUM, LOW, excepted) | `compliance-summary.json` in the `compliance-evidence` artifact | Entry in section 6 | CM-03 |
| Manifest: commit, run, tool versions, SHA-256 of mapping, exceptions, evaluator and Rego files | `manifest.json` in the artifact | Entry in section 6 | IC-01 |
| Checksum verification of the whole bundle | `sha256sum -c evidence/artifacts.sha256` after `gh run download <id> -n compliance-evidence` | Entry in section 6 | IC-01, CM-04 |
| Regression result and expected-controls list | `regression` job log; artifact `compliance-evidence-regression` | Entry in section 5 | MO-01 |
| Artifact creation and expiry time | `gh api repos/<owner>/<repo>/actions/runs/<id>/artifacts` | Entry in section 5 | IC-01 |
| Pull request, author, merger, approvals, checks at head | `gh pr view <n>` | Monthly change review record | CM-01, CM-02, CM-05 |
| Ruleset and environment settings | `gh api repos/<owner>/<repo>/rulesets/<id>` | Monthly change review record | CM-01 |

## 3. Retention and its limit

| Item | Limit | Consequence |
|---|---|---|
| GitHub Actions artifacts | 90 days from creation. The API shows `expires_at` for each | A sample from the start of a 6-month period would be gone before the report. Gap G7 |
| Run list, job results, pull requests, reviews | Kept by GitHub for the life of the repository (workflow run logs can expire sooner; the log of run 37498007502 was already unavailable on 2026-11-10) | Job results stay readable; step logs may not |
| This log and the real records | Kept in Git | Permanent, but they are summaries |
| Local `evidence/` and `output/` | Not committed (gitignored) and **overwritten by every local run** | Never cite them as durable evidence; copy what matters into this log with the time of observation |

Interim practice until the Object Lock archive exists (G7): at each monthly review, download the artifact of each push run of the month, run `sha256sum -c`, and record the digest of `artifacts.sha256` here. The digest in this log proves later that the bundle existed unchanged on that day. The bundle itself still expires after 90 days.

Artifact expiry already known: the runs of 2026-10-05 and 2026-10-06 expire on 2027-01-03 and 2027-01-04 and the run of 2026-10-14 expires on 2027-01-12.

## 4. Procedure for each collection

1. `git fetch` and note `origin/main`; list new merge commits since the last entry.
2. `gh run list --workflow test.yml --branch main --event push --limit 40 --json databaseId,headSha,conclusion,createdAt`.
3. For each new run, `gh run view <id> --json jobs` and `gh api .../actions/runs/<id>/artifacts`.
4. For one run per month, download `compliance-evidence`, run `sha256sum -c evidence/artifacts.sha256`, and compare `manifest.json` commit and run ID with the run.
5. Append the entries below. Never edit a past entry; correct it with a new entry that cites it.

## 5. Baseline: push runs on `main` before the period started

Collected 2026-11-10 from the GitHub API, for runs created from 2026-10-01. These runs belong to the baseline; the period starts on 2026-11-10. The five required checks are `validate-scripts`, `unit-tests`, `compliance / validate`, `compliance / compliance` and `Control Validation Regression`. `Apply` is the result of the `compliance / apply` job; `medium-risk-approval` was skipped in every run.

| Run | Commit | Created (UTC) | Pull request | Required checks | Apply | Artifacts | Artifacts expire |
|---|---|---|---|---|---|---|---|
| 37260097825 | `7ff1e16` | 2026-10-05 03:36 | #7 | 5 of 5 | success | 2 | 2027-01-03 |
| 37260460475 | `1d0f3dd` | 2026-10-05 03:41 | none | 5 of 5 | success | 2 | 2027-01-03 |
| 37260607696 | `faa6fec` | 2026-10-05 03:44 | none | 5 of 5 | success | 2 | 2027-01-03 |
| 37261607955 | `9e1e6c7` | 2026-10-05 03:59 | none | 5 of 5 | success | 2 | 2027-01-03 |
| 37262086972 | `0cabd74` | 2026-10-05 04:06 | #8 | 5 of 5 | success | 2 | 2027-01-03 |
| 37264036408 | `62e578f` | 2026-10-05 04:33 | #25 | 5 of 5 | failure | 2 | 2027-01-03 |
| 37264235258 | `5b9a6cf` | 2026-10-05 04:36 | #26 | 5 of 5 | failure | 2 | 2027-01-03 |
| 37264416085 | `3e4b6bb` | 2026-10-05 04:38 | #27 | 5 of 5 | failure | 2 | 2027-01-03 |
| 37264423672 | `0ff3441` | 2026-10-05 04:38 | #28 | 5 of 5 | failure | 2 | 2027-01-03 |
| 37264633484 | `9f2bf92` | 2026-10-05 04:41 | #29 | 5 of 5 | failure | 2 | 2027-01-03 |
| 37265010745 | `5286026` | 2026-10-05 04:47 | #31 | 5 of 5 | failure | 2 | 2027-01-03 |
| 37265025165 | `e12b1de` | 2026-10-05 04:47 | #30 | 5 of 5 | failure | 2 | 2027-01-03 |
| 37265256207 | `26d08f1` | 2026-10-05 04:50 | #32 | 5 of 5 | failure | 2 | 2027-01-03 |
| 37265644060 | `0a4ff8a` | 2026-10-05 04:56 | #33 | 5 of 5 | failure | 2 | 2027-01-03 |
| 37265819819 | `2d25412` | 2026-10-05 04:59 | #34 | 5 of 5 | failure | 2 | 2027-01-03 |
| 37266017890 | `cc41927` | 2026-10-05 05:02 | #35 | 5 of 5 | failure | 2 | 2027-01-03 |
| 37414960072 | `f297d2d` | 2026-10-06 04:42 | #36 | 5 of 5 | failure | 2 | 2027-01-04 |
| 37415104033 | `61e4499` | 2026-10-06 04:44 | #37 | 5 of 5 | failure | 2 | 2027-01-04 |
| 37498007502 | `500a263` | 2026-10-06 16:43 | #38 | 5 of 5 | failure | 2 | 2027-01-04 |
| 38559367091 | `3e6b06f` | 2026-10-14 11:50 | #39 | 5 of 5 | waiting | 2 | 2027-01-12 |

Reading of the baseline:

- All 20 runs passed all five required checks (CM-02, MO-01).
- Five runs (up to 2026-10-05 04:06 UTC) completed the `apply` job. Fourteen apply jobs failed and the latest (run 38559367091) is waiting for approval. For the first run listed after the ruleset, the annotation reads "The deployment was rejected or didn't satisfy other protection rules". CM-04 is therefore not evidenced after 2026-10-05 (G14).
- `1d0f3dd`, `faa6fec` and `7ff1e16` are not in the local clone and `9e1e6c7` is a commit of 2026-09-28; see finding F2 of [REAL-SOC2-001](../records/real/soc2/REAL-SOC2-001-change-review-2026-10.md).
- No run took the MEDIUM path: `medium-risk-approval` was skipped each time, so CM-03's approval branch has no run evidence.

## 6. Entries

### P-001: 2026-11-10, checkpoint of the first day

| Item | Observation |
|---|---|
| Collected | 2026-11-10, repository owner, AI-assisted tool run |
| `origin/main` | `3e6b06f`, committed 2026-10-14 17:20 +05:30. GitHub reported the same head (`gh api repos/<owner>/<repo>/commits/main`) |
| Merges since 2026-10-14 | None. The October population is in [REAL-SOC2-001](../records/real/soc2/REAL-SOC2-001-change-review-2026-10.md) |
| Push runs since 2026-10-14 | None. Run 38559367091 is `waiting` |
| Controls | CM-01 (no change reached `main` outside a pull request: none reached it at all), CM-02, CM-04 |

### P-002: 2026-11-10, IC-01 re-performance on a CI artifact

Run 38559367091 (commit `3e6b06f`, 2026-10-14), the latest push run.

| Item | Observation |
|---|---|
| Command | `gh run download 38559367091 -n compliance-evidence`, then `sha256sum -c evidence/artifacts.sha256` |
| Files in `artifacts.sha256` | 14 |
| Result | 14 of 14 `OK`, none failed |
| Manifest | repository `Ayush-cloud06/Ayka-Secure-Technologies-GmbH`, commit `3e6b06f142148c2817886677a4ce1c01b79876d7`, ref `refs/heads/main`, run ID 38559367091, `local: false`, decision `pass` |
| Summary | `pass`; HIGH 0, MEDIUM 0, LOW 6, excepted 14; unmapped 0 |
| Tools | Conftest 0.45.0 (OPA 0.56.0), tfsec v1.28.14, Checkov 3.3.20, Terraform 1.7.5 |
| Digest of `artifacts.sha256` | `724bb4d74cd05b0a56f2433b746668f87896a7f17af0d7b4b9b0bf02aa42ac27` |
| Controls | IC-01 (pass), CM-03 (pass decision recorded), MO-01 (regression artifact present, not downloaded) |
| Limit | Integrity only: the hash file travels with the bundle, so this does not prove authenticity (see the README on the evidence bundle) |

### P-003: 2026-11-10, local runs seen in `evidence/` and `output/` (not durable)

These folders are not committed and every local run deletes the previous contents. Two states were seen on the same day.

| Seen | Manifest `generated_at` | Workload | Commit and tree | Decision | Counts |
|---|---|---|---|---|---|
| About 03:35 UTC | 2026-11-10T03:30:51Z | `ayka-portal` | `509f4b21e55323f4b08f32b45ad1ef6b7d5ed63c`, no uncommitted changes, `local: true` | pass | HIGH 0, MEDIUM 0, LOW 6, excepted 14. The raw copy was `evidence/raw/2026-11-10_09-00-49`. The manifest SHA-256 line in `artifacts.sha256` was `5f7a84f5541e5a3790547f8bf2b81e74c51b3706c767b156d5ae2d63961ae953` |
| 03:48 UTC | 2026-11-10T03:40:46Z | `control-validation-scenarios` | `509f4b21e55323f4b08f32b45ad1ef6b7d5ed63c`, uncommitted changes in the tree, `local: true` | fail (the expected result of this workload) | HIGH 20, MEDIUM 34, LOW 10, unmapped 16. `sha256sum -c evidence/artifacts.sha256`: 16 of 16 `OK` |

Controls: CM-02 and MO-01 on a developer machine (re-performance of the gate; the regression expectation is that the scenarios workload fails). Local runs are not evidence for the period: they have no run ID and the tree was not clean in the second one.

## 7. Not collected yet

- Any run after 2026-10-14: runs exist since 2026-11-12 ([REAL-SDLC-002](../records/real/sdlc/REAL-SDLC-002-first-github-runs-and-apply-timeout.md) section 2) but are not yet entered in sections 5 and 6.
- A MEDIUM-path approval (CM-03): none occurred.
- The `compliance-evidence-regression` artifact content (MO-01): listed, not downloaded.
- Environment approval history for `manual-apply-approval`: not exported. G14 is explained without it: the approvals list of a failed run is empty and the job timed out after 30 days (REAL-SDLC-002 section 3).
- A copy of any artifact outside GitHub: none exists (G7). The `evidence-archive` root is scanned but has no upload step.
- Runs of the `Platform Gate`, `Platform Validate` and `Security Checks` jobs on GitHub: first runs on 2026-11-12 (REAL-SDLC-002), not entered here. Before that they ran only locally ([REAL-INFRA-001](../records/real/infra/REAL-INFRA-001-gate-run-all-roots.md), [REAL-SDLC-001](../records/real/sdlc/REAL-SDLC-001-first-local-scan.md)); they are not required checks, so they are not part of the observed controls in section 1.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-11-10 | First issue. Baseline of 20 push runs, entries P-001 to P-003 |
| 1.1 | 2026-11-10 | Section 7 lists the new CI jobs that have not run on GitHub and the archive without an upload step |
| 1.2 | 2026-11-12 | Section 7: runs since 2026-11-12 exist and are not entered yet; G14 explained by REAL-SDLC-002 |
