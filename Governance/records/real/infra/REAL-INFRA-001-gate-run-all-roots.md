# REAL-INFRA-001: Compliance gate run on every Terraform root

> **REAL RECORD.** Performed on the date shown. Scope and limits are stated below.

| Field | Value |
|---|---|
| Record ID | REAL-INFRA-001 |
| Performed | 2026-11-10 |
| Performed by | Repository owner, AI-assisted tool run (`run-local-chain.sh`, pinned toolchain in `.tools/bin`) |
| Base commit | `bc112b8` plus uncommitted working-tree changes (the change that adds the platform gate). The run manifests say `uncommitted_changes: true` |
| Controls | SOC 2 G12 (platform roots gated), CC7.1, CC8.1; ISO A.8.9, A.8.25, A.8.32 |
| Tools | Terraform 1.7.5, Checkov 3.3.20, tfsec 1.28.14, conftest 0.45.0 / OPA 0.56.0, TFLint 0.53.0 (version check by `check-tool-versions.sh` passed) |

## 1. What was done

The same chain CI runs (fmt, init, validate, offline plan with mock credentials, Checkov, tfsec, OPA, fail-closed evaluator, report, manifest, checksums) was run locally on every Terraform root, one after another. Platform roots that cannot be planned offline were run in the new `source` mode: Checkov and tfsec read the source, OPA does not run, and the summary says so in `tools_not_run`.

Reproduce (from the repository root, after `bootstrap-tools.sh`):

```
export PATH="$PWD/.tools/bin:$PATH"
S=Internal-IT/engineering/ci-cd/scripts
bash $S/run-local-chain.sh Internal-IT/workloads/ayka-portal
bash $S/run-local-chain.sh Internal-IT/platform/foundation/aws-organization
bash $S/run-local-chain.sh Internal-IT/platform/foundation/landing-zone
bash $S/run-local-chain.sh Internal-IT/platform/foundation/evidence-archive
bash $S/run-local-chain.sh Internal-IT/platform/domains/identity/aws-iam-core
bash $S/run-local-chain.sh Internal-IT/platform/foundation/remote-state source
bash $S/run-local-chain.sh Internal-IT/platform/domains/identity/aws-identity-center source
bash $S/run-local-chain.sh Internal-IT/workloads/control-validation-scenarios; bash $S/check-regression.sh
bash $S/run-local-chain.sh Internal-IT/platform/domains/identity/entra-id source
```

Each run deletes the previous `output/` and `evidence/`; the per-root summaries were copied aside after each run. They are not committed.

## 2. Results

| Root | Mode | Plan | Decision | Counted (H/M/L) | Excepted |
|---|---|---|---|---|---|
| `workloads/ayka-portal` | plan | 97 to add | **pass** | 0 / 0 / 6 | 15 |
| `platform/foundation/aws-organization` | plan | 10 to add | **pass** | 0 / 0 / 0 | 0 |
| `platform/foundation/landing-zone` | plan | 183 to add | **pass** | 0 / 0 / 9 | 87 |
| `platform/foundation/evidence-archive` | plan | 14 to add | **pass** | 0 / 0 / 2 | 4 |
| `platform/domains/identity/aws-iam-core` | plan | 20 to add | **pass** | 0 / 0 / 0 | 51 |
| `platform/foundation/remote-state` | source | none | **pass** | 0 / 0 / 2 | 14 |
| `platform/domains/identity/aws-identity-center` | source | none | **pass** | 0 / 0 / 0 | 0 |
| `workloads/control-validation-scenarios` | plan | 8 to add | **fail** (required) | 20 / 34 / 10 | 0 |
| `platform/domains/identity/entra-id` | source | none | **refused** (exit 3) | n/a | n/a |

- Regression check: `Negative test verified: every expected control was reported by every expected tool.`
- Entra ID: Checkov reported `resource_count: 0` because it has no rules for the `azuread` provider, and tfsec returned 0 results. The evaluator refuses a scan that checked nothing, which is the intended fail-closed behaviour. In CI this root therefore runs only fmt, validate and TFLint (job `Platform Validate (no scanner coverage)`).
- `terraform validate` and `tflint --recursive` passed (exit 0) on all nine roots, each initialised in a fresh `TF_DATA_DIR` with Terraform 1.7.5. `terraform fmt -check -recursive Internal-IT` passed.
- Unit tests after this run and the records were written: `pytest -q tests` 674 passed; `opa test` (OPA 0.56.0 from `.tools/bin`) 37/37 PASS.

Before this change the platform roots could not be planned offline at all (data sources and `assume_role` needed real AWS calls), so there is no baseline. The first runs during this change, before fixes and exceptions, failed: landing-zone 33 HIGH / 60 MEDIUM, aws-iam-core 46 HIGH / 14 MEDIUM, evidence-archive 1 HIGH / 3 MEDIUM, remote-state 1 HIGH / 19 MEDIUM. Fixed in code: inline IAM policies replaced by managed policies, the custom audit policy replaced by AWS `SecurityAudit`, DynamoDB encryption and point-in-time recovery, state-bucket lifecycle and TLS-only policy, Azure blob versioning, soft delete and no anonymous access. The rest were recorded in [`exceptions.yaml`](../../../../Internal-IT/engineering/policy-as-code/metadata/exceptions.yaml), each scoped to its root with a new `workload` field, with a reason, an owner and one of 20 staggered expiry dates (2027-01-08 to 2027-11-26). Several are real open work, not false positives: the broad `PlatformEngineerPolicy` and `WorkloadOperatorPolicy` grants in aws-iam-core (shortest expiry, 2027-01-15), no access logging for the log, state and evidence buckets, and shared-key auth on the Azure state account.

## 3. Limits

- **Scanned, not merge-blocking yet.** The ruleset `protect-main` requires five named checks. The new `Platform Gate (...)` and `Platform Validate (...)` jobs are not among them, so a red platform job does not stop a merge. **Open, owner action:** add those checks to the ruleset.

- A plan scan judges planned configuration, not a running system. Nothing was applied; account IDs in the plan-mode runs are AWS documentation IDs.
- Source-mode roots are not checked by the OPA rules, and Checkov cannot resolve values that only exist at plan time.
- Entra ID is not checked by any scanner.
- tfsec names only a module for findings inside modules, so module-level exceptions in the landing zone (for example `AVD-AWS-0057` on `module.dev_landing_zone`) cover every resource in that account module.
- Local run on an uncommitted working tree. A CI run on the merge commit is the evidence that counts; it does not exist yet.
