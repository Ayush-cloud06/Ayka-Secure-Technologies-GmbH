# ADR-0002: Project identity and scope boundary

- **Status:** Proposed
- **Date:** 2026-09-28
- **Deciders:** Ayush (owner)

## Context and problem statement

`README.md` describes a "comprehensive, compliance-oriented cloud security platform" (`README.md:5`). It lists five frameworks (`:12`, `:34-38`), SIEM integration (`:24`), zero-trust (`:61`), continuous monitoring with automated remediation (`:62`) and Terragrunt (`:67`).

What actually runs is narrower. It is a compliance gate for Terraform: plan, then scanners, then control mapping, then decision, then evidence. It runs on two workloads. Everything else is design-only Terraform or prose.

An interviewer who opens the repository will judge it by the gap between the claim and the code. You need one sentence that says what the project is, and a boundary that says what is in, what is context, and what is out.

**Nothing changes until you accept this ADR.** Until then, the original sentence stays the working identity in these plan documents.

| | Identity sentence |
|---|---|
| **Original** | "A compliance-as-code gate for Terraform: Checkov + tfsec + OPA scan a Terraform plan → findings are mapped to controls → a fail-closed evaluator decides pass/fail → a checksummed audit-evidence bundle and human-readable report are produced. It's backed by a simulated ISO 27001 case-study company, Ayka Secure Technologies GmbH." |
| **Proposed** | "A compliance-as-code gate for Terraform: Checkov and OPA scan the Terraform plan and tfsec scans the source, every finding is mapped to an ISO 27001-referenced control, a fail-closed evaluator decides pass / needs-approval / fail, and each run leaves a checksummed evidence bundle and a readable report. It is demonstrated on Ayka Secure Technologies GmbH, a simulated ISO 27001 case study." |

Why the proposed sentence is more accurate:

1. **There are three outcomes, not two.** The evaluator returns `fail`, `approval_required` or `pass` (`evaluate-results.py:417-421`).
2. **tfsec reads the folder, not the plan.** It is called on `$TARGET_DIR` (`run-tfsec.sh:13`), while Checkov reads `output/tfplan.json` (`run-checkov.sh:14`).
3. **"Audit-evidence" over-claims.** Your own treatment TRT-007 forbids "audit-ready" language until evidence is retained and independently reviewed (`risk-treatment-plan.md:26`).
4. **"Backed by" becomes "demonstrated on".** The company is simulated, and ADR-0006 asks every claim to say so.

A caveat: "fail-closed" is only true after Phase 4 (ADR-0011). Until then, the README must not use the word without the caveat.

## Decision drivers

- Every claim must point to code that runs, or be labelled (ADR-0006).
- You are one person with about two sessions a week. Scope has to fit that.
- Interview value comes from depth in one working thing, not breadth across many unfinished ones.
- Your own interim constraint: "present Ayka as a simulated case study, not a certified or deployed company platform" (`risk-treatment-plan.md:56`).

## Considered options

1. Keep the README's platform scope and try to build toward it.
2. Narrow the identity to the gate, keep the platform roots as labelled design-only context, and drop the unbuilt claims.
3. Narrow the identity to the gate and remove the platform roots from `main` now.

## Decision outcome

Chosen option: 2. It makes every remaining claim checkable without deleting about 100 substantive Terraform files you may still want to show as design work. It also adds a rule: **no new AWS services, scanners or compliance frameworks until Phase 5 is done.**

| Ring | What | Rule |
|---|---|---|
| **In (the gate)** | `.github/` (workflows and actions), `Internal-IT/engineering/ci-cd/scripts/`, `Internal-IT/engineering/policy-as-code/`, `tests/`, `Internal-IT/workloads/ayka-portal`, `Internal-IT/workloads/control-validation-scenarios`, and governance docs that link to evidence (ADR-0009) | Must work, be tested in CI, and be described accurately |
| **Context (design-only)** | `Internal-IT/platform/foundation/{aws-organization,landing-zone,remote-state}` and `Internal-IT/platform/domains/identity/{aws-iam-core,aws-identity-center,entra-id}` | May stay, labelled **Planned / design-only**. Not planned or scanned by the gate. Never described as deployed |
| **Out** | SIEM, SOC 2, NIST CSF and CIS as "supported frameworks", Terragrunt, zero-trust claims, automated remediation, continuous monitoring, incident-response workflows | Removed from README claims. Revisit only after Phase 5 |

