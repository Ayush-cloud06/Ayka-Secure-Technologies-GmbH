# Foundation

> **Planned: design-only.** These roots validate locally (`terraform init -backend=false && terraform validate`) but are not scanned by the compliance gate. `remote-state/` was applied once from a laptop (local state exists outside git); the other roots have no evidence of deployment.

Note: `remote-state/` mixes an AWS bootstrap (`bootstrap.tf`: S3 + DynamoDB) and Azure storage (`main.tf`: the Entra ID state backend).

```text
README.md
aws-organization/.terraform.lock.hcl
aws-organization/README.md
aws-organization/main.tf
aws-organization/modules/ou-structure/README.md
aws-organization/modules/ou-structure/ous.tf
aws-organization/modules/ou-structure/outputs.tf
aws-organization/modules/scp/README.md
aws-organization/modules/scp/attachment.tf
aws-organization/modules/scp/deny-disable-cloudtrail.json
aws-organization/modules/scp/deny-root-usage.json
aws-organization/modules/scp/restrict-region.json
aws-organization/modules/scp/scp.tf
aws-organization/organization.tf
aws-organization/outputs.tf
aws-organization/provider.tf
landing-zone/.terraform.lock.hcl
landing-zone/README.md
landing-zone/enterprise_strict.tfvars
landing-zone/locals.tf
landing-zone/main.tf
landing-zone/modules/account_landing_zone/main.tf
landing-zone/modules/account_landing_zone/outputs.tf
landing-zone/modules/account_landing_zone/variables.tf
landing-zone/modules/account_landing_zone/versions.tf
landing-zone/modules/break_glass/main.tf
landing-zone/modules/break_glass/variables.tf
landing-zone/modules/core/alerts/outputs.tf
landing-zone/modules/core/alerts/sns.tf
landing-zone/modules/core/docs/remediation.md
landing-zone/modules/core/iam/permission_boundary.tf
landing-zone/modules/core/iam/roles.tf
landing-zone/modules/core/iam/root_protection.tf
landing-zone/modules/core/logging/cloudtrail.tf
landing-zone/modules/core/logging/outputs.tf
landing-zone/modules/core/logging/trail_bucket.tf
landing-zone/modules/core/main.tf
landing-zone/modules/core/outputs.tf
landing-zone/modules/core/s3/public_access_block.tf
landing-zone/modules/core/variables.tf
landing-zone/modules/cost_controls/main.tf
landing-zone/modules/cost_controls/variables.tf
landing-zone/modules/quotas/main.tf
landing-zone/modules/quotas/variables.tf
landing-zone/modules/siem/main.tf
landing-zone/modules/siem/variables.tf
landing-zone/provider.tf
landing-zone/variables.tf
platform-compliance.md
remote-state/.terraform.lock.hcl
remote-state/README.md
remote-state/bootstrap.tf
remote-state/main.tf
remote-state/provider.tf
```
