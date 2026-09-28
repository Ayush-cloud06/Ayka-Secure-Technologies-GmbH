# ADR-0008: Drift detection is manual-only until a remote backend exists

- **Status:** Proposed
- **Date:** 2026-09-28
- **Deciders:** Ayush (owner)

## Context and problem statement

Drift detection means comparing the infrastructure that *exists* with what the code *says* should exist. That needs two things:

- a state file that records what was applied, and
- something that was actually applied.

This repository has neither for ayka-portal:

- **No backend block** in any `Internal-IT/workloads/**/*.tf` file (`grep -rn backend Internal-IT/workloads` returns nothing), so every CI runner starts with empty local state.
- **Nothing was ever applied.** The apply job only echoes a result (`run-apply.sh:24-27`, ADR-0006).

So `.github/workflows/drift-detection.yml` does the following every night:

1. Runs `terraform init` and `terraform plan -detailed-exitcode` (`:33-39`).
2. Sees 87 resources "to add".
3. Exits 2.
4. The "Report Drift" step (`:41-45`) turns that into a red run.

The workflow is scheduled nightly (`:3-6`) and assumes the real AWS role (`:27-31`). It failed **61 of 61 scheduled runs** (2026-04-16 to 2026-06-15). GitHub then set it to `disabled_inactivity` on 2026-06-15. That is GitHub's 60-day no-activity rule for scheduled workflows, not a reaction to the failures.

One more flaw: `continue-on-error: true` (`:38`) plus a check for exit code 2 only means a plan **error** (exit 1) is reported as green.

Your own treatment plan already says "keep scheduled drift disabled" (`risk-treatment-plan.md:51`). It also puts state custody (TRT-002) "before any live apply or scheduled drift" (`:21`). The YAML on `main` still has the cron line.

> **Why this matters to you:** a check that is red every night teaches everyone, including you, to ignore red. That is worse than having no check. A drift job is only meaningful once there is real state to drift *from*.

## Decision drivers

- CI signals must mean something (no permanent red, no silent green).
- Follow your own interim constraint (`risk-treatment-plan.md:51`).
- Keep the workflow as a ready-made building block for the later sandbox path (ADR-0010).
- No real cloud credentials for plan-only work (ADR-0013).

## Considered options

1. Re-enable the nightly schedule as it is.
2. Delete the drift workflow.
3. Manual-only (`workflow_dispatch`), with a guard that refuses to run without a remote backend, and correct exit-code handling.
4. Keep the schedule, but plan against a committed fake state file.

## Decision outcome

Chosen option: 3. It removes the permanent red, keeps the code for later, and makes the workflow tell the truth when someone runs it by hand.

Changes, in Phase 4:

- Remove the `schedule:` trigger (`drift-detection.yml:4-5`) and keep `workflow_dispatch`.
- Add a first step that fails with a clear message when the workload has no `backend` block. For example: `::error::No remote backend configured. Drift cannot be measured. See ADR-0008.`
- Handle every plan exit code explicitly:
  - `0` means no drift: green.
  - `2` means drift: red.
  - `1` means error: red.

  Drop `continue-on-error`.
- Remove the OIDC step while the workload uses mock credentials (ADR-0013).
- Label it **Planned** in the README until the conditions below are met (ADR-0006).

**When to bring the schedule back:** only after ADR-0010's first two steps are done, meaning a remote backend exists *and* a real sandbox apply has happened. At that point also:

- upload the drift plan as an artifact, and
- notify someone, instead of only turning red.

## Consequences

### Positive

- No more nightly red runs, and no more red runs that nobody reads.
- The YAML matches your risk treatment plan.
- A manual run gives an honest answer ("not measurable yet") instead of a fake "drift detected".

### Negative

- You can no longer honestly claim "drift detection" as a working feature. The README must say Planned.
- The guard is extra code that exists only to say "no". It is small, but it must be tested (ADR-0012).
- If you later add a backend but forget to apply, drift will again report everything as "to add". The sandbox step in ADR-0010 has to come first.

## Pros and cons of the options

### 1. Re-enable the schedule as it is

- Good: no work.
- Bad: guaranteed red every night (87 creates against empty state), and plan errors still show green.

### 2. Delete it

- Good: honest and zero maintenance.
- Bad: loses a working building block you will want in Phase 6.

### 3. Manual-only with a guard

- Good: honest, cheap, and ready for later.
- Bad: needs a few lines of shell and one test.

### 4. Fake state file

- Good: the job goes green.
- Bad: a simulation stacked on a simulation. The result proves nothing and would need its own label.

## Evidence

- `.github/workflows/drift-detection.yml:3-6` (cron and dispatch), `:27-31` (real role ARN), `:33-39` (plan, `continue-on-error`), `:41-45` (Report Drift, `if: … exitcode == '2'`).
- `grep -rn backend Internal-IT/workloads` returns no matches.
- GitHub Actions API: 61 `schedule` runs, all `failure`, from 2026-04-16T04:47Z to 2026-06-15T07:11Z ([research/codex.md](../research/codex.md) §3 row 14). The workflow state is `disabled_inactivity`, updated 2026-06-15 ([research/facts-lead.md](../research/facts-lead.md)).
- Job steps of run 27530067596: "Report Drift" ran and failed, so the plan exit code was 2 ([research/codex.md](../research/codex.md) §3 row 14). Logs have expired (HTTP 410).
- [research/pipeline.md](../research/pipeline.md) §7: local `terraform plan -detailed-exitcode` exits 2 with "Plan: 87 to add, 0 to change, 0 to destroy".
- `Governance/ISMS/03-risk-management/risk-treatment-plan.md:21,51` and `risk-register.md:38`.

## Links

- Related: [ADR-0005](0005-github-single-source-of-truth.md), [ADR-0010](0010-mock-plan-only-then-sandbox.md), [ADR-0013](0013-no-cloud-creds-for-plan-only.md)
- Phase playbooks: [phase 4 – pipeline](../05-phase-playbooks/phase-4-pipeline-green.md), [phase 6 – next growth](../05-phase-playbooks/phase-6-next-growth.md)