Why the platform roots are "context" and not "in":

- The CI gate targets only the two workloads (`test.yml:13-14`, `drift-detection.yml:17`).
- The six platform roots pass `terraform validate` locally, but none is planned in CI.
- None of them reads another root's state ([research/terraform.md](../research/terraform.md) §2).

### Open decision: the "80–120 files" target

After Phase 3 the repository will have about 195–205 non-empty files. Getting to 80–120 is only possible by moving the platform tree out of `main`. `Internal-IT/platform` has 118 tracked files, 101 of them substantive. The move could be a tag such as `archive/platform-2026` followed by deleting the tree from `main`, which leaves about 103 files ([02-target-state.md](../02-target-state.md#the-80120-file-question-an-honest-answer)).

**Default: keep the platform tree as labelled design-only context.** Decide at the end of Phase 3, or defer to Phase 6. The same choice is open question Q7 in [risks-and-open-questions.md](../risks-and-open-questions.md#before-phase-23).

- **Archive:** a smaller repository that is easier to review, and no design-only Terraform next to the gate. The cost is that you lose visible identity and landing-zone design work, and links into `platform/` from governance docs break.
- **Keep:** it shows breadth, and no links break. The cost is that a reviewer has to read the labels to know what runs. RISK-012 already warns that these roots have no safe apply order (`risk-register.md:32`).

## Consequences

### Positive

- The README can become a table of claims where each row links to code or a CI run (Phase 5).
- Scope creep has a written stop rule.

### Negative

- The README loses impressive-sounding lines (SOC 2, SIEM, zero trust). That may feel like a downgrade. It is really a credibility upgrade.
- About 100 design-only files stay in the repository. You must label them, and they still need honest README text.
- The identity sentence mentions ISO 27001. Controls cite Annex A IDs (`control-mapping.yaml:8-9`), but the ISO numbering across other docs is inconsistent (2013 vs 2022; [research/inventory.md](../research/inventory.md) §9). That must be fixed or kept out of the claims.

## Pros and cons of the options

### 1. Keep the platform scope

- Good: no README rewrite.
- Bad: every out-of-scope claim stays false or unverifiable ([research/inventory.md](../research/inventory.md) §7 lists 10+ over-claims).

### 2. Gate in, platform as context

- Good: honest, cheap, and reversible.
- Bad: reviewers must read labels. A larger tree.

### 3. Gate only, archive platform now

- Good: smallest, clearest repository.
- Bad: irreversible in practice, since people rarely browse tags. It is decided before you have re-read the platform code.

## Evidence

- `README.md:5,12,24,34-38,60-62,67`: over-claims ([research/inventory.md](../research/inventory.md) §7).
- `Internal-IT/engineering/ci-cd/scripts/evaluate-results.py:417-421`: three decisions.
- `Internal-IT/engineering/ci-cd/scripts/run-tfsec.sh:13` (folder) vs `run-checkov.sh:14` (plan JSON).
- `Governance/ISMS/03-risk-management/risk-treatment-plan.md:26`: TRT-007 bans "audit-ready" until evidence is retained. `:56` requires the simulated case-study framing.
- `.github/workflows/test.yml:13-14`: only the two workloads are gated.
- `git ls-files | grep -i terragrunt` prints nothing. The only `.hcl` files are provider lock files.
- `Internal-IT/platform/foundation/landing-zone/modules/siem/main.tf:16-27`: a Firehose stream with no source. There is no SIEM.
- [research/terraform.md](../research/terraform.md) §6: all 8 roots pass `fmt`, `init -backend=false` and `validate`, and only the two workloads were planned.
- `git ls-files Internal-IT/platform | wc -l` gives 118. [research/inventory.md](../research/inventory.md) §2 (per-folder table): 101 of them substantive. Size of each option: [02-target-state.md](../02-target-state.md#the-80120-file-question-an-honest-answer).

## Links

- Related: [ADR-0006](0006-honesty-labelling.md), [ADR-0009](0009-governance-links-evidence.md), [ADR-0010](0010-mock-plan-only-then-sandbox.md)
- Phase playbooks: [phase 0](../05-phase-playbooks/phase-0-orient.md), [phase 3](../05-phase-playbooks/phase-3-prune.md), [phase 5](../05-phase-playbooks/phase-5-readme-and-demo.md)
