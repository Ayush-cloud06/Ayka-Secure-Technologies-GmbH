# ADR-0015: Pin checkov, tflint, conftest, tfsec and actions; keep Rego v0 pinned now and migrate later

- **Status:** Proposed
- **Date:** 2026-09-28
- **Deciders:** Ayush (owner)

## Context and problem statement

A compliance gate is only reproducible if its tools are. Today the results can change **without any commit**:

| Item | State | path:line |
|---|---|---|
| Checkov | `pip install checkov`, no version | `.github/actions/check/action.yml:15` |
| TFLint | `terraform-linters/setup-tflint@v4` with `tflint_version: latest` | `.github/actions/validate/action.yml:22-24` |
| setup-terraform | `hashicorp/setup-terraform@v3` (tag only) | `plan/action.yml:30`, `validate/action.yml:17` |
| configure-aws-credentials | `@v4` (tag only). Removed anyway by ADR-0013 | `plan/action.yml:24` |
| checkout | `actions/checkout@v4` (tag only). The file is deleted by ADR-0005 | `policy-check.yml:18` |
| tfsec v1.28.14, conftest v0.45.0 | versions pinned, but downloaded with `wget` and **no checksum check** | `check/action.yml:18-20`, `policy/action.yml:11-13` |
| PyYAML | imported by the evaluator but never declared. It arrives as a Checkov dependency | `evaluate-results.py:9`; [research/pipeline.md](../research/pipeline.md) F22 |

The other 13 `uses:` are already pinned to commit SHAs with a version comment (for example `test.yml:28`). You already have the right convention; it just isn't applied everywhere. Terraform providers are pinned by committed lock files, for example aws 5.100.0 in `ayka-portal/.terraform.lock.hcl:4-5`.

**Rego is a special case.** All 6 `.rego` files use pre-1.0 syntax (`deny[msg] { … }`).

- They work with conftest v0.45.0, which bundles OPA 0.56.0 ([research/pipeline.md](../research/pipeline.md) §4).
- Under OPA 1.0, `opa check` reports **45 parse errors across all 6 files**.
- With `--v0-compatible` they pass.

So the conftest pin is load-bearing. If you bump it to a release that defaults to Rego v1, the gate breaks. It would at least break red, not green, because `run-policy-check.sh:24-28` turns a conftest error into an error payload that the evaluator rejects.

> **Why this matters to you:** "it was green last week and red today, and nobody changed anything" is the worst debugging session there is. Pinning turns every tool upgrade into a commit you chose, with a diff of findings you can review (ADR-0014). A tag like `@v4` can be moved by its owner, which is why the rest of your workflows already use SHAs.

## Decision drivers

- Same inputs and same tool versions give the same decision (reproducible evidence, ADR-0009).
- Supply-chain hygiene: don't run a downloaded binary without checking its hash.
- Upgrades happen on purpose, one at a time, with tests (ADR-0012).
- Don't mix a syntax migration into the Phase 4 bug-fix work.

## Considered options

1. Float everything on latest versions.
2. Pin everything now, keep Rego v0 with conftest 0.45.0, and migrate to `rego.v1` in Phase 6.
3. Pin everything and migrate Rego to v1 now, in Phase 4.
4. Pin actions to major-version tags (`@v4`) only.

## Decision outcome

Chosen option: 2.

- **Actions:** every `uses:` references a full commit SHA with a `# vX.Y.Z` comment. Reuse the SHAs already in the repository where the action is the same, for example setup-terraform `a1502cd…` at `apply/action.yml:19`.
- **Python tools:**
  - `pip install checkov==<version>`. Start with 3.3.20, the version that reproduced run #68 exactly ([research/pipeline.md](../research/pipeline.md) §5).
  - Pin PyYAML and pytest in a requirements file (ADR-0012).
- **Binaries:**
  - TFLint gets a fixed version (v0.53.0 was used locally).
  - tfsec v1.28.14, conftest v0.45.0 and OPA 0.56.0 (for tests) are downloaded, then checked with `sha256sum -c` against the published checksums before use.
