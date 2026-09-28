# B-pipeline findings — CI/CD compliance gate (repo main @ 53b0532)

Author: research agent B-pipeline. All paths are repo-relative; line numbers are from `cat -n` on a `git archive HEAD` copy
(`scratchpad/tree-B`). The real repo was never modified. SP = `<scratch>`.
Local chain outputs: `SP/chain/{ayka-portal,scenarios,probe-blindspots}/` (+ `*.log`). Runner script: `SP/work-B/run-chain.sh`.
CI evidence cited as "run #68" = https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/32621618951 (lead-verified, see FACTS-lead.md).

**Headline:** local re-execution with the same tool versions reproduces run #68 exactly, down to file sizes:
ayka-portal PASS (14 LOW, checkov only); scenarios FAIL (HIGH 4 / MEDIUM 8 / LOW 17, 29 findings).
But the gate has confirmed fail-open paths. tfsec output is always dropped. The OPA rules miss root-module resources, standalone SG-rule resources, unknown-at-plan ids and `Action: ["*"]`.
Checkov checks that match HIGH controls (CKV_AWS_24/79/20/62/63…) are unmapped, so they drop to LOW.
A probe plan with public SSH, IMDSv1 and a full-admin IAM policy gets **PASS** today. The apply stage is a simulation (`echo`).
With tfsec fixed, ayka-portal would turn **FAIL** (3 unmapped tfsec HIGH).

---

## 1. Workflow topology

| Workflow | Trigger | Jobs | Notes |
|---|---|---|---|
| `.github/workflows/test.yml` "PR Compliance Pipeline" | `push` (all branches) + `workflow_dispatch` (test.yml:3-10); **no `pull_request`** | `validate-scripts` (24-33, `bash -n` only), `compliance` (35-42, calls reusable terraform-workflow.yml), `regression` (44-98) | workflow-level `env` WORKLOAD_DIR/REGRESSION_DIR/AWS_ROLE_ARN (12-17) |
| `.github/workflows/terraform-workflow.yml` | `workflow_call` only (4-29) | `validate` (50-60) → `compliance` (62-111) → `medium-risk-approval` (113-125) → `apply` (127-150) | top-level `description:` key is invalid per actionlint (line 2) |
| `.github/workflows/policy-check.yml` | `workflow_call` only | `policy-check` (14-21) | **Not called by anything** (lead). Input `plan_json_path` (7-11) is never used. Standalone it has no plan, so conftest errors, `run-policy-check.sh` writes an error payload and **exits 0** (verified). This is a green no-op. |
| `.github/workflows/drift-detection.yml` | cron `0 2 * * *` + dispatch (3-6) | `detect-drift` matrix [ayka-portal] (13-45) | disabled_inactivity; 61/61 scheduled runs failed (lead/D-codex) |

`Internal-IT/engineering/ci-cd/templates/{policy-check,terraform-workflow}.yml` are **symlinks**. `git ls-files -s` shows mode `120000`, and `readlink` returns `../../../../.github/workflows/<same>.yml`. They resolve in a checkout.
`Internal-IT/engineering/ci-cd/pipelines/**`: **14 files, all 0 bytes** (code-security ×2, compliance ×3, core ×4, drift ×1, release ×4). `architecture.md:5-11` describes these five "layers" as if they existed.
Also 0 bytes: `ci-cd/README.md`, `compliance-gates/failure-handling.md`, `compliance-gates/approvals/{change-justification-template,prod-approval-policy}.md`, `Internal-IT/engineering/.pre-commit-config.yaml`, and **all 4 files under `Internal-IT/engineering/drift-detection/**`** (incl. `terraform-drift/drift-check.sh`).
Docs `enforcement-levels.md:13` and `policy-evaluation-flow.md:12` link to `/home/ayush/Compliance-Oriented-Cloud-Security-Platform/...`, an absolute local path. The link is broken and leaks the old repo name.
`policy-as-code/metadata/README.md:5-8` says the "active enforcement set" lives in `../active/control-mapping.yaml`. That file does not exist. The evaluator uses `metadata/control-mapping.yaml` (evaluate-results.py:23-28).

## 2. Stage-by-stage data flow (compliance job of terraform-workflow.yml; regression job is the same minus checksum)

