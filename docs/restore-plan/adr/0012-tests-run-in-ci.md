# ADR-0012: Evaluator unit tests and OPA policy tests run in CI as a gate

- **Status:** Proposed
- **Date:** 2026-09-28
- **Deciders:** Ayush (owner)

## Context and problem statement

You wrote tests, but CI never runs them.

- `tests/compliance/test_evaluate_results.py` has 5 tests (`:94`, `:118`, `:143`, `:169`, `:196`). They cover mapping happy paths: a mapped HIGH fails, unmapped OPA becomes MEDIUM, and metadata severity is used for Checkov and tfsec. Locally, `python3 -m pytest -q tests/` gives **5 passed**.
- The only CI job that touches code quality is `validate-scripts`, which runs `bash -n` on the shell scripts (`test.yml:24-33`). No workflow calls pytest or unittest.
- `python3 -m unittest discover -s tests` finds **0 tests**, because `tests/compliance/` has no `__init__.py`. Only pytest (or `-s tests/compliance`) finds them.
- There are **no Rego unit tests.** No `*_test.rego` file exists. `opa test` and `conftest verify` both report 0 tests and **exit 0**.
- `PyYAML`, which the evaluator imports, is not declared anywhere. It works only because `pip install checkov` pulls it in ([research/pipeline.md](../research/pipeline.md) F22).

Meanwhile the parts that decide pass or fail have known bugs that tests would have caught:

- the tfsec fallback (ADR-0011);
- Checkov `parsing_errors` being ignored;
- OPA rules that cannot see root-module resources, standalone security-group rules or `Action: ["*"]` ([research/pipeline.md](../research/pipeline.md) F7–F11).

> **Why this matters to you:** a test that never runs in CI is a note to self, not a control. A gate that decides pass or fail for infrastructure must itself be gated. Otherwise one careless edit to `evaluate-results.py` or a `.rego` file silently weakens every future run.

## Decision drivers

- The gate's own logic must be tested before it judges anything.
- Rules and evaluator change together, so both need tests.
- Run the same engine versions in tests and in the gate (ADR-0015).
- "0 tests" must be a failure, not a pass.
- Keep it quick. Local runs today take under a second.

## Considered options

1. Keep tests local only (status quo).
2. Run pytest in CI; no Rego tests.
3. Run pytest **and** Rego unit tests in a CI job that the scan jobs depend on.
4. Build a full end-to-end harness with committed plan-JSON fixtures for every rule.

## Decision outcome

Chosen option: 3. It closes the gap at low cost, and option 4 can grow from it later.

- **New job `unit-tests`** in `test.yml`, run before `compliance` and `regression` (both get `needs: unit-tests`). It does four things:
  1. Install pinned dependencies from a small `tests/requirements.txt` (pytest and PyYAML, exact versions).
  2. Run `python3 -m pytest -q tests/`.
  3. Install OPA **0.56.0**, the engine bundled in conftest v0.45.0 ([research/pipeline.md](../research/pipeline.md) §4), with a sha256 check. Then run `opa test -v Internal-IT/engineering/policy-as-code/OPA`. `conftest verify` against the same folder is an acceptable alternative with the same engine.
  4. **Fail if 0 Rego tests ran**, because `opa test` exits 0 when it finds nothing.
- **Minimum test set, added in Phase 4:**
  - **Evaluator:** one test per contract rule in ADR-0011 (missing file, empty file, Checkov `parsing_errors`, OPA missing a package, the MEDIUM floor for unmapped findings, and CRITICAL mapping to HIGH), plus the three-way decision table (`evaluate-results.py:417-421`).
  - **Wrappers:** `run-tfsec.sh` with a fake `tfsec` on `PATH`. It must write `tfsec-result.json` and must **not** write a fallback when tfsec fails.
  - **Rego:** for each `deny` rule, at least one fixture that fires and one that does not. Known blind spots (for example a root-module EC2 instance) get a test that documents current behaviour. When you fix the rule, you flip the test.
  - **Mapping file:** every control has a valid severity and a `rationale` (ADR-0014), and no `policy_id` appears twice.

## Consequences

### Positive

- Any change to the evaluator, a wrapper, a rule or the mapping is checked on every push.
- The regression workload and the unit tests together give two independent proofs that the gate bites.
- The tests pin down known rule weaknesses, so fixing them is visible progress, not a guess.
- It is a good interview topic: "how do you test a policy engine?"

### Negative

- Writing Rego fixtures is new work. With 18 `deny` rules in `OPA/terraform/`, expect 1–2 sessions.
- An extra OPA binary means one more version to keep in step with conftest (ADR-0015). `conftest verify` avoids this but gives less readable output. That is **UNVERIFIED** for v0.45.0; try both.
- Scans wait for tests, which adds perhaps half a minute of runner time per push (**UNVERIFIED**).
- Tests that document blind spots can look like "tests for bugs". Name them clearly, for example `test_root_module_instance_not_seen_known_gap`.

## Pros and cons of the options

### 1. Local only

- Good: nothing to do.
- Bad: no protection at all. That is today's situation.

### 2. pytest only

- Good: covers the evaluator in one step.
- Bad: rules stay untested, even though that is where most known bugs are ([research/pipeline.md](../research/pipeline.md) F7–F15).

### 3. pytest and Rego tests as a gate

- Good: covers both halves of the decision logic cheaply.
- Bad: new Rego test-writing skill needed, and one more pinned binary.

### 4. Full fixture harness

- Good: strongest end-to-end assurance.
- Bad: too big for Phase 4. Start with option 3, then add plan-JSON fixtures (such as the probe plan from [research/pipeline.md](../research/pipeline.md) F9) in Phase 6.

## Evidence

- `.github/workflows/test.yml:24-33`: `bash -n` only. `grep -rn 'pytest\|unittest' .github` finds nothing ([research/pipeline.md](../research/pipeline.md) F29).
- `tests/compliance/test_evaluate_results.py:48,94,118,143,169,196`: one class, five tests.
- `python3 -m pytest -q tests/` gives 5 passed. `python3 -m unittest discover -s tests` runs 0 tests ([research/codex.md](../research/codex.md) §4, [research/pipeline.md](../research/pipeline.md) §5).
- `opa test Internal-IT/engineering/policy-as-code/OPA` reports 0 tests, exit 0. `conftest verify` also reports 0 tests ([research/pipeline.md](../research/pipeline.md) §5).
- `.github/actions/policy/action.yml:11`: conftest v0.45.0, whose bundled engine is OPA 0.56.0 ([research/pipeline.md](../research/pipeline.md) §4).
- [research/codex.md](../research/codex.md) §3 row 4: tests are never run in CI.

## Links

- Related: [ADR-0011](0011-fail-closed-scanner-contract.md), [ADR-0014](0014-control-mapping-changes-reviewed.md), [ADR-0015](0015-pin-tool-versions.md)
- Phase playbook: [phase 4 – pipeline honest-green](../05-phase-playbooks/phase-4-pipeline-green.md)
- Study guide: [OPA rules: what they can and cannot see](../how-it-works.md#6-opa-rules-what-they-can-and-cannot-see)
