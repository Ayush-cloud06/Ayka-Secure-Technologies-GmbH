# 00 · Executive summary

## Verdict: **fix in place.** Don't restart. Don't merge the AI branch.

The core of your project works. The pipeline, the evaluator, the 38-control mapping and the should-pass / must-fail workloads have been running green on `main` since August:

- [run #68](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/32621618951), 2026-08-23;
- the local re-run on 2026-09-28 matches it finding for finding.

The mess is around the core, not in it:

- 155 empty or title-only files;
- a README that claims more than the code does;
- three passwords in Terraform;
- a handful of small bugs that make the gate **quieter than it should be**. The worst is that tfsec findings are dropped on every run.

Each of these is fixable in a 1–2 hour session, by you, in code you already wrote.

The AI cleanup branch isn't an option anyway: it was **never pushed to GitHub** ([codex-branch-triage.md](inventory/codex-branch-triage.md)). Everything it was supposed to fix is small enough to redo yourself, which is what you want for a portfolio you'll be interviewed on.

---

## The project in one sentence

> "A compliance-as-code gate for Terraform: Checkov + tfsec + OPA scan a Terraform plan → findings are mapped to controls → a fail-closed evaluator decides pass/fail → a checksummed audit-evidence bundle and human-readable report are produced. It's backed by a simulated ISO 27001 case-study company, Ayka Secure Technologies GmbH."

This stays your sentence. [ADR-0002](adr/0002-identity-and-scope.md) proposes a more precise version: three outcomes, "tfsec scans the source", "evidence bundle" rather than "audit-evidence", "demonstrated on" rather than "backed by". Accept or reject it; nothing changes silently.

---

## Decision table

Scores 1 (bad) – 5 (good). Weight = how much the criterion matters for a flagship portfolio project.

| Criterion | Weight | Restart from scratch | **Fix in place** | Merge codex branch |
|---|---:|:---:|:---:|:---:|
| Keeps the working, tested core | 3 | 1: you'd rewrite a gate that already works | **5**: evaluator, mapping, workloads untouched | 3: unknown; 293 files changed |
| You can explain every line (ownership) | 3 | 5 | **4**: your code, re-learned via [how-it-works.md](how-it-works.md) | 1: you reverted it because you couldn't follow it |
| Time to flagship-ready | 2 | 1: many weeks | **4**: about 13 sessions | 3: review time ≈ rewrite time |
| Keeps credible history (65 commits, 68 CI runs) | 2 | 1: history lost | **5** | 3 |
| Risk of new bugs | 2 | 2: new code, new bugs | **4**: small, tested diffs | 2: +9.5k / −3.8k lines nobody reviewed |
| Available today | 1 | 5 | **5** | 1: not on GitHub, maybe only on your laptop |
| **Weighted total (max 65)** | | **31** | **58** | **29** |

> **Why a restart scores so low even though it's "clean":** you'd rebuild the same design (Checkov + tfsec + OPA → mapping → evaluator) and hit the same bugs. You'd also throw away the proof that it ran: 68 CI runs and a green August baseline. A restart doesn't answer "why did the first one fragment?" — too much scaffolding, too little verification. Fixing in place does, and the plan is designed around that lesson.

---

## What the investigation found (headline numbers)

| Finding | Evidence |
|---|---|
| CI is **green** on current `main` (runs #66–#68, 2026-08-23). Your "last green = 15 Apr" note is outdated. | GitHub API, [run #68](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/32621618951) |
| But green is partly false: **tfsec findings are dropped on every run**. With them counted, ayka-portal goes from `pass` (14 LOW) to **`fail`** (3 HIGH, 1 MEDIUM, 14 LOW). | `run-tfsec.sh:13-19`; run #68 lists `tfsec-result` 4137 B vs `tfsec-result.json` 15 B; local reproduction |
| A plan with public SSH (via rule resources), IMDSv1 and an `Action=["*"]` policy **passes** today | local probe; OPA blind spots `aws_ec2.rego:6-39`, `aws_iam.rego:11-15` |
| 5 evaluator tests pass locally, but **CI never runs them**. The negative-test job only prints a warning if the bad workload passes. | `test.yml:24-33`, `:94-98` |
| 3 literal Entra passwords in public `main` since 2026-03-22 (one is a break-glass account with no expiry) | `entra-id/modules/core/users.tf:16`, `modules/privileged/break_glass.tf:6-8`, `modules/privileged/admin_accounts.tf:9` |
| CI assumes a **real** AWS role via OIDC, but Terraform ignores it (hard-coded mock keys) | run #68 OIDC step; `ayka-portal/provider.tf:19-20` |
| 373 files: 203 substantive, **155 empty or title-only**, 12 stubs | inventory |
| All 8 Terraform roots pass fmt/validate; ayka-portal plans **87** resources offline | terraform 1.7.5 |
| Code on `main` is byte-identical to 15 April; the AI branch was never pushed | `git diff 243c3b1 53b0532 -- Internal-IT .github tests` is empty; GitHub activity log |

Full detail: [01-current-state.md](01-current-state.md).

---

## Top 5 things to do

1. **Record a baseline, then remove the passwords** ([Phase 0](05-phase-playbooks/phase-0-orient.md), [Phase 1](05-phase-playbooks/phase-1-secrets.md)). Tag `baseline-2026-10` and download run #68's evidence before it expires on 2026-11-21. Then answer one question honestly: *were those Entra accounts ever real?* That decides whether this is a code edit or an incident.
2. **Make the gate see everything it claims to see** ([Phase 4](05-phase-playbooks/phase-4-pipeline-green.md)): fix the tfsec path, pass the workload folder, validate scanner outputs. Expect ayka-portal to turn red. Then triage each finding with a written reason.
3. **Make the tests bite:** run pytest and `opa test` in CI, and make the regression job fail the build when the scenarios stop failing.
4. **Delete the 155 placeholders** ([Phase 3](05-phase-playbooks/phase-3-prune.md)) and keep *one* index of documents you plan to write.
5. **Rewrite the README around a capability table** ([Phase 5](05-phase-playbooks/phase-5-readme-and-demo.md)): Implemented / Simulated / Planned. Then rehearse a 3-minute demo that includes the tfsec bug story.

## Top 5 things NOT to do

1. **Don't restart**, and don't start a "v2" folder next to v1.
2. **Don't merge or cherry-pick the AI cleanup wholesale.** If you find it on your laptop, take at most one file at a time, only for a known issue, and only if you can explain every line ([ADR-0003](adr/0003-codex-branch-parts-bin.md)).
3. **Don't add new things** (SIEM, Security Hub, Terragrunt, SOC 2 mappings, dashboards) before the gate is honest. Ideas go to [Phase 6](05-phase-playbooks/phase-6-next-growth.md).
4. **Don't buy a green build.** No lowering severities, no blanket skips, no `continue-on-error`. Fix the Terraform or write down why the finding is accepted ([ADR-0014](adr/0014-control-mapping-changes-reviewed.md)).
5. **Don't fill empty templates with invented records.** No backdated minutes, approvals or audit logs. Your own risk docs already say this: "require real activities and processing facts, not additional blank templates" (`Governance/ISMS/03-risk-management/risk-register.md:42`).

---

## What you need to answer before Phase 1

The four blocking questions (defaults in brackets) are detailed in [risks-and-open-questions.md](risks-and-open-questions.md):

1. Were the Entra passwords ever used in a real tenant? [assume yes]
2. What can `github-actions-oidc-role` in AWS account `982081090103` do, and who can assume it? [assume broad]
3. Was any Terraform root ever applied for real, and do you have local state files? [assume no, except whatever created the OIDC role]
4. Would you accept rewriting `main`'s history if needed? [no]
