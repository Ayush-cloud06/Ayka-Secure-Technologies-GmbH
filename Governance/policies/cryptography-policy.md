# Cryptography Policy

| Field | Value |
|---|---|
| Document ID | POL-CRY-01 |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or when an algorithm is deprecated, a data store is added or a key is compromised |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Simulated company. The encryption settings below are Terraform that the gate scans; nothing is deployed, so no key, certificate or encrypted store exists.

## 1. Purpose

Sets which cryptography Ayka uses to protect data at rest and in transit, and how keys, certificates and secrets are managed. This is Ayka's encryption policy. [POL-DATA-01 §5.2](data-classification-and-confidentiality-policy.md#52-protection) says which data must be encrypted; this policy says how.

## 2. Scope

| Covered | Examples |
|---|---|
| Stores and paths holding Internal, Confidential or Restricted data | `ayka-portal` workload, platform logging, Terraform state, CI evidence |
| Endpoints | Staff laptops |
| Keys, certificates and secrets | KMS keys, TLS certificates, Secrets Manager entries, passwords |

## 3. References

| Framework | Requirement |
|---|---|
| ISO/IEC 27001:2022 | A.8.24 (primary); A.5.31 (legal requirements on cryptography); A.8.13 (backup encryption) |
| SOC 2 | CC6.1, CC6.7, C1.1 |
| GDPR | Art. 32(1)(a), Art. 34(3)(a) |
| Controls | AC-12, AC-13, AC-14, CO-02 in the [control matrix](../SOC2/03-control-matrix.md) |
| Gate controls | `S3_ENCRYPTION_MISSING`, `S3_KMS_ENCRYPTION_REQUIRED`, `EC2_ROOT_VOLUME_UNENCRYPTED`, `ALB_TLS_ENFORCEMENT`, `RDS_ENCRYPTION_IN_TRANSIT`, `RDS_PERFORMANCE_INSIGHTS_ENCRYPTION`, `CLOUDWATCH_LOG_GROUP_KMS_ENCRYPTION`, `SECRETS_MANAGER_CMK_ENCRYPTION`, `SECRETS_MANAGER_ROTATION_DISABLED`, `SNS_TOPIC_KMS_ENCRYPTION`, `KMS_KEY_POLICY_DEFINED` in [`control-mapping.yaml`](../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml) |
| Control chain | [Control chain: S3 encryption at rest](../ISMS/04-controls-and-soa/control-chain-s3-encryption.md) |

## 4. Policy statements

### 4.1 Approved algorithms

| Use | Approved | Not allowed |
|---|---|---|
| Symmetric encryption at rest | AES-256 (AWS KMS, SSE-KMS, SSE-S3, EBS, RDS storage encryption) | DES, 3DES, RC4, any unauthenticated custom scheme |
| Transport | TLS 1.3; TLS 1.2 with forward-secret AEAD cipher suites | SSL, TLS 1.0, TLS 1.1 |
| Certificates and signatures | RSA 2048 bits or more; ECDSA P-256 or stronger | RSA under 2048 bits; SHA-1 signatures |
| Hashing for integrity | SHA-256 or stronger | MD5 or SHA-1 for any security purpose |
| Password storage (application) | Argon2id, scrypt or bcrypt with per-user salt | Plain or unsalted hashes |

These are proposed minimum choices, not a claim of alignment with the current BSI TR-02102 edition. Check its current algorithm/key-length recommendations and the required protection horizon before approving production cryptography. An algorithm that the guideline or the vendor deprecates is replaced within 12 months, or sooner if it is broken.

### 4.2 Encryption at rest

Every store of Confidential or Restricted data is encrypted with a customer-managed KMS key (CMK) unless the row says otherwise.

