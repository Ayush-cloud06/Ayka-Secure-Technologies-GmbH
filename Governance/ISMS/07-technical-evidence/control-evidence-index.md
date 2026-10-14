# Control evidence index

| Field | Value |
|---|---|
| Document ID | ISMS-07-01 |
| Owner | Cloud Platform Engineering |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or when scope, source configuration or evidence changes |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company. The CI gate operates on plans; the infrastructure has never been deployed.

## 1. Dated source record

Observed 2026-10-14 from [run 37498007502](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/37498007502), attempt 1, `main` commit `500a26312cff5b35ce70a796c3084a26897fa9ad` (run created 2026-10-06). The manifest identifies Terraform 1.7.5, Checkov 3.3.20, tfsec 1.28.14, conftest 0.45.0 / OPA 0.56.0 and Python 3.11.16.

| Artifact | Workload | Evaluator result | Availability observed 2026-10-14 |
|---|---|---|---|
| `compliance-evidence` (11428601525) | `Internal-IT/workloads/ayka-portal` | pass: 0 HIGH, 0 MEDIUM, 6 LOW; 14 excepted findings | Available; API expiry 2027-01-04T16:43:57Z |
| `compliance-evidence-regression` (11427664366) | `Internal-IT/workloads/control-validation-scenarios` | fail as required: 20 HIGH, 34 MEDIUM, 10 LOW raw; 7 / 25 / 9 distinct; 16 unmapped findings | Available; API expiry 2027-01-04T16:43:57Z |

The compliance, validation, unit-test and regression jobs completed successfully. The run itself has no completed conclusion: its simulated apply job remains waiting for environment approval. No deployment or approval is inferred. All 14 checksum entries in each downloaded artifact verified on 2026-10-14. The workload manifest's policy-input hashes match the local source used for this table.

| Workload file | SHA-256 |
|---|---|
| `output/tfplan.json` | `e1f1f350d3746bcea240a5b4fd20857c2943a3b96f613889dcd9cdc7c8d4710e` |
| `output/compliance-summary.json` | `40ed26560c4757c561ea776599658cbeabc1fbc1b82ffefac77bf698318057b7` |

## 2. Control lookup

Each row uses the run and two artifacts above. The first report column names the primary raw file from [control-mapping.yaml](../../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml); other listed tools have their own `output/<tool>-result.json` files in the same artifact. Counts are raw findings in the two `output/compliance-summary.json` files: **active** and **excepted** are from the workload; **negative** is from the regression scenarios. Zero means no reported finding in that summary, not a passing control test. The [negative detection contract](../../../Internal-IT/workloads/control-validation-scenarios/expected-controls.txt) asserts seven named controls; the other rows do not acquire regression coverage merely by being mapped.

