# REAL-SDLC-001: First local run of the supply-chain and SDLC checks

> **REAL RECORD.** Performed on the date shown. Scope and limits are stated below.

| Field | Value |
|---|---|
| Record ID | REAL-SDLC-001 |
| Performed | 2026-11-10 |
| Performed by | Repository owner, AI-assisted tool run (commands executed by an AI coding agent on the owner's machine) |
| Controls | SOC 2 CC7.1, CC8.1; ISO/IEC 27001:2022 A.8.8, A.8.25, A.8.28; NIS2 Art. 21(2)(e) |
| Subject | [`security-checks.yml`](../../../../.github/workflows/security-checks.yml), working tree on branch `sim/operating-baseline` |
| Related | [POL-SDL-01 section 4.4](../../../policies/secure-development-policy.md#44-secure-coding-a28), [POL-VUL-01](../../../policies/vulnerability-and-patch-management-policy.md), [POL-VDP-01](../../../policies/vulnerability-disclosure-policy.md) |

## What was run

Same tools and versions as the workflow, on Linux (WSL2), Python 3.10 locally (the workflow uses 3.11). Binaries were checked against the SHA-256 values in the workflow.

| Tool | Version | Command | Result |
|---|---|---|---|
| gitleaks | 8.30.1 | `gitleaks detect --source . --redact` (353 commits) | 18 findings, all one documented fake key in `tests/compliance/test_asset_inventory.py` (lines 292 and 294 in the current tree) across 9 commits; 0 after the allowlist in [`gitleaks.toml`](../../../../tests/sdlc/gitleaks.toml) |
| actionlint | 1.7.12 | `actionlint` | 0 findings |
| shellcheck | 0.11.0 | `shellcheck --severity=warning Internal-IT/engineering/ci-cd/scripts/*.sh` | 0 findings |
| Bandit | 1.8.6 | `bandit -r Internal-IT tests -ll -x '*/.terraform/*'` | 0 medium or high; the informational run reports 15 low (subprocess B404/B603/B607 in `write-manifest.py` and five test files); B101 `assert` in tests is a further 39 low when not skipped |
| pip-audit | 2.9.0 | `pip-audit -r tests/requirements.txt` | No known vulnerabilities |
| cyclonedx-bom | 7.1.0 | `cyclonedx-py environment <venv with tests/requirements.txt> --sv 1.6 --of JSON` | CycloneDX 1.6 SBOM with 11 components (pytest 9.1.1, PyYAML 6.0.1 and transitive packages) |

Reproduce: install the pinned versions above and run the commands from the repository root.

## Findings and decisions

1. **gitleaks, test fixture.** `AKIAABCDEFGHIJKLMNOP` is a made-up key that the inventory test uses to prove redaction. It is allowlisted by exact value and path, not by rule.
2. **gitleaks, bootstrap passwords (RISK-001).** The default gitleaks rules did not flag the Entra bootstrap passwords that remain in public Git history. A clean result therefore does not show that history holds no passwords. History was not rewritten.
3. **Local-only files.** A scan with `--no-git` also hit gitignored local files (`.env`, a Terraform state file, `.terraform/modules`). They are not tracked and not in a CI checkout, and the workflow does not scan them. Not remediated here.
4. **Bandit low findings.** Subprocess calls use fixed argument lists, not shell strings. The gate fails on medium or higher only; low findings are printed, not enforced.
5. **SBOM scope.** It lists the Python test environment only. It does not list Terraform providers, container images or the pinned CI binaries.

## Limits

- This was a **local run**. The workflow has **not yet run on GitHub**; whether the runner, network downloads and the artifact upload work there is unverified. Open until the first Actions run exists, then link its run ID here.
- The checks are not yet required checks in the `protect-main` ruleset. Adding them is an owner action in GitHub settings and is **open**.
- No application code exists, so SAST and SCA cover only the repository's scripts and tests.
- The shellcheck release has no published checksum file; its digest in the workflow was computed from the downloaded asset (trust on first use).
- GitHub secret scanning, push protection and private vulnerability reporting settings were not checked or changed.