| Store | Rule | Current configuration | Status | Evidence |
|---|---|---|---|---|
| S3 customer evidence bucket | SSE-KMS with the workload CMK | `sse_algorithm = "aws:kms"`, `kms_master_key_id` set | Gated design | [`storage/main.tf`](../../Internal-IT/workloads/ayka-portal/modules/storage/main.tf); `S3_ENCRYPTION_MISSING`, `S3_KMS_ENCRYPTION_REQUIRED` |
| S3 access-log bucket | SSE-S3 (AES256) allowed, under the recorded dev exception; current ALB/S3 delivery and encryption restrictions are to verify against provider documentation | `sse_algorithm = "AES256"` | Gated design; accepted until 2027-03-31 | [`exceptions.yaml`](../../Internal-IT/engineering/policy-as-code/metadata/exceptions.yaml) (`CKV_AWS_145`, `AVD-AWS-0132`) |
| RDS PostgreSQL storage | CMK | `storage_encrypted = true`, `kms_key_id` set | Gated design | [`database/main.tf`](../../Internal-IT/workloads/ayka-portal/modules/database/main.tf); AC-13 |
| RDS automated backups and snapshots | Same key as the instance | Not set separately. Snapshots of an encrypted instance are encrypted with its key (AWS behaviour, to verify) | Gated design | `database/main.tf` (`backup_retention_period = 7`); [POL-BCDR-01 §5](business-continuity-and-disaster-recovery-plan.md#5-resilience-in-the-design) |
| RDS Performance Insights | CMK | `performance_insights_kms_key_id` set | Gated design | `RDS_PERFORMANCE_INSIGHTS_ENCRYPTION` |
| EC2 root volumes | CMK | `encrypted = true` without `kms_key_id`, so the AWS-managed EBS key is used, not the CMK | Gated design: encryption configured, CMK rule not met | [`ec2.tf`](../../Internal-IT/workloads/ayka-portal/modules/compute/ec2.tf); `EC2_ROOT_VOLUME_UNENCRYPTED` passes |
| CloudWatch log groups (ECS, WAF, VPC flow logs) | CMK | `kms_key_id` set | Gated design | `CLOUDWATCH_LOG_GROUP_KMS_ENCRYPTION` |
| Secrets Manager | CMK | `kms_key_id` set | Gated design | `SECRETS_MANAGER_CMK_ENCRYPTION` |
| SNS topics | CMK | `kms_master_key_id` set | Gated design | `SNS_TOPIC_KMS_ENCRYPTION` |
| CloudTrail trail bucket (platform) | CMK in the log archive account | SSE-S3 (`AES256`); trail sets no `kms_key_id` | Designed; CMK rule not met | [`trail_bucket.tf`](../../Internal-IT/platform/foundation/landing-zone/modules/core/logging/trail_bucket.tf), [`cloudtrail.tf`](../../Internal-IT/platform/foundation/landing-zone/modules/core/logging/cloudtrail.tf) |
| Terraform state | Encrypted remote backend with restricted access | No remote backend | Planned | RISK-002 |
| Laptops | Full-disk encryption | No device management | Planned | AC-16; [POL-END-01](user-endpoint-device-policy.md) |

### 4.3 Encryption in transit

| Path | Rule | Current configuration | Status | Evidence |
|---|---|---|---|---|
| Internet to ALB | HTTPS only; TLS 1.2 minimum | Only a 443 listener; `ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"`; `drop_invalid_header_fields = true` | Gated design | [`alb.tf`](../../Internal-IT/workloads/ayka-portal/modules/compute/alb.tf); `ALB_TLS_ENFORCEMENT`; AC-12 |
| ALB to ECS tasks | Encrypted, or an accepted exception for traffic inside private subnets | Target group uses HTTP; TLS ends at the ALB | Open decision | `alb.tf` (target group `protocol = "HTTP"`) |
| Application to RDS | TLS required by the server | `rds.force_ssl = 1` | Gated design | `database/main.tf`; `RDS_ENCRYPTION_IN_TRANSIT` |
| Clients to S3 | Requests without TLS denied by bucket policy | `DenyInsecureTransport` on the access-log bucket only; none on the evidence bucket | Gated design: log-bucket rule only; evidence-bucket rule missing | [`storage/main.tf`](../../Internal-IT/workloads/ayka-portal/modules/storage/main.tf) |
| Staff to AWS, GitHub, Entra ID | Provider TLS endpoints only | Provider-controlled | Planned verification; provider operation not assessed | [Vendor review](vendor-management-policy.md), VM-02 |
| CI tool downloads | Verified against pinned SHA-256 | `bootstrap-tools.sh` and the composite actions check checksums | Implemented | [`bootstrap-tools.sh`](../../Internal-IT/engineering/ci-cd/scripts/bootstrap-tools.sh); [`toolchain.versions`](../../Internal-IT/engineering/ci-cd/toolchain.versions) |
| CI evidence integrity | SHA-256 manifest checked before apply | `checksum-evidence.sh`, `run-apply.sh` | Implemented (integrity between jobs, not authenticity) | CM-04; [README §6](../../README.md#6-known-limitations) |

### 4.4 Key management (AWS KMS)

1. **Key type.** Keys are KMS customer-managed keys generated inside AWS KMS. Key material is never exported or imported. The validation level of the KMS hardware security modules is to verify in the AWS documentation.
2. **One key per workload, at minimum.** Production uses separate keys for customer data and for logs, so that a log reader cannot decrypt customer data.
   - Today the Terraform defines one key (`alias/<prefix>-workload`) serves S3, RDS, logs, secrets and SNS ([`kms.tf`](../../Internal-IT/workloads/ayka-portal/kms.tf)). Gated design for one key; the separation is Planned.
3. **Rotation.** Automatic rotation is on for every CMK (`enable_key_rotation = true`, gated design). No `rotation_period_in_days` is set, so the AWS default period applies (one year, to verify). Suspected compromise triggers incident response, access containment and assessed replacement/re-encryption; rotation alone does not make previously exposed data safe.
4. **Key policy.** Every key has an explicit key policy (`KMS_KEY_POLICY_DEFINED`) under these rules:
   - key administrators are separate from key users;
   - AWS service principals are limited by `aws:SourceAccount` or `aws:SourceArn`;
   - service principals do not name a Region other than the approved one.

   Today the policy grants `kms:*` to the account root (delegation to IAM). It gives S3 use of the key with no source condition, and names `logs.ap-south-1.amazonaws.com` (RISK-011). Gated design; the three rules are not met.
5. **Deletion.** Scheduling a key for deletion is a change under [POL-CHG-01](change-management-policy.md) with CISO approval. Production keys use a 30-day deletion window. Today the window is 7 days, which is acceptable for the dev workload only.
6. **Inventory.** Terraform identifies intended keys and aliases. Before operation, maintain an actual key inventory with owner, purpose, resources, administrators/users, creation/rotation/deletion dates and recovery dependencies; verify it against the service configuration.

### 4.5 Certificates

1. Public endpoints must use publicly trusted certificates with validated domain control, supported renewal and expiry monitoring. The provider/key-custody model must be assessed; imported certificates need their own renewal process.
2. **Today:** the ALB uses a self-signed RSA-2048 certificate generated by Terraform (`tls_private_key`, `tls_self_signed_cert`, one-year validity) and imported into ACM ([`alb.tf`](../../Internal-IT/workloads/ayka-portal/modules/compute/alb.tf)). The private key is stored in Terraform state. Gated design; rule 1 not met.

### 4.6 Secrets

1. Secrets are never committed to source control ([POL-AC-01 §4.2](access-control-policy.md#42-authentication), item 5). Bootstrap passwords hard-coded until 2026-09-28 are tracked as RISK-001.
2. Runtime secrets are held in AWS Secrets Manager under the CMK (gated design, `database/main.tf`). They rotate automatically at least every 90 days in production (`SECRETS_MANAGER_ROTATION_DISABLED`).
   - Today rotation is off for the database secret: there is no rotation function. This is accepted for dev until 2027-03-31 (`CKV2_AWS_57` in [`exceptions.yaml`](../../Internal-IT/engineering/policy-as-code/metadata/exceptions.yaml)).
3. Generated secrets (`random_password`) and private keys are written to Terraform state. State is therefore treated as Restricted ([POL-DATA-01 §4](data-classification-and-confidentiality-policy.md#4-classification-levels)) until secrets come from a managed source instead (RISK-002).
4. CI holds no long-lived cloud credentials. When CI gains apply rights it uses OIDC federation ([POL-AC-01 §4.1](access-control-policy.md#41-identity), item 4). Status: Implemented for plan-only CI (AC-14).
5. Passwords for people follow [POL-AC-01 §4.2](access-control-policy.md#42-authentication).

### 4.7 Legal requirements

Use and export of cryptography follow the EU dual-use regulation and German law (applicability to a SaaS provider to verify). Contracts with customers state where and how their data is encrypted. Legal sources are listed in the [legal and regulatory register](../ISMS/00-context-and-governance/legal-and-regulatory-register.md).

## 5. Roles

| Activity | CISO | Cloud Platform Engineering | Product & Engineering | Security Operations |
|---|---|---|---|---|
| Approve algorithms and exceptions | A | C | C | |
| Configure encryption and keys in Terraform | A | R | C | |
| Approve key deletion | A | R | | I |
| Application password hashing and secrets use | A | C | R | |
| Respond to key or certificate compromise | A | R | C | R |

R responsible, A accountable, C consulted, I informed.

## 6. Exceptions

Exceptions are approved by the CISO in writing with a reason, compensating control and end date of at most 6 months. Gate findings use [`exceptions.yaml`](../../Internal-IT/engineering/policy-as-code/metadata/exceptions.yaml).

## 7. Compliance and monitoring

| Check | Frequency | Evidence |
|---|---|---|
| Encryption controls in the gate | Every run | `compliance-evidence` artifact; [run 37498007502](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/37498007502) (all five required checks succeeded; simulated apply waits at `manual-apply-approval`) |
| Regression keeps encryption failures detectable | Every run | `Control Validation Regression` job |
| Key rotation and key policy review | Annually once operating | KMS configuration export |
| Certificate expiry | Monthly once operating | ACM inventory |

## 8. Current gaps

| Gap | Status | Evidence | Tracked in |
|---|---|---|---|
| EC2 root volume uses the AWS-managed key, not the CMK; conflicts with POL-DATA-01 §5.2 and AC-13 wording | Open | `ec2.tf` (`encrypted = true`, no `kms_key_id`) | Open issue |
| Evidence bucket has no TLS-only bucket policy | Open | `storage/main.tf` | |
| Self-signed ALB certificate; private key in state | Open | `alb.tf` | RISK-002 |
| TLS ends at the ALB; ALB to ECS is HTTP | Open decision | `alb.tf` | |
| One CMK for all services; key policy lacks source conditions and admin/user split; hard-coded `ap-south-1` | Open | `kms.tf` | RISK-011 |
| CloudTrail bucket uses SSE-S3, no CMK | Designed | `trail_bucket.tf` | |
| No remote, encrypted Terraform state; generated secrets and keys sit in state | Planned | | RISK-002 |
| Database secret rotation off (dev exception) | Accepted until 2027-03-31 | `exceptions.yaml` | |
| No laptop full-disk encryption control | Planned | AC-16 | |

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
