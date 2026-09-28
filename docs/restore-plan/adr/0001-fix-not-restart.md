# ADR-0001: Fix in place instead of restarting

- **Status:** Proposed
- **Date:** 2026-09-28
- **Deciders:** Ayush (owner)

## Context and problem statement

You left this repository in April 2026 and came back in August with two shortcuts in mind. One is to start a fresh repository. The other is to merge an AI-generated "cleanup" branch that rewrote most of the tree. Both feel faster than re-reading your own code. The question is which path gets you, soonest, a portfolio project you can explain line by line in an interview without losing what already works.

Here is what `main` (53b0532) actually looks like:

- **The core gate runs end to end, and the last CI run on `main` is green.** That is run #68 on 2026-08-23. ayka-portal returns `pass` (0 HIGH / 0 MEDIUM / 14 LOW). The scenarios workload returns `fail` (4 HIGH / 8 MEDIUM / 17 LOW), which is the expected result for the negative-test workload.
- **The code has not changed since 2026-04-15 (UTC).** `git diff --stat 243c3b1 53b0532 -- tests .github Internal-IT` is empty. Only governance Markdown and `.gitignore` changed after that.
- **373 tracked files:** 203 substantive, 80 title-only, 75 empty, 12 stubs, 2 symlinks and 1 binary.
- **The "PR Compliance Pipeline" has 68 runs of history.**
- **The AI branch is not on GitHub or in any clone we can reach** (ADR-0003).

The known defects are real but local:

- tfsec findings are silently dropped (`run-tfsec.sh:13-19`).
- Tests never run in CI.
- Three Entra modules contain plaintext passwords.
- About 165 files are placeholders.

None of these needs a new architecture.

> **Why this matters to you:** "Green" is partly false today, because tfsec output never reaches the evaluator. But that is a bug in a few lines of shell, not a reason to throw away 200 working files. An interviewer will ask "what went wrong and how did you find it?" A public commit history that shows the bug, the fix and the test is a much better answer than a new repository with no history.

## Decision drivers

- You must be able to explain every line you keep. You wrote `main`; you did not write the AI branch.
- Keep the proof that the gate works: 68 runs, the green run #68, and a regression job that fails on purpose.
- Make the smallest change that makes the repository honest.
- Time budget: about 13 sessions of 1–2 hours before the 2026-11-21 target (PLAN-SPEC phases 0–5).
- Keep the dated history. It shows the project was built over months (January to April 2026), not in a weekend.

## Considered options

1. Restart in a new repository.
2. Fix in place on `main` in small commits, following phases 0–5.
3. Merge the codex AI-cleanup branch (`codex/pre-restore-ai-cleanup-20260823`, f68766c).

## Decision outcome

Chosen option: 2, "Fix in place". The reasons:

- The core pipeline already runs and is green.
- The code has not changed since April, so the amount you have to re-learn is bounded.
- Every known defect has a small, local fix.

The other two options fail for specific reasons. Option 3 cannot be done, because the branch was never pushed, and it would bring in code you could not follow. Option 1 would rebuild the same design and throw away the run history that shows it works.

## Consequences

### Positive

- CI history (68 runs, green run #68) and the commit dates stay as evidence.
- Each fix is one small commit you can point at: here is the bug, here is the fix, here is the test.
- Nothing that works is thrown away. The regression workload keeps proving that the gate can fail.

### Negative

- You keep earlier structure choices, such as the `Internal-IT/` and `Governance/` split and the long paths, unless you change them one commit at a time.
- Old mistakes stay visible in history, including the Entra passwords. ADR-0007 decides whether history is rewritten.
- Pruning about 165 empty, title-only and stub files costs about three sessions (Phase 3). A restart would cost zero.
- **Expect a red build.** Once tfsec findings flow, ayka-portal is predicted to go from `pass` to `fail` (HIGH 3 / MEDIUM 1 / LOW 14; [research/pipeline.md](../research/pipeline.md) F2). That is the truth becoming visible, not a regression, but your badge will be red until you handle those findings (ADR-0014).

## Pros and cons of the options

### 1. Restart

- Good: a clean tree with no placeholders and no visible history of mistakes.
- Bad: loses 68 CI runs and months of dated commits. A repository created in a few weeks looks less credible.
- Bad: you would rebuild the same design (plan, then scanners, then control mapping, then evaluator), because the design is fine. The problems are bugs.
- Bad: the plaintext passwords stay in the old public repository unless you also delete it (ADR-0007).

### 2. Fix in place

- Good: keeps the evidence, gives the smallest diff, and makes every change explainable.
- Bad: it takes longer to look "clean" than a restart, and it needs a pruning phase.

### 3. Merge the codex branch

- Good, in theory: many fixes at once. The claim was 293 files, +9.5k/−3.8k lines, which is **UNVERIFIABLE** because the commit is gone.
- Bad: it is unavailable. It is not on GitHub and was never pushed (ADR-0003).
- Bad: even if it were found, it touches about 79% of the repository. You could not review it or defend it in an interview.
- Bad: you already walked away from it once, when you reset `main` to the April state. fe1b27e's parent is 243c3b1; it is not a `git revert`.

## Evidence

- Run #68, green, on 53b0532 (2026-08-23): <https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/32621618951> ([research/facts-lead.md](../research/facts-lead.md), "Run #68 evidence").
- `git diff --stat 243c3b1 53b0532 -- tests .github Internal-IT` prints nothing ([research/codex.md](../research/codex.md) §1; re-run 2026-09-28).
- `git log -1 --format=%ci 243c3b1` prints `2026-04-16 00:46:24 +0530`, which is 2026-04-15 19:16 UTC.
- `git show --name-status --format= fe1b27e` gives 84 `A` and 5 `M`, with parent 243c3b1.
- [research/inventory.md](../research/inventory.md) §2 (status totals): 203 substantive, 80 title-only, 75 empty, 12 stub, 2 symlink, 1 binary.
- GitHub Actions API: the highest "PR Compliance Pipeline" `run_number` is 68 ([research/facts-lead.md](../research/facts-lead.md), "Git / GitHub").
- [research/pipeline.md](../research/pipeline.md) §6: a local re-run with the same tool versions reproduces run #68 exactly, and predicts the tfsec-fixed ayka-portal result (F2).
- Local defects: `Internal-IT/engineering/ci-cd/scripts/run-tfsec.sh:13-19`, `.github/workflows/test.yml:24-33` (only `bash -n`, no tests), and the Entra passwords (ADR-0007).

## Links

- Related: [ADR-0003](0003-codex-branch-parts-bin.md), [ADR-0004](0004-delete-placeholders.md), [ADR-0011](0011-fail-closed-scanner-contract.md)
- Phase playbook: [phase 0 – orient](../05-phase-playbooks/phase-0-orient.md)
- Study guide: [how it works](../how-it-works.md)
