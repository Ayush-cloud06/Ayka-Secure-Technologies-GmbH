# Control Validation Scenarios

This directory contains intentionally insecure or non-compliant Terraform used to validate CI/CD compliance gates.

It exists to prove that policy checks, static analysis, and severity handling behave as expected against realistic Terraform plans.

## Rules

- Do not treat these scenarios as deployable workloads.
- Keep each scenario small and focused on one control failure.
- Add a short `README.md` inside each scenario with the expected result: `block`, `warn`, or `pass`.
- Prefer generating `terraform plan` and `terraform show -json` from these scenarios instead of using hand-written test JSON.

## Scope

Typical cases include bad S3, EC2, IAM, VPC, logging, encryption, and network security configurations.
