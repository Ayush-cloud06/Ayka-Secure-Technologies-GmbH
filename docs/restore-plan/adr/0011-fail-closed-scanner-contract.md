# ADR-0011: Fail-closed scanner contract: verified, non-empty, schema-valid output and no silent fallbacks

- **Status:** Proposed
- **Date:** 2026-09-28
- **Deciders:** Ayush (owner)

## Context and problem statement

The evaluator is designed to fail closed. A missing file exits 1 (`evaluate-results.sh:13-18`), invalid JSON exits 1 (`evaluate-results.py:32-37`), and an OPA error payload exits 1 (`:282-285`). See [how it works §4](../how-it-works.md#4-what-fail-closed-means-here-and-where-it-is-true).

But the evaluator only checks that a file *exists and parses*. It never checks that the scanner *ran on the right thing and said something*. That gap is where the gate fails open today:

| # | Gap | Evidence |
|---|---|---|
| 1 | **tfsec results are always dropped.** `--out output/tfsec-result` writes a file with exactly that name. The script then sees no `tfsec-result.json` and writes `{"results":[]}`. The fallback also defeats the evaluator's missing-file check. | `run-tfsec.sh:13-19`. Run #68 lists `tfsec-result` (4137 B) *and* `tfsec-result.json` (15 B), and `by_tool` shows only checkov and opa. |
| 2 | **tfsec scans the wrong folder** in the regression job, because `WORKLOAD_DIR` is never passed. | `run-tfsec.sh:9`, `check/action.yml:26-28`, `test.yml:13`. The run #68 regression env shows ayka-portal. |
| 3 | **Checkov on a missing or broken plan exits 0** with `failed_checks: []` plus `parsing_errors`. The evaluator ignores `parsing_errors`, so the decision is `pass`. Checkov `{}`, tfsec `{}` and OPA `[]` also give `pass`. | `run-checkov.sh:13-16` (`\|\| true`), `evaluate-results.py:220-222`. [research/codex.md](../research/codex.md) §3 row 3 and [research/pipeline.md](../research/pipeline.md) F5 (checkov 3.3.20). |
| 4 | **Unmapped Checkov findings can never block.** Open-source Checkov reports `severity: null`, which becomes LOW. Checks that mirror HIGH controls, such as public SSH (CKV_AWS_24) and IMDSv1 (CKV_AWS_79), are unmapped. | `evaluate-results.py:48-54,229`. [research/pipeline.md](../research/pipeline.md) F6: 14/14 and 23/23 failed checks have `severity: null`. |

End to end, a probe plan with public SSH, an IMDSv1 instance and an `Action: ["*"]` IAM policy gets **`pass`** today ([research/pipeline.md](../research/pipeline.md) F9).

> **Why this matters to you:** "fail-closed" is the headline claim of this project (ADR-0002). Right now it is true for the evaluator and false for the pipeline. The fix is small, and it is the single best interview story in the repository: "I found my own fail-open bug by checking file sizes in the CI log."

## Decision drivers

- A `pass` must mean "all three scanners ran on the intended target and found nothing blocking".
- Silence is not success. An empty or missing result is an error.
- Keep scanner-specific quirks inside small, tested wrappers (ADR-0012).
- Unknown checks should be visible and should not block by accident. Tool upgrades are controlled by pinning (ADR-0015).

## Considered options

1. Fix only the tfsec file name (the 1-line fix).
2. A **scanner output contract**, enforced by the wrappers and the evaluator, with a MEDIUM floor for unmapped findings.
3. Replace the wrappers with a single orchestration tool or scanner.

## Decision outcome

Chosen option: 2. Every scanner result must pass these checks before the decision is computed. Otherwise the run ends with `decision=error`, exit 1.

1. **Exists** at the expected path. Wrappers never create or overwrite a result file after a failure. Delete `run-tfsec.sh:17-19`, and write to `--out "$OUTPUT_DIR/tfsec-result.json"`.
2. **Is non-empty.**
3. **Is schema-valid for its tool:**
   - **Checkov:** a JSON object with a `results.failed_checks` list and a `summary`, and **no parsing errors**. A non-empty `parsing_errors` means fail. `summary.resource_count` must be greater than 0 when the plan has resources.
   - **tfsec:** a JSON object whose `results` is a list.
   - **OPA/conftest:** a non-empty list. Every expected package (`policies.terraform.aws_ec2`, `aws_s3`, `aws_iam`, `aws_vpc`) must appear as a `namespace`, which proves the policies were loaded.
4. **Names its target.** `WORKLOAD_DIR` is a required input of the check action. `run-tfsec.sh` fails if it is unset (no default).
5. **Shows up in the summary.** `by_tool` lists all three tools, even with 0 findings, plus the tool version and target. A reviewer can then see that tfsec ran.

**Sub-decision: severity of unmapped findings.** The options were:

- (a) keep the scanner default (today: null becomes LOW);
- (b) floor at MEDIUM, meaning `max(scanner severity, MEDIUM)`;
- (c) fail on any unmapped finding.

**Chosen: (b).**

- It matches what you already do for OPA, where unmapped findings are MEDIUM (`evaluate-results.py:208-217`).
- It never *lowers* a tfsec HIGH or CRITICAL.
- It turns "unknown" into "a human must look" (`approval_required`) instead of "ignore" or "block everything".

Alongside it, map the Checkov IDs that mirror existing HIGH controls ([research/pipeline.md](../research/pipeline.md) F6). Those mapping edits go through ADR-0014.

## Consequences

### Positive

- `pass` becomes trustworthy, and "fail-closed" becomes true for the pipeline, not only the evaluator. This is milestone M4, "honest green".
- A broken scanner install, a wrong path or an empty plan turns the run red instead of green.
- `by_tool` becomes evidence that each scanner ran.

### Negative

- **ayka-portal is predicted to go from `pass` to `fail`** (HIGH 3 / MEDIUM 1 / LOW 14; [research/pipeline.md](../research/pipeline.md) F2):
  - AVD-AWS-0053 is a public ALB, **by design**.
  - AVD-AWS-0057 ×2 are false positives on a log-group ARN.

  They need documented exceptions with a reason and an expiry (ADR-0014), not a severity downgrade. Plan one session for this.
- Scenarios will change (predicted HIGH 17 / MEDIUM 16 / LOW 21, [research/pipeline.md](../research/pipeline.md) F4), so the strict regression job must be updated at the same time.
- The contract ensures scanners *ran*. It does **not** make the OPA rules correct. Root-module resources, standalone security-group rules, `Action: ["*"]` and plan-time unknowns are still missed ([research/pipeline.md](../research/pipeline.md) F7–F11). Those are separate Phase 4 fixes, and each needs a test.
- More code in the evaluator means more to test (ADR-0012).

## Pros and cons of the options

### 1. File-name fix only

- Good: 1 line.
- Bad: the next silent failure (missing plan, empty OPA output, wrong directory) still passes.

### 2. Output contract plus MEDIUM floor

- Good: closes the whole class of silent failures, and the unmapped policy is consistent across tools.
- Bad: roughly 40 lines plus tests. It will turn ayka-portal red until exceptions are documented.

### 3. New orchestration tool

- Good: may handle formats for you.
- Bad: a new dependency before Phase 5 (ADR-0002). You still have to prove it fails closed.

## Evidence

- `Internal-IT/engineering/ci-cd/scripts/run-tfsec.sh:9,13-19`, `run-checkov.sh:13-16`, `evaluate-results.sh:13-18`
- `Internal-IT/engineering/ci-cd/scripts/evaluate-results.py:48-54,208-217,220-222,282-289`
- `.github/actions/check/action.yml:26-28` and `.github/workflows/test.yml:13`
- [research/codex.md](../research/codex.md) §3 rows 1–3: reproduced with tfsec v1.28.14. On scenarios, the real `tfsec-result` held 25 findings (15 HIGH, 2 CRITICAL) while `tfsec-result.json` was `{"results":[]}`.
- Run #68 job logs: file sizes 4137 B vs 15 B, and `by_tool` = checkov and opa ([research/facts-lead.md](../research/facts-lead.md)) — <https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/32621618951>
- [research/pipeline.md](../research/pipeline.md) F1–F6 and F9. The local chain reproduces run #68 exactly (§6).

## Links

- Related: [ADR-0012](0012-tests-run-in-ci.md), [ADR-0014](0014-control-mapping-changes-reviewed.md), [ADR-0015](0015-pin-tool-versions.md), [ADR-0002](0002-identity-and-scope.md)
- Phase playbook: [phase 4 – pipeline honest-green](../05-phase-playbooks/phase-4-pipeline-green.md)
- Study guide: [how one finding travels](../how-it-works.md#3-how-one-finding-travels-scanner--control-id--severity--decision)
