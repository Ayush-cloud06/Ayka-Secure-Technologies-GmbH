# REAL-SDLC-002: First GitHub runs of the platform and security jobs, and why push runs on `main` end red

> **REAL RECORD.** Performed on the date shown. Scope and limits are stated below.

| Field | Value |
|---|---|
| Record ID | REAL-SDLC-002 |
| Performed | 2026-11-12 |
| Performed by | Repository owner, AI-assisted review (read-only `gh` and `git` queries run by an AI coding agent on the owner's machine) |
| Controls | SOC 2 CC7.1, CC8.1 (OP-01, CM-02, CM-03, CM-04; gaps G12, G14); ISO/IEC 27001:2022 A.8.4, A.8.8, A.8.25, A.8.28, A.8.32 |
| Subject | [`test.yml`](../../../../.github/workflows/test.yml), [`terraform-workflow.yml`](../../../../.github/workflows/terraform-workflow.yml), [`security-checks.yml`](../../../../.github/workflows/security-checks.yml); repository settings on GitHub |
| Related | [REAL-SDLC-001](REAL-SDLC-001-first-local-scan.md), [REAL-INFRA-001](../infra/REAL-INFRA-001-gate-run-all-roots.md), [REAL-SOC2-001](../soc2/REAL-SOC2-001-change-review-2026-10.md) F4, [REAL-ISMS-001](../isms/REAL-ISMS-001-owner-actions-open.md) O-01, O-03, O-13 |

## 1. What was done

The pipeline was compared with the documents that describe it. Run history, job results and job logs were read from GitHub, and the ruleset, environment and security settings were read through the GitHub API. Nothing on GitHub was changed. The workflow changes that followed are in section 6.

## 2. First runs on GitHub

Pull request #40 was the first to carry the `Platform Gate`, `Platform Validate` and `Security Checks` jobs to GitHub. Before it they had run locally only (REAL-INFRA-001, REAL-SDLC-001).

| Run | Workflow | Event, commit | Result |
|---|---|---|---|
| [43207474861](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/43207474861) | Security Checks | pull request #40, `c8295f7` | **failure**: Bandit reported 10 findings B608 (SQL built from strings), severity Medium, in `Internal-IT/engineering/privacy/dsr_tool.py`. gitleaks, actionlint, shellcheck and SBOM passed |
| [43207830148](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/43207830148) | Security Checks | pull request #40, `aa5f9a7` (the fix) | success, all four jobs |
| [43207830165](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/43207830165) | PR Compliance Pipeline | pull request #40, `aa5f9a7` | success. Decisions read from the job logs: `ayka-portal` pass (6 LOW, 15 excepted; the same figures as the local run); `aws-organization`, `landing-zone`, `evidence-archive`, `aws-iam-core` pass in plan mode; `remote-state`, `aws-identity-center` pass in source mode; `entra-id` validate-only success; regression scenarios decided `fail`, as required |
| [43208248261](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/43208248261) | Security Checks | push to `main`, `1945f57` | success |
| [43208248370](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/43208248370) | PR Compliance Pipeline | push to `main`, `1945f57` | every gate job success; the run is `waiting` at `compliance / apply` (section 3) |

What this shows:

1. The platform and security jobs work on a GitHub runner: downloads, checksums, plans without credentials and artifact uploads.
2. The security workflow rejected a real change (`c8295f7`) and accepted the fix. That is one observed failure and one observed pass.
3. The `compliance-report.md` in the evidence artifact of run 43207830165 carries SOC 2 criteria per finding.

## 3. Why push runs on `main` end red

[REAL-SOC2-001](../soc2/REAL-SOC2-001-change-review-2026-10.md) F4 found 14 of 20 push runs in October failed at the `apply` job and left the cause open.

The cause is a timeout, not a rejection:

- On a push to `main` with a passing decision, `compliance / apply` starts and waits for a reviewer at the `manual-apply-approval` environment.
- Nobody approved or rejected: the approvals list of run 37498007502 is empty.
- GitHub fails a job that has waited 30 days. Each of the 14 failed runs was last updated 30 days and about 2 minutes after it was created (37498007502: created 2026-10-06T16:43:56Z, failed 2026-11-05T16:45:42Z). Its `apply` job shows a duration of `720h0m0s` and the annotation "The deployment was rejected or didn't satisfy other protection rules."
- Two runs were still waiting on 2026-11-12: 38559367091 (created 2026-10-14, so it expires about 2026-11-13) and 43208248370.

The five green push runs all predate 2026-10-05 04:07 UTC and finished in about two minutes with an empty approvals list. The likely reason is that the environment had no required reviewer yet; that was **not** checked.

The checks that guard a merge were green in every one of these runs. The red result says the simulated apply was never released, not that a gate failed.

## 4. Settings read on 2026-11-12

| Setting | Value |
|---|---|
| Ruleset `protect-main` (24482491) | active; no bypass actors; pull request required with 0 approvals; `require_code_owner_review: false`; blocks deletion and force-push |
| Required checks | `validate-scripts`, `unit-tests`, `compliance / validate`, `compliance / compliance`, `Control Validation Regression`; "require branches to be up to date" off |
| Not required | every `Platform Gate` job, `Platform Validate`, every `Security Checks` job, `compliance / medium-risk-approval` |
| Environments `manual-apply-approval`, `medium-risk-approval` | one required reviewer (the owner); `prevent_self_review: false`; no deployment branch policy |
| Secret scanning, push protection | disabled |
| Dependabot alerts, Dependabot security updates | disabled (version updates run from `dependabot.yml`: pull requests #41 to #46 were open) |
| Actions | all actions allowed; `sha_pinning_required: false`; default workflow token read-only |

## 5. Finding: a MEDIUM decision does not block a merge

Read from the configuration; **not** tested with a pull request that carries a MEDIUM finding.

- The evaluator exits non-zero only for `fail` ([`evaluate-results.py`](../../../../Internal-IT/engineering/ci-cd/scripts/evaluate-results.py), last lines of `main`). On `approval_required` the job `compliance / compliance` ends green.
- `compliance / medium-risk-approval` then waits at its environment, but it is not a required check.
- So all five required checks are green and the pull request can merge while the approval is still pending.

CM-03 ("a MEDIUM finding stops it at the `medium-risk-approval` environment until a reviewer approves") holds for the simulated apply, not for the merge. Closing it is an owner action: require the summary check of section 6, or `compliance / medium-risk-approval` itself.

## 6. Changes made after this review

On branch `ci/audit-fixes` (commit `5fbe821`); they take effect when that branch is merged:

- The simulated apply runs only on a manual dispatch from `main`.
- `Gate Summary` and `Security Summary` jobs wait for every other job of their workflow, so the ruleset can require two names. `Gate Summary` also waits for a pending medium-risk approval.
- A zizmor job, a weekly schedule for the security checks, no expression pasted into a script, no token kept by checkout, a timeout on every job, a stated artifact retention, one pin for PyYAML.

These were checked locally with pytest, actionlint 1.7.12 and zizmor 1.30.1. They have **not** run on GitHub yet.

## Reproduce

```
gh run list --workflow test.yml --branch main --event push --limit 40 --json databaseId,status,conclusion,createdAt,updatedAt
gh run view 37498007502            # apply job duration and annotation
gh api repos/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/37498007502/approvals
gh run view 43207830165 --log | grep '"decision"'
gh run view 43207474861 --log-failed | grep 'Issue:'
gh api repos/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/rulesets/24482491
gh api repos/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/environments
gh api repos/Ayush-cloud06/Ayka-Secure-Technologies-GmbH --jq .security_and_analysis
```

## Limits

- One green run of the platform and security jobs is one sample, not an operating period. None of these jobs is a required check, so a red one still does not block a merge (O-03, open).
- A plan scanned on a runner is still a plan: nothing is deployed, and the platform roots remain Gated design.
- Section 5 is a reading of the configuration. No pull request with a MEDIUM finding was opened to prove it.
- The 30-day rule is GitHub's documented behaviour, matched here by the timestamps; the reason the five early runs passed was not established.
- No setting was changed. O-01, O-03 and O-13 in REAL-ISMS-001 stay open: they need the owner's hand or decision.
