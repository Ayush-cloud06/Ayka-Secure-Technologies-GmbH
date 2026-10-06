# SOC 2 Control Matrix

| Field | Value |
|---|---|
| Document ID | SOC2-03 |
| Owner | Compliance and Risk, for the CISO |
| Approver | CISO |
| Version | 1.0 |
| Status as of | 2026-10-06 |
| Next review | Quarterly, and in the same pull request as any change to a control |
| Status | Draft. Not approved |

## 1. How to read this matrix

Each row is one control Ayka operates or intends to operate. The criteria it answers are listed in the TSC column; the reverse view, criterion by criterion, is in the [Trust Services Criteria mapping](02-trust-services-criteria-mapping.md).

- **Nature**: `A` automated or `M` manual; `P` preventive or `D` detective. An automated control is tested once plus a test of the change controls around it (ITGC reliance); a manual control is sampled across the period.
- **Frequency** drives the Type II sample size (see [SOC2-05](05-audit-approach-and-evidence.md), section 5).
- **Evidence** names what an auditor would inspect, re-perform or observe. Where the evidence does not exist yet, the status says so.
- **Status** uses the vocabulary in the [README](README.md#4-status-vocabulary). Only `Implemented` would count in a Type I.
- Gate control names in `CODE_CASE` refer to entries in [`control-mapping.yaml`](../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml).

Owners are roles. The role holders in the [personnel register](../../organization/personnel-register.md) are fictional; in the real repository every role is held by the repository owner.

## 2. Control environment (CE)

| ID | Control | TSC | ISO 27001:2022 | Owner | Frequency | Nature | Evidence | Status and gap |
|---|---|---|---|---|---|---|---|---|
| CE-01 | The information security policy and the topic policies are approved by the Managing Director, published to staff and reviewed at least annually | CC1.1, CC2.2, CC5.3 | 5.2, A.5.1 | CISO | Annual | M, P | Approved policy versions in Git with approval recorded in the merge; review log | **Partial**: [policy](../ISMS/00-context-and-governance/information-security-policy.md) and SOC 2 policies exist; no approval or review record |
| CE-02 | Personnel acknowledge the code of conduct and the acceptable use policy at hire and every year | CC1.1 | A.5.10, A.6.2 | HR | At hire, annual | M, P | Signed acknowledgements for a sample of staff | **Planned**: no code of conduct written |
| CE-03 | The organization chart and role descriptions define reporting lines and security responsibilities; the CISO reports to the Managing Director | CC1.3 | 5.3, A.5.2 | Managing Director | Annual review | M, P | [Org structure](../../organization/org-structure.md), [roles](../../organization/roles-and-responsibilities.md) | **Partial**: documents exist; no dated review |
| CE-04 | New hires are screened before access is granted, within German law (identity, references; certificate of good conduct only for Tier 0 roles where justified under § 26 BDSG) | CC1.4 | A.6.1 | HR | Per hire | M, P | Screening checklist for sampled joiners | **Planned** |
| CE-05 | All personnel complete security awareness training at onboarding and annually; Tier 0 and Tier 1 staff complete role-based cloud security training | CC1.4, CC2.2 | 7.2, 7.3, A.6.3 | CISO | At hire, annual | M, P | Training completion export | **Designed**: [programme](../../organization/training-and-awareness.md) written; no completion records |
| CE-06 | The CISO reports security posture, open risks and control deficiencies to the Managing Director each quarter; decisions are minuted | CC1.2, CC2.2, CC4.2 | 9.3 | CISO | Quarterly | M, D | Quarterly report and minutes | **Planned**: no meeting has taken place; do not backdate |
| CE-07 | Security responsibilities are part of job descriptions and the annual performance review | CC1.5 | A.6.2 | HR | Annual | M, P | Job descriptions, review form | **Planned** |

## 3. Information and communication (IC)

| ID | Control | TSC | ISO 27001:2022 | Owner | Frequency | Nature | Evidence | Status and gap |
|---|---|---|---|---|---|---|---|---|
| IC-01 | Every pipeline run produces a compliance summary, a Markdown report and a manifest of tool versions and file hashes, so decisions rest on complete and traceable information | CC2.1 | 7.5, A.8.15 | Cloud Platform Engineering | Every run | A, D | `compliance-evidence` artifact of a sampled run; [`write-manifest.py`](../../Internal-IT/engineering/ci-cd/scripts/write-manifest.py) | **Implemented** |
| IC-02 | Customers receive the system description, security commitments, DPA and a security contact; material changes are announced in advance | CC2.3 | A.5.14, A.5.31 | Head of Product | At contract, on change | M, P | MSA, DPA, security page, change notices | **Planned**: no customer documents written |
| IC-03 | A monitored security mailbox receives incident reports and concerns from staff, customers and researchers; a `SECURITY.md` points to it | CC2.2, CC2.3, CC7.3 | A.6.8 | Security Operations | Continuous | M, D | Mailbox configuration; ticket sample | **Planned** |

## 4. Risk assessment (RA)

| ID | Control | TSC | ISO 27001:2022 | Owner | Frequency | Nature | Evidence | Status and gap |
|---|---|---|---|---|---|---|---|---|
| RA-01 | Risks are identified, scored and treated using the documented methodology; the register is reviewed at least quarterly | CC3.1, CC3.2, CC9.1 | 6.1.2, 6.1.3, 8.2 | CISO | Quarterly | M, D | [Risk register](../ISMS/03-risk-management/risk-register.md) with dated reviews | **Partial**: register and two dated reviews exist; no management approval |
| RA-02 | Fraud and insider misuse are assessed explicitly (self-approved changes, break-glass misuse, data exfiltration by staff) | CC3.3 | 6.1.2 | CISO | Annual | M, D | Fraud risk entries in the register | **Planned** |
| RA-03 | Significant changes (new Region, new subservice organization, first production release) trigger a risk review before go-live | CC3.4, CC9.1 | 6.1.2, 8.2 | CISO | On change | M, P | Change-triggered review records | **Partial**: Q2 review shows the practice; no trigger list |
| RA-04 | Every technical rule that is set aside needs a recorded reason, owner and expiry date; expired exceptions count again automatically | CC3.2, CC5.3 | 6.1.3 f | Repository owner | Every run | A, P | [`exceptions.yaml`](../../Internal-IT/engineering/policy-as-code/metadata/exceptions.yaml); "Excepted Findings" in the report; evaluator tests | **Implemented** |

## 5. Monitoring activities (MO)

| ID | Control | TSC | ISO 27001:2022 | Owner | Frequency | Nature | Evidence | Status and gap |
|---|---|---|---|---|---|---|---|---|
| MO-01 | A regression job plans deliberately insecure Terraform on every run and fails the build unless each expected control is reported by its named tool | CC4.1, CC7.1 | 9.1, A.8.29 | Cloud Platform Engineering | Every run | A, D | `regression` job log; [`check-regression.sh`](../../Internal-IT/engineering/ci-cd/scripts/check-regression.sh); [`expected-controls.txt`](../../Internal-IT/workloads/control-validation-scenarios/expected-controls.txt) | **Implemented** |
| MO-02 | Compliance and Risk performs an annual control self-assessment against this matrix, independent of control owners where staffing allows | CC4.1 | 9.2 | Compliance and Risk | Annual | M, D | Self-assessment workpapers | **Planned** |
| MO-03 | Control deficiencies are logged with an owner and due date and tracked to closure in the risk treatment plan | CC4.2 | 10.2 | CISO | On occurrence | M, D | [Risk treatment plan](../ISMS/03-risk-management/risk-treatment-plan.md); deficiency log | **Partial**: treatment plan exists; no separate deficiency log |

## 6. Control activities and policy enforcement (CA)

| ID | Control | TSC | ISO 27001:2022 | Owner | Frequency | Nature | Evidence | Status and gap |
|---|---|---|---|---|---|---|---|---|
| CA-01 | 38 configuration rules, each with a severity and rationale, are enforced by Checkov, tfsec and OPA on every Terraform plan; an unmapped finding counts as at least MEDIUM | CC5.1, CC5.2, CC7.1 | A.5.36, A.8.9 | Repository owner | Every run | A, P | [`control-mapping.yaml`](../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml); `tests/compliance/test_control_mapping.py` | **Implemented** |
| CA-02 | The evaluator fails closed: missing, empty, malformed or errored scanner output, or an invalid severity, stops the run | CC5.2, CC7.1 | A.8.25 | Repository owner | Every run | A, P | [`evaluate-results.py`](../../Internal-IT/engineering/ci-cd/scripts/evaluate-results.py); `tests/compliance/test_evaluate_results.py` | **Implemented** |

## 7. Logical and physical access (AC)

| ID | Control | TSC | ISO 27001:2022 | Owner | Frequency | Nature | Evidence | Status and gap |
|---|---|---|---|---|---|---|---|---|
| AC-01 | Workforce identities are created from the personnel source into Entra ID by Terraform; one identity per person, no shared accounts | CC6.1, CC6.2 | A.5.16 | Cloud Platform Engineering | Per joiner | A, P | [`entra-id/modules/core/`](../../Internal-IT/platform/domains/identity/entra-id/modules/core/) | **Designed** |
| AC-02 | Staff reach AWS only through Entra ID federation into IAM Identity Center permission sets; IAM users are prohibited | CC6.1 | A.5.15, A.8.2 | Cloud Platform Engineering | Continuous | A, P | [`aws-identity-center/`](../../Internal-IT/platform/domains/identity/aws-identity-center/); gate control `IAM_USER_PROHIBITED` | **Partial**: the gate rejects IAM users in scanned plans (Implemented); the federation itself is Designed |
| AC-03 | MFA is required for all administrative access; Tier 0 access requires phishing-resistant MFA | CC6.1 | A.8.5 | CISO | Continuous | A, P | Conditional Access policy export; Identity Center MFA setting | **Designed**: [`ca-tier0-mfa.tf`](../../Internal-IT/platform/domains/identity/entra-id/modules/security/conditional_access/ca-tier0-mfa.tf) is written, but `enable_conditional_access` defaults to `false` because the tenant is on Entra ID Free. MFA cannot be shown as enforced |
| AC-04 | Permissions follow least privilege: tiered permission sets, permission boundaries on every role, ABAC by mandatory tags, no wildcard actions | CC6.1, CC6.3 | A.8.2, A.8.3 | Cloud Platform Engineering | Continuous | A, P | [`aws-iam-core/`](../../Internal-IT/platform/domains/identity/aws-iam-core/); gate controls `IAM_WILDCARD_POLICY`, `IAM_INLINE_POLICY_USAGE` | **Partial**: wildcard and inline checks Implemented in the gate; boundaries and ABAC Designed |
| AC-05 | Privileged sessions are time-limited: 1 hour for the platform administrator set, 8 hours for others | CC6.1 | A.8.2 | Cloud Platform Engineering | Continuous | A, P | [`session-controls.tf`](../../Internal-IT/platform/domains/identity/aws-identity-center/session-controls.tf) | **Designed** |
| AC-06 | Access is granted only on an approved request and removed within one business day of a leaver event from HR | CC6.2, CC6.3 | A.5.16, A.5.18 | IT Support | Per event | M, P | Joiner and leaver tickets matched to identity change commits | **Designed**: [provisioning workflow](../../Internal-IT/platform/domains/identity/docs/identity-provisioning-workflow.md); no tickets |
| AC-07 | Managers and the CISO review all workforce access to production and to the repository each quarter; removals are completed and evidenced | CC6.2, CC6.3 | A.5.18 | Security Operations | Quarterly | M, D | Signed review records (template in SOC2-05) | **Planned** |
| AC-08 | The AWS root user is denied by SCP in member accounts; emergency access uses a break-glass role whose trust policy requires MFA, and every use is reviewed within 24 hours | CC6.1, CC7.2 | A.8.2, A.8.18 | CISO | Per use | A, P / M, D | [`deny-root-usage.json`](../../Internal-IT/platform/foundation/aws-organization/modules/scp/deny-root-usage.json); [break-glass procedure](../../Internal-IT/platform/domains/identity/docs/break-glass-procedure.md) | **Designed**: the procedure promises an EventBridge alert that does not exist in the Terraform |
| AC-09 | Repository access is limited to named accounts; `CODEOWNERS` covers the gate, scripts and workflows; ruleset `protect-main` requires a pull request and five passing checks and blocks force-push and deletion | CC6.1, CC8.1 | A.8.4 | Repository owner | Continuous | A, P | [`CODEOWNERS`](../../.github/CODEOWNERS); ruleset export; collaborator list | **Implemented** (ruleset configured 2026-10-05); collaborator list never reviewed |
| AC-10 | Network exposure is restricted: no SSH from the internet, no unrestricted NACL ingress or public egress, no default VPC, only the ALB is public | CC6.6 | A.8.20, A.8.21 | Cloud Platform Engineering | Every run | A, P | Gate controls `EC2_OPEN_SSH`, `NETWORK_ACL_UNRESTRICTED_INGRESS`, `EC2_PUBLIC_EGRESS`, `VPC_DEFAULT_PROHIBITED`; [networking module](../../Internal-IT/workloads/ayka-portal/modules/networking/) | **Partial**: rules Implemented in the gate; the network is Gated design |
| AC-11 | Public traffic passes AWS WAF with AWS managed rule groups, including Log4j protection, before reaching the ALB | CC6.6, CC6.8 | A.8.20, A.8.23 | Cloud Platform Engineering | Continuous | A, P | [`alb.tf`](../../Internal-IT/workloads/ayka-portal/modules/compute/alb.tf); gate controls `ALB_WAF_PROTECTION_REQUIRED`, `WAF_LOG4J_PROTECTION` | **Gated design** |
| AC-12 | Data in transit is encrypted with TLS 1.2 or higher at the ALB and between the application and RDS | CC6.7 | A.8.24 | Cloud Platform Engineering | Continuous | A, P | ALB listener policy; RDS parameter group; gate controls `ALB_TLS_ENFORCEMENT`, `RDS_ENCRYPTION_IN_TRANSIT` | **Gated design** |
| AC-13 | Data at rest is encrypted with a customer-managed KMS key with annual rotation (RDS, S3, logs, secrets, Performance Insights) | CC6.1, CC6.7, C1.1 | A.8.24 | Cloud Platform Engineering | Continuous | A, P | [`kms.tf`](../../Internal-IT/workloads/ayka-portal/kms.tf); gate controls `S3_ENCRYPTION_MISSING`, `S3_KMS_ENCRYPTION_REQUIRED`, `EC2_ROOT_VOLUME_UNENCRYPTED`, `CLOUDWATCH_LOG_GROUP_KMS_ENCRYPTION`, `SECRETS_MANAGER_CMK_ENCRYPTION`; [S3 control chain](../ISMS/04-controls-and-soa/control-chain-s3-encryption.md) | **Gated design** |
| AC-14 | The pipeline holds no cloud credentials; scanner binaries are verified by SHA-256 and GitHub Actions are pinned by commit SHA | CC6.8, CC8.1 | A.8.19, A.5.21 | Repository owner | Every run | A, P | [`.github/actions/`](../../.github/actions/); absence of `id-token` permissions; [`toolchain.versions`](../../Internal-IT/engineering/ci-cd/toolchain.versions) | **Implemented** |
| AC-15 | Container images are pulled from an approved registry by immutable digest and scanned for vulnerabilities before deployment | CC6.8, CC7.1 | A.8.7, A.8.8 | Product and Engineering | Every build | A, P | Image scan results | **Planned**: the task definition uses the mutable tag `nginx:stable` |
| AC-16 | Company laptops are managed: full-disk encryption, screen lock, endpoint protection and automatic updates | CC6.8, CC6.5 | A.8.1, A.8.7 | IT Support | Continuous | A, P | MDM compliance report | **Planned** |
| AC-17 | Physical security of production facilities | CC6.4 | A.7.1 to A.7.4 | AWS (carved out) | | | AWS SOC 2 report, reviewed under VM-02 | **Carved out**: CSOC, see [system description](01-system-description.md) section 7 |
| AC-18 | Storage media in production are destroyed by the cloud provider; Ayka laptops are wiped with a recorded certificate before reuse or disposal | CC6.5 | A.7.10, A.7.14 | IT Support / AWS | Per disposal | M, P | Disposal certificates | **Planned** for laptops; carved out for production media |

## 8. System operations (OP)

| ID | Control | TSC | ISO 27001:2022 | Owner | Frequency | Nature | Evidence | Status and gap |
|---|---|---|---|---|---|---|---|---|
| OP-01 | Infrastructure configuration is scanned against the 38 rules on every change before it can be applied | CC7.1 | A.8.8, A.8.9 | Cloud Platform Engineering | Every run | A, P | Compliance summary of sampled runs | **Implemented** for `ayka-portal`; platform roots under `Internal-IT/platform/` are not scanned |
| OP-02 | Application dependencies, container images and the running environment are scanned for known vulnerabilities; findings are fixed within: critical 7 days, high 30 days, medium 90 days | CC7.1 | A.8.8 | Product and Engineering | Weekly and per build | A, D | Scanner reports; ticket ageing | **Planned**: only infrastructure code is scanned today |
| OP-03 | CloudTrail records management events in all Regions of every account with log file validation; an SCP prevents stopping, deleting or changing it | CC7.2 | A.8.15 | Cloud Platform Engineering | Continuous | A, D | [`cloudtrail.tf`](../../Internal-IT/platform/foundation/landing-zone/modules/core/logging/cloudtrail.tf); [`deny-disable-cloudtrail.json`](../../Internal-IT/platform/foundation/aws-organization/modules/scp/deny-disable-cloudtrail.json) | **Designed**: delivery never tested (RISK-006) |
| OP-04 | Workload logs are kept 365 days: VPC flow logs, WAF logs, ECS application logs, ALB and S3 access logs | CC7.2 | A.8.15 | Cloud Platform Engineering | Continuous | A, D | Log group retention settings; gate controls `VPC_FLOW_LOGS_MISSING`, `S3_LOGGING_DISABLED`, `WAF_LOGGING_DISABLED` | **Gated design** |
| OP-05 | Security events raise alerts to the on-call engineer: root or break-glass use, CloudTrail changes, IAM policy changes, GuardDuty findings of medium or higher | CC7.2, CC7.3 | A.8.16 | Security Operations | Continuous | A, D | EventBridge rules, GuardDuty configuration, alert tickets | **Planned**: only the `security-alerts` SNS topic exists; no rule publishes to it |
| OP-06 | Security incidents are triaged, classified, contained, eradicated and recovered under the Incident Response Plan; customers are notified within 48 hours of confirmation | CC7.3, CC7.4 | A.5.24 to A.5.26 | CISO | Per incident | M, D | Incident tickets and timelines | **Designed**: [Incident Response Plan](policies/incident-response-plan.md); no incidents |
| OP-07 | Each incident of severity 2 or higher, and each annual tabletop exercise, ends with a post-incident review and tracked actions | CC7.5 | A.5.27 | CISO | Per incident, annual | M, D | Post-incident review records | **Designed**; no exercise held |
| OP-08 | Configuration drift between Terraform and the running environment is detected daily and investigated | CC7.1 | A.8.9 | Cloud Platform Engineering | Daily | A, D | Drift workflow runs | **Designed**: [`drift-detection.yml`](../../.github/workflows/drift-detection.yml) is manual and refuses to run without a remote backend |

## 9. Change management (CM)

| ID | Control | TSC | ISO 27001:2022 | Owner | Frequency | Nature | Evidence | Status and gap |
|---|---|---|---|---|---|---|---|---|
| CM-01 | Every change to infrastructure, policies and pipeline goes through a pull request to `main`; direct pushes and force-pushes are blocked | CC8.1 | A.8.32 | Repository owner | Every change | A, P | Ruleset `protect-main`; merged PR list for the period | **Implemented** |
| CM-02 | A change can merge only when script validation, unit and policy tests, Terraform validate and plan, the three scanners, the evaluator and the regression job pass | CC8.1, CC7.1 | A.8.25, A.8.29 | Repository owner | Every change | A, P | [`test.yml`](../../.github/workflows/test.yml); required checks in the ruleset | **Implemented** |
| CM-03 | A HIGH finding fails the change; a MEDIUM finding stops it at the `medium-risk-approval` environment until a reviewer approves | CC8.1 | A.8.32 | Repository owner | Every change | A, P | [`enforcement-levels.md`](../../Internal-IT/engineering/ci-cd/compliance-gates/enforcement-levels.md); environment approval history | **Implemented** |
| CM-04 | The apply job verifies the SHA-256 checksums of the evidence bundle and that it belongs to the commit being applied | CC8.1 | A.8.32 | Repository owner | Every apply | A, P | [`run-apply.sh`](../../Internal-IT/engineering/ci-cd/scripts/run-apply.sh); `tests/compliance/test_evidence.py` | **Implemented** (apply itself is simulated) |
| CM-05 | The person who approves a change, or a MEDIUM-risk release, is not its author | CC8.1, CC5.1 | A.5.3, A.8.32 | CISO | Every change | M, P | PR approvals vs authors for the period | **Planned**: the ruleset requires 0 approvals and environments allow self-review because the repository has one maintainer |
| CM-06 | Emergency changes may skip the approval wait but not the scans; they are reviewed retrospectively within two business days | CC8.1 | A.8.32 | CISO | Per emergency | M, D | Emergency change log | **Designed**: [Change Management Policy](policies/change-management-policy.md) section 6 |

## 10. Risk mitigation and vendors (RM, VM)

| ID | Control | TSC | ISO 27001:2022 | Owner | Frequency | Nature | Evidence | Status and gap |
|---|---|---|---|---|---|---|---|---|
| RM-01 | Business disruption risks are covered by the BC/DR plan, which is tested annually | CC9.1, A1.3 | A.5.29, A.5.30 | CISO | Annual | M, D | Plan; test record | **Designed**: [BC/DR plan](policies/business-continuity-and-disaster-recovery-plan.md); no test |
| RM-02 | Ayka holds cyber insurance sized to its contractual liability | CC9.1 | | Managing Director | Annual | M, P | Policy schedule | **Planned** |
| VM-01 | A vendor register lists every supplier that touches customer data or the system, with a risk tier, data categories, location and contract status | CC9.2 | A.5.19, A.5.20 | Compliance and Risk | On change, annual | M, P | Vendor register | **Partial**: [processor register](../GDPR/processor-register.md) lists AWS, Microsoft, GitHub; no risk tiering |
| VM-02 | For each critical vendor, the latest SOC 2 Type II (or ISO 27001 certificate and SoA), its bridge letter and its CUECs are reviewed yearly; exceptions in the report are assessed | CC9.2 | A.5.22 | Compliance and Risk | Annual | M, D | Vendor review records (template in SOC2-05) | **Planned**: no report retrieved |

## 11. Availability (AV)

| ID | Control | TSC | ISO 27001:2022 | Owner | Frequency | Nature | Evidence | Status and gap |
|---|---|---|---|---|---|---|---|---|
| AV-01 | Capacity is managed by ECS CPU target-tracking autoscaling, AWS service quota monitoring and budget alerts | A1.1 | A.8.6 | Cloud Platform Engineering | Continuous | A, D | [`autoscaling.tf`](../../Internal-IT/workloads/ayka-portal/modules/compute/autoscaling.tf); [quotas](../../Internal-IT/platform/foundation/landing-zone/modules/quotas/main.tf) and [cost controls](../../Internal-IT/platform/foundation/landing-zone/modules/cost_controls/main.tf) modules | **Partial**: autoscaling is Gated design; quotas and budgets Designed |
| AV-02 | The database runs Multi-AZ and the ALB spans at least two availability zones | A1.2 | A.8.14 | Cloud Platform Engineering | Continuous | A, P | [`database/main.tf`](../../Internal-IT/workloads/ayka-portal/modules/database/main.tf) (`multi_az = true`) | **Gated design** |
| AV-03 | Automated RDS backups are kept 7 days with deletion protection and a final snapshot; S3 evidence objects are versioned with noncurrent versions kept 30 days | A1.2, C1.2 | A.8.13 | Cloud Platform Engineering | Daily | A, P | RDS and S3 configuration; gate control `S3_VERSIONING_DISABLED` | **Gated design**: no cross-Region or cross-account copy (`S3_REPLICATION_DISABLED` is LOW and open) |
| AV-04 | A database and file restore is tested at least annually against the RPO and RTO, and the result recorded | A1.3 | A.8.13, A.5.30 | Cloud Platform Engineering | Annual | M, D | Restore test record (template in SOC2-05) | **Planned** |
| AV-05 | External uptime monitoring checks the portal every minute and pages on-call after three failures; monthly availability is reported against the 99.5 % target | A1.1, CC7.2 | A.8.16 | Security Operations | Continuous, monthly | A, D | Monitor configuration; monthly report | **Planned** |

## 12. Confidentiality (CO)

| ID | Control | TSC | ISO 27001:2022 | Owner | Frequency | Nature | Evidence | Status and gap |
|---|---|---|---|---|---|---|---|---|
| CO-01 | Information is classified Public, Internal, Confidential or Restricted and handled by the rules for its class; resources carry a `DataClassification` tag | C1.1 | A.5.12, A.5.13 | CISO | Continuous | M, P | [Data Classification and Confidentiality Policy](policies/data-classification-and-confidentiality-policy.md); tag on resources | **Designed**: no Terraform sets the tag yet |
| CO-02 | No customer data store is public: S3 public access is blocked and ACLs disabled | C1.1, CC6.6 | A.8.12 | Cloud Platform Engineering | Every run | A, P | Gate controls `S3_PUBLIC_ACCESS`, `S3_ACLS_DISABLED`; [public access block](../../Internal-IT/platform/foundation/landing-zone/modules/core/s3/public_access_block.tf) | **Partial**: Implemented as a gate rule; the buckets are Gated design |
| CO-03 | Personnel and contractors sign confidentiality agreements before access | C1.1, CC1.4 | A.6.6 | HR | At hire | M, P | Signed agreements for sampled joiners | **Planned** |
| CO-04 | On contract end, customer data is deleted from live stores within 30 days and ages out of backups within 35 further days; deletion is confirmed to the customer in writing | C1.2 | A.8.10 | Head of Product | Per offboarding | M, P | Deletion tickets and confirmations | **Designed**: policy written; no customer has left |
| CO-05 | Test and development use synthetic data only; production customer data is never copied out of production | C1.1 | A.8.33 | Product and Engineering | Continuous | M, P | Test fixtures; access logs | **Implemented** for this repository: all scenarios are synthetic Terraform |

## 13. Summary

| Status | Controls |
|---|---:|
| Implemented | 13 |
| Partial | 11 |
| Gated design | 6 |
| Designed | 14 |
| Planned | 20 |
| Carved out | 1 |
| **Total** | **65** |

Counts are kept in step with the tables in the same pull request. A status moves up only with a link to new evidence.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-06 | First issue |
