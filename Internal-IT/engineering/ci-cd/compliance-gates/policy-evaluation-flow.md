# Policy evaluation flow

The order of steps in one gate run. Severity rules, fail-closed conditions and exceptions are in [enforcement levels](enforcement-levels.md).

## Flow (plan mode)

1. `terraform plan` runs with mock credentials and no cloud login; the plan is exported to `output/tfplan.json`.
2. Checkov scans the plan and writes `output/checkov-result.json`.
3. tfsec scans the source of the same root and writes `output/tfsec-result.json`.
4. conftest evaluates the Rego rules on the plan and writes `output/opa-result.json`.
5. [`evaluate-results.py`](../scripts/evaluate-results.py) checks each input and stops if one is missing, malformed, errored or empty.
6. It turns all findings into one shared model and applies [`control-mapping.yaml`](../../policy-as-code/metadata/control-mapping.yaml).
7. It sets aside findings matched by an active entry in [`exceptions.yaml`](../../policy-as-code/metadata/exceptions.yaml).
8. It decides on what remains and writes `output/compliance-summary.json`.
9. GitHub Actions reads only the summary's outputs to route the run.
10. The report, the raw scanner JSON, a run manifest and SHA-256 checksums of every file are uploaded as the evidence artifact, also when the run fails.

In source mode there is no step 1 or 4: Checkov reads the source, OPA does not run, and the summary records that under `tools_not_run`.

## OPA mapping order

1. A control ID prefix in the message, for example `[S3_PUBLIC_ACCESS]`.
2. Otherwise the OPA package and message text, matched against `message_patterns` in the mapping.
3. Otherwise the finding is unmapped and counts as `MEDIUM`.

## Decision

1. Any `HIGH` finding: `fail`.
2. No `HIGH` but at least one `MEDIUM`: `approval_required`.
3. Only `LOW`, or nothing: `pass`.

An unmapped finding is at least `MEDIUM`, so it leads to `approval_required` or `fail`, never to a silent `pass`.

## After the decision

- `approval_required` starts the `medium-risk-approval` job, which waits for a reviewer.
- The simulated apply runs only on a manual dispatch from `main`, after `pass` or an approved medium decision. It verifies the checksums and that the bundle belongs to the commit, then prints `SIMULATED APPLY`.
