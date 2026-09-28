# Lead-verified facts (cite these; they are verified by the lead)

## Git / GitHub (verified 2026-09-28 via git + GitHub API)
- main HEAD = 53b0532 "fix: align risk documentation baseline dates"; 373 tracked files (`git ls-files | wc -l`).
- Top-level tracked counts: Internal-IT 240, Governance 110, .github 11, organization 8, tests 1, README.md, LICENSE, .gitignore.
- GitHub branches: ONLY `main` (protected: false). `codex/pre-restore-ai-cleanup-20260823` does NOT exist on GitHub (list_branches + git ls-remote show only main + refs/pull/1..6/head).
- Workflows (GitHub API list_workflows):
  - PR Compliance Pipeline (.github/workflows/test.yml) — active
  - Terraform Compliance Workflow (terraform-workflow.yml) — active (reusable, workflow_call only)
  - Policy Check Workflow (policy-check.yml) — active (reusable, workflow_call only; NOT called by any workflow → UNUSED)
  - Scheduled Drift Detection (drift-detection.yml) — state `disabled_inactivity` (updated 2026-06-15). 61 scheduled runs, all recent ones `failure` (last run #61 2026-06-15). Logs expired (HTTP 410), so failure cause is inferred from code, not logs.
- test.yml run history: #68 (53b0532, 2026-08-23) SUCCESS, #67 (0a3c53b) SUCCESS, #66 (fe1b27e Revert) SUCCESS, #65 (243c3b1, 2026-04-15) SUCCESS, #62–#64 failure, #61 success.
  → The claim "last green run 15 Apr 2026" is OUTDATED: latest run on current HEAD is green: https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/32621618951
- test.yml triggers on `push` (all branches) + workflow_dispatch — NOT on pull_request despite the name "PR Compliance Pipeline" (test.yml:1-10).

## Run #68 evidence (job logs)
- ayka-portal (compliance job): decision=pass; HIGH 0 / MEDIUM 0 / LOW 14; 14 findings ALL checkov, 100% mapped; OPA 0 findings; tfsec absent from by_tool.
  Examples: CKV2_AWS_5 → SECURITY_GROUP_UNUSED (LOW) ×4 (module.security.aws_security_group.{alb,ec2,ecs,rds}); CKV2_AWS_76 → WAF_LOG4J_PROTECTION (LOW).
- scenarios (regression job): decision=fail; HIGH 4 / MEDIUM 8 / LOW 17; 29 findings: checkov 23 (14 mapped, 9 unmapped), opa 6 (all mapped). "Regression Decision: fail … SUCCESS".
- output/ listing in BOTH jobs: `tfsec-result` 4137 bytes AND `tfsec-result.json` 15 bytes → run-tfsec.sh:13-19 bug: tfsec writes to the literal `--out` path (`output/tfsec-result`), the script then sees no `.json` and writes the `{"results":[]}` fallback → **tfsec findings are silently dropped in every run (fail-open)**.
- Regression job env shows WORKLOAD_DIR=Internal-IT/workloads/ayka-portal (from test.yml:13) → run-tfsec.sh:9 scans ayka-portal in the regression job, not the scenarios dir. In the reusable workflow WORKLOAD_DIR is not set at all → default ayka-portal.
- decision/action.yml:38 jq quoting bug: log `jq: error: syntax error, unexpected INVALID_CHARACTER … .schema_version // \"unknown\"` → schema_version output empty; step still "success".
- Checksum: terraform-workflow.yml:96-105 sha256sum of output/tfplan.json + output/compliance-summary.json → evidence/artifacts.sha256. Upload (evidence/action.yml:23-32) includes evidence/, output/compliance-report.md, output/tfplan.json, output/tfplan.binary — NOT output/compliance-summary.json (only a copy under evidence/raw/<ts>/). Apply log: only `output/tfplan.json: OK` → summary skipped by `--ignore-missing` (run-apply.sh:14).
- The checksum file travels in the SAME artifact as the files it protects → detects accidental corruption, not deliberate tampering by someone who can rewrite the artifact.
- apply job ran on main (decision=pass) and started ~4 s after creation → environment `manual-apply-approval` apparently has NO required reviewers (UNVERIFIED — check repo Settings → Environments). run-apply.sh:24-27 only echoes "Apply complete! Resources: 14 added" (hardcoded; not real).
- OIDC: `Configure AWS credentials` succeeded in plan + apply + regression jobs; AWS_SESSION_TOKEN present → role `arn:aws:iam::982081090103:role/github-actions-oidc-role` is REAL and assumable from this repo (test.yml:16,41; drift-detection.yml:31). Terraform itself uses hardcoded mock keys (ayka-portal/provider.tf:19-20) so real creds are not used by terraform. Trust-policy scope + permissions of the role: UNKNOWN (owner must check).
- CI provider versions: aws v5.100.0, random v3.8.1, tls v4.2.1; terraform 1.7.5; Python 3.11.16.

## Secrets (values NEVER printed)
- Hardcoded string-literal `password =` in main:
  - Internal-IT/platform/domains/identity/entra-id/modules/core/users.tf:16 (literal, 16 chars)
  - Internal-IT/platform/domains/identity/entra-id/modules/privileged/break_glass.tf:6 (literal, 24 chars)
  - Internal-IT/platform/domains/identity/entra-id/modules/privileged/admin_accounts.tf:9 (literal, 17 chars)
- Governance/ISMS/03-risk-management/risk-register.md:21 (RISK-001) says "even though current source is clean" — FALSE for main (it was true for the reverted AI-cleanup state).

## Other tracked artifacts worth flagging
- Internal-IT/workloads/control-validation-scenarios/tfplan.binary (committed binary plan)
- Tracked tfvars: Internal-IT/platform/foundation/landing-zone/enterprise_strict.tfvars, Internal-IT/workloads/ayka-portal/envs/dev.tfvars
- Risk docs link to `AUDIT/…` (untracked local folder) → broken links on GitHub: risk-register.md:15, risk-management-methodology.md:36,167-169, 2026-q1-risk-assessment.md:19-20.
- Risk register cites "124 Checkov failures" (RISK-009, risk-register.md:29) but CI on main shows 14 (ayka-portal) — number comes from a different state/scan (UNVERIFIED which).

## Evaluator / OPA code facts (lead read)
- evaluate-results.py:417-421: HIGH>0 → fail; elif MEDIUM>0 → approval_required; else pass. exit 1 only on fail (453-454).
- normalize_severity (48-54): CRITICAL→HIGH; unknown/None → LOW. Unmapped checkov/tfsec keep scanner severity (137-148) → open-source checkov usually has severity null → LOW → unmapped checkov findings can never block (fail-open for unknown checks).
- Unmapped OPA → MEDIUM (179-188, 208-217).
- Fail-closed paths: missing file (evaluate-results.sh:13-18), bad JSON (load_json 32-37), OPA error payload (282-285), non-list OPA (287-289).
- OPA rules (OPA/terraform/*.rego) iterate only `input.planned_values.root_module.child_modules[_].resources` (e.g. aws_ec2.rego:7) → root-module resources (e.g. ayka-portal/kms.tf) and nested modules are invisible to OPA.
- aws_s3.rego:4-14 S3_PUBLIC_ACCESS: bucket and ACL are not linked (any public-read ACL in the module flags every bucket in it).
- aws_vpc.rego:18,30 flow-logs rule compares `vpc.values.id` / `fl.values.resource_id`, which are unknown at plan time; ROUTE_TABLE_PUBLIC_IGW (aws_vpc.rego:41) needs `gateway_id` known → both effectively cannot evaluate correctly on a fresh plan (UNVERIFIED exact behaviour).
- OPA/aws/{s3,ec2}.rego use `input.buckets` / `input.instances` (not plan JSON) → never fire on a plan; they ARE loaded because run-policy-check.sh:14 passes the whole OPA dir with --all-namespaces. Dead code. s3.rego:8 typo "publicy".
- All rego uses pre-1.0 syntax (`deny[msg] {`) → requires conftest/OPA < 1.0 or --v0-compatible (conftest v0.45.0 pinned in policy/action.yml:11).
- control-validation-scenarios/main.tf uses `count = contains(var.enabled_scenarios, …)` per module.
- ayka-portal/provider.tf:17-33 mock keys + skip_* flags; default_tags.
