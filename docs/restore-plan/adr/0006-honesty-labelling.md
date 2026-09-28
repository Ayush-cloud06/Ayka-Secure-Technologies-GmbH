# ADR-0006: Implemented / Simulated / Planned labels

- **Status:** Proposed
- **Date:** 2026-09-28
- **Deciders:** Ayush (owner)

## Context and problem statement

The repository mixes three kinds of things without telling the reader which is which:

- Code that really runs in CI and produces evidence.
- Code that runs but fakes its effect.
- Things that exist only as design or prose.

Four examples:

- The apply job prints `Apply complete! Resources: 14 added, 0 changed, 0 destroyed.` (`run-apply.sh:24-27`). Nothing is applied, and the real plan has 87 resources.
- The cost check prints `Simulated cost check: Passed.` because infracost is not installed (`run-cost-check.sh:10-12`).
- The README lists "SIEM integration" (`README.md:24`). The only code is a Firehose stream with no source (`landing-zone/modules/siem/main.tf:16-27`), in a root that has never been applied.
- The README says "drift detection" (`README.md:25`). The workflow failed 61 of 61 nights and GitHub then disabled it.

Your own risk docs already name this problem. RISK-008 is "A reviewer could mistake the mock-provider, refresh-free workload and simulated apply for a deployed platform" (`risk-register.md:28`). TRT-008 asks you to "display the evidence boundary wherever results are summarized" (`risk-treatment-plan.md:27`).

> **Why this matters to you:** "Simulated" is not a weakness. It is a design choice you can defend: "I don't apply to a real account from a portfolio repository, and here is exactly where the simulation starts." An unlabelled simulation, found by the reviewer instead of pointed out by you, reads as dishonest.

## Decision drivers

- A reviewer should know within seconds whether a claim is backed by a run.
- The labels must be simple enough to put in a README table and in log output.
- They should fit the evidence-confidence scale you already use (E1–E4, `risk-management-methodology.md:87-90`).
- No marketing words.

## Considered options

1. No labels. Rely on prose caveats.
2. Three labels: **Implemented / Simulated / Planned**, with the rules below.
3. Reuse the E1–E4 evidence-confidence levels directly.
4. Delete everything that is not Implemented.

## Decision outcome

Chosen option: 2.

| Label | Definition | Examples from this repository |
|---|---|---|
| **Implemented** | Code exists, runs in CI, and a run URL or a test shows it doing the real thing | Plan → Checkov and OPA → evaluator decision (run #68). The regression workload fails as intended: scenarios `fail`, 4 HIGH (run #68). `tfplan.json` checksum verified in the apply job (run #68 log line `output/tfplan.json: OK`). |
| **Simulated** | Code runs, but its effect is faked, stubbed, or run against fake inputs | Apply: `run-apply.sh:24-27` echoes a hard-coded result, introduced by 243c3b1. Cost check: `run-cost-check.sh:10-12`. Mock AWS credentials: `ayka-portal/provider.tf:19-24`. The company itself: "simulated case study", `risk-register.md:3`. Human approval, until reviewers are proven: the apply job started about 4 s after it was queued in run #68 (**UNVERIFIED** config). |
| **Planned** | Designed, written down, or Terraform that the gate never plans or scans. Nothing in CI proves it | SIEM (`siem/main.tf:16-27`). The six platform roots (ADR-0002). ISMS documents listed as `Planned` in the index (ADR-0004). Drift detection until a backend exists (ADR-0008). |

Rules:

1. **The weakest true label wins.** If you cannot link a run or a test, it is not Implemented.
2. **Every Implemented row links to evidence:** a run URL, a test file, or a committed evidence snapshot (ADR-0009).
3. **A label can carry one caveat line.** Until Phase 4, the tfsec row reads "Implemented, *results dropped by a wrapper bug* (`run-tfsec.sh:13-19`)".
4. **Out-of-scope items are removed, not labelled Planned** (ADR-0002): SOC 2, Terragrunt, zero trust, automated remediation.
5. **Simulations say so at runtime too.** For example, `run-apply.sh` should print `SIMULATED APPLY: no resources were created` instead of a fake Terraform summary.

How the labels relate to your E-scale (for governance docs):

- **Planned** is about E1 (Defined).
- **Simulated**, and Implemented-but-local-only, are about E2 (Locally verified).
- **Implemented** with a CI run is about E3 (Externally verified).
- Nothing in this repository is E4 (Operating).

## Consequences

### Positive

- The Phase 5 README can be a capability table with one label and one link per row.
- It answers RISK-008 and TRT-008 with something visible, so it is more than a register entry.
- It gives you a clean interview answer to "is this deployed?"

### Negative

- The README will show several **Simulated** and **Planned** rows. Some readers will skim past the project. They are not your audience.
- It is a maintenance duty: every change that alters behaviour must update the label. That is a review step (ADR-0014).
- The fake "14 added" line goes. The apply job becomes visibly a no-op, which it always was.

## Pros and cons of the options

### 1. Prose caveats only

- Good: no new vocabulary.
- Bad: caveats get lost in paragraphs, and today they are missing entirely.

### 2. Implemented / Simulated / Planned

- Good: three words, self-explanatory, and they work in tables and logs.
- Bad: judgement calls at the edges. Rule 1 settles those.

### 3. E1–E4 directly

- Good: already defined in your methodology.
- Bad: it measures the strength of evidence for a risk statement, not whether a capability is real. It does not separate "ran for real" from "ran against fakes". Readers outside compliance won't know it.

### 4. Delete everything not Implemented

- Good: nothing to label.
- Bad: throws away the design work (ADR-0002 keeps it as context) and the simulated apply, which is a legitimate part of the demo.

## Evidence

- `Internal-IT/engineering/ci-cd/scripts/run-apply.sh:24-27`: hard-coded "14 added". [research/terraform.md](../research/terraform.md) §4: 243c3b1 replaced a real `terraform apply` with this echo, and the real plan is 87 creates.
- `Internal-IT/engineering/ci-cd/scripts/run-cost-check.sh:6-13`: infracost is missing, so it prints "Simulated cost check: Passed."
- `Internal-IT/workloads/ayka-portal/provider.tf:19-24`: static mock keys and `skip_*` flags.
- `README.md:24-25`: SIEM and drift claims. `Internal-IT/platform/foundation/landing-zone/modules/siem/main.tf:16-27`: Firehose only.
- `Governance/ISMS/03-risk-management/risk-register.md:28` (RISK-008) and `risk-treatment-plan.md:27` (TRT-008).
- `Governance/ISMS/03-risk-management/risk-management-methodology.md:87-90`: E1–E4 definitions.
- Run #68: <https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/32621618951> ([research/facts-lead.md](../research/facts-lead.md): apply log, checksum line, job timings).

## Links

- Related: [ADR-0002](0002-identity-and-scope.md), [ADR-0008](0008-drift-manual-only.md), [ADR-0009](0009-governance-links-evidence.md), [ADR-0010](0010-mock-plan-only-then-sandbox.md)
- Phase playbooks: [phase 0](../05-phase-playbooks/phase-0-orient.md), [phase 5 – README and demo](../05-phase-playbooks/phase-5-readme-and-demo.md)
- Study guide: [the stages, one by one](../how-it-works.md#2-the-stages-one-by-one)
