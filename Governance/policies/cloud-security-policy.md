# Cloud Security Policy

| Field | Value |
|---|---|
| Document ID | POL-CLD-01 |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or when a cloud provider, Region or AWS account is added |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Simulated company. Nothing in AWS is deployed. CI runs `terraform plan` with mock credentials and `-refresh=false`; the apply step is simulated behind the `manual-apply-approval` environment.

## 1. Purpose

Sets how Ayka chooses, configures, operates and leaves cloud services, and which part of security is Ayka's job and which is the provider's. It also defines the approved AWS Regions, which the [ISMS scope](../ISMS/00-context-and-governance/scope.md) refers to.

## 2. Scope

All cloud services Ayka uses to build, run or change the Ayka Portal: AWS (hosting), Microsoft Entra ID (workforce identity) and GitHub (source control, CI). Office SaaS without access to customer data or production is out of scope. Supplier due diligence and contracts are covered by [POL-VEN-01](vendor-management-policy.md); this policy adds the cloud-specific rules.

## 3. References

| Framework | Requirement |
|---|---|
| ISO/IEC 27001:2022 | A.5.23 (primary); A.5.19 to A.5.22 through POL-VEN-01; A.8.9, A.8.32 through POL-CHG-01 |
| SOC 2 | CC6.1, CC6.6, CC7.1, CC8.1, CC9.2 |
| GDPR | Art. 28, Art. 32, Art. 44 to 46 |
| Controls | CA-01, CA-02, OP-01, OP-08, MO-01, CM-01 to CM-03, AC-08, AC-10, AC-14, AC-17, VM-01, VM-02 in the [control matrix](../SOC2/03-control-matrix.md) |
| Gate controls | All 38 in [`control-mapping.yaml`](../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml) |
| Related | [POL-VEN-01](vendor-management-policy.md), [POL-CHG-01](change-management-policy.md), [POL-CRY-01](cryptography-policy.md), [POL-AC-01](access-control-policy.md), [STD-LOG-01](logging-and-monitoring-standard.md), [POL-BCDR-01](business-continuity-and-disaster-recovery-plan.md) |

## 4. Policy statements

### 4.1 Provider and service selection

