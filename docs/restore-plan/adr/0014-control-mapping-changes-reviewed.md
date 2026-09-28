# ADR-0014: Severity and mapping changes need a written reason (the mapping is a controlled document)

- **Status:** Proposed
- **Date:** 2026-09-28
- **Deciders:** Ayush (owner)

## Context and problem statement

For every mapped finding, the severity comes from **your** YAML, not from the scanner (`evaluate-results.py:155,174,202`). `control-mapping.yaml` has 38 controls: 11 HIGH, 9 MEDIUM and 18 LOW. **None of them records why it has that severity.** There is no `rationale` field.

That makes the YAML the most powerful file in the repository. Whoever edits it controls the gate: set a control to LOW and its findings stop blocking.

In run #68, **all 14 ayka-portal findings mapped to LOW controls.** Three examples:

- `CKV2_AWS_5` → `SECURITY_GROUP_UNUSED`, ×4 (`control-mapping.yaml:560-575`).
- `CKV2_AWS_76` → `WAF_LOG4J_PROTECTION` (`:628-631`, severity LOW). This is the control for WAF protection against a well-known remote-code-execution bug. It may well be LOW for this workload, but nothing written down says why.
- The rest: CloudWatch, SNS, Secrets Manager and RDS encryption and rotation controls, all LOW.

There is a second lever. You already wrote `# checkov:skip=…` comments **with reasons**, for example `modules/security/main.tf:28` and `modules/database/main.tf:11`. That was the right instinct. But Checkov ignores these comments when it scans plan JSON, and 8 of the 14 findings are ones you tried to suppress ([research/pipeline.md](../research/pipeline.md) F24). So today the suppressions don't work, and the severities have no reasons.

This gets more important soon. Once tfsec findings flow (ADR-0011), ayka-portal gets three unmapped HIGH findings:

- a public ALB, AVD-AWS-0053, which is **by design**;
- two false positives, AVD-AWS-0057.

The tempting shortcut is to lower severities until the build is green. Your own rule forbids that: "do not suppress scanner findings merely to obtain a clean result" (`risk-treatment-plan.md:55`).

Nothing currently stops an unreviewed change either:

- `main` is unprotected, and there is no CODEOWNERS file ([research/facts-lead.md](../research/facts-lead.md); RISK-005, `risk-register.md:25`).
- The mapping's commit history (9 commits, 2026-03-25 to 2026-04-13) has messages like "expanded control mapping" that don't explain any severity.

> **Why this matters to you:** this is the first question a sharp interviewer asks about any policy gate: "who decides what's LOW, and how would I know if someone quietly downgraded something?" "Every severity has a written reason, a test enforces it, and changes only land through a PR that passed the gate" is a complete answer.

## Decision drivers

- Severity choices must be explainable later, by you or by a reviewer.
- Downgrades and exceptions must leave a trail, not just a diff.
- It must work for a **solo** maintainer. GitHub does not let you approve your own pull request.
- Exceptions (accepted findings) must be explicit, have an owner, and expire.

## Considered options

1. Status quo: edit the YAML freely and commit straight to `main`.
2. A `rationale` on every control, a test that enforces it, PR-only changes with required status checks, and one central exceptions list.
3. Require an independent reviewer's approval for every mapping change.
4. Drop the mapping's severity authority and use scanner severities only.

## Decision outcome

Chosen option: 2.

- **Every control gets `rationale:`**, 1–2 sentences on why this severity fits *this* project, and **`reviewed:`**, a date. LOW controls come first, because LOW is where risk hides.
- **A unit test** (ADR-0012) fails if any control has:
  - no `rationale`;
  - a severity outside HIGH / MEDIUM / LOW;
  - a duplicate `policy_id`.
- **Changes only through pull requests**, with branch protection on `main` requiring the `unit-tests`, `compliance` and `regression` checks.
  - Add a `CODEOWNERS` entry for `Internal-IT/engineering/policy-as-code/` and `Internal-IT/engineering/ci-cd/scripts/evaluate-results.py`, naming you.
  - **Required approvals stay off** while you are the only maintainer, because otherwise you could never merge. Turn them on when a second reviewer exists.
