# CI/CD Architecture

This CI/CD design treats infrastructure delivery as a controlled pipeline, not a direct deployment path. Every change moves through validation, security, compliance, planning, approval, and promotion before it is allowed to affect higher environments.

The architecture is organized into five layers:

- `pipelines/core`: baseline Terraform execution such as validate, plan, apply, and destroy.
- `pipelines/code-security`: early checks for secrets exposure and IAM risk before deployment logic runs.
- `pipelines/compliance`: policy enforcement with tools such as OPA, Checkov, and tfsec.
- `pipelines/release`: stage-to-prod promotion, rollback, and emergency bypass under explicit governance.
- `pipelines/drift`: scheduled detection of infrastructure drift outside approved delivery workflows.

The expected execution flow is simple: code is validated first, security and compliance gates run next, a plan is generated, approvals are applied for sensitive environments, and only then can promotion or apply proceed. This keeps deployment speed high in lower environments while preserving strong control for production.

