# Platform Compliance Mapping

This document maps **implemented controls in `Internal-IT/cloud-platform/`** to major compliance frameworks.

Scope covered:

- `landing-zone/` (account-level controls)
- `aws-organization/` (org-level governance via SCP + OU)

Important:

- This is a **control implementation crosswalk**, not a certification statement.
- It maps controls that are currently configured in Terraform.
- Framework catalogs (ISO/NIST/SOC/GDPR/CIS) are much broader than the controls currently implemented.

## Implemented Control Inventory (Evidence)

| Control Capability | Terraform Evidence |
|---|---|
| Multi-account OU model | `aws-organization/modules/ou-structure/ous.tf` |
| SCP: deny root user usage | `aws-organization/modules/scp/deny-root-usage.json` |
| SCP: deny CloudTrail tampering | `aws-organization/modules/scp/deny-disable-cloudtrail.json` |
| SCP: region restriction | `aws-organization/modules/scp/restrict-region.json` |
| IAM baseline roles (admin/security/automation) | `landing-zone/modules/core/iam/roles.tf` |
| IAM permission boundary for automation | `landing-zone/modules/core/iam/permission_boundary.tf` |
| Root-account hardening baseline (documented) | `landing-zone/modules/core/iam/root_protection.tf` |
| CloudTrail enabled, multi-region, log validation | `landing-zone/modules/core/logging/cloudtrail.tf` |
| CloudTrail S3 bucket, public access block, SSE | `landing-zone/modules/core/logging/trail_bucket.tf` |
| Account-level S3 public access block | `landing-zone/modules/core/s3/public_access_block.tf` |
| Security alerting (SNS + email subscription) | `landing-zone/modules/core/alerts/sns.tf` |
| Break-glass role with MFA condition | `landing-zone/modules/break_glass/main.tf` |
| VPC quota guardrail | `landing-zone/modules/quotas/main.tf` |
| Budget + anomaly detection alerts | `landing-zone/modules/cost_controls/main.tf` |
| SIEM delivery stream (Kinesis Firehose -> S3) | `landing-zone/modules/siem/main.tf` |

## Framework Crosswalk

| Implemented Control | AWS CIS (Foundations) | ISO/IEC 27001:2022 (Annex A themes) | NIST CSF 2.0 | SOC 2 (Trust Services) | GDPR | Status |
|---|---|---|---|---|---|---|
| Root user restrictions (SCP deny root usage + documented MFA/no keys) | IAM root hardening controls (root usage/MFA/no root keys) | A.5.15, A.5.16, A.5.17 (access governance) | PR.AA, PR.PS | CC6.1, CC6.2 | Art. 32(1)(b) | Partially Automated (MFA/key deletion are manual governance tasks) |
| IAM role segregation (admin/security/automation) | IAM least-privilege and role management | A.5.15, A.5.18 | PR.AA | CC6.1, CC6.3 | Art. 25, Art. 32 | Implemented |
| Permission boundary for automation roles | IAM privilege restriction | A.8.2, A.8.3 | PR.AA, PR.PS | CC6.1, CC7.2 | Art. 32 | Implemented |
| CloudTrail org/account logging enabled | CloudTrail enabled across regions | A.8.15 (logging), A.5.24 (incident readiness) | DE.CM, DE.AE | CC7.2, CC7.3 | Art. 5(2), Art. 30, Art. 32 | Implemented |
| CloudTrail log-file validation | CloudTrail integrity validation | A.8.15 | DE.CM | CC7.2 | Art. 5(1)(f), Art. 32 | Implemented |
| Prevent CloudTrail disable/delete (SCP + boundary denies) | CloudTrail protection controls | A.8.15, A.8.16 | PR.PS, DE.CM | CC7.2 | Art. 32 | Implemented |
| S3 public access blocked (bucket and account level) | S3 public access controls | A.8.9, A.8.10 | PR.DS | CC6.6, CC7.1 | Art. 25, Art. 32 | Implemented |
| CloudTrail bucket encryption at rest (SSE-S3) | Encryption at rest baseline | A.8.24 (use of cryptography) | PR.DS | CC6.7 | Art. 32(1)(a) | Implemented |
| Break-glass admin with MFA condition | Privileged access control | A.5.15, A.5.18 | PR.AA, RS.RP | CC6.2, CC7.3 | Art. 32 | Implemented |
| Security alerting via SNS | Monitoring and event notification | A.8.16 | DE.CM, RS.AN | CC7.2, CC7.3 | Art. 33 readiness support | Implemented |
| SIEM forwarding path (Firehose to S3 target) | Centralized log pipeline intent | A.8.15, A.8.16 | DE.CM, DE.AE | CC7.2 | Art. 30, Art. 32 | Implemented (requires SIEM target governance) |
| Budget and anomaly detection alerts | Cost/risk anomaly governance (not a primary security control) | A.5.4, A.5.7 (governance support) | GV.RM | CC3.2 | Indirect support | Implemented |
| Region restriction SCP | Data residency / control boundary | A.5.31, A.5.32 | PR.IR, GV.PO | CC9.2 | Art. 44-49 (cross-border transfer controls) | Implemented |
| VPC quota limit guardrail | Abuse/misconfiguration containment | A.8.7, A.8.20 | PR.PS | CC7.1 | Indirect support | Implemented |

