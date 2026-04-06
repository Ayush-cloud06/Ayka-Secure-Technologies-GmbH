# Enforcement Levels

This document defines the active  enforcement behavior for the CI/CD compliance pipeline.

## Severity Contract

- `HIGH`: the pipeline fails immediately after result evaluation.
- `MEDIUM`: the pipeline produces `approval_required` and routes to the manual approval environment.
- `LOW`: the finding is recorded in the summary artifact and evidence export, but does not block progression by itself.

## Severity Ownership

- When a finding is mapped in [control-mapping.yaml](/home/ayush/Compliance-Oriented-Cloud-Security-Platform/Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml), the severity comes from metadata.
- When a finding is not mapped:
  - Checkov and tfsec fall back to scanner-provided severity.
  - OPA falls back to `MEDIUM`.
- Unmapped findings are explicitly reported in `output/compliance-summary.json` under `unmapped_findings` and `metadata_coverage`.

## Mapping Methods

- `policy_id`: the scanner rule ID matched a control entry directly.
- `control_id_prefix`: the OPA message included a control ID prefix such as `[EC2_OPEN_SSH]`.
- `policy_package_message_pattern`: the OPA namespace and message text matched metadata patterns when a control prefix was absent.
- `scanner_default` or `opa_default`: no active control mapping matched, so fallback severity was used.

## Summary Contract

The evaluator emits `output/compliance-summary.json` with these Level 2 fields:

- `schema_version`
- `decision`
- `approval_required`
- `decision_basis`
- `totals`
- `by_tool`
- `by_control`
- `metadata_coverage`
- `mapped_findings`
- `unmapped_findings`
- `findings`

This summary is the single decision artifact consumed by the workflow.
