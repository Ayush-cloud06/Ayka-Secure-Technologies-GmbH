# Control Validation Scenarios

This directory contains intentionally flawed Terraform used to validate CI/CD controls.

Keep it simple: bad EC2, bad S3, bad VPC, bad IAM.

Each folder should contain a small Terraform example that triggers one obvious finding.

Use these scenarios to generate real `terraform plan` output for policy checks instead of relying on dummy JSON.
