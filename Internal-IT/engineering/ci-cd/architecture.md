# CI/CD architecture

The pipeline is defined in `.github/` and nowhere else.

| What | Where |
|---|---|
| Entry workflow, runs on every push | [`.github/workflows/test.yml`](../../../.github/workflows/test.yml) |
| Reusable gate: validate, plan, scan, decide, evidence, approval, apply | [`.github/workflows/terraform-workflow.yml`](../../../.github/workflows/terraform-workflow.yml) |
| Drift check | [`.github/workflows/drift-detection.yml`](../../../.github/workflows/drift-detection.yml) |
| Steps the workflows call | [`.github/actions/`](../../../.github/actions/) (validate, plan, check, policy, decision, evidence, apply) |
| Scripts the steps run | [`scripts/`](scripts/) |
| Policies and the control mapping | [`../policy-as-code/`](../policy-as-code/) |

Not built: release promotion, rollback, emergency bypass, secrets scanning and IAM diff checks. Earlier versions of this file described them as if they existed.
