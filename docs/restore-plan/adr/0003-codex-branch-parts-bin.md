# ADR-0003: Codex AI-cleanup branch is a parts bin, never merged (and currently unavailable)

- **Status:** Proposed
- **Date:** 2026-09-28
- **Deciders:** Ayush (owner)

## Context and problem statement

In August 2026 an AI agent produced a cleanup branch, `codex/pre-restore-ai-cleanup-20260823` (commit f68766c). It was said to touch 293 files (+9.5k/−3.8k lines). You did not keep it. Commit fe1b27e ("Revert: cleanup") reset `main` to the 15 April code and added 84 one-line "# Title" stubs whose names came from the AI's ISMS tree.

Two questions follow. Can the branch still be used, and if so, how?

**The branch cannot be found anywhere we can reach:**

| Check | Result |
|---|---|
| `git cat-file -t f68766c` (local) | `fatal: Not a valid object name` |
| `git fetch origin f68766c` | `couldn't find remote ref` |
| `git ls-remote origin` | only `HEAD`, `refs/heads/main`, `refs/pull/1..6/head` |
| GitHub `get_commit f68766c` / REST `/commits/f68766c` | "No commit found" / HTTP 422 |
| GitHub activity API | 0 force pushes. Branch creations only for `main`, `test-pipeline` and `test-pipeline-2` |
| Pull request refs 1–6 | all from March 2026, all ancestors of `main`, none of them is the cleanup |
| Actions runs (131) | only on `main` and `test-pipeline-2`. No run on f68766c |

So the branch was **never pushed**. If it still exists, it is only on your laptop.

> **Why this matters to you:** an AI diff across 79% of the repository is not something you can defend in an interview. "I let a tool rewrite my project and merged it" is a weak story. "I compared a tool's suggestions against my code, took three ideas, and wrote them myself with tests" is a strong one.

## Decision drivers

- You must understand and be able to explain every line on `main` (ADR-0001).
- Nothing on `main` should depend on an artefact that may not exist.
- Don't delete anything the branch might be needed to compare against before Phase 2 is closed. That is why Phase 2 comes before the Phase 3 prune.
- Don't publish anything by accident. The repository is public (`forks_count: 0`).

## Considered options

1. Merge the branch, or cherry-pick whole commits from it.
2. Parts bin: archive it outside `main`, compare only code paths, and re-implement the ideas by hand in small commits.
3. Ignore it entirely and declare it lost now.

## Decision outcome

Chosen option: 2, "parts bin", with a deadline. Every fix category the branch reportedly contained can be re-implemented from `main` ([research/codex.md](../research/codex.md) §3), so the branch is at most a reference. It is never a source of commits.

**If you find it on your laptop during Phase 2:**

1. Check that it exists: `git cat-file -t f68766c` and `git branch -a --contains f68766c`.
2. Archive it without touching `main`. **Prefer the bundle.** Pushing a ref to this public repository publishes the AI's work.
   - `git bundle create codex-ai-cleanup.bundle codex/pre-restore-ai-cleanup-20260823 ^main`, stored outside the repository, or
   - `git push origin f68766c:refs/heads/archive/codex-ai-cleanup-20260823`, but only if you accept that it becomes public.
3. Compare **only code paths**: `git diff --stat main f68766c -- tests .github Internal-IT/engineering/ci-cd/scripts Internal-IT/engineering/policy-as-code '*.tf'`.
4. Take ideas, not commits. Re-implement each idea by hand in its own commit, with a test.

**Never `git merge` it and never `git checkout f68766c -- <path>` onto `main`.**

**If it is not found by the end of Phase 2 (planned for Thu 2026-10-15):** record it as lost in the Phase 2 playbook and move on. Nothing is lost, because every fix category already has a plan item that re-implements it from `main`:

| # | Category ([research/codex.md](../research/codex.md) §3) | Where it is handled |
|---|---|---|
| 1–3 | tfsec output path, `WORKLOAD_DIR`, evaluator fail-open | ADR-0011 |
| 4 | tests not run in CI | ADR-0012 |
| 5–6 | pinning, Rego v1 | ADR-0015 |
| 7–10, 12 | dead OPA/aws, regression strictness, checksum coverage, evidence export, jq bug | Phase 4 |
| 11 | simulated apply presented as real | ADR-0006 |
| 13 | Entra passwords | ADR-0007 |
| 14 | drift | ADR-0008 |
| 15 | empty files | ADR-0004 |

## Consequences

### Positive

- `main` only ever contains code you wrote and reviewed.
- The decision has a deadline, so it cannot block Phase 3.
- A bundle keeps your options open without publishing anything.

### Negative

- If the AI found a bug that nobody has found since, you might miss it. The risk is low, because three independent research passes re-checked the code paths ([research/codex.md](../research/codex.md), [research/pipeline.md](../research/pipeline.md), [research/terraform.md](../research/terraform.md)), but it is not zero.
- Re-implementing by hand is slower than cherry-picking.
- You will never be able to verify the "293 files" claim.

## Pros and cons of the options

### 1. Merge or cherry-pick

- Good: fastest, if the branch existed.
- Bad: not possible (not found). Even if found, it would bring in unreviewed code and repeat the change you already rejected in fe1b27e.

### 2. Parts bin with a deadline

- Good: safe, keeps what is useful, and ends on a fixed date.
- Bad: costs one session to look for the branch.

### 3. Declare lost now

- Good: zero effort.
- Bad: skips a cheap 10-minute check on your own machine.

## Evidence

- [research/codex.md](../research/codex.md) §1: the table above, with commands and API responses.
- [research/codex.md](../research/codex.md) §3: reconstruction table (15 fix categories checked against `main`).
- `git show -s --format='%h %p %s' fe1b27e` prints `fe1b27e 243c3b1 Revert: cleanup`. It has one parent, so it is not a merge or a revert.
- `git show --name-status --format= fe1b27e` gives 84 `A` and 5 `M`.
- `git diff --stat 243c3b1 53b0532 -- tests .github Internal-IT` prints nothing.

## Links

- Related: [ADR-0001](0001-fix-not-restart.md), [ADR-0004](0004-delete-placeholders.md), [ADR-0011](0011-fail-closed-scanner-contract.md)
- Detailed triage: [inventory/codex-branch-triage.md](../inventory/codex-branch-triage.md)
- Phase playbook: [phase 2 – codex branch triage](../05-phase-playbooks/phase-2-codex-branch-triage.md)