1. AWS is the only infrastructure provider for production. Microsoft Entra ID is the workforce identity provider. GitHub hosts source code and CI. Adding a cloud provider needs a risk assessment and Managing Director approval.
2. A new cloud provider is tiered and assessed under [POL-VEN-01 §4](vendor-management-policy.md#4-risk-tiers) before any data goes to it. Minimum criteria for a Critical cloud provider:
   - required data locations and support access compatible with the assessed legal/contract requirements;
   - independent attestation (SOC 2 Type II, ISO/IEC 27001 with SoA, or BSI C5);
   - a GDPR Art. 28 DPA;
   - an assessed encryption and key-management model appropriate to the data; document any requirement for customer-managed keys;
   - API-level audit logging;
   - documented data export.
3. A new AWS service type may enter the Terraform only if:
   - it is available in the approved Region;
   - it meets the cryptography requirements relevant to the data and service;
   - its API calls are recorded by CloudTrail;
   - the gate covers it, or the gap is recorded in the pull request and the risk register.

### 4.2 Shared responsibility

| Layer | Provider responsibility | Ayka responsibility | Status of Ayka's part | Evidence |
|---|---|---|---|---|
| Data centres, hardware, hypervisor, media destruction | AWS | Review the AWS SOC 2 report each year | Planned: report not retrieved | AC-17, VM-02; [POL-VEN-01 §5](vendor-management-policy.md#5-current-critical-vendors) |
| Managed services (RDS engine, S3 durability, KMS hardware) | AWS | Configure encryption, backups, Multi-AZ, minor-version upgrades | Gated design | [`database/main.tf`](../../Internal-IT/workloads/ayka-portal/modules/database/main.tf), [`storage/main.tf`](../../Internal-IT/workloads/ayka-portal/modules/storage/main.tf) |
| Network configuration (VPC, security groups, NACLs, WAF) | None beyond the service itself | Least exposure; only the ALB is public | Gated design | AC-10, AC-11; `EC2_OPEN_SSH`, `NETWORK_ACL_UNRESTRICTED_INGRESS`, `ALB_WAF_PROTECTION_REQUIRED` |
| Identity and access in AWS | Identity-service operation; contractual boundary to verify | Federation, permission sets, SCPs | Designed | [POL-AC-01](access-control-policy.md); `Internal-IT/platform/domains/identity/` |
| Guest OS and container images | Provider service boundaries to verify | Patch, scan, pin by digest | Planned | [POL-VUL-01](vulnerability-and-patch-management-policy.md) |
| Application and customer data | Service operation; customer decides uploaded content | Classification, encryption, retention, deletion | Gated design for storage encryption only; retention/deletion and application controls are Planned | [POL-DATA-01](data-classification-and-confidentiality-policy.md), [POL-CRY-01](cryptography-policy.md) |
| GitHub and Entra ID platforms | GitHub, Microsoft | Configure rulesets, environments, MFA; review vendor reports | Partial: ruleset and environments configured; Entra ID not applied | AC-09; [POL-AC-01 §8](access-control-policy.md#8-current-gaps) |

The split of duties follows each provider's published shared responsibility model (to verify against the providers' current documentation).

### 4.3 Approved Regions

1. **Target Region: `eu-central-1` (Frankfurt)** for all customer data, personal data, logs and backups.
2. A second EU Region for backup copies and recovery will be chosen when cross-Region backup is designed ([POL-BCDR-01 §5](business-continuity-and-disaster-recovery-plan.md#5-resilience-in-the-design)).
3. Global-service use needs assessment of data flow, service availability and the exact SCP exemptions; an exemption does not prove EU-only processing.
4. Any other Region needs a risk assessment, a transfer assessment if personal data leaves the EU, and CISO approval.
5. **Today the Terraform does not match the target.**
   - Terraform uses `ap-south-1` (Mumbai) in about ten roots, for example the `ayka-portal` default `aws_region = "ap-south-1"` in [`variables.tf`](../../Internal-IT/workloads/ayka-portal/variables.tf).
   - The region SCP [`restrict-region.json`](../../Internal-IT/platform/foundation/aws-organization/modules/scp/restrict-region.json) allows only `ap-south-1`, so it would block the target Region.
   - The KMS key policy names `logs.ap-south-1.amazonaws.com` ([`kms.tf`](../../Internal-IT/workloads/ayka-portal/kms.tf)).

   Until these are migrated, Ayka makes no "data stays in the EU" claim (RISK-011, TRT-011 in the [risk register](../ISMS/03-risk-management/risk-register.md)).

### 4.4 Account structure

1. The AWS estate is one AWS Organization with all features. Its organizational units:

   | OU | Purpose |
   |---|---|
   | Security | Log archive and security tooling accounts |
   | Infrastructure | Shared networking and pipeline accounts |
   | Workloads | One account per workload environment |

   Status: Designed. See [`ous.tf`](../../Internal-IT/platform/foundation/aws-organization/modules/ou-structure/ous.tf) and [`organization.tf`](../../Internal-IT/platform/foundation/aws-organization/organization.tf).
2. No workload runs in the management account. Production and non-production run in separate member accounts.
3. The baseline SCPs apply to every member account:
   - `DenyRootUsage`;
   - `DenyDisableCloudTrail`;
   - `RestrictRegions`.

   Status: Designed, and attached only to the Workloads OU ([`attachment.tf`](../../Internal-IT/platform/foundation/aws-organization/modules/scp/attachment.tf)).
4. No member accounts are defined in Terraform yet. The safe order to bootstrap the organization, landing zone and identity roots is open (RISK-012).

### 4.5 Changes only through infrastructure as code

1. Every cloud resource is created and changed through Terraform in a pull request to `main` under [POL-CHG-01](change-management-policy.md). Console changes are allowed only under break-glass ([POL-AC-01 §4.5](access-control-policy.md#45-privileged-and-emergency-access)), and are codified or reverted afterwards ([POL-CHG-01 §5](change-management-policy.md#5-rules), rule 9).
2. Terraform state is held in a remote backend that is encrypted, versioned, locked and restricted to the pipeline role, before the first apply. Status: Planned. No remote backend exists (RISK-002).
3. Drift between Terraform and the running environment is checked daily once resources operate. Status: Designed. [`drift-detection.yml`](../../.github/workflows/drift-detection.yml) is manual and refuses to run without a remote backend (OP-08).

### 4.6 The compliance gate is the primary cloud configuration control

1. The pipeline plans, scans and decides on pull requests and pushes covered by the [workflow triggers](../../.github/workflows/terraform-workflow.yml). It evaluates the `ayka-portal` plan; it does not scan every root.
   - **Plan:** with mock credentials and `-refresh=false`.
   - **Scan:** Checkov, tfsec and OPA/conftest check the plan against the 38 controls in [`control-mapping.yaml`](../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml).
   - **Decide:**

     | Finding | Decision |
     |---|---|
     | Any HIGH | Fail |
     | Any MEDIUM | `approval_required` (`medium-risk-approval` environment) |
     | Only LOW, or none | Pass |

   Status: **Implemented**. Evidence: [run 37498007502](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/37498007502) on commit `500a263` (2026-10-06):
   - all five required checks succeeded;
   - the simulated apply waits at `manual-apply-approval`.
2. Every run also plans deliberately insecure Terraform (`control-validation-scenarios`). It fails the build unless the gate rejects it with the expected controls and tools. Status: **Implemented** (MO-01). The `Control Validation Regression` job succeeded in the same run.
3. The control's severity in the mapping decides, not the scanner's. A finding that will not be fixed is recorded in [`exceptions.yaml`](../../Internal-IT/engineering/policy-as-code/metadata/exceptions.yaml) with a reason, an owner and an expiry date (all current entries expire 2027-03-31). Lowering a severity to get a green build is not allowed ([POL-CHG-01 §7](change-management-policy.md#7-exceptions)).
4. The gate checks planned configuration, not running resources. The following are Planned:
   - running-state monitoring (AWS Config rules, Security Hub, GuardDuty);
   - gating the `Internal-IT/platform/` roots.

### 4.7 Configuration baseline

| Area | Rule | Gate controls |
|---|---|---|
| Storage | No public buckets; ACLs disabled; versioning on; access logging | `S3_PUBLIC_ACCESS`, `S3_ACLS_DISABLED`, `S3_VERSIONING_DISABLED`, `S3_LOGGING_DISABLED` |
| Encryption | Per [POL-CRY-01](cryptography-policy.md) | `S3_ENCRYPTION_MISSING`, `EC2_ROOT_VOLUME_UNENCRYPTED`, `ALB_TLS_ENFORCEMENT` and others |
| Network | No SSH or HTTP from the internet; no unrestricted NACL ingress; no default VPC; only the ALB is public, behind WAF | `EC2_OPEN_SSH`, `EC2_HTTP_OPEN`, `NETWORK_ACL_UNRESTRICTED_INGRESS`, `VPC_DEFAULT_PROHIBITED`, `ALB_WAF_PROTECTION_REQUIRED` |
| Compute | IMDSv2 required; mandatory tags | `EC2_MISSING_IMDSV2`, `EC2_MISSING_TAGS` |
| Identity | No IAM users, wildcard or inline policies | `IAM_USER_PROHIBITED`, `IAM_WILDCARD_POLICY`, `IAM_INLINE_POLICY_USAGE` |
| Logging | Per [STD-LOG-01](logging-and-monitoring-standard.md) | `VPC_FLOW_LOGS_MISSING`, `WAF_LOGGING_DISABLED`, `CLOUDWATCH_LOG_GROUP_KMS_ENCRYPTION` |

### 4.8 Exit strategy

1. Each Critical cloud provider has a written exit plan ([POL-VEN-01 §6](vendor-management-policy.md#6-requirements), item 7). The plan covers how data is exported, how long the migration would take, and how deletion at the old provider is confirmed.
2. Exit triggers:
   - the provider loses its attestation;
   - a material contract or price change;
   - a legal change that makes transfers unlawful;
   - repeated outages beyond the RTO in [POL-BCDR-01 §4](business-continuity-and-disaster-recovery-plan.md#4-business-impact-and-objectives);
   - a provider security incident affecting Ayka.
3. Portability facts for AWS (inferred from the Terraform):
   - **Network and compute:** described in Terraform, but with the AWS provider. Moving them means rewriting the Terraform for a new provider, not reusing it.
   - **Database:** the [database design](../../Internal-IT/workloads/ayka-portal/modules/database/main.tf) selects PostgreSQL. A logical export/import method, version compatibility and restoration must be tested; none has been.
   - **Files:** test an object export including versions, metadata and deletion obligations; no exit exercise has occurred.
   - **Keys:** the design uses KMS-generated key material; portability and provider restrictions are to verify. The exit plan must establish a supported decrypt/re-encrypt path without exposing plaintext.
4. Status: Planned. No exit plan exists and none has been tested.

## 5. Roles

| Activity | CISO | Cloud Platform Engineering | Compliance & Risk Management | Managing Director |
|---|---|---|---|---|
| Approve a new cloud provider or Region | R | C | C | A |
| Approve a new AWS service type | A | R | I | |
| Maintain account structure, SCPs, Terraform | A | R | | |
| Maintain gate rules and mapping | A | R | C | |
| Annual provider report review | A | C | R | I |
| Exit plan | A | R | C | I |

R responsible, A accountable, C consulted, I informed.

## 6. Exceptions

Policy exceptions are requested in writing with a reason, compensating control and end date of at most 6 months, and approved by the CISO. Technical exceptions to gate rules use [`exceptions.yaml`](../../Internal-IT/engineering/policy-as-code/metadata/exceptions.yaml) and follow the elevated change path in [POL-CHG-01](change-management-policy.md#4-change-types).

## 7. Compliance and monitoring

| Check | Frequency | Evidence |
|---|---|---|
| Gate decision on every change | Every run | `compliance-evidence` artifact of each run (summary, report, manifest) |
| Regression proves the gate still rejects insecure plans | Every run | `Control Validation Regression` job log |
| Exceptions near expiry reviewed | Quarterly | `exceptions.yaml` history |
| Region, account and SCP design matches this policy | Annually and on change | Terraform review recorded in the pull request |

## 8. Current gaps

| Gap | Status | Evidence | Tracked in |
|---|---|---|---|
| Terraform and the region SCP use `ap-south-1`, not `eu-central-1` | Open | [`restrict-region.json`](../../Internal-IT/platform/foundation/aws-organization/modules/scp/restrict-region.json), [`variables.tf`](../../Internal-IT/workloads/ayka-portal/variables.tf) | RISK-011 |
| Organization, OUs and SCPs are not gated and not deployed; SCPs attach to the Workloads OU only; no member accounts defined | Designed | [`aws-organization/`](../../Internal-IT/platform/foundation/aws-organization/) | RISK-012 |
| No remote state backend; drift detection cannot run | Planned | [README §6](../../README.md#6-known-limitations) | RISK-002 |
| Platform roots are not scanned by the gate | Planned | OP-01 status in the [control matrix](../SOC2/03-control-matrix.md) | |
| No running-state posture monitoring (Config, Security Hub, GuardDuty) | Planned | [STD-LOG-01 §6](logging-and-monitoring-standard.md#6-alerting) | |
| No provider attestation retrieved; no exit plan | Planned | [POL-VEN-01 §8](vendor-management-policy.md#8-current-gaps) | |
| Only a `dev` environment exists (`envs/dev.tfvars`) | Planned | [`envs/`](../../Internal-IT/workloads/ayka-portal/envs/) | |

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