- **Terraform:**
  - Keep 1.7.5.
  - Stop hard-coding it in `apply/action.yml:21` and `drift-detection.yml:25`; use the input instead.
  - Commit a lock file for any root you plan in CI.
- **Rego:**
  - Stay on v0 syntax with conftest v0.45.0 until Phase 6. Document that pin in a comment next to it.
  - In Phase 6, add `import rego.v1`, rewrite rules as `deny contains msg if { … }`, and run `opa fmt`. All 6 files currently need formatting ([research/pipeline.md](../research/pipeline.md) §5).
  - Then bump conftest and OPA **together**, with the Rego tests from ADR-0012 as the safety net.
- **Upgrades:** one tool per PR. Include the before and after `compliance-summary.json` totals in the PR description. New unmapped findings go through ADR-0014.

## Consequences

### Positive

- The same commit gives the same decision, so evidence snapshots (ADR-0009) can be compared over time.
- Downloaded binaries are verified.
- The Rego migration becomes a planned, tested change, not a surprise.

### Negative

- Pins go stale. Nothing tells you about a security fix in Checkov or an action unless you look. Optional: enable Dependabot for `github-actions` and `pip`. It opens bump PRs you still have to review, which means some noise.
- Keeping conftest 0.45.0 means staying on an older OPA (0.56.0) for months.
- tfsec says it is "joining the Trivy family" ([research/pipeline.md](../research/pipeline.md) §8), which suggests it will get fewer updates. Replacing it is a new-tool decision for after Phase 5 (ADR-0002). This ADR only pins what exists.
- Pinning Checkov freezes its rule set. Newer checks, and newer false positives, arrive only when you choose to bump.

## Pros and cons of the options

### 1. Float everything

- Good: always the newest checks.
- Bad: results drift without commits, and nothing is reproducible. A Rego-v1 default would break the gate unannounced.

### 2. Pin now, migrate Rego in Phase 6

- Good: stable while you fix bugs, and the migration is planned.
- Bad: temporary technical debt (v0 syntax, older OPA).

### 3. Pin and migrate now

- Good: done in one go.
- Bad: mixes a mechanical rewrite of all 6 files with Phase 4 behaviour fixes. That makes regressions hard to attribute, and the Rego tests don't exist yet.

### 4. Major-version tags only

- Good: easy to read.
- Bad: tags are mutable. It is not the convention you already use for 13 other actions.

## Evidence

- [research/codex.md](../research/codex.md) §3 row 5 (unpinned refs and unverified downloads) and row 6 (Rego: 45 errors under OPA 1.0, fine with `--v0-compatible`).
- [research/pipeline.md](../research/pipeline.md) §4 (conftest v0.45.0 bundles OPA 0.56.0), §5 (`opa check` results, `opa fmt --list`, checkov 3.3.20 reproduction) and §8 (the full pin list).
- `.github/actions/check/action.yml:15,18-20`, `.github/actions/policy/action.yml:11-13`, `.github/actions/validate/action.yml:17,22-24`, `.github/actions/plan/action.yml:24,30`, `.github/workflows/policy-check.yml:18`
- `Internal-IT/engineering/ci-cd/scripts/run-policy-check.sh:24-28`: a conftest error becomes an error payload, so the gate fails closed.
- `Internal-IT/workloads/ayka-portal/.terraform.lock.hcl:4-5`: provider pinned by the lock file.
- `grep -n '^deny' Internal-IT/engineering/policy-as-code/OPA -r` shows every rule uses the `deny[msg] {` form.

## Links

- Related: [ADR-0011](0011-fail-closed-scanner-contract.md), [ADR-0012](0012-tests-run-in-ci.md), [ADR-0013](0013-no-cloud-creds-for-plan-only.md), [ADR-0014](0014-control-mapping-changes-reviewed.md)
- Phase playbooks: [phase 4 – pipeline honest-green](../05-phase-playbooks/phase-4-pipeline-green.md), [phase 6 – next growth](../05-phase-playbooks/phase-6-next-growth.md)
