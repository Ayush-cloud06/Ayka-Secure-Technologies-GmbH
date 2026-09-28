# ADR-0005: `.github/` is the single source of truth for pipelines

- **Status:** Proposed
- **Date:** 2026-09-28
- **Deciders:** Ayush (owner)

## Context and problem statement

Today there are three places that look like pipeline definitions:

| Location | What is there | Does GitHub run it? |
|---|---|---|
| `.github/workflows/*.yml` and `.github/actions/*/action.yml` | 4 workflows and 7 composite actions: the real pipeline | Yes |
| `Internal-IT/engineering/ci-cd/pipelines/**` | **14 YAML files, all 0 bytes**: code-security 2, compliance 3, core 4, drift 1, release 4 | No |
| `Internal-IT/engineering/ci-cd/templates/*.yml` | 2 **symlinks** (git mode `120000`) pointing back into `.github/workflows/` | No (they are pointers) |

On top of that:

- `.github/workflows/policy-check.yml` is a reusable workflow (`workflow_call` only) that **nothing calls**. The only reusable call in the repository is `test.yml:37` → `terraform-workflow.yml`. If someone did call it on its own, it would have no plan: conftest errors, `run-policy-check.sh` writes an error payload and exits 0, so the job is green while checking nothing ([research/pipeline.md](../research/pipeline.md) §1).
- `Internal-IT/engineering/ci-cd/architecture.md:5-11` describes five pipeline "layers" (`pipelines/core`, `code-security`, `compliance`, `release`, `drift`) as if they existed. They are the empty files above.

A reader cannot tell which pipeline is real without checking file sizes. You probably couldn't either, three months from now.

> **Why this matters to you:** GitHub Actions only runs workflows from `.github/workflows/`. Everything else is documentation pretending to be code. Two sources of truth always drift apart. Here, one of them was never filled in the first place.

## Decision drivers

- One place to read, one place to change.
- Only keep YAML that GitHub actually runs.
- Don't move the scripts. Many files already reference their paths (for example `check/action.yml:24,28` and `test.yml:31`).
- Small, reviewable Phase 3 commits.

## Considered options

1. Keep all three locations (status quo).
2. Make `.github/` the only pipeline definition. Delete the empty YAMLs, the symlinks and the unused `policy-check.yml`. Keep the scripts where they are.
3. Move the logic into `Internal-IT/engineering/ci-cd/` and make `.github/` thin wrappers.
4. Fill the 14 empty YAMLs with real workflows (release, promote, rollback, secrets scan, and so on).

## Decision outcome

Chosen option: 2. It matches how GitHub works, removes 17 misleading files, and changes no working path.

| Path | Role after this ADR |
|---|---|
| `.github/workflows/` | **Workflow definitions.** The only ones. |
| `.github/actions/` | **Composite steps.** The only ones. |
| `Internal-IT/engineering/ci-cd/scripts/` | **Logic.** Shell and Python called by the actions. Unit-tested (ADR-0012). |
| `Internal-IT/engineering/policy-as-code/` | **Rules and mapping.** Rego and `control-mapping.yaml`. |
| `Internal-IT/engineering/ci-cd/architecture.md` | Rewritten as a short pointer to `.github/` and [how-it-works](../how-it-works.md). |

To delete in Phase 3:

- `ci-cd/pipelines/**` (14 files)
- `ci-cd/templates/*.yml` (2 symlinks)
- `.github/workflows/policy-check.yml`

The empty `ci-cd/README.md` and `compliance-gates/*` placeholders are covered by ADR-0004.

## Consequences

### Positive

- One truthful answer to "where is the pipeline?"
- Only 3 workflows remain in `.github/workflows/`, all of them used: `test.yml`, `terraform-workflow.yml` and `drift-detection.yml` (manual-only per ADR-0008).
- No symlinks. Symlinks become plain text files on Windows checkouts unless `core.symlinks` is enabled, so this also removes a portability trap.

### Negative

- If you later want a "release" or "promote" pipeline, you design it from scratch. The empty files never contained a design anyway.
- `policy-check.yml` goes away. If you want a standalone OPA check, add it back as a job in `test.yml` that runs after a plan exists.
- `architecture.md` and `platform/structure.md` both mention the old layers. The prose must be fixed in the same commit, or you create broken references.
- `Internal-IT/engineering/` becomes "scripts + policy-as-code + docs", which is less impressive-looking. That is fine.

## Pros and cons of the options

### 1. Status quo

- Good: no work.
- Bad: 16 misleading files plus one dead workflow, and prose that describes things that don't exist.

### 2. `.github/` as the single source of truth

- Good: matches GitHub's model and changes no working path.
- Bad: removes aspirational structure some readers may like.

### 3. Logic in `ci-cd/`, thin `.github/` wrappers

- Good: keeps "engineering" content together.
- Bad: GitHub still needs workflow files in `.github/workflows/`, so you get two layers for every change. It also moves paths that 10+ files reference.

### 4. Fill the 14 YAMLs

- Good: matches `architecture.md`.
- Bad: scope creep outside the gate (ADR-0002). None of these pipelines has a target environment.

## Evidence

- `git ls-files -s Internal-IT/engineering/ci-cd/templates/` shows mode `120000` for `policy-check.yml` and `terraform-workflow.yml`.
- `git ls-files Internal-IT/engineering/ci-cd/pipelines | wc -l` gives 14. [research/inventory.md](../research/inventory.md) §2 (claim checks): all 0 bytes, same empty blob `e69de29`, and not referenced by any workflow or script.
- `grep -rn 'uses: ./.github/workflows' .github` finds a single hit, `.github/workflows/test.yml:37` (→ `terraform-workflow.yml`).
- `.github/workflows/policy-check.yml:4-11`: `workflow_call` only, and input `plan_json_path` is never used. `:18` has an unpinned `actions/checkout@v4`.
- [research/pipeline.md](../research/pipeline.md) §1: standalone `policy-check.yml` is a green no-op. §5: actionlint reports an invalid top-level `description:` at `policy-check.yml:2` and `terraform-workflow.yml:2`.
- `Internal-IT/engineering/ci-cd/architecture.md:5-11`: the five "layers".
- GitHub API `list_workflows` ([research/facts-lead.md](../research/facts-lead.md)): Policy Check Workflow is active and unused.

## Links

- Related: [ADR-0004](0004-delete-placeholders.md), [ADR-0008](0008-drift-manual-only.md), [ADR-0012](0012-tests-run-in-ci.md)
- Phase playbook: [phase 3 – prune](../05-phase-playbooks/phase-3-prune.md)
