# Business Continuity and Disaster Recovery Plan

| Field | Value |
|---|---|
| Document ID | POL-BCDR-01 |
| Classification | Internal |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, after every test and after every activation |
| Status | Draft. Not approved. Never tested |

## 1. Purpose

Keeps the Ayka Portal available to customers within the commitments in the [system description](../01-system-description.md#21-service-commitments-to-customers), and restores it within the stated objectives when something fails.

## 2. Scope

The Ayka Portal production environment, its data, the pipeline that deploys it, and the people needed to run a recovery. Office facilities matter only as far as staff can work remotely, which they can.

## 3. References

| Framework | Requirement |
|---|---|
| SOC 2 | A1.1, A1.2, A1.3, CC7.5, CC9.1 |
| ISO/IEC 27001:2022 | A.5.29, A.5.30, A.8.13, A.8.14 |
| Controls | AV-01 to AV-05, RM-01 |

## 4. Business impact and objectives

| Function | Impact of outage | Maximum tolerable downtime | RTO | RPO |
|---|---|---|---|---|
| Customer access to the portal | Customers cannot prepare for or answer their auditors; reputational damage grows after one business day | 24 hours | 8 hours | 24 hours |
| Customer evidence files (S3) | Loss would break customers' audit trails | 24 hours | 8 hours | 0 for committed objects (versioned) |
| Deploying changes (pipeline) | Fixes cannot be released through the gate | 3 days | 1 business day | Not applicable (Git is the source) |
| Workforce identity (Entra ID, Identity Center) | Staff cannot administer AWS | 8 hours | Break-glass within 1 hour | Not applicable |

The RPO of 24 hours is a deliberately conservative commitment: RDS automated backups allow point-in-time recovery to within about five minutes, so the commitment leaves room for a failed restore attempt.

## 5. Resilience in the design

| Measure | Protects against | Defined in | Status |
|---|---|---|---|
| RDS Multi-AZ with automatic failover | Loss of an instance or availability zone | [`database/main.tf`](../../../Internal-IT/workloads/ayka-portal/modules/database/main.tf) | Gated design |
| RDS automated backups, 7 days; deletion protection; final snapshot | Data corruption, accidental deletion | same | Gated design |
| S3 versioning; noncurrent versions kept 30 days | Overwrite, deletion, ransomware encryption of objects | [`storage/main.tf`](../../../Internal-IT/workloads/ayka-portal/modules/storage/main.tf) | Gated design |
| ALB and ECS across availability zones; CPU autoscaling | Zone loss, load peaks | [`compute/`](../../../Internal-IT/workloads/ayka-portal/modules/compute/) | Gated design |
| Everything in Terraform | Loss of an environment or account | `Internal-IT/` | Implemented as code; never applied |
| Code and history on GitHub, with local clones | Loss of the repository host | Git | Implemented |

**Known weaknesses.** All copies of data are in one Region and one account. There is no cross-Region or cross-account backup (gate control `S3_REPLICATION_DISABLED` open, LOW). A Region-wide outage or a compromise of the production account that deletes backups would exceed the RTO and RPO. The planned fix is AWS Backup with a vault in a separate account, vault lock, and copies to a second EU Region.

## 6. Scenarios and response

| Scenario | Response | Expected recovery |
|---|---|---|
| Single task or instance failure | Automatic: ECS replaces tasks; RDS fails over | Minutes, no action |
| Availability zone outage | Automatic Multi-AZ failover; ECS reschedules in remaining zones | Under 1 hour |
| Data corruption or bad migration | Point-in-time restore of RDS to a new instance; switch the application over; S3 object version restore | 2 to 6 hours |
| Accidental deletion of infrastructure | Re-apply from Terraform; restore data from final snapshot | 4 to 8 hours |
| Region outage | No automated recovery. Re-create in a second EU Region from Terraform and the latest snapshot copy (once copies exist) | Exceeds RTO today |
| Production account compromise | Incident Response Plan; rebuild in a clean account from Terraform; restore from backups held outside the account (once they exist) | Exceeds RTO today |
| Entra ID outage | Break-glass access to AWS per the procedure | 1 hour for administrative access |
| GitHub outage | Wait for recovery; emergency changes with the CISO's approval only through a documented manual plan run from a clean clone, with the same scanners run locally (`run-local-chain.sh`) | Same day |

## 7. Activation and roles

1. The Incident Commander (see the [Incident Response Plan](incident-response-plan.md)) activates this plan when an incident threatens the RTO.
2. The Technical Lead runs recovery; the Communications Lead updates customers at least every 2 hours during a SEV 1 outage.
3. The plan is deactivated when service is restored and verified, and a post-incident review follows.

## 8. Testing

| Test | Frequency | Pass criterion |
|---|---|---|
| RDS restore of the latest snapshot into an isolated environment, with application smoke test | Quarterly once in production; annually at minimum | Within RTO; data within RPO |
| S3 object version restore | Annually | Restored object matches checksum |
| Rebuild of the workload from Terraform in an empty account | Annually | Plan applies with no manual step |
| Tabletop of the Region outage scenario | Annually | Gaps recorded and assigned |

Tests are recorded on the restore test template in [SOC2-05](../05-audit-approach-and-evidence.md#73-restore-test-av-04). No test has been run.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-06 | First issue |