| Control ID | Metadata Annex A references | Scanner rules | Primary report | Active | Excepted | Negative |
|---|---|---|---|---:|---:|---:|
| `EC2_OPEN_SSH` | A.8.20, A.8.21 | opa: EC2_OPEN_SSH; tfsec: AVD-AWS-0107; checkov: CKV_AWS_24 | `output/opa-result.json` | 0 | 0 | 3 |
| `S3_PUBLIC_ACCESS` | A.8.12, A.8.24 | opa: S3_PUBLIC_ACCESS; tfsec: AVD-AWS-0086; tfsec: AVD-AWS-0087; tfsec: AVD-AWS-0091; tfsec: AVD-AWS-0092; tfsec: AVD-AWS-0093 | `output/opa-result.json` | 0 | 0 | 10 |
| `EC2_MISSING_IMDSV2` | A.8.9, A.8.20 | opa: EC2_MISSING_IMDSV2; tfsec: AVD-AWS-0028; checkov: CKV_AWS_79 | `output/opa-result.json` | 0 | 0 | 3 |
| `S3_VERSIONING_DISABLED` | A.8.13, A.5.30 | checkov: CKV_AWS_21; tfsec: AVD-AWS-0090 | `output/checkov-result.json` | 0 | 0 | 4 |
| `EC2_MISSING_TAGS` | A.5.9 | opa: EC2_MISSING_TAGS | `output/opa-result.json` | 0 | 0 | 1 |
| `S3_ENCRYPTION_MISSING` | A.8.24 | opa: S3_ENCRYPTION_MISSING; tfsec: AVD-AWS-0088; tfsec: AVD-AWS-0132 | `output/opa-result.json` | 0 | 1 | 6 |
| `EC2_ROOT_VOLUME_UNENCRYPTED` | A.8.24 | opa: EC2_ROOT_VOLUME_UNENCRYPTED; tfsec: AVD-AWS-0131 | `output/opa-result.json` | 0 | 0 | 1 |
| `EC2_HTTP_OPEN` | A.8.20 | opa: EC2_HTTP_OPEN; checkov: CKV_AWS_260 | `output/opa-result.json` | 0 | 0 | 0 |
| `EC2_PROD_UNDERSIZED_INSTANCE` | A.5.30 | opa: EC2_PROD_UNDERSIZED_INSTANCE | `output/opa-result.json` | 0 | 0 | 0 |
| `EC2_PROD_SPOT_USAGE` | A.5.30 | opa: EC2_PROD_SPOT_USAGE | `output/opa-result.json` | 0 | 0 | 0 |
| `EC2_PUBLIC_EGRESS` | A.8.20, A.8.21 | tfsec: AVD-AWS-0104; checkov: CKV_AWS_382 | `output/tfsec-result.json` | 0 | 0 | 2 |
| `EC2_SECURITY_GROUP_RULE_DESCRIPTION` | A.5.37 | tfsec: AVD-AWS-0124 | `output/tfsec-result.json` | 0 | 0 | 2 |
| `S3_LOGGING_DISABLED` | A.8.15, A.8.16 | tfsec: AVD-AWS-0089; checkov: CKV_AWS_18 | `output/tfsec-result.json` | 0 | 1 | 4 |
| `S3_KMS_ENCRYPTION_REQUIRED` | A.8.24 | checkov: CKV_AWS_145 | `output/checkov-result.json` | 0 | 1 | 2 |
| `ALB_WAF_PROTECTION_REQUIRED` | A.8.20, A.8.21 | checkov: CKV2_AWS_28 | `output/checkov-result.json` | 0 | 0 | 0 |
| `ALB_TLS_ENFORCEMENT` | A.8.20, A.8.21, A.8.24 | checkov: CKV_AWS_2; checkov: CKV_AWS_103; checkov: CKV2_AWS_20 | `output/checkov-result.json` | 0 | 0 | 0 |
| `IAM_WILDCARD_POLICY` | A.8.2, A.8.3 | opa: IAM_WILDCARD_POLICY; checkov: CKV_AWS_62; checkov: CKV_AWS_63 | `output/opa-result.json` | 0 | 0 | 0 |
| `IAM_INLINE_POLICY_USAGE` | A.8.2 | opa: IAM_INLINE_POLICY_USAGE | `output/opa-result.json` | 0 | 0 | 0 |
| `IAM_USER_PROHIBITED` | A.5.17, A.8.2 | opa: IAM_USER_PROHIBITED | `output/opa-result.json` | 0 | 0 | 0 |
| `IAM_USER_MFA_MISSING` | A.8.5 | opa: IAM_USER_MFA_MISSING | `output/opa-result.json` | 0 | 0 | 0 |
| `VPC_DEFAULT_PROHIBITED` | A.8.20 | opa: VPC_DEFAULT_PROHIBITED | `output/opa-result.json` | 0 | 0 | 0 |
| `VPC_FLOW_LOGS_MISSING` | A.8.15, A.8.16 | opa: VPC_FLOW_LOGS_MISSING; checkov: CKV2_AWS_11 | `output/opa-result.json` | 0 | 0 | 2 |
| `ROUTE_TABLE_PUBLIC_IGW` | A.8.20, A.8.21 | opa: ROUTE_TABLE_PUBLIC_IGW | `output/opa-result.json` | 0 | 0 | 0 |
| `NETWORK_ACL_UNRESTRICTED_INGRESS` | A.8.20, A.8.21 | opa: NETWORK_ACL_UNRESTRICTED_INGRESS | `output/opa-result.json` | 0 | 0 | 1 |
| `CLOUDWATCH_LOG_GROUP_KMS_ENCRYPTION` | A.8.15, A.8.16, A.8.24 | checkov: CKV_AWS_158 | `output/checkov-result.json` | 3 | 0 | 0 |
| `SECRETS_MANAGER_CMK_ENCRYPTION` | A.8.24 | checkov: CKV_AWS_149 | `output/checkov-result.json` | 1 | 0 | 0 |
| `SNS_TOPIC_KMS_ENCRYPTION` | A.8.24 | checkov: CKV_AWS_26 | `output/checkov-result.json` | 1 | 0 | 0 |
| `SECURITY_GROUP_UNUSED` | A.8.15, A.5.15 | checkov: CKV2_AWS_5 | `output/checkov-result.json` | 0 | 4 | 1 |
| `S3_REPLICATION_DISABLED` | A.8.13, A.5.30 | checkov: CKV_AWS_144 | `output/checkov-result.json` | 0 | 2 | 2 |
| `S3_ACLS_DISABLED` | A.8.12, A.8.24 | checkov: CKV2_AWS_65 | `output/checkov-result.json` | 0 | 0 | 0 |
| `KMS_KEY_POLICY_DEFINED` | A.8.24 | checkov: CKV2_AWS_64 | `output/checkov-result.json` | 0 | 0 | 0 |
| `WAF_LOG4J_PROTECTION` | A.8.20, A.8.21 | checkov: CKV_AWS_192; checkov: CKV2_AWS_76 | `output/checkov-result.json` | 0 | 1 | 0 |
| `RDS_PERFORMANCE_INSIGHTS_ENCRYPTION` | A.8.24 | checkov: CKV_AWS_354 | `output/checkov-result.json` | 1 | 0 | 0 |
| `S3_NOTIFICATIONS_DISABLED` | A.8.15, A.8.16 | checkov: CKV2_AWS_62 | `output/checkov-result.json` | 0 | 0 | 2 |
| `SECRETS_MANAGER_ROTATION_DISABLED` | A.5.17, A.8.2 | checkov: CKV2_AWS_57 | `output/checkov-result.json` | 0 | 1 | 0 |
| `RDS_ENCRYPTION_IN_TRANSIT` | A.8.24 | checkov: CKV2_AWS_69 | `output/checkov-result.json` | 0 | 0 | 0 |
| `S3_LIFECYCLE_DISABLED` | A.8.13 | checkov: CKV2_AWS_61 | `output/checkov-result.json` | 0 | 0 | 2 |
| `WAF_LOGGING_DISABLED` | A.8.15, A.8.16 | checkov: CKV2_AWS_31 | `output/checkov-result.json` | 0 | 0 | 0 |