| # | Stage / step | Script / command | Inputs | Outputs (exact) | Consumed by | path:line |
|---|---|---|---|---|---|---|
| 0 | validate job | setup-terraform@v3, setup-tflint@v4 `latest`, `terraform fmt -check -recursive`, `init -backend=false`, `validate`, `tflint --init && tflint --recursive` | workload dir | none (gate only); no `.tflint.hcl` in repo | — | validate/action.yml:16-43; terraform-workflow.yml:50-60 |
| 1 | Terraform Plan | configure-aws-credentials@v4 (OIDC), `terraform init`, `terraform plan -input=false -refresh=false -out=tfplan.binary`, `terraform show -json` | workload dir, role ARN. **No `-var-file`** (envs/dev.tfvars unused by any workflow) | `output/tfplan.json`; `output/tfplan.binary` (mv'd from workload dir) | checkov, conftest, checksum, upload | plan/action.yml:23-50; terraform-workflow.yml:74-80 |
| 2 | Cost Estimation Hook | `run-cost-check.sh` | output/tfplan.json | nothing on GH runners: prints "Simulated cost check: Passed." (infracost not installed) | — | run-cost-check.sh:6-13; terraform-workflow.yml:82-84 |
| 3a | Security Check: Checkov | `pip install checkov` (unpinned); `checkov -f output/tfplan.json --framework terraform_plan -o json > output/checkov-result.json \|\| true` | output/tfplan.json | `output/checkov-result.json` | evaluator, export | check/action.yml:7-24; run-checkov.sh:13-16 |
| 3b | Security Check: tfsec | wget tfsec v1.28.14; `tfsec "$TARGET_DIR" --format json --out output/tfsec-result \|\| true`; if `output/tfsec-result.json` missing, write `{"results":[]}` | **source dir** `${WORKLOAD_DIR:-Internal-IT/workloads/ayka-portal}` (not the plan) | **`output/tfsec-result`** (real results, no extension) + **`output/tfsec-result.json`** = 15-byte fallback | evaluator reads the `.json` fallback only | check/action.yml:17-28; run-tfsec.sh:9,13-19 |
| 4 | Policy Check | wget conftest v0.45.0; `conftest test output/tfplan.json --policy Internal-IT/engineering/policy-as-code/OPA --all-namespaces --output json > output/opa-result.json 2> output/opa-result.stderr.log`; if exit>1 or empty stdout → `write-opa-error-result.py` payload `{"status":"error",...}` | output/tfplan.json, all 6 .rego (incl. OPA/aws) | `output/opa-result.json`, `output/opa-result.stderr.log` | evaluator | policy/action.yml:7-17; run-policy-check.sh:11-28; write-opa-error-result.py:24-32 |
| 5 | Compliance Decision | `evaluate-results.sh` (checks the 3 files exist) → `evaluate-results.py` | checkov-result.json, opa-result.json, tfsec-result.json, control-mapping.yaml | `output/compliance-summary.json` (schema 2.0); exit 1 iff decision=fail | publish-summary (jq) → job outputs; report; checksum; export | decision/action.yml:21-23; evaluate-results.sh:13-20; evaluate-results.py:426-454 |
| 5b | Publish Compliance Summary (`if: always()`) | jq → `$GITHUB_OUTPUT` schema_version/decision/approval_required/unmapped_findings; missing summary → decision=`error` | compliance-summary.json | job outputs | medium-risk-approval `if`, apply `if` | decision/action.yml:25-41; terraform-workflow.yml:65-69 |
| 6 | Checksum Artifacts (**no `if:`, so skipped when step 5 fails, i.e. on every `fail`**) | `sha256sum output/tfplan.json output/compliance-summary.json > evidence/artifacts.sha256` | the two files | `evidence/artifacts.sha256` | apply job | terraform-workflow.yml:96-105 |
| 7a | Evidence: report (`if: always()`) | `generate-report.py` | output/compliance-summary.json (exit 1 if missing) | `output/compliance-report.md` | upload | evidence/action.yml:13-16; generate-report.py:5-8,64-65 |
| 7b | Evidence: export (`if: always()`) | `export-evidence.sh`: `cp output/*.json evidence/raw/<YYYY-mm-dd_HH-MM-SS>/` | output/*.json | `evidence/raw/<ts>/{tfplan,checkov-result,opa-result,tfsec-result,compliance-summary}.json`. Real tfsec output (`tfsec-result`, no .json), stderr log and report are **not** copied (verified locally) | upload | export-evidence.sh:14-29 |
| 7c | Upload Evidence Artifact (`if: always()`) | upload-artifact@26f96df (v4.3.0), name `${{ inputs.artifact_name }}` (default `compliance-evidence`; regression: `compliance-evidence-regression`) | — | artifact with `evidence/` (raw/<ts>/*.json + artifacts.sha256), `output/compliance-report.md`, `output/tfplan.json`, `output/tfplan.binary`. **Not** `output/compliance-summary.json`. Default retention (no `retention-days`) | apply job download | evidence/action.yml:23-32; terraform-workflow.yml:107-111; test.yml:78-81 |
| 8 | medium-risk-approval (`if approval_required=='true'`) | echo only; relies on environment `medium-risk-approval` protection rules (config UNVERIFIED) | job outputs | — | apply `needs` | terraform-workflow.yml:113-125 |
| 9 | apply (`always() && (decision=='pass' \|\| medium-risk-approval.result=='success') && ref==main`, env `manual-apply-approval`) | configure-aws-credentials (OIDC, SHA-pinned); download-artifact name **hardcoded `compliance-evidence`** → `downloaded-evidence/`; setup-terraform 1.7.5 (hardcoded); `run-apply.sh` | artifact | nothing real | — | terraform-workflow.yml:127-150; apply/action.yml:12-27 |
| 9a | run-apply.sh | `cd downloaded-evidence && sha256sum -c evidence/artifacts.sha256 --ignore-missing`; `cd $WORKLOAD_DIR && terraform init`; then **only `echo "Simulating Terraform apply…"` / `echo "Apply complete! Resources: 14 added…"`** (hardcoded; ayka-portal is actually 87 creates) | downloaded artifact | — | — | run-apply.sh:11-27 |

Regression job (test.yml:44-98): validate → plan (REGRESSION_DIR) → check → policy → decision (`continue-on-error: true`, :76) → evidence (`compliance-evidence-regression`) → "Check Regression Results" (:83-98). There is no checksum step and no apply.

## 3. Evaluator semantics (`Internal-IT/engineering/ci-cd/scripts/evaluate-results.py`)

| Aspect | Rule | path:line |
|---|---|---|
| Decision | `HIGH>0 → "fail"`; elif `MEDIUM>0 → "approval_required"` + `approval_required=true`; else `"pass"`. Only `fail` exits 1. Unmapped count does not gate | 417-421, 453-454 |
| Severity normalization | `(value or "LOW").upper()`; `CRITICAL→HIGH`; HIGH/MEDIUM/LOW kept; anything else (None, INFO, UNKNOWN…) → **LOW** | 48-54 |
| Index build | For each control: `enforcement` + `additional_enforcements`. checkov/tfsec `policy_id → control` (last writer wins; no duplicates exist today). opa: `control_id` (default = control key) → control; plus `policy_package → [{control_id, message_patterns}]` | 69-99 |
| Checkov | iterates `data["results"]["failed_checks"]` (assumes dict output); `check_id` via index. Mapped → metadata severity; unmapped → `item["severity"]`, which is **None in OSS checkov (verified: 14/14 and 23/23 failed checks have `severity: null`), so LOW** | 220-247, 137-159 |
| tfsec | iterates `data["results"]`; key `rule_id` (e.g. `AVD-AWS-0107`) or `long_id`; mapped → metadata; unmapped → tfsec severity (CRITICAL→HIGH) | 250-278 |
| OPA | error payload → exit 1; non-list → exit 1; per namespace `failures` (ignores `warnings`/`exceptions`). Msg regex `^\[([A-Z0-9_]+)\]\s*(.*)$`: known ID → mapped (`control_id_prefix`); unknown ID → **MEDIUM** unmapped; no prefix → case-insensitive substring match of `message_patterns` within the same `namespace` → mapped; else **MEDIUM** `opa_default`. `resource` = `failure.metadata.resource`, but no rego emits metadata, so it is **always null** for OPA findings (verified in chain) | 281-314, 162-217, 29, 306 |
| Summary | `schema_version "2.0"`, decision_basis, totals, by_tool, by_control (severity = first finding's), metadata_coverage, mapped/unmapped/findings | 386-423 |

### Fail-closed behaviours (verified with harness `SP/work-B` + D-codex probes)
| Condition | Result | Where |
|---|---|---|
| Any of the 3 result files missing | exit 1 before python | evaluate-results.sh:13-18 (also load_json 32-37) |
| Invalid / empty JSON in any file | "Failed to parse JSON" exit 1 | 32-37 |
| control-mapping.yaml unparsable | exit 1 | 40-45 |
| conftest error (bad rego, missing plan, missing policy dir): conftest exits **1** with empty stdout; `! -s` catches it → error payload | evaluator "OPA execution failed" exit 1 | run-policy-check.sh:24-28; evaluate-results.py:282-285 |
| OPA JSON not a list | exit 1 | 287-289 |
| checkov list output (multi-framework) / tfsec `results: null` / OPA `failures: null` | crash (AttributeError/TypeError) exit 1. Fail-closed only **by accident**. tfsec v1.28.14 emits `[]` not `null` when clean (verified), so the null path is theoretical | 222, 252, 294 |
| Summary missing downstream | publish-summary sets `decision=error` → apply `if` false | decision/action.yml:30-36 |

### Fail-open gaps / bugs (claim | evidence | status | severity)

| # | Claim | Evidence | Status | Sev |
|---|---|---|---|---|
| F1 | tfsec findings are **always dropped**: `--out output/tfsec-result` writes exactly that path, then the script sees no `tfsec-result.json` and writes `{"results":[]}` | run-tfsec.sh:13-19. Local tfsec v1.28.14 writes `…/tfsec-result` ("1 file(s) written"). Run #68 output/ has `tfsec-result` 4137 B + `tfsec-result.json` 15 B. The local file is 4265 B = 4137 + 4×32-byte path-prefix difference, so CI had the **same 4 findings** as below. `by_tool` in CI/local lists only checkov+opa | **CONFIRMED** | Critical |
| F2 | Silently dropped tfsec findings: **ayka-portal** 4 = AVD-AWS-0053 `aws-elb-alb-not-public` HIGH (modules/compute/alb.tf:34, `internal=false`, by design), AVD-AWS-0057 `aws-iam-no-policy-wildcards` HIGH ×2 (modules/networking/main.tf:168; false positive: resources are the log-group ARN + `:*`, and tfsec shows an unresolved placeholder), AVD-AWS-0089 MEDIUM (storage/main.tf:22 access-logs bucket). 0053/0057 are **unmapped** (scanner severity HIGH); 0089 maps to S3_LOGGING_DISABLED (MEDIUM). **Predicted ayka-portal decision once F1 is fixed: FAIL** (HIGH 3 / MEDIUM 1 / LOW 14; 3 unmapped) | `SP/chain/ayka-portal/predicted-with-tfsec-summary.json` | **CONFIRMED** (local) | High |
| F3 | tfsec scans the wrong directory. In the reusable workflow `WORKLOAD_DIR` is never set (caller `env` is not propagated to called workflows), and the check action passes no dir, so the default is ayka-portal. The regression job inherits `WORKLOAD_DIR=ayka-portal` from test.yml:13. So the scenario regression never tfsec-scans the scenarios | run-tfsec.sh:9; check/action.yml:26-28; test.yml:13,67-68. Run #68 regression env shows ayka-portal; both jobs' tfsec-result = 4137 B | **CONFIRMED** | High |
| F4 | Scenarios tfsec (correct dir) would add 25 findings (23 mapped; 13 HIGH): 0107 (EC2_OPEN_SSH), 0104 CRITICAL (EC2_PUBLIC_EGRESS), 0028 (IMDSv2), 0131, 0086/0087/0091/0092/0093 (S3_PUBLIC_ACCESS), 0088/0132 (S3_ENCRYPTION_MISSING, meta MEDIUM), 0089, 0090, 0124 ×2; unmapped 0094 LOW ×2. Predicted scenarios: FAIL, HIGH 17 / MEDIUM 16 / LOW 21 (54 total, 11 unmapped) | `SP/chain/scenarios/predicted-with-tfsec-summary.json` | CONFIRMED (local) | info |
| F5 | Checkov `\|\| true` + missing/unparseable plan: checkov **exits 0** with `results.failed_checks=[]` + `parsing_errors` → evaluator ignores `parsing_errors` → 0 findings. Summary-only output (plan with 0 resources) → no `results` key → 0 findings | run-checkov.sh:13-16; evaluate-results.py:222. Verified with checkov 3.3.20 on missing file / `{}` | **CONFIRMED** | High |
| F6 | Unmapped checkov findings can never block: OSS checkov `severity` is null → LOW. Checkov checks that mirror HIGH controls are **not mapped**: CKV_AWS_24 (SSH 0.0.0.0/0), CKV_AWS_79 (IMDSv1), CKV_AWS_8 (EBS encryption), CKV_AWS_20 (S3 public-read ACL), CKV_AWS_62/63/355, CKV2_AWS_40 (IAM `*`) | chain scenarios: 9 unmapped checkov all LOW, incl. CKV_AWS_24/79/8/20 | **CONFIRMED** | High |
| F7 | OPA rules only walk `planned_values.root_module.child_modules[_].resources`. Root-module resources (e.g. ayka-portal `kms.tf` → `aws_kms_key.workload`, `aws_kms_alias.workload`) and nested modules (child of child) are invisible | e.g. aws_ec2.rego:7, aws_s3.rego:5, aws_iam.rego:7, aws_vpc.rego:5. Synthetic plan: root `aws_instance` IMDSv1 + nested-module open-SSH SG → 0 failures. Real probe plan below | **CONFIRMED** | High |
| F8 | EC2_OPEN_SSH / EC2_HTTP_OPEN only inspect inline `aws_security_group.ingress` with exact from/to port and `protocol=="tcp"` and IPv4 `0.0.0.0/0`. `aws_vpc_security_group_ingress_rule` / `aws_security_group_rule`, `protocol -1` all-ports and `::/0` are missed. ayka-portal uses only standalone rule resources (modules/security/main.tf:56-136) | aws_ec2.rego:6-39; synthetic SG `protocol:-1` 0-0 → no finding | **CONFIRMED** | High |
| F9 | **End-to-end probe** (`SP/chain/probe-blindspots/`, real TF 1.7.5 / aws 5.100.0 plan): public SSH via `aws_vpc_security_group_ingress_rule` + `aws_security_group_rule`, root-module EC2 `http_tokens=optional`, `aws_iam_policy` `Action=["*"],Resource="*"` → **current pipeline decision PASS** (16 LOW, 15 unmapped, OPA 0). With tfsec fixed → FAIL (0107, 0028, 0131, 0057×2 HIGH) | chain log + summaries | **CONFIRMED** | Critical |
| F10 | IAM_WILDCARD_POLICY matches only `stmt.Action == "*"` (string) in a Statement **list**. `["*"]`, a single-object Statement, `NotAction`, service wildcards and unknown-at-plan `policy` (e.g. ayka-portal `aws_iam_policy.flow_logs` policy is unknown) are missed | aws_iam.rego:11-15; synthetic: only the string form fired | **CONFIRMED** | High |
| F11 | VPC_FLOW_LOGS_MISSING is broken both ways. On a new VPC `values.id` is unknown/absent, so the rule body is undefined and it **never fires** (even with no flow log). The rule compares `fl.values.resource_id`, but aws_flow_log has **no `resource_id` attribute** (provider 5.100.0 schema has `vpc_id`), so on an existing VPC with known id it **always fires** (false positive) | aws_vpc.rego:18,26-31. ayka-portal plan: `aws_vpc.this` no `id`; `aws_flow_log.vpc` unknown `vpc_id`, no `resource_id`. opa eval: unknown-id VPC w/o flow log → `[]`; known-id VPC with matching flow log → fires | **CONFIRMED** | Medium |
| F12 | ROUTE_TABLE_PUBLIC_IGW needs a literal `igw-…` `gateway_id`. On any plan referencing `aws_internet_gateway.x.id` the value is unknown/absent (ayka-portal `route_table.public.route[0]` has no `gateway_id`), so it never fires | aws_vpc.rego:39-41 + ayka-portal plan JSON | **CONFIRMED** | Low (control is LOW) |
| F13 | IAM_USER_MFA_MISSING compares `user.name` (resource **label**) with `mfa.values.user`; the provider attribute is `user_name` (schema verified). So it fires for every `aws_iam_user` regardless of MFA (redundant with IAM_USER_PROHIBITED) | aws_iam.rego:48-66 | CONFIRMED (static + schema) | Low |
| F14 | S3_PUBLIC_ACCESS / S3_ENCRYPTION_MISSING don't link ACL/SSE to the bucket: any public-read ACL flags **every** bucket in that module; any SSE config satisfies **all** buckets in the module; bucket policy / public-access-block not considered | aws_s3.rego:4-30 | CONFIRMED (static) | Medium |
| F15 | EC2_MISSING_TAGS reads `values.tags`, not `tags_all`, so provider `default_tags` don't count (false positive risk). IMDSv2 rule: `metadata_options` absent/unknown → neither IMDS rule fires | aws_ec2.rego:84-107, 42-66 | CONFIRMED (static) | Low |
| F16 | Regression job is non-strict: decision step `continue-on-error: true`; if decision is `pass`/`approval_required` it only prints WARNING and exits 0 | test.yml:76, 94-98 | **CONFIRMED** | High |
| F17 | Checksum step has no `if: always()`, so it is skipped whenever decision=fail. Fail runs have no `artifacts.sha256`; regression job has no checksum step at all | terraform-workflow.yml:96-105 | CONFIRMED (YAML semantics) | Low |
| F18 | `--ignore-missing`: `output/compliance-summary.json` is not in the artifact (only `evidence/raw/<ts>/compliance-summary.json`), so only `output/tfplan.json` is verified. `tfplan.binary` is never hashed. If *all* listed files are missing, coreutils 9.4 exits 1 ("no file was verified") | run-apply.sh:14; evidence/action.yml:28-32; local coreutils 9.4 tests; run #68 log `output/tfplan.json: OK` only | **CONFIRMED** | Medium |
| F19 | Integrity ≠ tamper-evidence: `artifacts.sha256` ships in the same artifact. Rewriting tfplan.json + regenerating the hash verifies OK (tested). No signing/attestation | run-apply.sh:12-17 | CONFIRMED | Medium |
| F20 | Apply is simulated: after verification it runs `terraform init` then only echoes a hardcoded "14 added" (real plan: 87 creates). The checked plan is never applied | run-apply.sh:20-27 | **CONFIRMED** | High (claim accuracy) |
| F21 | jq quoting bug: `'.schema_version // \"unknown\"'` inside single quotes reaches jq with backslashes → compile error. `echo` still exits 0, so `schema_version=` is empty | decision/action.yml:38. Reproduced with bash `-eo pipefail` + jq 1.7; run #68 log | **CONFIRMED** | Low |
| F22 | `pyyaml` is an undeclared dependency of evaluate-results.py (import yaml, :9). It works only because `pip install checkov` pulls PyYAML in | check/action.yml:15; `pip show checkov` Requires: pyyaml | CONFIRMED | Low |
| F23 | Apply downloads artifact name **hardcoded** `compliance-evidence`, while upload uses `inputs.artifact_name`. A caller overriding `artifact_name` breaks apply | apply/action.yml:15 vs terraform-workflow.yml:111 | CONFIRMED (static) | Low |
| F24 | Checkov inline `# checkov:skip=` comments in .tf are **ignored** when scanning plan JSON. 8 of the 14 ayka-portal findings are ones the authors tried to suppress (CKV2_AWS_5 ×4 security/main.tf:28-49, CKV2_AWS_76 alb.tf:32, CKV_AWS_144 ×2 storage/main.tf:21,82, CKV2_AWS_57 database/main.tf:11). With `--repo-root-for-plan-enrichment Internal-IT/workloads/ayka-portal`, 3 are honored (CKV2_AWS_57, CKV2_AWS_76, CKV_AWS_144 on `this`); the rest stay because the comment sits outside the resource block | `SP/chain/ayka-portal/checkov-with-enrichment.json` (failed 11, skipped 3) | CONFIRMED | Low |
| F25 | OPA `warn`/`exceptions` ignored by the evaluator (latent; no warn rules today) | evaluate-results.py:294 | CONFIRMED (latent) | Low |
| F26 | `export-evidence.sh` copies `*.json` only. The evidence bundle holds the **fallback** empty tfsec file, not the real `tfsec-result`, and omits the conftest stderr log | export-evidence.sh:25-26; local evidence listing | CONFIRMED | Medium |
| F27 | Cost check is a no-op on GH runners ("Simulated cost check: Passed.") | run-cost-check.sh:6-13 | CONFIRMED | Low |
| F28 | tfsec `results: null` → crash | tfsec v1.28.14 emits `{"results": []}` when clean | **REFUTED** for pinned version (theoretical) | — |
| F29 | Unit tests are never run in CI. `validate-scripts` only runs `bash -n` | test.yml:24-33; `grep pytest\|unittest .github` → none | CONFIRMED | Medium |

## 4. Control mapping (`Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml`, 748 lines)

**38 controls**: 11 HIGH, 9 MEDIUM, 18 LOW. Only ISO 27001 refs (`frameworks.iso27001`); no other frameworks. No duplicate policy_ids across controls.

| control_id (line) | sev | enforcement (tool:policy_id / opa package) | ISO 27001 |
|---|---|---|---|
| EC2_OPEN_SSH (L2) | HIGH | opa:aws_ec2 [EC2_OPEN_SSH]; tfsec:AVD-AWS-0107 | A.8.20, A.8.21 |
| S3_PUBLIC_ACCESS (L25) | HIGH | opa:aws_s3; tfsec:0086,0087,0091,0092,0093 | A.8.12, A.8.24 |
| EC2_MISSING_IMDSV2 (L56) | HIGH | opa:aws_ec2; tfsec:0028 | A.8.9, A.8.20 |
| S3_VERSIONING_DISABLED (L80) | MED | checkov:CKV_AWS_21; tfsec:0090 | A.8.13, A.5.30 |
| EC2_MISSING_TAGS (L101) | LOW | opa:aws_ec2 | A.5.9 |
| S3_ENCRYPTION_MISSING (L121) | MED | opa:aws_s3; tfsec:0088,0132 | A.8.24 |
| EC2_ROOT_VOLUME_UNENCRYPTED (L146) | HIGH | opa:aws_ec2; tfsec:0131 | A.8.24 |
| EC2_HTTP_OPEN (L169) | MED | opa:aws_ec2; checkov:CKV_AWS_260 | A.8.20 |
| EC2_PROD_UNDERSIZED_INSTANCE (L192) | LOW | opa:aws_ec2 | A.5.30 |
| EC2_PROD_SPOT_USAGE (L212) | MED | opa:aws_ec2 | A.5.30 |
| EC2_PUBLIC_EGRESS (L232) | HIGH | tfsec:0104; checkov:CKV_AWS_382 | A.8.20, A.8.21 |
| EC2_SECURITY_GROUP_RULE_DESCRIPTION (L252) | LOW | tfsec:0124 (**tfsec-only → dead today**) | A.5.37 |
| S3_LOGGING_DISABLED (L269) | MED | tfsec:0089; checkov:CKV_AWS_18 | A.8.15, A.8.16 |
| S3_KMS_ENCRYPTION_REQUIRED (L289) | MED | checkov:CKV_AWS_145 | A.8.24 |
| ALB_WAF_PROTECTION_REQUIRED (L306) | HIGH | checkov:CKV2_AWS_28 | A.8.20, A.8.21 |
| ALB_TLS_ENFORCEMENT (L323) | HIGH | checkov:CKV_AWS_2, CKV_AWS_103, CKV2_AWS_20 | A.8.20, A.8.21, A.8.24 |
| IAM_WILDCARD_POLICY (L345) | HIGH | opa:aws_iam (only) | A.8.2, A.8.3 |
| IAM_INLINE_POLICY_USAGE (L365) | MED | opa:aws_iam | A.8.2 |
| IAM_USER_PROHIBITED (L385) | HIGH | opa:aws_iam | A.5.17, A.8.2 |
| IAM_USER_MFA_MISSING (L406) | HIGH | opa:aws_iam | A.8.5 |
| VPC_DEFAULT_PROHIBITED (L426) | MED | opa:aws_vpc | A.8.20 |
| VPC_FLOW_LOGS_MISSING (L446) | MED | opa:aws_vpc; checkov:CKV2_AWS_11 | A.8.15, A.8.16 |
| ROUTE_TABLE_PUBLIC_IGW (L469) | LOW | opa:aws_vpc (only; never fires on fresh plan) | A.8.20, A.8.21 |
| NETWORK_ACL_UNRESTRICTED_INGRESS (L489) | HIGH | opa:aws_vpc (only) | A.8.20, A.8.21 |
| CLOUDWATCH_LOG_GROUP_KMS_ENCRYPTION (L509) | LOW | checkov:CKV_AWS_158 | A.8.15, A.8.16, A.8.24 |
| SECRETS_MANAGER_CMK_ENCRYPTION (L526) | LOW | checkov:CKV_AWS_149 | A.8.24 |
| SNS_TOPIC_KMS_ENCRYPTION (L543) | LOW | checkov:CKV_AWS_26 | A.8.24 |
| SECURITY_GROUP_UNUSED (L560) | LOW | checkov:CKV2_AWS_5 | A.8.15, A.5.15 |
| S3_REPLICATION_DISABLED (L577) | LOW | checkov:CKV_AWS_144 | A.8.13, A.5.30 |
| S3_ACLS_DISABLED (L594) | LOW | checkov:CKV2_AWS_65 | A.8.12, A.8.24 |
| KMS_KEY_POLICY_DEFINED (L611) | LOW | checkov:CKV2_AWS_64 | A.8.24 |
| WAF_LOG4J_PROTECTION (L628) | LOW | checkov:CKV_AWS_192, CKV2_AWS_76 | A.8.20, A.8.21 |
| RDS_PERFORMANCE_INSIGHTS_ENCRYPTION (L648) | LOW | checkov:CKV_AWS_354 | A.8.24 |
| S3_NOTIFICATIONS_DISABLED (L665) | LOW | checkov:CKV2_AWS_62 | A.8.15, A.8.16 |
| SECRETS_MANAGER_ROTATION_DISABLED (L682) | LOW | checkov:CKV2_AWS_57 | A.5.17, A.8.2 |
| RDS_ENCRYPTION_IN_TRANSIT (L699) | LOW | checkov:CKV2_AWS_69 | A.8.24 |
| S3_LIFECYCLE_DISABLED (L716) | LOW | checkov:CKV2_AWS_61 | A.8.13 |
| WAF_LOGGING_DISABLED (L733) | LOW | checkov:CKV2_AWS_31 | A.8.15, A.8.16 |

Cross-check results:
- All **18 `[ID]` prefixes** in `OPA/terraform/*.rego` map to an existing control, and their package matches `policy_package`. All 18 OPA-enforced controls have a rego rule, and every `message_patterns` string occurs in the rego message text. No control references a non-existent package or rule.
- `OPA/aws/{ec2,s3}.rego` (packages `policies.aws.ec2`, `policies.aws.s3`) read `input.instances` / `input.buckets`. Those keys don't exist in plan JSON. The files **are loaded** (conftest output lists both namespaces with `successes: 1`) but can never fire. Their messages have no `[ID]` prefix and no package mapping, so a hit would be unmapped MEDIUM → approval_required. Dead code; `s3.rego:8` has the typo "publicy".
- Controls whose only working enforcement is tfsec (dead due to F1): EC2_SECURITY_GROUP_RULE_DESCRIPTION. Controls whose only enforcement is an OPA rule that can't fire on a fresh plan: ROUTE_TABLE_PUBLIC_IGW, and VPC_FLOW_LOGS_MISSING (checkov CKV2_AWS_11 still covers it). NETWORK_ACL_UNRESTRICTED_INGRESS has no working regression scenario (`vpc/permissive-network-acl/main.tf` is 0 bytes). The scenario README promises "bad IAM", but no IAM scenario exists.
- Rego syntax: pre-1.0 (`deny[msg] {`, `missing_tags(tags) = missing {`, `import future.keywords.in`). `opa check` / `--strict` pass on OPA 0.56.0, which conftest v0.45.0 bundles ("OPA: 0.56.0"). **OPA 1.0.0 `opa check` → 45 parse errors** (`if`/`contains` required); OK with `--v0-compatible`. Any conftest upgrade to a v1-default release breaks the gate. That would be fail-closed via the error payload.

## 5. Verification table

| Check | Command (in SP/tree-B) | Result | Tool version |
|---|---|---|---|
| pytest | `python3 -m pytest -q tests/` | **5 passed** in 0.38s | Python 3.11.15, pytest 9.1.1, PyYAML 6.0.1 |
| unittest (as CI would) | `python3 -m unittest` / `discover -s tests` | **Ran 0 tests** (no `__init__.py` in tests/compliance) | — |
| unittest direct | `python3 -m unittest discover -s tests/compliance -v` | 5 OK | — |
| bash -n | all `ci-cd/scripts/*.sh` + drift-check.sh | all OK (drift-check.sh is empty) | bash |
| py_compile | `ci-cd/scripts/*.py` | OK | — |
| shellcheck | `shellcheck ci-cd/scripts/*.sh` | 1 warning: SC2034 SUMMARY_FILE unused (evaluate-results.sh:11) | 0.11.0 |
| opa check | `opa check OPA/` and `--strict` | exit 0 | OPA 0.56.0 |
| opa check v1 | `opa1 check OPA/` | **45 errors** (rego_parse_error `if`/`contains`) | OPA 1.0.0 |
| opa fmt | `opa fmt --list OPA/` | **all 6 files** need formatting | OPA 0.56.0 |
| opa test / conftest verify | `opa test OPA/`; `conftest verify --policy OPA/` | 0 tests (no `*_test.rego`) | conftest 0.45.0 |
| actionlint | `actionlint -shellcheck= .github/workflows/*.yml` | 2 errors: invalid top-level `description:` (policy-check.yml:2, terraform-workflow.yml:2) | 1.7.7 |
| yamllint | `yamllint -d relaxed .github/ control-mapping.yaml` | errors: trailing spaces (drift-detection.yml:21,40; test.yml:88,93), no EOF newline (apply/action.yml:27); many line-length warnings | 1.38.0 |
| jq bug | decision/action.yml:30-41 under `bash -eo pipefail` | jq compile error; `schema_version=` empty; exit 0 | jq 1.7 |
| tfsec --out naming | `tfsec <dir> --format json --out X/tfsec-result` | writes `tfsec-result` (no .json), exit 1 when findings | tfsec v1.28.14 |
| sha256sum --ignore-missing | 4 cases | missing-summary OK exit 0; tamper+rehash OK exit 0; all missing → exit 1; no checksum file → exit 1 | coreutils 9.4 |
| checkov | `checkov -f plan.json --framework terraform_plan -o json` | see §6; missing plan → exit 0 + parsing_errors; `api0.prismacloud.io` blocked (403) → guideline fetch traceback on stderr, results unaffected | checkov 3.3.20 (CI unpinned) |
| terraform | A-terraform's plans (TF 1.7.5, aws 5.100.0, random 3.8.1, tls 4.2.1) + my probe/drift plans via `-plugin-dir SP/plugin-mirror` | OK | terraform 1.7.5 |

## 6. End-to-end local chain (same step order as CI; `SP/work-B/run-chain.sh`)

### ayka-portal (`SP/plans/ayka-portal.tfplan.json`, 87 creates + 2 reads)
- CI-equivalent (tfsec bug in place): **decision PASS**, HIGH 0 / MEDIUM 0 / LOW 14. 14 findings, all checkov, 14/14 mapped (100%). OPA 0 failures across 6 namespaces.
  `opa-result.json` 1271 B = CI 1079 B + 6×32 B path difference. Checkov summary: passed 208, failed 14, skipped 0, resource_count 87; all failed checks have `severity: null`.
  - By control: SECURITY_GROUP_UNUSED ×4 (CKV2_AWS_5, sg alb/ec2/ecs/rds), CLOUDWATCH_LOG_GROUP_KMS_ENCRYPTION ×3, S3_REPLICATION_DISABLED ×2, RDS_PERFORMANCE_INSIGHTS_ENCRYPTION, SECRETS_MANAGER_CMK_ENCRYPTION, SECRETS_MANAGER_ROTATION_DISABLED, SNS_TOPIC_KMS_ENCRYPTION, WAF_LOG4J_PROTECTION (CKV2_AWS_76). This **matches run #68 exactly**.
- With the real tfsec results (F1 fixed): **FAIL**, HIGH 3 / MEDIUM 1 / LOW 14, unmapped 3 (AVD-AWS-0053 ×1, AVD-AWS-0057 ×2).
- Outputs: `SP/chain/ayka-portal/output/*`, `evidence/raw/<ts>/*`, `evidence/artifacts.sha256`, `predicted-with-tfsec-summary.json`, `checkov-with-enrichment.json`.

### control-validation-scenarios (`SP/plans/scenarios.tfplan.json`, 6 creates; tfsec dir = ayka-portal as in CI)
- **decision FAIL**, HIGH 4 / MEDIUM 8 / LOW 17, total 29. checkov 23 (14 mapped / 9 unmapped), opa 6 (6 mapped), 68.97% mapped. **Matches run #68 exactly.**
- HIGH drivers: OPA EC2_MISSING_IMDSV2, EC2_OPEN_SSH, S3_PUBLIC_ACCESS; checkov CKV_AWS_382 → EC2_PUBLIC_EGRESS.
  MEDIUM: OPA S3_ENCRYPTION_MISSING ×2; checkov CKV_AWS_18 ×2, CKV_AWS_145 ×2, CKV_AWS_21 ×2. OPA LOW: EC2_MISSING_TAGS.
  Unmapped checkov (all LOW): CKV_AWS_79, 135, 8, 126, 24, CKV2_AWS_6 ×2, CKV_AWS_20, CKV2_AWS_41.
- OPA findings have `resource: null` (no metadata emitted).
- With tfsec on the correct dir: FAIL, HIGH 17 / MEDIUM 16 / LOW 21 (54; 11 unmapped).

### probe-blindspots (my own plan, outside repo: `SP/chain/probe-blindspots/{main.tf,mod/}`)
- Public SSH (standalone rule resources), root-module IMDSv1 EC2, `Action=["*"]` admin policy → **PASS**, 16 LOW (15 unmapped), OPA 0. With tfsec → FAIL.

## 7. Drift workflow

- `drift-detection.yml:33-45`: `terraform init -input=false` + `terraform plan -detailed-exitcode -out=drift.plan` (`continue-on-error: true`). `Report Drift` runs `if: steps.plan.outputs.exitcode == '2'` (the output comes from the setup-terraform wrapper) and `exit 1`s.
- ayka-portal has **no `backend` block** in any .tf (grep: 0 files), so the local backend on a fresh runner has no state. Nothing was ever applied either (run-apply.sh only echoes), so no state exists anywhere.
  Every resource is therefore "to add", plan exits 2, and the step reports "Drift detected" every night.
  Reproduced locally: `terraform plan -detailed-exitcode` in a copy → **exit 2, "Plan: 87 to add, 0 to change, 0 to destroy"**, no pre-existing tfstate. Matches D-codex: Report Drift ran and failed in 61/61 runs.
- The provider uses hardcoded mock keys + skip_* flags (ayka-portal/provider.tf:17-24). The OIDC creds are ignored, and with no state the plan never talks to AWS. So "drift" is purely "desired config vs empty local state", not real infra.
- Also `continue-on-error: true` + only checking `exitcode=='2'` means a plan **error** (exit 1) is reported green (fail-open). The workflow does not upload the plan or notify anyone. The `drift-detection/**` docs and script are empty files.

## 8. Pinning / supply-chain notes

- SHA-pinned: actions/checkout@b4ffde6 (v4.1.1) [terraform-workflow.yml:54,72,138; test.yml:28,51; drift:20]; configure-aws-credentials@5579c00 (v4.0.2) [terraform-workflow.yml:141; drift:28]; setup-terraform@a1502cd (v3.0.0) [apply/action.yml:19; drift:23]; download-artifact@65a9edc (v4.1.7); upload-artifact@26f96df (v4.3.0); setup-python@0a5c615 (v5.0.0).
- Tag-only: `aws-actions/configure-aws-credentials@v4` (plan/action.yml:24, the step that actually receives the OIDC token in every plan job), `hashicorp/setup-terraform@v3` (plan/action.yml:30; validate/action.yml:17), `terraform-linters/setup-tflint@v4` (validate/action.yml:22), `actions/checkout@v4` (policy-check.yml:18).
- `tflint_version: latest` (validate/action.yml:24); `pip install checkov` unpinned (check/action.yml:15), so results can change without a commit.
  Local checkov 3.3.20 reproduces run #68 exactly. tfsec v1.28.14 and conftest v0.45.0 are version-pinned but fetched by `wget` with **no checksum verification** (check/action.yml:18-20; policy/action.yml:11-13). tfsec itself prints "tfsec is joining the Trivy family" (deprecated).
- Terraform 1.7.5 is consistent, but apply/action.yml:21 and drift-detection.yml:25 hardcode it and ignore the `terraform_version` input.
- Hardcoded AWS account/role: `arn:aws:iam::982081090103:role/github-actions-oidc-role` at test.yml:16, test.yml:41, drift-detection.yml:31 (also passed via input to terraform-workflow.yml:78,144). The lead verified that the role is real and assumable. `permissions: id-token: write` is granted workflow-wide (test.yml:19-21; terraform-workflow.yml:45-47), including the `validate-scripts` job.
- `test.yml` runs on every push to every branch (`on: push`, no branch filter), so every push mints an OIDC token for that role. `apply` is gated by `ref == main` + environment `manual-apply-approval` (reviewers UNVERIFIED; run #68 apply started ~4 s after creation).
