# Technical and organizational measures: encryption, logging and backup

- **Organization:** Ayka Secure Technologies GmbH (simulated case study)
- **Framework:** GDPR Art. 32 (security of processing); Art. 25 where a measure is only a default in design
- **Document ID:** GDPR-12
- **Version:** 1.3
- **Last updated:** 2026-11-12
- **Status:** Draft. Not approved: no approval record exists

## 1. How to read this document

Labels match the [identity and access measures](identity-and-access-toms.md) and the yardstick in the [repository README](../../../README.md#4-capability-status):

- **Implemented**: the check runs in CI, and a run or test shows it working. It still does not prove a deployed store.
- **Gated design (plan check, [REAL-INFRA-001](../../records/real/infra/REAL-INFRA-001-gate-run-all-roots.md))**: Terraform exists in a root that the gate plans and scans (`ayka-portal`, `landing-zone`, `evidence-archive`), never applied. The scan was first a local run of an uncommitted tree; the CI job for the platform roots first ran on GitHub on 2026-11-12 ([REAL-SDLC-002](../../records/real/sdlc/REAL-SDLC-002-first-github-runs-and-apply-timeout.md)) and is not a required check.
- **Planned (design-only)**: Terraform or a policy describes the measure. It is not deployed and, where noted, not planned or scanned.
- **Not designed**: no rule is written.

Nothing in `ayka-portal` or the platform roots has been applied. A passing plan check protects no personal data in a running system. Gate control IDs point at [`control-mapping.yaml`](../../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml).

## 2. Encryption

| Measure | Status | Evidence | Gap |
|---|---|---|---|
| S3 buckets in the gated workload use the encryption control the gate maps | Implemented (plan check only) | `S3_ENCRYPTION_MISSING`, `S3_KMS_ENCRYPTION_REQUIRED`; traced in the [S3 control chain](../../ISMS/04-controls-and-soa/control-chain-s3-encryption.md) | The chain is a plan. No object exists |
| RDS storage, Performance Insights and transit encryption in the workload design | Implemented (plan check only) | `RDS_PERFORMANCE_INSIGHTS_ENCRYPTION`, `RDS_ENCRYPTION_IN_TRANSIT` | Not deployed. The certificate on the load balancer is a self-signed placeholder |
| EBS root volumes, CloudWatch log groups, Secrets Manager and SNS topics in the gated design | Implemented (plan check only) | `EC2_ROOT_VOLUME_UNENCRYPTED`, `CLOUDWATCH_LOG_GROUP_KMS_ENCRYPTION`, `SECRETS_MANAGER_CMK_ENCRYPTION`, `SNS_TOPIC_KMS_ENCRYPTION`, `KMS_KEY_POLICY_DEFINED` | Plan patterns. `CLOUDWATCH_LOG_GROUP_KMS_ENCRYPTION` had active LOW findings in the evidence snapshot cited by the [ISMS objectives](../../ISMS/00-context-and-governance/isms-objectives.md). Key use is not observed |
| Algorithm, key-custody and rotation rules | Planned (design-only) for the policy; KMS keys with rotation enabled are Gated design (plan check, [REAL-INFRA-001](../../records/real/infra/REAL-INFRA-001-gate-run-all-roots.md)) | [Cryptography policy](../../policies/cryptography-policy.md); [`kms.tf`](../../../Internal-IT/workloads/ayka-portal/kms.tf), [`evidence-archive/kms.tf`](../../../Internal-IT/platform/foundation/evidence-archive/kms.tf) | Draft. No key ceremony and no rotation record; no key exists |
| Endpoint disk encryption | Planned (design-only) | [Endpoint policy](../../policies/user-endpoint-device-policy.md) | No device inventory |

## 3. Logging

| Measure | Status | Evidence | Gap |
|---|---|---|---|
| VPC flow logs, S3 access logs and WAF logs required by the gate | Implemented (plan check only) | `VPC_FLOW_LOGS_MISSING`, `S3_LOGGING_DISABLED`, `WAF_LOGGING_DISABLED` | Configuration in the plan. No delivery sample |
| CloudTrail organization trail, file validation and retention targets | Gated design (plan check, [REAL-INFRA-001](../../records/real/infra/REAL-INFRA-001-gate-run-all-roots.md)) | [Logging standard](../../policies/logging-and-monitoring-standard.md); [`cloudtrail.tf`](../../../Internal-IT/platform/foundation/landing-zone/modules/core/logging/cloudtrail.tf) in the `landing-zone` root | Not applied. Delivery never tested. No rule checks the one-year online and archive targets |
| Alerting on security events | Gated design (plan check, [REAL-INFRA-001](../../records/real/infra/REAL-INFRA-001-gate-run-all-roots.md)) | [`modules/detection`](../../../Internal-IT/platform/foundation/landing-zone/modules/detection/): GuardDuty, Security Hub, AWS Config and five EventBridge rules into the `security-alerts` SNS topic; [logging standard](../../policies/logging-and-monitoring-standard.md) section 6 | Never applied, no rule has fired, no test per rule. The topic has an e-mail subscription only: no paging, no on-call. Rules ALR-06, ALR-07 and ALR-09 of the standard have no Terraform |
| Clock comparison across log sources | Planned (design-only) | [Logging standard](../../policies/logging-and-monitoring-standard.md) section 5.1 | Sources are named. Offset is not measured |
| Access to a log archive limited to security roles | Planned (design-only) | Logging standard section 5 | The archive does not exist |

Personal data in future logs is PA-03. It is not occurring.

## 4. Backup and restoration

| Measure | Status | Evidence | Gap |
|---|---|---|---|
| S3 versioning, replication and lifecycle settings on the gated design | Implemented (plan check only) | `S3_VERSIONING_DISABLED`, `S3_REPLICATION_DISABLED`, `S3_LIFECYCLE_DISABLED` | Versioning is not a tested backup. Replication does not prove a second copy can be restored |
| RDS Multi-AZ and a short automated-backup setting | Planned (design-only) for the parts the gate does not score as backup success | [Retention policy](../../policies/records-and-data-retention-policy.md) records 7-day RDS automated retention as gated design; [BC/DR plan](../../policies/business-continuity-and-disaster-recovery-plan.md) | Single Region. No copy outside the account. No restore test |
| AWS Backup: daily recovery points of the database and the data bucket, 35 days, Vault Lock | Gated design (plan check, [REAL-INFRA-001](../../records/real/infra/REAL-INFRA-001-gate-run-all-roots.md)) | [`modules/backup`](../../../Internal-IT/workloads/ayka-portal/modules/backup/main.tf) in the `ayka-portal` root | Never applied; no recovery point exists. The vault is in the workload account and nothing is copied to another account or Region |
| Restore procedure | Planned (design-only) | [Backup and restore procedure](../../ISMS/06-operational-procedures/backup-and-restore-procedure.md) | The procedure forbids treating an untested objective as a result |
| Restore-and-verify method (dump, destroy, restore, compare checksums) | Simulated (local fixture test only) | [`restore-test.sh`](../../../Internal-IT/engineering/ci-cd/scripts/restore-test.sh), run once in `local` mode: [REAL-INFRA-002](../../records/real/infra/REAL-INFRA-002-restore-test-local-postgres.md) | A local PostgreSQL container with synthetic data (10,000 and 30,000 rows). Not AWS Backup, not RDS, not the vault; restore time says nothing about production. The `aws` mode has never run |
| Independent retention of CI evidence | Not met; archive root is Gated design (plan check, [REAL-INFRA-001](../../records/real/infra/REAL-INFRA-001-gate-run-all-roots.md)) | GitHub artifact retention is 90 days ([ISMS objectives](../../ISMS/00-context-and-governance/isms-objectives.md) OBJ-08); [`evidence-archive`](../../../Internal-IT/platform/foundation/evidence-archive/) (Object Lock, 548 days) | The 18-month copy is not built: no workflow step uploads to the bucket (RISK-007) |

## 5. Rights handling and privacy tooling

| Measure | Status | Evidence | Gap |
|---|---|---|---|
| Access and erasure request handled end to end, processor path | Simulated operation | [SIM-DSR-001](../../records/simulated/privacy/SIM-DSR-001-access-and-erasure-request.md) | Tabletop. No request, no customer, no deployed portal. Six procedure defects were found; one is still open (no private request register) |
| DPIA for security logging decided before collection | Simulated operation | [SIM-GDPR-003](../../records/simulated/privacy/SIM-GDPR-003-dpia-sign-off.md) | Tabletop. DPO advice outstanding; no log is delivered |
| Find and erase one person's records, with legal hold and audit log | Simulated (fixture test only) | [REAL-PRIV-001](../../records/real/privacy/REAL-PRIV-001-dsr-tool-test-run.md) | Synthetic SQLite fixture. Not run on any deployed store. Backups and Git history are not searched |
| Masking by removal, synthetic values or tokens, with a label and a leak test | Simulated (fixture test only) | [REAL-PRIV-001](../../records/real/privacy/REAL-PRIV-001-dsr-tool-test-run.md) | Function library, no approved product, not used on any real data set |

## 6. What can be shown today

The compliance-gate artifacts for the Implemented rows, as indexed in the [control evidence index](../../ISMS/07-technical-evidence/control-evidence-index.md). The policies above for the design-only rows.

Not available: a key-usage log, a delivered CloudTrail object, an alert acknowledgement, or a restore timed against the RPO in the BC/DR plan.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
| 1.1 | 2026-11-10 | Section 5 added: rights handling and privacy tooling, linked to simulated and real records |
| 1.2 | 2026-11-10 | Gated design label added for scanned Terraform: CloudTrail, detection and alerting, AWS Backup with Vault Lock, KMS keys, evidence archive. Local restore test recorded (REAL-INFRA-002) |
| 1.3 | 2026-11-12 | Gated design note: the platform CI job has run on GitHub (REAL-SDLC-002); still not a required check |