- **One exceptions list instead of inline skips.** Checkov ignores inline skips on plan scans anyway. Each entry holds: `policy_id`, `resource`, `reason`, `owner`, `expires`. For example: "AVD-AWS-0053 on the ALB: public by design, internet-facing portal".
  - The evaluator reports excepted findings in the summary as *excepted*. They are never silently dropped.
  - An expired exception counts as a normal finding again.
  - Move the reasons you already wrote in `# checkov:skip` comments into this list.
- **Reference only:** this is the same idea as ISO/IEC 27001:2022 Annex A 8.32 (change management), at small scale. Do not claim conformity with it.

## Consequences

### Positive

- Every severity and every exception has a reason you can read aloud in an interview.
- A quiet downgrade needs a PR, a rationale edit and green checks. It leaves a trail.
- The ayka-portal tfsec findings (ADR-0011) get handled honestly: excepted with reasons and expiry, not downgraded.

### Negative

- Writing 38 rationales takes about a session. Some will expose severities you can't justify, and you will change them.
- For a solo maintainer, CODEOWNERS and PR-only is a **process record, not separation of duties**. Say so. Don't claim independent review (TRT-005, `risk-treatment-plan.md:24`).
- Branch protection slows quick fixes: every change needs a PR and a green run.
- The exceptions list needs evaluator code and tests (ADR-0012). If it is done badly, it becomes a new way to fail open. Expiry and "report, don't drop" are what prevent that.

## Pros and cons of the options

### 1. Status quo

- Good: fast.
- Bad: invisible downgrades, and inline skips that don't work.

### 2. Rationale, test, PR-only and exceptions list

- Good: a written trail, enforced by CI, that works solo.
- Bad: upfront writing effort, and new evaluator code for exceptions.

### 3. Independent approval

- Good: real separation of duties.
- Bad: impossible with one maintainer today. Keep it as the upgrade path.

### 4. Scanner severities only

- Good: nobody can "game" severity.
- Bad: open-source Checkov reports no severity (`severity: null`), so everything becomes LOW. It also throws away the point of mapping to your own controls ([how it works §3](../how-it-works.md#3-how-one-finding-travels-scanner--control-id--severity--decision)).

## Evidence

- `Internal-IT/engineering/ci-cd/scripts/evaluate-results.py:155,174,202`: mapped severity comes from metadata.
- `Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml:560-575,628-631`. `grep -o 'severity: [A-Z]*' … | sort | uniq -c` gives HIGH 11, MEDIUM 9, LOW 18. `grep -n rationale` finds nothing.
- Run #68 ayka-portal: 14 findings, all LOW, 100% mapped ([research/facts-lead.md](../research/facts-lead.md); [research/pipeline.md](../research/pipeline.md) §6).
- [research/pipeline.md](../research/pipeline.md) F24: inline `checkov:skip` is ignored on plan JSON. Examples: `ayka-portal/modules/security/main.tf:28,35,42,49` and `modules/storage/main.tf:21`.
- [research/pipeline.md](../research/pipeline.md) F2: tfsec findings AVD-AWS-0053 and AVD-AWS-0057 ×2, unmapped HIGH.
- `git ls-files | grep -i codeowners` finds nothing. `git log --format='%h %ad %s' -- …/control-mapping.yaml` lists 9 commits (2026-03-25 to 2026-04-13).
- `Governance/ISMS/03-risk-management/risk-treatment-plan.md:24,55`, `risk-register.md:25`, `risk-management-methodology.md:163`.

## Links

- Related: [ADR-0011](0011-fail-closed-scanner-contract.md), [ADR-0012](0012-tests-run-in-ci.md), [ADR-0006](0006-honesty-labelling.md)
- Phase playbook: [phase 4 – pipeline honest-green](../05-phase-playbooks/phase-4-pipeline-green.md)
