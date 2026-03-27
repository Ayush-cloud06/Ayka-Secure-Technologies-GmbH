# Control Validation Scenarios

This directory contains intentionally flawed Terraform used to validate CI/CD controls.

Keep it simple: bad EC2, bad S3, bad VPC, bad IAM.

Each folder should contain a small Terraform example that triggers one obvious finding.

Use these scenarios to generate real `terraform plan` output for policy checks instead of relying on dummy JSON.

## Selective testing

The root module now supports enabling only the scenarios you want to validate.

By default, all scenarios are enabled. To run a subset, set `enabled_scenarios` in a root `terraform.tfvars` file:

```hcl
enabled_scenarios = [
  "ec2_imdsv2",
  "s3_public",
]
```

You can also disable everything and turn on one scenario at plan time:

```bash
terraform plan -var='enabled_scenarios=["vpc_permissive_network_acl"]'
```

Supported scenario names:

- `ec2_imdsv2`
- `ec2_openssh`
- `s3_encryption`
- `s3_public`
- `vpc_permissive_network_acl`