## Framework-by-Framework View

### AWS CIS Foundations

Mapped implemented areas:

- Root account governance (partial automation + SCP)
- IAM role and privilege boundaries
- CloudTrail enabled and protected
- Log validation enabled
- S3 public exposure prevention

### ISO/IEC 27001:2022

Mapped implemented themes:

- Access control governance and privileged access
- Logging, monitoring, and event evidence
- Cryptographic protection for stored logs
- Organizational security rules using SCP guardrails

### NIST CSF 2.0

Mapped functions:

- `Govern`: OU/SCP structure, org guardrails
- `Protect`: IAM controls, permission boundaries, S3 access protections
- `Detect`: CloudTrail, SNS alerting, SIEM feed path
- `Respond` readiness support: alerting and break-glass access

### SOC 2 (Common Criteria)

Mapped criteria themes:

- Logical access controls and role restrictions
- Change/operation monitoring through CloudTrail
- Security event monitoring and alerting
- Protective controls over data storage exposure

### GDPR

Mapped obligations (technical/organizational controls):

- Art. 25 (data protection by design/default): public access blocking, region restriction
- Art. 30 (records/accountability support): auditable CloudTrail logs
- Art. 32 (security of processing): IAM controls, encryption, MFA-based privileged access
- Art. 44-49 support posture: SCP regional boundary helps residency constraints

## Known Gaps / Residual Risks

1. `landing-zone/modules/core/iam/root_protection.tf` documents root hardening but cannot enforce root MFA and root key deletion in Terraform.
2. No immutable retention/WORM or object-lock policy is configured for CloudTrail logs.
3. No KMS CMK is configured for CloudTrail bucket encryption (currently SSE-S3/AES256).
4. No AWS Config conformance packs/rules are defined here for continuous compliance checks.
5. No explicit GuardDuty/Security Hub/Config enablement in this folder (outside scope or pending).
6. `landing-zone/modules/siem/main.tf` contains `Version = "2012=10-17"` in trust policy JSON and should be corrected to `"2012-10-17"` before production apply.

## Suggested Evidence Bundle for Audit

- Terraform plan/apply outputs for `aws-organization` and `landing-zone`
- State snapshots or resource inventory exports
- Screenshots/exports for CloudTrail active status in each account
- SCP attachment proof to workloads OU
- IAM role trust policy and attached managed policy exports
- SNS subscription confirmation and alert test evidence
- Change management records for all module updates
