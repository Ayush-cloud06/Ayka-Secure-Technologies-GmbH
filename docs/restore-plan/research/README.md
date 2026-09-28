# Research notes (evidence appendix)

These are the raw notes behind the plan. Four read-only research passes and the lead's own checks produced them on **2026-09-28** against `main` = `53b0532`. They're here so every claim in the plan can be traced to a command, a file and line, or a CI log.

| File | Scope | Headline |
|---|---|---|
| [facts-lead.md](facts-lead.md) | GitHub API, CI job logs of run #68, secrets check, evaluator/OPA reading | CI green on HEAD; tfsec output dropped; OIDC role real; apply simulated |
| [terraform.md](terraform.md) | 8 Terraform roots, dependency graph, secrets, fmt/init/validate/plan results | 8/8 validate; ayka-portal plans 87 resources; no root reads another's state |
| [pipeline.md](pipeline.md) | workflows, composite actions, scripts, evaluator, control mapping, OPA, local chain | local chain reproduces run #68 exactly; 29 issues F1–F29; the probe plan passes |
| [inventory.md](inventory.md) | every tracked file, governance deep read, README claims, secrets, messes | 203 substantive / 80 title-only / 75 empty / 12 stub / 2 symlink / 1 binary |
| [codex.md](codex.md) | where the AI cleanup branch is, and its claimed fixes checked against `main` | never pushed; code on `main` equals 15 April; re-implement list |

**How to read them**

- These are working notes. Where a note and the curated plan disagree, **the plan wins**; the plan went through a second check. Known correction: `fe1b27e` added **84** new title files and titled **3** empty ones. It didn't title "87 previously-empty" files.
- Paths like `SP/…`, `<scratch>` and `<session>` refer to the planning sandbox, which no longer exists. The commands still work if you re-create the same layout with `git archive 53b0532`.
- **Sanitised before commit:** no secret values ever appear. The personal tenant domain, the three landing-zone account IDs and the planning-sandbox paths are replaced by placeholders. The CI OIDC account ID `982081090103` stays because it's already public in `.github/workflows/test.yml:16`.
- Tools used: terraform 1.7.5, tflint 0.53.0, checkov 3.3.20, tfsec v1.28.14, conftest 0.45.0 (OPA 0.56.0), OPA 1.0.0 (syntax check only), pytest 9.1.1, shellcheck 0.11.0, actionlint 1.7.7, yamllint 1.38.0, mermaid-cli 11.17.0.
- `registry.terraform.io` was blocked (403) in the sandbox. Providers came from `releases.hashicorp.com` and were checksum-verified against HashiCorp's SHA256SUMS and your lock files (see [terraform.md §0](terraform.md#0-toolchain-and-method)).
