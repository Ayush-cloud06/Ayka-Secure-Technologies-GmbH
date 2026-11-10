# Foundation

> **Scanned design, never applied by the pipeline.** Since 2026-11-10 every root here is scanned by the `Platform Gate` job in `.github/workflows/test.yml` (see "What the gate covers"). Nothing is applied from CI. `remote-state/` was applied once from a laptop (its local state exists outside git); the other roots have no evidence of deployment.

Target Region for every AWS root: `eu-central-1` ([ADR-0003](../../../Governance/ADR/0003-target-region.md)). The region SCP denies all other Regions except global services and the us-east-1 EventBridge forwarding rules ([SCP README](aws-organization/modules/scp/README.md)).

## Bootstrap order and state custody

Remote state cannot store its own first state, so the order is fixed. Each step needs the previous one applied.

| Step | Root | Runs as | State | Creates |
|---|---|---|---|---|
| 1 | `remote-state/` | Management-account admin, from a workstation | **Local** `terraform.tfstate`, never committed (`.gitignore`). Must be kept encrypted outside git (not verified); it contains secrets (the Azure storage account keys are part of the `azurerm_storage_account` state) | S3 bucket `ayka-terraform-state` (versioned, public access blocked, TLS-only), DynamoDB table `terraform-locks`, Azure storage container `entra-id` |
| 2 | `aws-organization/` | Management account | S3 `aws-organization/terraform.tfstate` | Organization (SCP policy type, Identity Center trusted access), OUs, SCPs |
| 3 | `landing-zone/` | Management account, assuming `OrganizationAccountAccessRole` into security, dev and prod | S3 `landing-zone/terraform.tfstate` | Per account: KMS key, CloudTrail + Object-Lock log bucket (18 months), GuardDuty, Security Hub, AWS Config, EventBridge alert rules, `security-alerts` topic, break-glass role |
| 4 | `evidence-archive/` | Security account | S3 `evidence-archive/terraform.tfstate` | Object-Lock evidence bucket (COMPLIANCE, 18 months), OIDC writer role |
| 5 | `../domains/identity/aws-iam-core/` | Each member account | S3 `aws-iam-core/terraform.tfstate` | Cross-account roles, ABAC policies, permission boundary, `BreakGlassRole` |
| 6 | `../domains/identity/entra-id/` | Entra ID admin | Azure `entra-id/identity.tfstate` | Users, groups, admin accounts |
| 7 | `../domains/identity/aws-identity-center/` | Management account (Identity Center home Region `eu-central-1`) | S3 `aws-identity-center/terraform.tfstate` | Groups, permission sets, assignments |

Backend rules:
- Every AWS root uses the same `backend "s3"` block: bucket `ayka-terraform-state`, table `terraform-locks`, Region `eu-central-1`, `encrypt = true`; only `key` differs (`<root>/terraform.tfstate`). Terraform 1.7.5 (the CI pin) needs the DynamoDB table; S3-native locking needs 1.10+.
- Entra ID uses the Azure container created in step 1.
- A root that already has a local `terraform.tfstate` (for example `aws-iam-core/`) moves it with `terraform init -migrate-state` once step 1 exists, then the local file is deleted.
- Plan-only CI and `run-local-chain.sh` never touch these backends: they write a gitignored `ci_backend_override.tf` with a throw-away local backend, and the local runner plans a clean copy without `terraform.tfstate` or `*.tfvars`.

## What the gate covers

| Root | Mode | Checked | Not checked |
|---|---|---|---|
| `aws-organization/`, `landing-zone/`, `evidence-archive/`, `../domains/identity/aws-iam-core/` | plan (mock credentials, `TF_VAR_mock_credentials=true`: no role assumed, no AWS call) | fmt, validate, tflint, Checkov on the plan, OPA on the plan, tfsec on the source | Anything that needs a live account. Account IDs are AWS documentation IDs in CI |
| `remote-state/`, `../domains/identity/aws-identity-center/` | source (needs a real Azure login, or Identity Center lookups) | fmt, validate, tflint, Checkov and tfsec on the source | The OPA rules (they read a plan); values only known at plan time |
| `../domains/identity/entra-id/` | validate only | fmt, validate, tflint | No scanner: Checkov 3.3.20 and tfsec 1.28.14 have no rules for the `azuread` provider (Checkov reports `resource_count 0`) |