## 3. Retrieve, verify and regenerate

Run these commands in a restricted temporary directory, not in the repository's tracked files. Full plans can contain secrets or identity details. The download uses the current authenticated GitHub CLI session.

```bash
gh run download 37498007502 --repo Ayush-cloud06/Ayka-Secure-Technologies-GmbH --name compliance-evidence --dir workload-evidence
cd workload-evidence
sha256sum -c evidence/artifacts.sha256
```

Read `evidence/manifest.json` and compare its repository, commit, run, attempt, workload, tool versions and policy hashes with the intended source. Download `compliance-evidence-regression` to a separate directory and verify it independently. Recount findings by `control_id` in each summary; review `excepted_findings` with the dated [exception metadata](../../../Internal-IT/engineering/policy-as-code/metadata/exceptions.yaml). Checksum agreement establishes internal integrity, not independent authenticity.

From the repository root, regenerate the two public extracts with the [inventory generator](../../../Internal-IT/engineering/ci-cd/scripts/generate-asset-inventory.py):

```bash
python3 Internal-IT/engineering/ci-cd/scripts/generate-asset-inventory.py /restricted/workload-evidence/output/tfplan.json   --run-id 37498007502 --commit 500a26312cff5b35ce70a796c3084a26897fa9ad   --source-artifact compliance-evidence --workload Internal-IT/workloads/ayka-portal   --repository Ayush-cloud06/Ayka-Secure-Technologies-GmbH   --inventory-out Governance/ISMS/02-asset-management/asset-inventory.md   --iam-out Governance/ISMS/07-technical-evidence/iam-plan-extract.md
```

The generator reads managed resources recursively, cross-checks addresses against resource changes, applies the allowlist and Terraform sensitivity masks, and records the input hash. It is a manual snapshot tool; no inventory generation job is wired into CI. Review allowlisted tags before publishing. Do not commit the raw artifact. If the artifact expires, report the evidence unavailable and choose a new dated run; do not replace provenance with a local reconstruction.

## 4. Use and limitations

Cloud Platform Engineering refreshes this index after relevant pipeline, mapping or workload changes; Compliance & Risk Management reviews its relationship to the [SoA](../04-controls-and-soa/statement-of-applicability.md) and [gap analysis](../04-controls-and-soa/control-gap-analysis.md). The [access evidence index](../04-controls-and-soa/access-control-evidence-index.md) supplies the identity-specific boundary.

The gate evaluates mapped static findings; it cannot establish log delivery, restoration, patch installation, effective IAM access, personnel training or supplier performance. A mapping to an Annex A ID is not proof that the full control is implemented. Snapshot counts are neither detection coverage nor a longitudinal KPI. Historic exceptions are not renewed by this document. Independent review, durable evidence retention and runtime tests remain gaps under RISK-007/RISK-010 in the [risk register](../03-risk-management/risk-register.md).

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
