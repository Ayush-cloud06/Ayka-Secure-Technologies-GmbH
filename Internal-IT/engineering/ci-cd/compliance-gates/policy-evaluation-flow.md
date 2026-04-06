# Policy Evaluation Flow

This document describes the active  evaluation flow for the compliance pipeline.

## Flow

1. Terraform plan JSON is exported to `output/tfplan.json`.
2. Checkov scans the plan and writes `output/checkov-result.json`.
3. tfsec scans the workload and writes `output/tfsec-result.json`.
4. Conftest evaluates OPA policies and writes `output/opa-result.json`.
5. `evaluate-results.py` normalizes all findings into one shared model.
6. The evaluator applies metadata from [control-mapping.yaml](/home/ayush/Compliance-Oriented-Cloud-Security-Platform/Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml).
7. The evaluator writes `output/compliance-summary.json`.
8. GitHub Actions reads only the summary outputs for gating and approval routing.
9. Raw scanner JSON and the summary artifact are exported as evidence.

## OPA Mapping Logic

OPA findings are resolved in this order:

1. Match a control ID prefix in the message, for example `[S3_PUBLIC_ACCESS]`.
2. If no prefix exists, match the OPA namespace and message text using `message_patterns` in `control-mapping.yaml`.
3. If neither match succeeds, record the finding as unmapped and assign fallback severity.

## Decision Logic

1. Any `HIGH` finding sets `decision` to `fail`.
2. If there is no `HIGH` finding but there is at least one `MEDIUM` finding, set `decision` to `approval_required`.
3. If only `LOW` findings exist, set `decision` to `pass`.
4. Unmapped findings do not currently create a separate gate, but they are surfaced explicitly for Level 2 coverage tracking.
