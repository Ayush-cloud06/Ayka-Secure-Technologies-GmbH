# CI/CD architecture

The pipeline is defined in `.github/` and nowhere else.

| What | Where |
|---|---|
| Entry workflow: every pull request, every push to `main`, manual dispatch | [`.github/workflows/test.yml`](../../../.github/workflows/test.yml) |
| Reusable gate: validate, plan, scan, decide, evidence, approval, simulated apply | [`.github/workflows/terraform-workflow.yml`](../../../.github/workflows/terraform-workflow.yml) |
| Security checks: gitleaks, actionlint, shellcheck, zizmor, Bandit, pip-audit, SBOM. Same triggers, plus weekly | [`.github/workflows/security-checks.yml`](../../../.github/workflows/security-checks.yml) |
| Drift check: manual only, refuses to run without a remote backend | [`.github/workflows/drift-detection.yml`](../../../.github/workflows/drift-detection.yml) |
| Steps the workflows call | [`.github/actions/`](../../../.github/actions/) (validate, plan, check, policy, decision, evidence, apply) |
| Dependency updates: GitHub Actions and `tests/requirements.txt`, weekly, 7-day cooldown | [`.github/dependabot.yml`](../../../.github/dependabot.yml) |
| Scripts the steps run | [`scripts/`](scripts/) |
| Pinned tool versions and checksums | [`toolchain.versions`](toolchain.versions) |
| Policies, the control mapping and the exceptions | [`../policy-as-code/`](../policy-as-code/) |

## Jobs of the entry workflow

| Job | What it covers | Required by the ruleset `protect-main` (read 2026-11-12) |
|---|---|---|
| `validate-scripts` | `bash -n` on every CI script | Yes |
| `unit-tests` | pytest over `tests/` (evaluator, wrappers, mapping, governance documents, workflow hardening) and `opa test` | Yes |
| `compliance / validate`, `compliance / compliance` | The gate on `ayka-portal`: all three scanners on the plan | Yes |
| `Control Validation Regression` | Insecure scenarios must be rejected with the expected controls | Yes |
| `compliance / medium-risk-approval` | Waits for a reviewer when the decision is `approval_required` | No |
| `Platform Gate` (six roots) | Four roots in plan mode; `remote-state` and `aws-identity-center` in source mode, where OPA does not run | No |
| `Platform Validate (no scanner coverage)` | `entra-id`: fmt, validate, tflint only | No |
| `compliance / apply` | Verifies the evidence checksums, then prints `SIMULATED APPLY`. Manual dispatch from `main` only | No |
| `Gate Summary` | Succeeds only when every job above did. One name the ruleset can require | No (owner action O-03) |

`Security Summary` does the same for the security workflow.

## Limits

- A check that is not required does not block a merge. Today that includes the platform jobs, the security checks and the medium-risk approval ([REAL-SDLC-002](../../../Governance/records/real/sdlc/REAL-SDLC-002-first-github-runs-and-apply-timeout.md)).
- GitHub's own secret scanning and push protection are off; gitleaks in CI is the only secret scan.
- Not built: release promotion, rollback, an emergency bypass, IAM diff checks, real apply, signed evidence. Earlier versions of this file described some of them as if they existed.
