# Workloads

Two Terraform workloads exercise the compliance gate. Both are **Simulated**: the AWS provider runs with mock credentials, plans are refresh-free, and nothing is deployed.

| Workload | Role | Expected gate decision |
|---|---|---|
| [`ayka-portal/`](ayka-portal/) | Realistic customer-portal workload | **pass** (LOW findings only; accepted exceptions are listed in the report) |
| [`control-validation-scenarios/`](control-validation-scenarios/) | Deliberately insecure resources | **fail**, with the controls listed in [`expected-controls.txt`](control-validation-scenarios/expected-controls.txt) |

## ayka-portal

`ayka-portal/main.tf` wires five modules plus a workload KMS key (`kms.tf`). The plan creates about 87 resources:

| Module | What it defines |
|---|---|
| `modules/networking/` | Its own VPC, public/private/database subnets, internet and NAT gateway, route tables, VPC flow logs to CloudWatch |
| `modules/security/` | Security groups for the ALB, ECS tasks, the EC2 instance and the database, with explicit ingress/egress rules |
| `modules/compute/` | Internet-facing ALB (HTTPS, TLS 1.2+ policy) with WAF, ECS Fargate cluster/service/task, autoscaling, an EC2 instance |
| `modules/database/` | RDS PostgreSQL (Multi-AZ), parameter and subnet groups, credentials in Secrets Manager |
| `modules/storage/` | Application bucket and access-log bucket: encryption, versioning, lifecycle, public-access block, notifications |

## Compliance mapping

The gate maps scanner findings to the controls in [`control-mapping.yaml`](../engineering/policy-as-code/metadata/control-mapping.yaml), which carry ISO/IEC 27001:2022 references. Examples relevant to this workload:

| Domain | Control IDs (ISO/IEC 27001:2022) |
|---|---|
| Data at rest | `S3_ENCRYPTION_MISSING`, `S3_KMS_ENCRYPTION_REQUIRED`, `EC2_ROOT_VOLUME_UNENCRYPTED` (A.8.24) |
| Data in transit | `ALB_TLS_ENFORCEMENT` (A.8.20, A.8.21, A.8.24), `RDS_ENCRYPTION_IN_TRANSIT` (A.8.24) |
| Network exposure | `EC2_OPEN_SSH`, `EC2_PUBLIC_EGRESS`, `ALB_WAF_PROTECTION_REQUIRED` (A.8.20, A.8.21) |
| Logging | `VPC_FLOW_LOGS_MISSING`, `S3_LOGGING_DISABLED`, `WAF_LOGGING_DISABLED` (A.8.15, A.8.16) |
| Access control | `IAM_WILDCARD_POLICY`, `IAM_INLINE_POLICY_USAGE` (A.8.2, A.8.3) |

Changes to `main` go through a pull request with required CI checks once the branch ruleset is active; approvals aren't required while there is one maintainer.

## Run it locally (plan-only)

```bash
cd ayka-portal
terraform init -input=false
AWS_ACCESS_KEY_ID=mock AWS_SECRET_ACCESS_KEY=mock terraform plan -input=false -refresh=false
```

For the full gate (plan, three scanners, decision) use `Internal-IT/engineering/ci-cd/scripts/run-local-chain.sh`.
