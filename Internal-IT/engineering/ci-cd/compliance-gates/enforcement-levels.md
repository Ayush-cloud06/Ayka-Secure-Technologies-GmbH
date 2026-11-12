# Enforcement levels

How a finding's severity becomes a result. The code is [`evaluate-results.py`](../scripts/evaluate-results.py); where this file and the code differ, the code is right and this file is wrong.

## Severity contract

| Remaining findings | Decision | Evaluator exit | What GitHub does |
|---|---|---|---|
| Any `HIGH` | `fail` | 1 | `compliance / compliance` is red; it is a required check, so the merge is blocked |
| No `HIGH`, any `MEDIUM` | `approval_required` | 0 | `compliance / compliance` is green; `medium-risk-approval` waits for a reviewer |
| Only `LOW`, or none | `pass` | 0 | Green; the finding is in the summary and the report |

"Remaining" means after exceptions are set aside (below).

**Limit.** The approval job is not a required check, so an `approval_required` decision holds the simulated apply, not the merge. Requiring `Gate Summary` in the ruleset closes this; it is an open owner action ([REAL-SDLC-002](../../../../Governance/records/real/sdlc/REAL-SDLC-002-first-github-runs-and-apply-timeout.md) section 5).

## Where a severity comes from

- A finding mapped in [`control-mapping.yaml`](../../policy-as-code/metadata/control-mapping.yaml) takes the control's severity, not the scanner's.
- An unmapped Checkov or tfsec finding takes the scanner's severity, raised to at least `MEDIUM`.
- An unmapped OPA finding is `MEDIUM`.
- So nothing unmapped can pass silently: a human sees it at the approval step.
- `CRITICAL` counts as `HIGH`; `INFO` and a missing severity count as `LOW` before the rule above. Any other value stops the run.

Unmapped findings are listed under `unmapped_findings` and counted in `metadata_coverage`.

## Mapping methods

| `mapping_method` | Meaning |
|---|---|
| `policy_id` | The Checkov or tfsec rule ID matched a control |
| `control_id_prefix` | The OPA message starts with a control ID, such as `[EC2_OPEN_SSH]` |
| `policy_package_message_pattern` | No prefix; the OPA package and message text matched a control's `message_patterns` |
| `control_id_prefix_unmapped` | The OPA message names a control ID that is not in the mapping |
| `scanner_default`, `opa_default` | Nothing matched; the fallback severity applies |

## Fail closed

The evaluator stops with exit 1, and writes no decision, when:

- a result file is missing or is not valid JSON;
- Checkov reports parsing errors, or scanned nothing (`resource_count` 0, or no passed and no failed checks);
- tfsec's output has no `results` list;
- OPA returned an error, an empty list, no result for a mapped package, or a mapped package that evaluated no rules;
- a severity in the mapping or in a result is not one it knows;
- an exception entry lacks `policy_id`, `resource`, `reason`, `owner` or `expires`;
- the scan mode is neither `plan` nor `source`.

## Exceptions

A finding that will not be fixed is listed in [`exceptions.yaml`](../../policy-as-code/metadata/exceptions.yaml).

- An entry matches on the exact rule ID and resource, and on its `workload` when it has one. Without a known workload, a scoped entry never matches.
- An expired entry stops matching; the finding counts again.
- Excepted findings do not count toward the decision. They stay in the summary (`excepted_findings`) and in the report, with reason, owner and expiry.
- tfsec names a module, not a resource, so one tfsec entry can cover more than one resource.

## Scan modes

- `plan` (default): Checkov and OPA read the plan; tfsec reads the source.
- `source`: for a root that cannot be planned without a real login. Checkov and tfsec read the source and OPA does not run. The summary says so in `tools_not_run`.

## Summary contract

`output/compliance-summary.json`, schema version 2.2, is the one decision artifact the workflow reads:

`schema_version`, `scan_mode`, `workload_dir`, `tools_not_run`, `decision`, `approval_required`, `decision_basis`, `totals`, `by_tool`, `by_control`, `metadata_coverage`, `distinct_totals`, `distinct_findings`, `mapped_findings`, `unmapped_findings`, `findings`, `excepted_findings`.

`totals` counts raw reports, so one problem found by three tools counts three times. `distinct_findings` groups them as one issue on one resource.