**Not merge-blocking yet:** the `Platform Gate` and `Platform Validate` checks are not in the required checks of ruleset `protect-main`, so a red platform job does not stop a merge. Adding them is an owner action in the GitHub settings.

Accepted findings are in [`exceptions.yaml`](../../engineering/policy-as-code/metadata/exceptions.yaml), each scoped to its root with `workload`, with a reason, an owner and a staggered expiry.

## Files

```text
README.md
aws-organization/.terraform.lock.hcl
aws-organization/README.md
aws-organization/backend.tf
aws-organization/main.tf
aws-organization/modules/ou-structure/README.md
aws-organization/modules/ou-structure/ous.tf
aws-organization/modules/ou-structure/outputs.tf
aws-organization/modules/ou-structure/versions.tf
aws-organization/modules/scp/README.md
aws-organization/modules/scp/attachment.tf
aws-organization/modules/scp/deny-disable-cloudtrail.json
aws-organization/modules/scp/deny-root-usage.json
aws-organization/modules/scp/restrict-region.json
aws-organization/modules/scp/scp.tf
aws-organization/modules/scp/versions.tf
aws-organization/organization.tf
aws-organization/outputs.tf
aws-organization/provider.tf
aws-organization/variables.tf
evidence-archive/.terraform.lock.hcl
evidence-archive/README.md
evidence-archive/backend.tf
evidence-archive/bucket.tf
evidence-archive/kms.tf
evidence-archive/outputs.tf
evidence-archive/provider.tf
evidence-archive/variables.tf
evidence-archive/writer.tf
landing-zone/.terraform.lock.hcl
landing-zone/README.md
landing-zone/backend.tf
landing-zone/enterprise_strict.tfvars
landing-zone/locals.tf
landing-zone/main.tf
landing-zone/modules/account_landing_zone/main.tf
landing-zone/modules/account_landing_zone/outputs.tf
landing-zone/modules/account_landing_zone/variables.tf
landing-zone/modules/account_landing_zone/versions.tf
landing-zone/modules/break_glass/main.tf
landing-zone/modules/break_glass/variables.tf
landing-zone/modules/break_glass/versions.tf
landing-zone/modules/core/alerts/outputs.tf
landing-zone/modules/core/alerts/sns.tf
landing-zone/modules/core/alerts/versions.tf
landing-zone/modules/core/docs/remediation.md
landing-zone/modules/core/iam/permission_boundary.tf
landing-zone/modules/core/iam/roles.tf
landing-zone/modules/core/iam/root_protection.tf
landing-zone/modules/core/iam/versions.tf
landing-zone/modules/core/kms/main.tf
landing-zone/modules/core/kms/versions.tf
landing-zone/modules/core/logging/cloudtrail.tf
landing-zone/modules/core/logging/outputs.tf
landing-zone/modules/core/logging/trail_bucket.tf
landing-zone/modules/core/logging/variables.tf
landing-zone/modules/core/logging/versions.tf
landing-zone/modules/core/main.tf
landing-zone/modules/core/outputs.tf
landing-zone/modules/core/s3/public_access_block.tf
landing-zone/modules/core/s3/versions.tf
landing-zone/modules/core/variables.tf
landing-zone/modules/core/versions.tf
landing-zone/modules/cost_controls/main.tf
landing-zone/modules/cost_controls/variables.tf
landing-zone/modules/cost_controls/versions.tf
landing-zone/modules/detection/config.tf
landing-zone/modules/detection/eventbridge.tf
landing-zone/modules/detection/guardduty.tf
landing-zone/modules/detection/outputs.tf
landing-zone/modules/detection/securityhub.tf
landing-zone/modules/detection/variables.tf
landing-zone/modules/detection/versions.tf
landing-zone/modules/quotas/main.tf
landing-zone/modules/quotas/variables.tf
landing-zone/modules/quotas/versions.tf
landing-zone/modules/siem/main.tf
landing-zone/modules/siem/variables.tf
landing-zone/modules/siem/versions.tf
landing-zone/provider.tf
landing-zone/variables.tf
platform-compliance.md
remote-state/.terraform.lock.hcl
remote-state/README.md
remote-state/bootstrap.tf
remote-state/main.tf
remote-state/provider.tf
```
