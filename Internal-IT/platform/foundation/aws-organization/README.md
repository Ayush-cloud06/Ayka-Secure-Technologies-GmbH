# AWS Organization Layer

This layer defines the root AWS Organization for Ayka Secure Technologies GmbH.

Scope:
- Creates the AWS Organization (ALL features, SCP policy type enabled, trusted access for IAM Identity Center)
- Creates the Security, Infrastructure and Workloads OUs (`modules/ou-structure`)
- Creates and attaches the SCPs to the Workloads OU (`modules/scp`): deny root, deny CloudTrail tampering, restrict Regions to `eu-central-1`

This layer does NOT:
- Create accounts
- Configure security services (see `../landing-zone`)

Runs only in a fresh management account. State: S3 key `aws-organization/terraform.tfstate` (bootstrap order in [../README.md](../README.md)). Scanned by the `Platform Gate` job in plan mode; never applied by the pipeline.
