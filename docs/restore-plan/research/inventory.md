# C-inventory findings — Ayka-Secure-Technologies-GmbH @ main 53b0532

Scope: every tracked path on `main` = `53b0532` (373 entries; verified byte-for-byte against `git ls-tree -r main`, same blob SHAs).
Machine-readable: `findings/inventory.tsv` (header + 373 rows; columns `path mode bytes lines nonblank status top_folder area note` — first 7 are the requested schema, `area`/`note` appended).
`lines` = newline count (+1 if last line unterminated); `nonblank` = lines with non-whitespace. Blobs read from git objects, not the worktree.

NOTE: while this research ran, the local checkout was switched to `plan/restore-2026` and commit `b3169ec docs(plan): add how-it-works study guide` (adds `docs/restore-plan/how-it-works.md`, pushed to origin) appeared. It is NOT part of this inventory. `main`/`origin/main` are still `53b0532`.

Status rules: `empty` = 0 bytes or whitespace only · `title-only` = ≤3 non-blank lines, all Markdown headings · `stub` = hand-judged thin doc (topic list / stale tree / generic outline), see notes · `symlink` = mode 120000 · `binary` = non-UTF-8 blob · `substantive` = everything else (includes small but real code/config).

---

## 1. Git facts

| Claim | Command | Actual |
|---|---|---|
| 373 tracked files | `git ls-files \| wc -l` | **373** ✔ |
| HEAD 53b0532 | `git rev-parse --short HEAD` | **53b0532** ✔ (main = origin/main = 53b0532d364f…) |
| History size | `git log --oneline \| wc -l` / `--all` | **65 commits** (65 with --all), 6 merge commits (PR #1–#6), single author (you) |
| First / last commit | `git log --reverse` | first **89db3df 2026-03-22 "gitignore cleanup"**; last **53b0532 2026-08-23 11:26 +0530** |
| Root commits | `git rev-list --max-parents=0 --all` | **3 roots**: 89db3df, 7a2f667 (2026-03-22), fcbb603 (2026-03-25) — unrelated histories merged via PR #2/#3 (each re-added the whole 211-file tree) |
| Activity gap | log dates | 2026-04-16 (243c3b1) → 2026-08-23 (fe1b27e): **no commits for ~4 months**; the last 3 commits are all 2026-08-23 and touch only Governance/ + .gitignore |
| fe1b27e "Revert: cleanup" | `git show --name-status fe1b27e` | **NOT a git revert** (no "This reverts commit" body; parent 243c3b1). 89 files, +100/−2: **84 files ADDED** (all one-line `# Title` Governance/ISMS/*.md; none of the 84 ever existed in history before), **5 MODIFIED**: `.gitignore` (+`annotations`, `graphify-out`, `AUDIT/`), `Governance/ISMS/tree.md` (+9/−2), and 3 previously-empty files given a title (`Governance/ISMS/README.md`, `04-controls-and-soa/access-control-evidence-index.md`, `04-controls-and-soa/privileged-access-justification.md`). Governance/ went from **26 files @243c3b1 → 110 @HEAD**. |
| 0a3c53b "add: risk documentation" | `git show --stat` | 8 files under `Governance/ISMS/03-risk-management/`, +567/−173 (7 title-only files filled; `risk-management-methodology.md` rewritten 289 lines changed) |
| 53b0532 "fix: align risk documentation baseline dates" | `git show --stat` | same 8 files, +16/−8 (one metadata line each → "Historical baseline: 2026-04-16") |
| Code unchanged since April | `git diff --stat 243c3b1 53b0532 -- tests .github Internal-IT organization` | **empty** — all code/config is byte-identical to 243c3b1 |
| `codex/pre-restore-ai-cleanup-20260823` exists | `git ls-remote origin`, `git branch -a`, `git cat-file -t f68766c` | **Does NOT exist** on remote (ls-remote = HEAD, refs/heads/main, refs/pull/1..6/head only) nor locally; `f68766c` → "Not a valid object name". Confirms your belief. (Locally there are also `claude/gallant-thompson-thia82` and now `plan/restore-2026` — session branches, not owner branches.) |
| `.env` / tfstate / pem / id_rsa ever committed | `git log --all --name-only \| grep -E '\.env$\|tfstate\|tfvars\|\.pem$\|id_rsa\|\.key$\|credentials'` | **No .env, no *.tfstate, no .pem/.key/id_rsa ever.** tfvars YES: `Internal-IT/platform/foundation/landing-zone/enterprise_strict.tfvars` (3 commits), `Internal-IT/workloads/ayka-portal/envs/dev.tfvars` (1) — both still tracked. Also `output/tfplan.json` + `output/opa-result.json` were committed and deleted in 3d9a0aa (2026-04-13). `tfplan.binary` (a plan zip that embeds `tfstate`/`tfstate-prev`, 144 B each, empty state) is still tracked. |
| AWS access keys in history | `git log -p --all \| grep -cE 'AKIA[0-9A-Z]{16}'` | **0** (also 0 in tree; 0 `BEGIN … PRIVATE KEY` in history) |
| Literal credential assignments ever added | `git log -p --all` scan for `+… (password\|secret_key\|access_key\|client_secret) = "…"` | only the 3 Entra files (added in each root commit 89db3df / 7a2f667 / fcbb603 — same value hashes, never changed) + `ayka-portal/provider.tf` mock keys (83004ae). Nothing was ever removed. |

`.gitignore` (121 lines) observations:
- `tree.md` (l.68) ignores a file that IS tracked (`Governance/ISMS/tree.md`); `output/` (l.39) matches the Terraform module dir `Internal-IT/platform/domains/identity/entra-id/modules/output/` (tracked `compliance.tf`); `*.binary` (l.36) matches the force-tracked `tfplan.binary`. `git ls-files -i -c --exclude-standard` lists exactly these 3.
- `AUDIT/`, `annotations`, `graphify-out` (l.21-23, added by fe1b27e) → the risk docs link into `AUDIT/`, which can therefore never exist on GitHub.
- Personal scratch files ignored (l.25-30: `todolater.md`, `pipelinefix.md`, `plan.md`, `futureplan.md`, `context.md`, `Compliancelisting.md`).
- Only `terraform.tfvars`/`*.auto.tfvars` ignored, not `*.tfvars` → the two tfvars above are tracked. Lock files deliberately tracked (`#.terraform.lock.hcl`, l.5).
- l.120-121 `!.github/` negations are no-ops. `!**/evidence/.gitkeep` (l.100) references a file that doesn't exist.
- A nested `Internal-IT/platform/domains/identity/entra-id/.gitignore` (27 lines) additionally ignores `.terraform.lock.hcl` and `*.tfvars` for that root.

---

## 2. Status totals

**Overall (373): substantive 203 · empty 75 · title-only 80 · stub 12 · symlink 2 · binary 1.**
empty + title-only = **155**; + stubs = **167**.

By top-level folder:

| Top folder | files | empty | title-only | stub | symlink | binary | substantive |
|---|---:|---:|---:|---:|---:|---:|---:|
| (root: README.md, LICENSE, .gitignore) | 3 | 0 | 0 | 0 | 0 | 0 | 3 |
| .github | 11 | 0 | 0 | 0 | 0 | 0 | 11 |
| Governance | 110 | 8 | 80 | 7 | 0 | 0 | 15 |
| Internal-IT | 240 | 64 | 0 | 5 | 2 | 1 | 168 |
| organization | 8 | 3 | 0 | 0 | 0 | 0 | 5 |
| tests | 1 | 0 | 0 | 0 | 0 | 0 | 1 |
| **TOTAL** | **373** | **75** | **80** | **12** | **2** | **1** | **203** |

By area:

| Area | files | empty | title-only | stub | symlink | binary | substantive |
|---|---:|---:|---:|---:|---:|---:|---:|
| (root files) | 3 | 0 | 0 | 0 | 0 | 0 | 3 |
| .github | 11 | 0 | 0 | 0 | 0 | 0 | 11 |
| Governance/(top files) | 4 | 1 | 0 | 3 | 0 | 0 | 0 |
| Governance/GDPR | 6 | 4 | 0 | 0 | 0 | 0 | 2 |
| Governance/ISMS/(files) | 2 | 0 | 1 | 0 | 0 | 0 | 1 |
| Governance/ISMS/00-context-and-governance | 10 | 0 | 8 | 0 | 0 | 0 | 2 |
| Governance/ISMS/01-organization | 9 | 0 | 9 | 0 | 0 | 0 | 0 |
| Governance/ISMS/02-asset-management | 7 | 0 | 7 | 0 | 0 | 0 | 0 |
| Governance/ISMS/03-risk-management | 8 | 0 | 0 | 0 | 0 | 0 | 8 |
| Governance/ISMS/04-controls-and-soa | 7 | 0 | 6 | 0 | 0 | 0 | 1 |
| Governance/ISMS/05-operational-policies | 17 | 0 | 17 | 0 | 0 | 0 | 0 |
| Governance/ISMS/06-operational-procedures | 12 | 0 | 12 | 0 | 0 | 0 | 0 |
| Governance/ISMS/07-technical-evidence | 7 | 3 | 4 | 0 | 0 | 0 | 0 |
| Governance/ISMS/08-monitoring-and-measurement | 5 | 0 | 5 | 0 | 0 | 0 | 0 |
| Governance/ISMS/09-internal-audit | 3 | 0 | 3 | 0 | 0 | 0 | 0 |
| Governance/ISMS/10-management-review | 4 | 0 | 4 | 0 | 0 | 0 | 0 |
| Governance/ISMS/11-improvement | 4 | 0 | 4 | 0 | 0 | 0 | 0 |
| Governance/architecture | 5 | 0 | 0 | 4 | 0 | 0 | 1 |
| Internal-IT/assurance | 19 | 19 | 0 | 0 | 0 | 0 | 0 |
| Internal-IT/engineering/(files) | 1 | 1 | 0 | 0 | 0 | 0 | 0 |
| Internal-IT/engineering/ci-cd | 33 | 18 | 0 | 0 | 2 | 0 | 13 |
| Internal-IT/engineering/drift-detection | 4 | 4 | 0 | 0 | 0 | 0 | 0 |
| Internal-IT/engineering/policy-as-code | 8 | 0 | 0 | 0 | 0 | 0 | 8 |
| Internal-IT/platform/(files) | 4 | 2 | 0 | 1 | 0 | 0 | 1 |
| Internal-IT/platform/deployments | 1 | 0 | 0 | 1 | 0 | 0 | 0 |
| Internal-IT/platform/domains | 50 | 2 | 0 | 0 | 0 | 0 | 48 |
| Internal-IT/platform/foundation | 56 | 1 | 0 | 3 | 0 | 0 | 52 |
| Internal-IT/platform/operations | 7 | 7 | 0 | 0 | 0 | 0 | 0 |
| Internal-IT/workloads/(files) | 1 | 0 | 0 | 0 | 0 | 0 | 1 |
| Internal-IT/workloads/ayka-portal | 30 | 0 | 0 | 0 | 0 | 0 | 30 |
| Internal-IT/workloads/control-validation-scenarios | 26 | 10 | 0 | 0 | 0 | 1 | 15 |

### Claim checks (inventory)

| Claim | Actual |
|---|---|
| "Governance/: 110 files, ~90 ≤3 lines" | **110 ✔; 89** have ≤3 non-blank lines (8 empty + 80 title-only + `Governance/architecture/README.md` 3-line pointer). Only **15** Governance files are substantive (8 of them are the 03-risk-management set). |
| "Internal-IT/assurance/: 19 files, 0 lines" | **19 ✔, all empty.** 18 are 0 bytes; `audit-support/sample-audit-session.md` is 2 bytes of whitespace (1 line). Total 2 bytes. |
| "14 empty duplicate YAMLs in Internal-IT/engineering/ci-cd/pipelines/" | **14 ✔** (code-security 2, compliance 3, core 4, drift 1, release 4), all 0 bytes, same blob e69de29. "Duplicate" only in the sense that they shadow `.github/workflows` + `.github/actions`; no workflow/script references them (only prose in `ci-cd/architecture.md:5-9` and `platform/structure.md`). |
| "symlinks in ci-cd/templates/" | **2 ✔**: `templates/policy-check.yml -> ../../../../.github/workflows/policy-check.yml`, `templates/terraform-workflow.yml -> ../../../../.github/workflows/terraform-workflow.yml`; both targets exist. |
| "some empty .tf files" | **8 ✔**: `entra-id/modules/output/compliance.tf` (1-byte newline), `entra-id/modules/privileged/governance_authorities.tf`, `foundation/remote-state/variables.tf`, scenarios `ec2/open-ssh-security-group/variables.tf`, `s3/public-bucket/variables.tf`, `shared/variables.tf`, `vpc/permissive-network-acl/main.tf`, `vpc/permissive-network-acl/variables.tf`. |
| "empty evidence .txt files and penetration-test-report.md" | ✔ `Governance/ISMS/07-technical-evidence/iam/{aws-iam-role-list,identity-center-groups,terraform-plan-iam}.txt` are 0 bytes; `07-technical-evidence/penetration-test-report.md` is title-only (`# Penetration Test Report`, not 0 bytes). |
| "Platform_Complilance.md filename typo" | ✔ `Internal-IT/platform/foundation/Platform_Complilance.md` (91 non-blank lines, substantive). `Internal-IT/platform/structure.md` refers to it as `Platform_Compliance.md`. |
| "~160 tracked files empty or title-only" | **155** strictly (75 empty + 80 title-only); **167** incl. 12 stubs. "~160" is fair. |

### Structural dependencies — empty files that must NOT be deleted blindly
- `Internal-IT/platform/domains/identity/entra-id/modules/output/compliance.tf` is the ONLY file in a module dir referenced by `entra-id/main.tf:28-30` (`module "output" { source = "./modules/output" }`). Deleting it breaks `terraform init` for entra-id unless the module block is removed too.
- `Internal-IT/workloads/control-validation-scenarios/vpc/permissive-network-acl/` is referenced by `control-validation-scenarios/main.tf:21-24` and advertised in its README (l.15-35 list `vpc_permissive_network_acl`), but `main.tf` + `variables.tf` + `README.md` are empty — only `versions.tf` is real. The scenario is a **no-op** (declares no resources). Delete-the-dir requires editing root `main.tf`; better: implement it or drop it from main.tf + README.
- `control-validation-scenarios/shared/` (versions.tf 3 lines + empty variables.tf) is not referenced by any module block → dead dir.
- Empty `variables.tf` inside module dirs that also contain a real `main.tf`/`versions.tf` are safe to delete.
- No workflow, script or test references any empty file by path (checked every empty path with `git grep -F`).


---

## 3. Every empty / title-only / stub file, grouped by folder

(Deletion input. Also filterable from inventory.tsv column `status`. Mind the structural dependencies listed above.)
### empty (75)

- `Governance/` (1): `company-security-roadmap.md`
- `Governance/GDPR/` (4): `data-processing-register.md`, `data-retention-policy.md`, `data-subject-rights.md`, `privacy-impact-assessment.md`
- `Governance/ISMS/07-technical-evidence/iam/` (3): `aws-iam-role-list.txt`, `identity-center-groups.txt`, `terraform-plan-iam.txt`
- `Internal-IT/assurance/` (1): `README.md`
- `Internal-IT/assurance/audit-support/` (4): `audit-logs-index.md`, `evidence-guide.md`, `sample-audit-session.md` (2B ws), `walkthrough.md`
- `Internal-IT/assurance/audit-support/auditor-requests/` (3): `access-control-sample.md`, `encryption-control-sample.md`, `incident-response-sample.md`
- `Internal-IT/assurance/evidence/` (1): `README.md`
- `Internal-IT/assurance/integrity/` (3): `evidence-handling.md`, `immutability-notes.md`, `retention-policy.md`
- `Internal-IT/assurance/metrics/` (2): `compliance-dashboard.md`, `security-kpis.md`
- `Internal-IT/assurance/reports/compliance-reports/` (2): `control-effectiveness.md`, `iso27001-readiness.md`
- `Internal-IT/assurance/reports/drift-reports/` (1): `infra-drift-summary.md`
- `Internal-IT/assurance/reports/security-reports/` (2): `incident-summary.md`, `monthly-security-summary.md`
- `Internal-IT/engineering/` (1): `.pre-commit-config.yaml`
- `Internal-IT/engineering/ci-cd/` (1): `README.md`
- `Internal-IT/engineering/ci-cd/compliance-gates/` (1): `failure-handling.md`
- `Internal-IT/engineering/ci-cd/compliance-gates/approvals/` (2): `change-justification-template.md`, `prod-approval-policy.md`
- `Internal-IT/engineering/ci-cd/pipelines/code-security/` (2): `iam-diff-check.yml`, `secrets-scan.yml`
- `Internal-IT/engineering/ci-cd/pipelines/compliance/` (3): `checkov.yml`, `opa-check.yml`, `tfsec.yml`
- `Internal-IT/engineering/ci-cd/pipelines/core/` (4): `apply.yml`, `destroy.yml`, `plan.yml`, `validate.yml`
- `Internal-IT/engineering/ci-cd/pipelines/drift/` (1): `drift-detection.yml`
- `Internal-IT/engineering/ci-cd/pipelines/release/` (4): `emergency-bypass.yml`, `promote-prod.yml`, `promote-stage.yml`, `rollback.yml`
- `Internal-IT/engineering/drift-detection/alerting/` (2): `drift-alerting.md`, `integration.md`
- `Internal-IT/engineering/drift-detection/terraform-drift/` (2): `detection-strategy.md`, `drift-check.sh`
- `Internal-IT/platform/` (2): `README.md`, `architecture.md`
- `Internal-IT/platform/domains/identity/entra-id/modules/output/` (1): `compliance.tf` (1B ws)
- `Internal-IT/platform/domains/identity/entra-id/modules/privileged/` (1): `governance_authorities.tf`
- `Internal-IT/platform/foundation/remote-state/` (1): `variables.tf`
- `Internal-IT/platform/operations/change-management/` (2): `change-policy.md`, `rollout-strategy.md`
- `Internal-IT/platform/operations/incident-response/scenarios/` (3): `compromised-iam-user.md`, `guardduty-crypto-miner.md`, `s3-data-exfiltration.md`
- `Internal-IT/platform/operations/monitoring/` (2): `alerting-strategy.md`, `dashboard.md`
- `Internal-IT/workloads/control-validation-scenarios/ec2/no-imdsv2/` (1): `README.md`
- `Internal-IT/workloads/control-validation-scenarios/ec2/open-ssh-security-group/` (2): `README.md`, `variables.tf`
- `Internal-IT/workloads/control-validation-scenarios/s3/missing-encryption/` (1): `README.md`
- `Internal-IT/workloads/control-validation-scenarios/s3/public-bucket/` (2): `README.md`, `variables.tf`
- `Internal-IT/workloads/control-validation-scenarios/shared/` (1): `variables.tf`
- `Internal-IT/workloads/control-validation-scenarios/vpc/permissive-network-acl/` (3): `README.md`, `main.tf`, `variables.tf`
- `organization/` (3): `acceptable-use-policy.md`, `security-steering-committee.md`, `vendor-management.md`

### title-only (80)

- `Governance/ISMS/` (1): `README.md`
- `Governance/ISMS/00-context-and-governance/` (8): `context-of-organization.md`, `document-control-procedure.md`, `document-register.md`, `interested-parties.md`, `isms-objectives.md`, `legal-and-regulatory-requirements.md`, `management-commitment-statement.md`, `record-retention-policy.md`
- `Governance/ISMS/01-organization/` (7): `competence-matrix.md`, `disciplinary-process.md`, `onboarding-offboarding-procedure.md`, `org-chart.md`, `personnel-register.md`, `roles-and-responsibilities.md`, `training-and-awareness-program.md`
- `Governance/ISMS/01-organization/confidentiality-agreements/` (2): `signed-nda-index.md`, `template-nda.md`
- `Governance/ISMS/02-asset-management/` (7): `acceptable-use-policy.md`, `asset-classification-policy.md`, `asset-inventory.md`, `asset-ownership-register.md`, `asset-return-checklist.md`, `mobile-device-policy.md`, `remote-work-policy.md`
- `Governance/ISMS/04-controls-and-soa/` (6): `access-control-evidence-index.md`, `control-gap-analysis.md`, `control-mapping-to-internal-it.md`, `justification-for-exclusions.md`, `privileged-access-justification.md`, `statement-of-applicability.md`
- `Governance/ISMS/05-operational-policies/` (17): `access-control-policy.md`, `backup-policy.md`, `change-management-policy.md`, `clean-desk-and-clear-screen-policy.md`, `cloud-security-policy.md`, `data-protection-policy.md`, `data-retention-policy.md`, `encryption-policy.md`, `incident-response-policy.md`, `logging-and-monitoring-policy.md`, `mfa-policy.md`, `password-policy.md`, `patch-management-policy.md`, `privileged-access-policy.md`, `secure-development-policy.md`, `supplier-security-policy.md`, `vulnerability-management-policy.md`
- `Governance/ISMS/06-operational-procedures/` (12): `access-review-procedure.md`, `backup-and-restore-procedure.md`, `business-continuity-procedure.md`, `change-management-procedure.md`, `corrective-action-procedure.md`, `data-breach-notification-procedure.md`, `disaster-recovery-procedure.md`, `incident-response-procedure.md`, `patch-deployment-procedure.md`, `supplier-onboarding-procedure.md`, `user-access-procedure.md`, `vulnerability-scanning-procedure.md`
- `Governance/ISMS/07-technical-evidence/` (4): `control-evidence-index.md`, `internal-it-mapping.md`, `penetration-test-report.md`, `terraform-module-mapping.md`
- `Governance/ISMS/08-monitoring-and-measurement/` (3): `kpi-and-metrics.md`, `security-metrics-dashboard.md`, `supplier-performance-review.md`
- `Governance/ISMS/08-monitoring-and-measurement/monitoring-results/` (2): `q1-monitoring.md`, `q2-monitoring.md`
- `Governance/ISMS/09-internal-audit/` (3): `audit-findings-log.md`, `audit-plan-2026.md`, `audit-programme.md`
- `Governance/ISMS/10-management-review/` (4): `management-review-action-items.md`, `management-review-agenda.md`, `management-review-minutes-q1.md`, `management-review-minutes-q2.md`
- `Governance/ISMS/11-improvement/` (4): `corrective-action-log.md`, `improvement-register.md`, `lessons-learned-log.md`, `nonconformity-log.md`

### stub (12)

- `Governance/` (3): `security-architecture.md`, `security-operating-model.md`, `vendor-risk-management.md`
- `Governance/architecture/` (4): `README.md`, `platform-architecture.md`, `security-control-model.md`, `system-overview.md`
- `Internal-IT/platform/` (1): `CONTROL-PLANE.md`
- `Internal-IT/platform/deployments/` (1): `platform-rollout.md`
- `Internal-IT/platform/foundation/` (1): `README.md`
- `Internal-IT/platform/foundation/landing-zone/modules/siem/` (1): `elastic-siem.md`
- `Internal-IT/platform/foundation/remote-state/` (1): `README.md`

  - `Governance/architecture/README.md` [3 nb] — 3-line pointer to system-overview.md
  - `Governance/architecture/platform-architecture.md` [6 nb] — 6 account names inside a /* */ comment
  - `Governance/architecture/security-control-model.md` [4 nb] — 4-line bullet list
  - `Governance/architecture/system-overview.md` [17 nb] — bare bullet outline, no prose
  - `Governance/security-architecture.md` [6 nb] — 6 topic words, no content
  - `Governance/security-operating-model.md` [5 nb] — 5 unanswered questions
  - `Governance/vendor-risk-management.md` [4 nb] — 4 vendor names only
  - `Internal-IT/platform/CONTROL-PLANE.md` [14 nb] — generic headings + one-liners; Detection/Response planes do not exist
  - `Internal-IT/platform/deployments/platform-rollout.md` [19 nb] — phase outline; phases 3-5 (network/detection/response) not implemented
  - `Internal-IT/platform/foundation/README.md` [28 nb] — stale tree (cloud-platform/, ou-structure/ at top, security-account.tf etc. do not exist)
  - `Internal-IT/platform/foundation/landing-zone/modules/siem/elastic-siem.md` [23 nb] — tree of an elastic-siem-lab whose files do not exist
  - `Internal-IT/platform/foundation/remote-state/README.md` [5 nb] — 5 bullets unrelated to remote-state



---

## 4. Symlinks

| Path | Target | Target exists |
|---|---|---|
| `Internal-IT/engineering/ci-cd/templates/policy-check.yml` | `../../../../.github/workflows/policy-check.yml` | yes (policy-check.yml is itself unused per FACTS-lead) |
| `Internal-IT/engineering/ci-cd/templates/terraform-workflow.yml` | `../../../../.github/workflows/terraform-workflow.yml` | yes |

Added by 7965f17 "symlink fix" (2026-04-15). They only mirror `.github/workflows`; nothing references `templates/`.

---

## 5. Short-but-meaningful files (≤15 non-blank lines, real content — do NOT bulk-delete)

75 substantive files + 2 symlinks. Mostly Terraform plumbing (provider/versions/variables/outputs), small scripts, OPA policies, SCP JSON, tfvars. Also keep in mind files >15 lines that look like config but are essential: `.gitignore` (112 nb), `Internal-IT/platform/domains/identity/entra-id/.gitignore`, 7× `.terraform.lock.hcl`.
Notable judgement calls: `Internal-IT/engineering/policy-as-code/OPA/aws/{ec2,s3}.rego` are small but **dead** (they read `input.instances`/`input.buckets`, never plan JSON — FACTS-lead); `Internal-IT/engineering/policy-as-code/metadata/README.md` is real text but points to a non-existent file; `landing-zone/modules/core/docs/remediation.md` is a genuine 5-step root-hardening checklist; `domains/identity/docs/scim.md` (19 nb) and `entra-id/provisioning.md` (20 nb) are real manual procedures; `ci-cd/architecture.md` is real prose but describes the 14 empty pipeline YAMLs.

- `.github/actions/policy/action.yml` [15 nb]
- `Internal-IT/engineering/ci-cd/architecture.md` [9 nb]
- `Internal-IT/engineering/ci-cd/scripts/run-checkov.sh` [13 nb]
- `Internal-IT/engineering/ci-cd/scripts/run-cost-check.sh` [12 nb]
- `Internal-IT/engineering/ci-cd/scripts/run-tfsec.sh` [15 nb]
- `Internal-IT/engineering/ci-cd/templates/policy-check.yml` [1 nb] — -> ../../../../.github/workflows/policy-check.yml
- `Internal-IT/engineering/ci-cd/templates/terraform-workflow.yml` [1 nb] — -> ../../../../.github/workflows/terraform-workflow.yml
- `Internal-IT/engineering/policy-as-code/OPA/aws/ec2.rego` [9 nb]
- `Internal-IT/engineering/policy-as-code/OPA/aws/s3.rego` [9 nb]
- `Internal-IT/engineering/policy-as-code/metadata/README.md` [9 nb] — points to ../active/control-mapping.yaml which does not exist
- `Internal-IT/platform/domains/identity/aws-iam-core/provider.tf` [11 nb]
- `Internal-IT/platform/domains/identity/aws-iam-core/variables.tf` [8 nb]
- `Internal-IT/platform/domains/identity/aws-identity-center/backend.tf` [9 nb]
- `Internal-IT/platform/domains/identity/aws-identity-center/groups.tf` [10 nb]
- `Internal-IT/platform/domains/identity/aws-identity-center/provider.tf` [11 nb]
- `Internal-IT/platform/domains/identity/aws-identity-center/sso-settings.tf` [6 nb]
- `Internal-IT/platform/domains/identity/aws-identity-center/variables.tf` [3 nb]
- `Internal-IT/platform/domains/identity/entra-id/modules/core/group_roles.tf` [13 nb]
- `Internal-IT/platform/domains/identity/entra-id/modules/core/groups_tiers.tf` [12 nb]
- `Internal-IT/platform/domains/identity/entra-id/modules/core/outputs.tf` [9 nb]
- `Internal-IT/platform/domains/identity/entra-id/modules/core/users.tf` [13 nb] — hardcoded password literal line 16
- `Internal-IT/platform/domains/identity/entra-id/modules/privileged/break_glass.tf` [12 nb] — hardcoded password literal line 6
- `Internal-IT/platform/domains/identity/entra-id/modules/privileged/outputs.tf` [3 nb]
- `Internal-IT/platform/domains/identity/entra-id/modules/privileged/variables.tf` [3 nb]
- `Internal-IT/platform/domains/identity/entra-id/modules/security/conditional_access/variables.tf` [9 nb]
- `Internal-IT/platform/domains/identity/entra-id/variables.tf` [9 nb]
- `Internal-IT/platform/foundation/aws-organization/README.md` [12 nb]
- `Internal-IT/platform/foundation/aws-organization/main.tf` [9 nb]
- `Internal-IT/platform/foundation/aws-organization/modules/ou-structure/README.md` [12 nb]
- `Internal-IT/platform/foundation/aws-organization/modules/ou-structure/ous.tf` [15 nb]
- `Internal-IT/platform/foundation/aws-organization/modules/ou-structure/outputs.tf` [9 nb]
- `Internal-IT/platform/foundation/aws-organization/modules/scp/README.md` [7 nb]
- `Internal-IT/platform/foundation/aws-organization/modules/scp/attachment.tf` [15 nb]
- `Internal-IT/platform/foundation/aws-organization/modules/scp/deny-disable-cloudtrail.json` [15 nb]
- `Internal-IT/platform/foundation/aws-organization/organization.tf` [4 nb]
- `Internal-IT/platform/foundation/aws-organization/outputs.tf` [6 nb]
- `Internal-IT/platform/foundation/aws-organization/provider.tf` [3 nb]
- `Internal-IT/platform/foundation/landing-zone/README.md` [12 nb]
- `Internal-IT/platform/foundation/landing-zone/enterprise_strict.tfvars` [15 nb] — tracked tfvars with 3 AWS account IDs (lines 5-7)
- `Internal-IT/platform/foundation/landing-zone/locals.tf` [5 nb]
- `Internal-IT/platform/foundation/landing-zone/modules/account_landing_zone/outputs.tf` [8 nb]
- `Internal-IT/platform/foundation/landing-zone/modules/account_landing_zone/versions.tf` [7 nb]
- `Internal-IT/platform/foundation/landing-zone/modules/break_glass/variables.tf` [4 nb]
- `Internal-IT/platform/foundation/landing-zone/modules/core/alerts/outputs.tf` [3 nb]
- `Internal-IT/platform/foundation/landing-zone/modules/core/alerts/sns.tf` [14 nb]
- `Internal-IT/platform/foundation/landing-zone/modules/core/docs/remediation.md` [6 nb]
- `Internal-IT/platform/foundation/landing-zone/modules/core/iam/root_protection.tf` [10 nb]
- `Internal-IT/platform/foundation/landing-zone/modules/core/logging/outputs.tf` [4 nb]
- `Internal-IT/platform/foundation/landing-zone/modules/core/outputs.tf` [8 nb]
- `Internal-IT/platform/foundation/landing-zone/modules/core/s3/public_access_block.tf` [9 nb]
- `Internal-IT/platform/foundation/landing-zone/modules/core/variables.tf` [9 nb]
- `Internal-IT/platform/foundation/landing-zone/modules/cost_controls/variables.tf` [9 nb]
- `Internal-IT/platform/foundation/landing-zone/modules/quotas/main.tf` [6 nb]
- `Internal-IT/platform/foundation/landing-zone/modules/quotas/variables.tf` [5 nb]
- `Internal-IT/platform/foundation/landing-zone/modules/siem/variables.tf` [9 nb]
- `Internal-IT/platform/foundation/remote-state/provider.tf` [13 nb]
- `Internal-IT/workloads/ayka-portal/envs/dev.tfvars` [14 nb] — tracked tfvars (no secrets; placeholder AMI)
- `Internal-IT/workloads/ayka-portal/modules/compute/outputs.tf` [12 nb]
- `Internal-IT/workloads/ayka-portal/modules/compute/versions.tf` [13 nb]
- `Internal-IT/workloads/ayka-portal/modules/database/outputs.tf` [7 nb]
- `Internal-IT/workloads/ayka-portal/modules/database/versions.tf` [13 nb]
- `Internal-IT/workloads/ayka-portal/modules/networking/outputs.tf` [12 nb]
- `Internal-IT/workloads/ayka-portal/modules/networking/versions.tf` [9 nb]
- `Internal-IT/workloads/ayka-portal/modules/security/variables.tf` [12 nb]
- `Internal-IT/workloads/ayka-portal/modules/security/versions.tf` [9 nb]
- `Internal-IT/workloads/ayka-portal/modules/storage/outputs.tf` [6 nb]
- `Internal-IT/workloads/ayka-portal/modules/storage/variables.tf` [9 nb]
- `Internal-IT/workloads/ayka-portal/modules/storage/versions.tf` [9 nb]
- `Internal-IT/workloads/control-validation-scenarios/ec2/no-imdsv2/main.tf` [8 nb]
- `Internal-IT/workloads/control-validation-scenarios/ec2/no-imdsv2/versions.tf` [9 nb]
- `Internal-IT/workloads/control-validation-scenarios/ec2/open-ssh-security-group/versions.tf` [9 nb]
- `Internal-IT/workloads/control-validation-scenarios/s3/missing-encryption/main.tf` [10 nb]
- `Internal-IT/workloads/control-validation-scenarios/s3/missing-encryption/versions.tf` [9 nb]
- `Internal-IT/workloads/control-validation-scenarios/s3/public-bucket/main.tf` [7 nb]
- `Internal-IT/workloads/control-validation-scenarios/s3/public-bucket/versions.tf` [9 nb]
- `Internal-IT/workloads/control-validation-scenarios/shared/versions.tf` [3 nb]
- `Internal-IT/workloads/control-validation-scenarios/vpc/permissive-network-acl/versions.tf` [9 nb]

---

## 6. Governance deep read

### 6.1 `Governance/ISMS/03-risk-management/**` (8 docs, owner's preferred style) — all substantive

What makes them good (quote → path:line):
- Honest framing on every doc: "(simulated case study)" (`risk-register.md:3`, same line 3 in all 8); "This repository is a **non-deploying portfolio case study**. Source definitions and local tests are not treated as proof of cloud deployment…" (`risk-management-methodology.md:27`).
- Explicit evidence grading: Source / Local validation / Dated external observation / Operating table (`risk-management-methodology.md:29-34`) and E0 "Claimed" → E4 "Operating" confidence scale (`risk-management-methodology.md:84-90`).
- Refuses to fabricate records: "Creating meeting minutes, attendees, decisions, or approval dates now would manufacture evidence" (`2026-q1-risk-assessment.md:12`); "Record status: Retrospective reconstruction; no contemporaneous Q1 meeting…" (`2026-q1-risk-assessment.md:8`); "No named person, signature, ticket, meeting decision, or external approval artifact is present…" (`risk-acceptance-log.md:38`); "An empty approval field never counts as approval" (`risk-management-methodology.md:51`); "Do not backdate meetings…" (`:159`); "Treat scanner totals as triage input, not as a compliance percentage" (`:163`); "require real activities and processing facts, not additional blank templates" (`risk-register.md:42`).
- Due *gates* instead of invented dates (`risk-treatment-plan.md:12`) and interim constraints (`risk-treatment-plan.md:46-56`).
- Scenarios are grounded in real repo conditions (verified):
  - THR-008 / RISK-008 "mock credentials, refresh-free planning, and a no-change apply simulation" (`threat-scenarios-catalog.md:23`) ↔ `Internal-IT/workloads/ayka-portal/provider.tf:17-33` (mock keys + skip_* flags) and `Internal-IT/engineering/ci-cd/scripts/run-apply.sh:24-27` (echoes a fake "Apply complete!").
  - RISK-012 / TRT-012 "create-versus-adopt for AWS Organizations" (`risk-treatment-plan.md:31`) ↔ `aws-organization/organization.tf:1` (resource) vs `aws-organization/main.tf:11` (data source for the same org).
  - RISK-013 "multiple untested emergency-access paths" (`risk-register.md:33`) ↔ 3 implementations: `domains/identity/aws-iam-core/break-glass-role.tf:2`, `foundation/landing-zone/modules/break_glass/main.tf:1`, `domains/identity/entra-id/modules/privileged/break_glass.tf:1`.
  - RISK-004 contradictory lifecycle ↔ Terraform manages Identity Store groups + memberships (`aws-identity-center/groups.tf`, `memberships.tf:56`) while SCIM is documented as the sync source (`domains/identity/docs/scim.md`, `entra-id/provisioning.md`); no `azuread_synchronization_job` exists.
  - RISK-011 Region inconsistency ↔ 10× `"ap-south-1"` (Mumbai) vs 2× `"eu-central-1"` (e.g. `aws-identity-center/backend.tf:5`) for an EU/Stuttgart company.
  - RISK-002 fragmented state ↔ only 2 roots declare a backend (`aws-identity-center/backend.tf` S3, `entra-id/provider.tf` azurerm); `foundation/remote-state` mixes AWS S3+DynamoDB (`bootstrap.tf:5,31`) with Azure storage (`main.tf:1-19`).
  - Q2 drift interpretation (`2026-q2-risk-review.md:21,44`) ↔ `.github/workflows/drift-detection.yml` (61/61 scheduled failures per D-codex/FACTS-lead).

Weaknesses / broken refs:
- **Zero** repo file paths, **zero** `control-mapping.yaml` control IDs, **zero** ISO Annex A refs, **zero** ISO clause refs across all 8 docs. Their only evidence links go to `AUDIT/`, which is gitignored and was never committed → **10 broken links**: `risk-register.md:15` (×3: CURRENT_STATE, FINDINGS, ROADMAP_AND_PIPELINE_NOTES), `risk-management-methodology.md:36,167,168,169`, `risk-assessment-results/2026-q1-risk-assessment.md:19,20`.
- `risk-register.md:21` (RISK-001) "even though current source is clean" — **false on main**: the 3 Entra password literals are still present (§8).
- `risk-register.md:29` (RISK-009) and `risk-treatment-plan.md:28` (TRT-009) "124 Checkov failures" — no scan artifact in repo; CI on main reports 14 checkov findings for ayka-portal (FACTS-lead).
- Statuses claim source work that is not on main: TRT-006 "Source correction complete" (`risk-treatment-plan.md:25`), TRT-003 "Source work started" (`:22`), RISK-003/006/007 "Treating … source fixes / checksums" (`risk-register.md:23,26,27`) — yet `git diff 243c3b1 53b0532 -- Internal-IT .github tests` is empty. The described fixes lived only in the discarded AI-cleanup state. (Checksums do exist in `terraform-workflow.yml:101` + `run-apply.sh:14`, so RISK-007's "E2 checksums" is true.)
- `risk-treatment-plan.md:51` "keep scheduled drift disabled" — `drift-detection.yml:4-5` still has an active nightly cron on main (GitHub auto-disabled it for inactivity; the repo did not).
- `risk-register.md:25` RISK-005 cites "E3 dated GitHub observation from 2026-08-10" — no evidence file.
- `2026-q1-risk-assessment.md:12` "The repository contained only the heading for a Q1 assessment" — the heading file was itself created by fe1b27e the same morning (2026-08-23); at 243c3b1 it did not exist.

### 6.2 Other governance / organization docs

| Doc | Status | Repo refs (exist?) | control-mapping IDs | Annex A | Issues |
|---|---|---|---|---|---|
| `Governance/ISMS/00-context-and-governance/information-security-policy.md` | substantive (82 nb), generic template | none | none | none | "Approved by: Managing Director", "Effective Date: 01-03-2026" (l.6-7, 123-125) — approval not evidenced (contradicts risk docs' own rules); "100% MFA enforcement for privileged access" (l.47) unmeasured |
| `Governance/ISMS/00-context-and-governance/scope.md` | substantive (86 nb), generic | none | none | none | "Approved by: Managing Director", effective 21-02-2026; scope lists "Logging, monitoring, and SIEM systems" / "Backup and disaster recovery systems" (l.63-64) that don't exist in repo. Linked correctly from risk-management-methodology.md:19,170 |
| `Governance/ISMS/04-controls-and-soa/iam-iso27001-mapping.md` | substantive (102 nb) | **7 BROKEN**: `Internal-IT/iam/entra-id/modules/core/personnel.json` (l.17), `…/users.tf` (l.21), `Internal-IT/iam/entra-id/modules/security/conditional_access` (l.48), `Internal-IT/iam/aws-identity-center/groups.tf` (l.75), `…/permission-sets.tf` (l.79), `Internal-IT/policy-as-code` (l.186). Real homes: `Internal-IT/platform/domains/identity/…`, `Internal-IT/engineering/policy-as-code`. The `Internal-IT/iam/` paths never existed in git history. Bare filenames (l.32-33, 58-59, 89-91, 111-112, 132-133, 151) resolve by suffix only. | none | A.5.15-A.5.18, A.8.2-A.8.4 | **ISO 27001:2022 numbering shifted by one**: labels A.5.15 "Identity Management" (2022: 5.15 = Access control, 5.16 = Identity management), A.5.16 "Authentication Information" (= 5.17), A.5.17 "Access Rights" (= 5.18), A.5.18 "Access Provisioning" (no such control). Contradicts `domains/identity/docs/iam_compliance_crosswalk.md` which uses correct numbering. Claims SCIM "Automation implemented using Terraform" (l.107) — SCIM is a manual console step. |
| `Governance/GDPR/technical-and-organization-measures/identity-and-access-toms.md` | substantive (24 nb) | `aws-iam-core/abac-custom-policies.tf` (l.31, suffix match only) | none | none | Over-claims: "zero-trust authentication perimeter" (l.14), "No local IAM users are permitted" (l.16), FIDO2 "for all access" (l.17), Identity Protection auto-block (l.19), SCIM "immediately revokes" (l.26). CA policies only exist for Tier0 MFA + legacy auth and are gated by `enable_conditional_access` (entra-id/variables.tf:6, default false). ABAC tag `Owner = Engineering` (l.24) contradicts `ResourceTag Department` (iam-iso27001-mapping.md:155-156). Evidence "Terraform state files" (l.31) — no state. Dir name "technical-and-organization-measures" (→ organizational). |
| `Governance/GDPR/technical-and-organization-measures/segregation-of-duties.md` | substantive (25 nb) | **BROKEN** `Internal-IT/cloud-platform` (l.31); SOP-IAM-001 (l.35) → `domains/identity/docs/break-glass-procedure.md:4` ✔ | none | A.5.3 ✔ | Tier table (Tier0 = Cloud Platform Admins, Tier1 = SecOps, Tier2 = Workload Ops) contradicts `Governance/architecture/identity-architecture.md:5-7` + README.md:44-46 (Tier0 Security Admin, Tier1 Infra Ops, Tier2 Devs); PIM/JIT (l.26) not implemented; "minimum of one approved Pull Request" (l.31) — main is unprotected (FACTS-lead) |
| `Governance/architecture/identity-architecture.md` | substantive (56 nb, mermaid) | dir names only | none | none | Duplicates the flow in `Internal-IT/platform/domains/identity/README.md` and README.md:48 |
| `Governance/ISMS/tree.md` | substantive (134 nb, planning tree) | lists 3 PNGs (`07-technical-evidence/architecture-diagrams/*.png`) + 6 dirs (logging-evidence/, access-review-logs/, backup-test-results/, vulnerability-scan-reports/, audit-checklists/, audit-reports/) that don't exist | — | — | Matched by `.gitignore:68 tree.md` but tracked; mis-indented l.39 |
| `Governance/ISMS/README.md` | title-only | — | — | — | just `# Information Security Management System (ISMS)` |
| Governance stubs (7) | stub | none | none | none | `security-architecture.md` (6 topic words), `security-operating-model.md` (5 questions), `vendor-risk-management.md` (4 vendor names), `architecture/README.md`, `architecture/platform-architecture.md` (account list in `/* */`), `architecture/security-control-model.md`, `architecture/system-overview.md` |
| 80 title-only ISMS docs + 8 empty Governance files | — | — | — | — | see §3 |
| `organization/business-model.md` | substantive | none | none | none | typos "compnay" (l.8), "framworks" (l.10); claims TISAX / IEC 62443 offerings |
| `organization/org-structure.md`, `roles-and-responsibilities.md`, `training-and-awareness.md`, `personnel-register.md` | substantive | none | none | none | `roles-and-responsibilities.md:69` "Monitors SIEM alerts (Microsoft Sentinel)" contradicts `landing-zone/modules/siem/elastic-siem.md` (Elastic) and the code (Firehose→S3 only). Personnel register is fictional; `personnel.json` (338 lines) drives Terraform users. |
| `organization/{acceptable-use-policy,security-steering-committee,vendor-management}.md` | empty | — | — | — | — |

Cross-doc: **no Governance or organization doc references a single control ID from `Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml`** (38 controls, all mapped only under `frameworks.iso27001`; ISO refs used there: A.8.24×12, A.8.20×10, A.8.21×7, A.8.15×6, A.8.16×5, A.8.2×4, A.5.30×4, A.8.13×3, A.8.12×2, A.5.17×2, A.8.9, A.8.5, A.8.3, A.5.9, A.5.37, A.5.15). The only docs that mention control IDs at all are `ci-cd/compliance-gates/enforcement-levels.md:22` and `policy-evaluation-flow.md:21` (as an example).

### 6.3 Other doc-level broken references (outside Governance)
| Path:line | Reference | Problem |
|---|---|---|
| `Internal-IT/engineering/ci-cd/compliance-gates/enforcement-levels.md:13` | `/home/ayush/Compliance-Oriented-Cloud-Security-Platform/Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml` | absolute local path (leaks old repo name + username); broken on GitHub |
| `Internal-IT/engineering/ci-cd/compliance-gates/policy-evaluation-flow.md:12` | same absolute path | same |
| `Internal-IT/engineering/policy-as-code/metadata/README.md:8` | `../active/control-mapping.yaml` | never existed; README also mis-describes the single mapping file as "comprehensive … not all enforced" |
| `Internal-IT/platform/foundation/Platform_Complilance.md:3` | `Internal-IT/cloud-platform/` | never existed (real: `Internal-IT/platform/foundation/`); its "Known gap #6" (l.110, siem trust-policy `2012=10-17`) is stale — `siem/main.tf:6` is already `2012-10-17` |
| `Internal-IT/platform/domains/identity/docs/iam_compliance_crosswalk.md:12` | `Internal-IT/iam/` | never existed |
| `Internal-IT/platform/domains/identity/docs/identity-provisioning-workflow.md:46` | `Internal-IT/iam/entra-id/modules/core/personnel.json` | never existed |
| `Internal-IT/platform/domains/identity/README.md:58-72` | tree rooted at `iam/` with `bootstrap/remote-state/` | stale layout |
| `Internal-IT/workloads/README.md:30,33` | `/modules/analytics/`, `data.tf` | don't exist |
| `Internal-IT/platform/structure.md` | `domains/detection|response|network/`, `shared/`, `policy-as-code/config-rules/`, `Platform_Compliance.md` | aspirational; none exist (and engineering/assurance shown under platform/ but live at Internal-IT/) |
| `Internal-IT/platform/foundation/README.md` | `cloud-platform/…`, `landing-zone/security-account.tf`, `dev-account.tf`, `prod-account.tf`, `scp/policies/restrict-regions.json`, `attachments.tf` | stale tree; real names `restrict-region.json`, `attachment.tf` |
| `Internal-IT/platform/foundation/landing-zone/README.md:14` | "internal cloud-platform-control-plane module" | doesn't exist |
| `Internal-IT/platform/foundation/landing-zone/modules/siem/elastic-siem.md` | docker-compose.yml, ingestion/*, detections/*, dashboards/*, automation/alert-handler.py | none exist |

---

## 7. README over-claims

Root `README.md` (title "Compliance-Oriented Cloud Security Platform" = the old repo name seen in the `/home/ayush/...` links):

| Claim | README path:line | Evidence in repo | Verdict |
|---|---|---|---|
| "implements a comprehensive … platform … serves as both the company's internal security infrastructure and a reference implementation" | README.md:5 | Nothing deployed; ayka-portal uses mock keys (provider.tf:17-33); apply is simulated (run-apply.sh:24-27); risk docs RISK-008 warn against exactly this | Over-claim |
| NIST CSF 2.0 mappings | README.md:12, 35 | Only prose crosswalk `Internal-IT/platform/foundation/Platform_Complilance.md:38-83`; `control-mapping.yaml` has only `iso27001` keys (38/38) | Doc-only |
| AWS CIS Benchmarks | README.md:12, 36 | Same single crosswalk (`Platform_Complilance.md:57`); no CIS IDs anywhere in code | Doc-only |
| SOC 2 | README.md:12, 37 | `Platform_Complilance.md:85` only | Doc-only |
| GDPR mappings | README.md:12, 38 | 2 TOM docs (Governance/GDPR/technical-and-organization-measures/*) + GDPR column in Platform_Complilance; 4 of 6 Governance/GDPR files empty (ROPA, DPIA, DSR, retention) | Partial |
| "Structured audit evidence trails" | README.md:14 | `Internal-IT/assurance/` 19/19 empty; `Governance/ISMS/07-technical-evidence/` 7/7 empty or title-only; only pipeline artifact upload (`.github/actions/evidence/action.yml`, `ci-cd/scripts/export-evidence.sh`) | Mostly unsupported |
| OUs + SCPs | README.md:18 | `aws-organization/modules/ou-structure/ous.tf`, `modules/scp/{scp.tf,attachment.tf,*.json}` (attached to Workloads OU only, attachment.tf:7,12,17) | Source exists (never applied) |
| "delegated administration" | README.md:18 | NONE (no `aws_organizations_delegated_administrator`; "delegated" appears only in README + risk-register) | False |
| RBAC and ABAC | README.md:20, 48 | `aws-iam-core/abac-custom-policies.tf`, `abac-mandatory-tagging.tf`, `aws-identity-center/permission-sets.tf`, `session-controls.tf` | Source exists |
| CloudTrail logging **and monitoring** | README.md:21 | `landing-zone/modules/core/logging/cloudtrail.tf`, `trail_bucket.tf`; SCP `deny-disable-cloudtrail.json`. Monitoring: only an SNS topic (`core/alerts/sns.tf`); no CloudWatch metric filters/alarms, EventBridge rules, GuardDuty, Security Hub or Config anywhere | Logging: source exists; monitoring: NONE |
| S3 public access blocking | README.md:22 | `landing-zone/modules/core/s3/public_access_block.tf` | Source exists |
| Break-glass emergency access procedures | README.md:23 | `domains/identity/docs/break-glass-procedure.md` (SOP-IAM-001) + 3 competing implementations (see §6.1) | Exists (untested, fragmented; entra break-glass has a hardcoded password) |
| SIEM integration | README.md:24 | `landing-zone/modules/siem/main.tf`: one Firehose stream → S3 bucket, no log source wired in, no SIEM; `elastic-siem.md` is a tree of non-existent files; org doc says Sentinel | Over-claim |
| CI/CD pipelines | README.md:25 | `.github/workflows/{test,terraform-workflow,policy-check,drift-detection}.yml`, `.github/actions/*` (7) | Exists (14 empty duplicate YAMLs under `ci-cd/pipelines/`) |
| Incident response workflows | README.md:25 | NONE: `platform/operations/incident-response/scenarios/*.md` (3) empty; ISMS IR policy/procedure title-only; no EventBridge/Lambda/SSM/Step Functions | False |
| Policy-as-code enforcement | README.md:25 | `policy-as-code/OPA/terraform/*.rego`, `metadata/control-mapping.yaml`, `ci-cd/scripts/evaluate-results.py`, `tests/compliance/test_evaluate_results.py` | Exists (see B-pipeline/FACTS-lead caveats) |
| Drift detection | README.md:25 | `.github/workflows/drift-detection.yml` exists but failed 61/61 and is GitHub-disabled; `engineering/drift-detection/*` (4) and `ci-cd/pipelines/drift/drift-detection.yml` empty; `assurance/reports/drift-reports/` empty | Broken |
| CISO independence | README.md:28 | `organization/org-structure.md`, `roles-and-responsibilities.md` | Doc exists |
| Personnel registers / training | README.md:29 | `organization/personnel-register.md`, `training-and-awareness.md`, `entra-id/modules/core/personnel.json` | Doc exists (no training records) |
| "background checks" | README.md:29 | NONE (word appears only in README) | False |
| Vendor/third-party risk assessment | README.md:30 | `organization/vendor-management.md` empty; `Governance/vendor-risk-management.md` = 4 vendor names; supplier policy/procedure title-only | False |
| Tier 0/1/2 identity model + SCIM flow | README.md:44-48 | Tiers in `entra-id/modules/core/groups_tiers.tf` (comment lists **4** tiers tier0-3), `aws-identity-center/groups.tf` (3). SCIM = manual console steps (`docs/scim.md`, `entra-id/provisioning.md`); no `azuread_synchronization_job` | Partial / tier definitions inconsistent across docs |
| Root account isolation | README.md:51 | SCP `deny-root-usage.json`; `root_protection.tf` is an output + comment only | Partial |
| Dedicated security **and logging** accounts | README.md:52 | security/dev/prod account IDs in `enterprise_strict.tfvars:5-7`; no logging account anywhere (only a word in `Governance/architecture/platform-architecture.md` stub) | Logging account: NONE |
| Workload accounts with automated controls | README.md:53 | `landing-zone/modules/account_landing_zone` instantiated for security/dev/prod (`landing-zone/main.tf`) | Source exists |
| "audit-ready evidence … for certification audits" | README.md:60 | Contradicted by own risk docs (`risk-treatment-plan.md:26` TRT-007 gate "Before using 'audit-ready'…") | Over-claim |
| Zero-trust principles | README.md:61 | NONE beyond prose in `identity-and-access-toms.md:14` | Over-claim |
| Continuous compliance monitoring and automated remediation | README.md:62 | NONE: no AWS Config/Security Hub/EventBridge/Lambda; `Platform_Complilance.md:108-109` itself lists "No AWS Config conformance packs/rules…" as a gap | False |
| Terragrunt | README.md:67 | NONE (no terragrunt.hcl; word only in README) | False |
| Mermaid diagrams | README.md:72 | `Governance/architecture/identity-architecture.md` (1 diagram) | True (1) |

Other READMEs:

| Claim | Path:line | Evidence | Verdict |
|---|---|---|---|
| Workload "does not provision its own networking … inherits via data sources" | `Internal-IT/workloads/README.md:6`, `:33` (`data.tf`) | `ayka-portal/modules/networking/main.tf` creates VPC, subnets, NAT, IGW, flow log; no `data.tf` | False |
| Analytics: Kinesis Firehose → S3 data lake → Athena; `/modules/analytics/` | `Internal-IT/workloads/README.md:13, 30` | no analytics module, no Kinesis/Athena in ayka-portal | False |
| ALB + WAF, ECS Fargate, RDS PostgreSQL Multi-AZ, TLS 1.2+ | `Internal-IT/workloads/README.md:10-12, 22` | `aws_wafv2_web_acl`, `ecs.tf:19,84` FARGATE, `database/main.tf:85,104` postgres + multi_az, `alb.tf:71` TLS13-1-2 policy | True |
| ISO mapping A.9.1.2, A.10.1.1, A.12.4.1, A.13.1.3, A.13.2.1, A.14.2.7 | `Internal-IT/workloads/README.md:20-24` | these are **ISO 27001:2013** IDs; rest of repo uses 2022 | Inconsistent |
| "All infrastructure changes require PR approvals" | `Internal-IT/workloads/README.md:23` | main unprotected (FACTS-lead) | False |
| "bad EC2, bad S3, bad VPC, bad IAM" | `Internal-IT/workloads/control-validation-scenarios/README.md:5` | no IAM scenario; VPC scenario is empty | Partial |
| "This layer does NOT … Attach SCPs" | `Internal-IT/platform/foundation/aws-organization/README.md:10,13` | `aws-organization/main.tf:1-4` calls `modules/scp`, whose `attachment.tf` attaches 3 SCPs | Contradiction |
| "SIEM integration" / "Consumes internal cloud-platform-control-plane module" | `Internal-IT/platform/foundation/landing-zone/README.md:12,14` | Firehose only; module doesn't exist | Over-claim / broken |
| Remote-state = "S3/DynamoDB setup" | `Internal-IT/platform/structure.md` (remote-state line) | `foundation/remote-state/bootstrap.tf` (S3+DynamoDB) **and** `main.tf` (azurerm storage) with `provider.tf` declaring only azurerm; `remote-state/README.md` bullets unrelated | Confused |
| Detection / Response control planes, auto-remediation | `Internal-IT/platform/CONTROL-PLANE.md` (Detection/Response sections), `platform/deployments/platform-rollout.md` (Phases 4-5), `platform/structure.md` | no such code | Aspirational |

---

## 8. Secrets and sensitive identifiers (values never printed)

| path:line | Kind | Introducing commit | Still on main? |
|---|---|---|---|
| `Internal-IT/platform/domains/identity/entra-id/modules/core/users.tf:16` | hardcoded `password = "<literal>"` for every `azuread_user` (16 chars; `force_password_change = true` l.17) | **89db3df 2026-03-22 "gitignore cleanup"** (root commit); identical value re-added in root commits 7a2f667 (2026-03-22) and fcbb603 (2026-03-25); never changed | YES |
| `Internal-IT/platform/domains/identity/entra-id/modules/privileged/break_glass.tf:6` | hardcoded break-glass password literal (24 chars) with `force_password_change = false` (l.7) and `disable_password_expiration = true` (l.8) | 89db3df (same as above; also 7a2f667, fcbb603) | YES |
| `Internal-IT/platform/domains/identity/entra-id/modules/privileged/admin_accounts.tf:9` | hardcoded admin password literal (17 chars) | 89db3df (also 7a2f667, fcbb603) | YES |
| `Internal-IT/workloads/ayka-portal/provider.tf:19-20` | `access_key`/`secret_key` literals — 15-char mock placeholders containing "mock/test"; not AKIA-format; paired with `skip_credentials_validation` etc. | 83004ae 2026-04-04 "workload ayka-poratal" | YES (benign, intentional) |

Also present in all 3 historical PR heads (`refs/pull/1..6/head`) → public since 2026-03-22.

Non-secret but identifying (flag, don't treat as secrets): AWS account IDs at `enterprise_strict.tfvars:5-7`, `.github/workflows/test.yml:16,41`, `.github/workflows/drift-detection.yml:31` (OIDC role account, real/assumable per FACTS-lead), `entra-id/aws_enterprise_app.tf:60`, `ayka-portal/kms.tf:19`; personal Entra tenant domain `…outlook.onmicrosoft.com` in 29 places (`aws-identity-center/memberships.tf:6-37`, `users.tf:5`, `admin_accounts.tf:5`, `break_glass.tf:2`); email `secops@aykasecure.com` (`enterprise_strict.tfvars:2`); absolute home path `/home/ayush/...` (§6.3).
No AKIA keys, private keys, `.env`, or tfstate in tree or history. `tfplan.binary` embeds an empty state (144 B) and mock-provider config — low risk, but a generated artifact that shouldn't be tracked.

---

## 9. Other messes

**Filename / naming issues**
- `Internal-IT/platform/foundation/Platform_Complilance.md` — typo (Complilance); referenced as `Platform_Compliance.md` in `platform/structure.md`.
- `Governance/GDPR/technical-and-organization-measures/` — "organization" → "organizational".
- `Internal-IT/platform/domains/identity/docs/tempChangePlan.md` — temporary working notes committed (camelCase).
- Mixed conventions: `iam_compliance_crosswalk.md` (snake) vs kebab elsewhere; `break_glass` vs `break-glass`; `permission_boundary.tf` (landing-zone) vs `permissions-boundaries.tf` (aws-iam-core); `CONTROL-PLANE.md`; top-level `organization/` lowercase vs `Governance/`, `Internal-IT/`.
- `Internal-IT/engineering/.pre-commit-config.yaml` — empty and in the wrong place (pre-commit only reads repo root).
- `Internal-IT/workloads/control-validation-scenarios/tfplan.binary` — generated artifact force-tracked (0756e0a).
- Commit-message typos (for the record): "ayka-poratal", "Inital compliacne", "harderning", "moudlar", "validaton", "stablizing".

**Duplicate content (identical blobs, excluding the 73 empty files that share e69de29)**
- `52c142d` ×8: identical `versions.tf` in ayka-portal `modules/{networking,security,storage}` and 5 scenario dirs — normal Terraform boilerplate.
- `39a6fbd` ×3: identical `.terraform.lock.hcl` in `aws-iam-core`, `aws-identity-center`, `control-validation-scenarios` — fine.
- `8300298` ×2: identical `provider.tf` in `aws-iam-core` and `aws-identity-center`.
- Whitespace-only variants of empty: `sample-audit-session.md` (2 B), `modules/output/compliance.tf` (1 B).

**Overlapping / competing documents on the same topic**
- Personnel: `organization/personnel-register.md` (real) vs `Governance/ISMS/01-organization/personnel-register.md` (title) vs `entra-id/modules/core/personnel.json`.
- Roles: `organization/roles-and-responsibilities.md` vs `Governance/ISMS/01-organization/roles-and-responsibilities.md` (title).
- Org chart: `organization/org-structure.md` vs `Governance/ISMS/01-organization/org-chart.md` (title).
- Training: `organization/training-and-awareness.md` vs `Governance/ISMS/01-organization/training-and-awareness-program.md` (title).
- Acceptable use: `organization/acceptable-use-policy.md` (empty) vs `Governance/ISMS/02-asset-management/acceptable-use-policy.md` (title).
- Vendors/suppliers: `organization/vendor-management.md` (empty), `Governance/vendor-risk-management.md` (stub), `05/supplier-security-policy.md`, `06/supplier-onboarding-procedure.md`, `08/supplier-performance-review.md` (all title).
- Retention: `Governance/GDPR/data-retention-policy.md` (empty), `05/data-retention-policy.md`, `00/record-retention-policy.md` (title), `Internal-IT/assurance/integrity/retention-policy.md` (empty).
- Change mgmt: `05/change-management-policy.md`, `06/change-management-procedure.md` (title), `platform/operations/change-management/{change-policy,rollout-strategy}.md` (empty), `ci-cd/compliance-gates/approvals/*` (empty).
- Incident response: `05/incident-response-policy.md`, `06/incident-response-procedure.md` (title), `platform/operations/incident-response/scenarios/*` (empty), `assurance/reports/security-reports/incident-summary.md` (empty).
- Drift: `.github/workflows/drift-detection.yml` (real) vs `ci-cd/pipelines/drift/drift-detection.yml` + `engineering/drift-detection/*` + `assurance/reports/drift-reports/*` (empty).
- Compliance crosswalks (4, mutually inconsistent): `Governance/ISMS/04-controls-and-soa/iam-iso27001-mapping.md`, `domains/identity/docs/iam_compliance_crosswalk.md`, `foundation/Platform_Complilance.md`, `policy-as-code/metadata/control-mapping.yaml` (the only one the pipeline uses); plus title-only `04/control-mapping-to-internal-it.md`, `07/internal-it-mapping.md`, `07/terraform-module-mapping.md`, `07/control-evidence-index.md`.
- SCIM how-to twice: `domains/identity/docs/scim.md` (AWS side) and `entra-id/provisioning.md` (Entra side).
- Architecture: `Governance/architecture/*` (4 stubs + 1), `Governance/security-architecture.md`, `platform/architecture.md` (empty), `platform/structure.md`, `platform/CONTROL-PLANE.md`, `foundation/README.md`, identity README.
- Metrics/dashboards: `08/security-metrics-dashboard.md`, `08/kpi-and-metrics.md` (title), `assurance/metrics/*` (empty), `platform/operations/monitoring/dashboard.md` (empty).

**Internal inconsistencies**
- Tier model: 3 tiers (README.md:44-46; identity-architecture.md:5-7: Tier0 = Security Admin) vs segregation-of-duties.md table (Tier0 = Cloud Platform Admins, Tier1 = SecOps) vs `groups_tiers.tf` comment listing tier0-tier3 (4 tiers).
- SIEM: Elastic (`elastic-siem.md`) vs Microsoft Sentinel (`organization/roles-and-responsibilities.md:69`) vs code (Firehose → S3 only).
- Region: EU company, but 10× ap-south-1 (Mumbai) vs 2× eu-central-1.
- ISO version: 2022 numbering (control-mapping.yaml, iam_compliance_crosswalk.md, Platform_Complilance) vs 2013 IDs (`workloads/README.md:20-24`) vs shifted-2022 labels (`iam-iso27001-mapping.md`).
- OUs: ou-structure README/ous.tf = Security/Infrastructure/Workloads vs structure.md "Sandbox, Workloads, Security OUs".
- ABAC tag key: `Department` (mapping doc, crosswalk) vs `Owner` (GDPR TOM).

---

## 10. Claims that were wrong / need correcting

1. "fe1b27e Revert: cleanup" is **not a revert** of anything in git; it **created** 84 title-only Governance files (none had prior history) + titled 3 empty ones + added 3 `.gitignore` entries + edited tree.md. (D-codex's note says "87 previously-empty" — precisely: 84 new + 3 previously empty.)
2. "Internal-IT/assurance/: 0 lines" — 18 × 0 B plus one 2-byte whitespace file (`audit-support/sample-audit-session.md`). Substantively correct.
3. "~160 empty or title-only" — exactly **155** (75 + 80); 167 incl. stubs.
4. "empty penetration-test-report.md" — it is **title-only** (`# Penetration Test Report`), not 0 bytes.
5. `codex/pre-restore-ai-cleanup-20260823` — **does not exist** on origin or locally (your belief confirmed).
6. Risk register's "current source is clean" (RISK-001, `risk-register.md:21`) — **wrong for main**.
7. Risk docs' "source correction complete / source fixes" (TRT-006, TRT-003, RISK-003/006) — **not on main** (Internal-IT unchanged since 243c3b1).
8. README "Terragrunt", "delegated administration", "background checks", "incident response workflows", "continuous compliance monitoring and automated remediation", "SIEM integration", "logging account", "zero-trust", "audit-ready" — **no supporting code**.
9. "14 empty *duplicate* YAMLs" — they are 14 empty placeholders; they don't duplicate content (they're empty), they shadow the real `.github/` pipeline.
