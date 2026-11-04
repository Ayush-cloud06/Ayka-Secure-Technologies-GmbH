# Technical and organizational measures: encryption, logging and backup

- **Organization:** Ayka Secure Technologies GmbH (simulated case study)
- **Framework:** GDPR Art. 32 (security of processing); Art. 25 where a measure is only a default in design
- **Document ID:** GDPR-12
- **Version:** 1.0
- **Last updated:** 2026-10-14
- **Status:** Draft. Not approved: no approval record exists

## 1. How to read this document

Labels match the [identity and access measures](identity-and-access-toms.md) and the yardstick in the [repository README](../../../README.md#4-capability-status):

- **Implemented**: the check runs in CI, and a run or test shows it working. It still does not prove a deployed store.
- **Planned (design-only)**: Terraform or a policy describes the measure. It is not deployed and, where noted, not scanned.
- **Not designed**: no rule is written.

Nothing in `ayka-portal` or the platform roots has been applied. A passing plan check protects no personal data in a running system. Gate control IDs point at [`control-mapping.yaml`](../../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml).

## 2. Encryption

| Measure | Status | Evidence | Gap |
|---|---|---|---|
| S3 buckets in the gated workload use the encryption control the gate maps | Implemented (plan check only) | `S3_ENCRYPTION_MISSING`, `S3_KMS_ENCRYPTION_REQUIRED`; traced in the [S3 control chain](../../ISMS/04-controls-and-soa/control-chain-s3-encryption.md) | The chain is a plan. No object exists |
| RDS storage, Performance Insights and transit encryption in the workload design | Implemented (plan check only) | `RDS_PERFORMANCE_INSIGHTS_ENCRYPTION`, `RDS_ENCRYPTION_IN_TRANSIT` | Not deployed. The certificate on the load balancer is a self-signed placeholder |
| EBS root volumes, CloudWatch log groups, Secrets Manager and SNS topics in the gated design | Implemented (plan check only) | `EC2_ROOT_VOLUME_UNENCRYPTED`, `CLOUDWATCH_LOG_GROUP_KMS_ENCRYPTION`, `SECRETS_MANAGER_CMK_ENCRYPTION`, `SNS_TOPIC_KMS_ENCRYPTION`, `KMS_KEY_POLICY_DEFINED` | Plan patterns. `CLOUDWATCH_LOG_GROUP_KMS_ENCRYPTION` had active LOW findings in the evidence snapshot cited by the [ISMS objectives](../../ISMS/00-context-and-governance/isms-objectives.md). Key use is not observed |
| Algorithm, key-custody and rotation rules | Planned (design-only) | [Cryptography policy](../../policies/cryptography-policy.md) | Draft. No key ceremony and no rotation record |
| Endpoint disk encryption | Planned (design-only) | [Endpoint policy](../../policies/user-endpoint-device-policy.md) | No device inventory |

## 3. Logging

| Measure | Status | Evidence | Gap |
|---|---|---|---|
| VPC flow logs, S3 access logs and WAF logs required by the gate | Implemented (plan check only) | `VPC_FLOW_LOGS_MISSING`, `S3_LOGGING_DISABLED`, `WAF_LOGGING_DISABLED` | Configuration in the plan. No delivery sample |
| CloudTrail organization trail, file validation and retention targets | Planned (design-only) | [Logging standard](../../policies/logging-and-monitoring-standard.md); landing-zone `cloudtrail.tf` is outside the workload gate | Not applied. Not scanned as part of `ayka-portal` |
| Alerting on security events | Not designed as an operating control | SNS topic in the landing-zone design; [logging standard](../../policies/logging-and-monitoring-standard.md) section 6 | No subscriber and no test. The standard says the rules do not exist yet |
| Clock comparison across log sources | Planned (design-only) | [Logging standard](../../policies/logging-and-monitoring-standard.md) section 5.1 | Sources are named. Offset is not measured |
| Access to a log archive limited to security roles | Planned (design-only) | Logging standard section 5 | The archive does not exist |

Personal data in future logs is PA-03. It is not occurring.

## 4. Backup and restoration

| Measure | Status | Evidence | Gap |
|---|---|---|---|
| S3 versioning, replication and lifecycle settings on the gated design | Implemented (plan check only) | `S3_VERSIONING_DISABLED`, `S3_REPLICATION_DISABLED`, `S3_LIFECYCLE_DISABLED` | Versioning is not a tested backup. Replication does not prove a second copy can be restored |
| RDS Multi-AZ and a short automated-backup setting | Planned (design-only) for the parts the gate does not score as backup success | [Retention policy](../../policies/records-and-data-retention-policy.md) records 7-day RDS automated retention as gated design; [BC/DR plan](../../policies/business-continuity-and-disaster-recovery-plan.md) | Single Region. No copy outside the account. No restore test |
| Restore procedure | Planned (design-only) | [Backup and restore procedure](../../ISMS/06-operational-procedures/backup-and-restore-procedure.md) | The procedure forbids treating an untested objective as a result |
| Independent retention of CI evidence | Not met | GitHub artifact retention is 90 days ([ISMS objectives](../../ISMS/00-context-and-governance/isms-objectives.md) OBJ-08) | The 18-month copy is not built (RISK-007) |

## 5. What can be shown today

The compliance-gate artifacts for the Implemented rows, as indexed in the [control evidence index](../../ISMS/07-technical-evidence/control-evidence-index.md). The policies above for the design-only rows.

Not available: a key-usage log, a delivered CloudTrail object, an alert acknowledgement, or a restore timed against the RPO in the BC/DR plan.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
