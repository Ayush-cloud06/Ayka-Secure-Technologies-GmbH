# Backup and restore procedure

| Field | Value |
|---|---|
| Document ID | ISMS-OPS-06 |
| Owner | Cloud Platform Engineering |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or restore test, architecture change or recovery incident |
| Status | Draft. Not approved: no approval record exists (simulated company) |

Ayka Secure Technologies GmbH is a simulated company; this document does not establish a performed activity.

## 1. Scope and prerequisite

Implement the [BC/DR plan](../../policies/business-continuity-and-disaster-recovery-plan.md) for database data, object evidence, configuration and future Terraform state. Workload backup settings are **Gated design** in [database](../../../Internal-IT/workloads/ayka-portal/modules/database/main.tf) and [storage](../../../Internal-IT/workloads/ayka-portal/modules/storage/main.tf); no backup or restore test has occurred. Repository copies do not substitute for customer-data or protected-state backups.

Cloud Platform Engineering must establish asset owners, backup location/access, encryption-key custody, retention/deletion constraints, authorized isolated restore space and real monitoring before production use. Resolve RISK-002 and RISK-012 in the [treatment plan](../03-risk-management/risk-treatment-plan.md) before state migration or live apply. The target Region is `eu-central-1`; existing `ap-south-1` provider defaults conflict with it (RISK-011). Confirm source and recovery locations before any real copy.

## 2. Backup design and verification

| Data | Current design/source | Required operating evidence before reliance |
|---|---|---|
| RDS | Seven-day automated backup retention, deletion protection and final snapshot in the database module | Successful backup inventory, latest recoverable point, encrypted snapshot ownership, key usability and tested restoration |
| S3 evidence | Versioning and noncurrent lifecycle in the storage module | Version inventory, deletion behavior, checksum recovery and protection against account/key compromise |
| Terraform state | Fragmented/local state risk; backend design unresolved | Restricted encrypted backup, ownership/locking, access log and test of safe recovery without concurrent writers |
| Source/configuration | Repository and local copies | Independently retained recoverable copy with access controls, required references and tested checkout; avoid storing secret-bearing state in Git |

For future operation, check backup completion and age daily against the asset's RPO, alert on missing jobs, stale recovery points, key/access failures or deletion, and record incidents. Do not assume versioning offers zero data loss for account compromise, lifecycle deletion or lost encryption keys. Separate-account/Region copies are still planned; no claim of Region recovery is supported.

## 3. Restore sequence

1. Open a test/recovery ticket with scenario, affected assets, last known good point, RTO/RPO targets, authorizing role and risk of restoring malicious or inconsistent data. The CISO activates incident recovery under the BC/DR plan when appropriate.
2. Preserve source evidence and obtain a read-only backup inventory. Select the correct account, Region, key and recovery point; record its timestamp and checksum where available. Do not overwrite the sole surviving copy.
3. Restore to an isolated target with restricted access and no unintended customer notifications or outbound integrations. Database restoration uses a new instance; object restoration retains the original version for comparison. Do not perform a live restore in this plan-only repository.
4. Verify encryption/access, database consistency, representative records and application behavior; compare object checksums. Product & Engineering confirms functional checks and Security Operations checks access and suspicious content. Reapply previously authorized deletion instructions to restored data and verify them before service cutover, as required by the [retention policy](../../policies/records-and-data-retention-policy.md); recovery must not reintroduce data already due for deletion.
5. Measure elapsed restoration from declared start to validated usability and actual data age/loss relative to disruption. Compare with the BC/DR targets (portal/database RTO eight hours, database RPO 24 hours); the S3 zero-loss target is unvalidated and cannot be inferred from versioning alone. Record failures and untested scope.
6. Obtain service-owner/CISO authorization before future cutover; preserve rollback state. Remove temporary copies/access under the retention policy once approved, recording deletion and exceptions.

## 4. Test programme and evidence

After authorized operation starts, run database restore tests quarterly (at least annually), object version recovery and infrastructure rebuild annually, and a Region-loss tabletop annually, following the BC/DR plan. Schedule the first controlled test before relying on recovery commitments. A tabletop proves decisions and gaps, not restoration time or data integrity.

Use the restore template in [SOC2 evidence guidance](../../SOC2/05-audit-approach-and-evidence.md): test ID/date, scenario, operator/reviewer, source/target, backup timestamp, start/end, measured RTO/RPO, integrity/functional results, exceptions, cleanup and actions. Store records under the [retention policy](../../policies/records-and-data-retention-policy.md), report [metrics](../08-monitoring-and-measurement/kpis-and-metrics.md), and handle failures through [corrective action](corrective-action-procedure.md). ISO/IEC 27001:2022 A.8.13, A.5.29 and A.5.30.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
