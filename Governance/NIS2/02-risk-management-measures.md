# NIS2 Risk-Management Measures: Gap Assessment

| Field | Value |
|---|---|
| Document ID | NIS2-02 |
| Organization | Ayka Secure Technologies GmbH (simulated case study) |
| Owner | CISO |
| Contributors | Cloud Platform Engineer, Security Engineer, Compliance Officer |
| Version | 1.0 |
| Assessment date | 2026-10-06 |
| Status | Draft. Not approved: no approval record exists. |
| Classification | Internal |

## 1. Why this exists when NIS2 does not apply

Ayka is out of scope ([NIS2-01](01-applicability-assessment.md)). This assessment still matters for two reasons:

1. **Customers ask for it.** In-scope customers must judge the security practices of their suppliers. They will ask the questions in this table, in this order, because it is the order of NIS2 Art. 21(2) and §30(2) BSIG.
2. **There is no transition period.** If Ayka reaches 50 employees, these measures are a legal duty from that day. Everything below that is "Planned" on that day is a breach.

The yardstick is the BSIG list, not ISO 27001. ISO 27001 controls are given for cross-reference because the [ISMS](../ISMS/README.md) is the management system Ayka will use to run these measures. For cloud computing service providers, the detailed content of each measure is set by the annex of Implementing Regulation (EU) 2024/2690, which is more specific than §30 BSIG; section 4 covers what it adds.

## 2. How status is judged

The labels follow the repository's capability yardstick ([README, section 4](../../README.md#4-capability-status)). The weakest true label wins.

- **Implemented**: runs today and something shows it working (a CI run, a test, a configured setting).
- **Partial**: some of the measure is implemented; the gap is named.
- **Designed**: Terraform or a procedure exists but has never been applied or exercised.
- **Planned**: only written down as an intention, or not at all.

Remember what the repository is: the compliance gate runs for real on every pull request, but no infrastructure is deployed. A measure that depends on a running AWS account can at best be "Designed".

## 3. Assessment against §30(2) BSIG / NIS2 Art. 21(2)

| No. | Measure (§30(2) BSIG, Art. 21(2) NIS2) | What exists at Ayka | Status | ISO 27001:2022 | Gap and next action | Owner |
|---|---|---|---|---|---|---|
| 1 | **(a) Risk analysis and information system security policies** | [Information security policy](../ISMS/00-context-and-governance/information-security-policy.md); [risk methodology](../ISMS/03-risk-management/risk-management-methodology.md) and [criteria](../ISMS/03-risk-management/risk-criteria.md); [risk register](../ISMS/03-risk-management/risk-register.md) with 13 risks tied to repository conditions | Partial | 5.1, 6.1.2, A.5.1 | All documents are drafts nobody has approved. The risk register describes the repository, not a running service. Action: management approval of the policy (see [NIS2-04](04-management-accountability.md)); first risk assessment of the live service before launch | CISO |
| 2 | **(b) Incident handling** | [NIS2-03 incident reporting procedure](03-incident-reporting-procedure.md) (new). Roles assigned: Incident Coordinator and Incident Handler in the [personnel register](../../organization/personnel-register.md). CloudTrail with log file validation and an SNS `security-alerts` topic in the [landing zone](../../Internal-IT/platform/foundation/landing-zone/) | Planned | A.5.24 to A.5.28, A.6.8 | **Detection does not exist.** The SNS topic has a subscriber but nothing publishes to it: no EventBridge rule, no GuardDuty, no CloudWatch alarm. No SIEM; the Firehose stream only copies logs to S3. Action: GuardDuty and Security Hub organisation-wide, EventBridge rules for root use, break-glass use and CloudTrail changes, routed to the SNS topic. Then one tabletop exercise | Security Engineer |
| 3 | **(c) Business continuity: backup, disaster recovery, crisis management** | RDS Multi-AZ, 7-day automated backups, deletion protection ([database module](../../Internal-IT/workloads/ayka-portal/modules/database/main.tf)); S3 versioning; Terraform as the rebuild path | Designed | A.5.29, A.5.30, A.8.13, A.8.14 | Never applied or restored. Single Region, so a Regional outage stops the service. No backups outside the production account, so a compromised account can delete its own backups. No crisis team or out-of-band communication defined. Action: BCP with RTO/RPO per service; AWS Backup with a vault in a separate account; first restore test as a record | Cloud Platform Engineer |
| 4 | **(d) Supply-chain security** | [Processor register](../GDPR/processor-register.md) (AWS, Microsoft, GitHub); GitHub Actions pinned by commit SHA; tool versions and checksums pinned in [`toolchain.versions`](../../Internal-IT/engineering/ci-cd/toolchain.versions) | Partial | A.5.19 to A.5.23, A.8.30 | Software-supply-chain hygiene in CI is real. Supplier assessments are not: no attestation (SOC 2 report, ISO certificate) retrieved for any provider. Full treatment in [NIS2-05](05-supply-chain-security.md) | Finance & Procurement Officer with CISO |
| 5 | **(e) Security in acquisition, development and maintenance, including vulnerability handling and disclosure** | Compliance gate on every pull request: Checkov, tfsec and OPA mapped to 38 controls, fail-closed evaluator, checksummed evidence ([README](../../README.md)); branch ruleset `protect-main` requiring a PR and the pipeline checks; [CODEOWNERS](../../.github/CODEOWNERS) on the gate itself | **Implemented** for infrastructure code | A.8.25 to A.8.29, A.8.32, A.8.8 | This is Ayka's strongest measure. Gaps: it covers Terraform only, not application code (no SAST, no dependency scanning, no container image scanning); 14 findings are excepted in [`exceptions.yaml`](../../Internal-IT/engineering/policy-as-code/metadata/exceptions.yaml); no vulnerability disclosure policy or `security.txt`. Action: publish a disclosure policy with a contact address before launch | Security Engineer |
| 6 | **(f) Assessing the effectiveness of the measures** | Regression job: deliberately insecure scenarios must fail with named controls, or the build fails ([`expected-controls.txt`](../../Internal-IT/workloads/control-validation-scenarios/expected-controls.txt)); unit and policy tests | Partial | 9.1, 9.2, A.5.35, A.5.36 | Proves the gate detects what it claims to, which is rarer than it sounds. No internal audit, no KPIs, no management review has happened. Action: audit programme and KPI set computed from CI history | Compliance Officer |
| 7 | **(g) Basic cyber hygiene and cybersecurity training** | [Training and awareness programme](../../organization/training-and-awareness.md) | Planned | A.6.3, A.8.1, A.8.7 | Programme text only; no training has been delivered, and no endpoint management exists. Action: first baseline training with attendance record; device management decision (Intune is included in some Microsoft 365 plans) | HR & Administration (Training Coordinator) |
| 8 | **(h) Cryptography and encryption** | KMS customer-managed key; RDS and Performance Insights encrypted with it; S3 encryption enforced by a gate control traced end to end in the [S3 encryption control chain](../ISMS/04-controls-and-soa/control-chain-s3-encryption.md) | Partial | A.8.24 | Encryption at rest is gate-enforced. Missing: a cryptography policy (algorithms, key rotation, who may use keys); the ALB uses a self-signed placeholder certificate; no TLS policy pinned | Cloud Platform Engineer |
| 9 | **(i) HR security, access control, asset management** | Entra ID as identity source with department and tier groups; IAM Identity Center permission sets; permissions boundaries and ABAC tagging ([identity domain](../../Internal-IT/platform/domains/identity/)); [provisioning workflow](../../Internal-IT/platform/domains/identity/docs/identity-provisioning-workflow.md); IAM gate controls (no IAM users, no wildcard policies) | Designed (identity) / Implemented (IAM gate) | A.5.9, A.5.15 to A.5.18, A.6.1 to A.6.6, A.8.2 | Identity Terraform is design-only and not gated. No access review has been performed. No asset inventory. No signed confidentiality agreements. Action: generate the asset inventory from the plan JSON; quarterly access review with a record | CISO with IT Support |
| 10 | **(j) MFA, secured communications, secured emergency communication** | Conditional Access policy "Tier0 - Require MFA" in Terraform; [break-glass procedure](../../Internal-IT/platform/domains/identity/docs/break-glass-procedure.md) | Designed, and **switched off** | A.5.14, A.8.5 | `enable_conditional_access` defaults to `false` because the lab tenant runs Entra ID Free, which has no Conditional Access. Real MFA enforcement needs Entra ID P1 or security defaults. No secured emergency channel defined (who calls whom if Entra ID or company e-mail is down). Action: licence decision; fallback contact list held offline | CISO |

**Summary:** 1 Implemented, 4 Partial, 3 Designed, 2 Planned. The gaps that would matter most to an in-scope customer or to the BSI are, in order: **no detection or alerting** (No. 2), **no tested backup or recovery** (No. 3), and **MFA not enforced** (No. 10).

## 4. What Implementing Regulation 2024/2690 adds for a cloud provider

If Ayka comes into scope as a cloud computing service provider, the annex of the implementing regulation defines the measures in 13 sections. Most map onto the table above. Points that go beyond it and are easy to miss:

| Annex section | Requirement beyond §30(2) BSIG | Ayka position |
|---|---|---|
| 1 Policy on the security of network and information systems | Policy approved by management bodies, reviewed at least annually, with named roles reporting to management | Policy exists as a draft; annual review and approval not yet done |
| 2 Risk management | Compliance monitoring and a regular independent review of network and information security | No internal or external audit yet |
| 3 Incident handling | Logging of a defined set of events, monitoring, and retention of logs for a documented period | CloudTrail defined; log retention period not documented in Terraform or policy |
| 4 Business continuity | Backup copies kept separate from the production environment; regular restore tests | Neither exists (No. 3) |
| 5 Supply chain | Supplier security assessment and contractual requirements, including vulnerability notification by the supplier | See [NIS2-05](05-supply-chain-security.md) |
| 6 Acquisition, development, maintenance | Secure development rules, security testing, patch management, network segmentation | Gate covers infrastructure; application testing and patch process missing |
| 12 Asset management | Asset inventory, classification, handling, return on departure | No inventory |
| 13 Environmental and physical security | Protection against loss of power, failure of supporting utilities, physical access controls | Inherited from AWS for the platform (to evidence through AWS Artifact); the Stuttgart office itself is not assessed |

## 5. Priorities

Ranked by what an auditor or customer would find first and what it costs to fix. Dates are targets, not commitments; they only become commitments when the Managing Director approves them.

| Rank | Action | Closes | Effort | Target |
|---|---|---|---|---|
| 1 | Enable GuardDuty, Security Hub and EventBridge rules feeding the existing `security-alerts` topic | No. 2 detection | Days; small monthly cost | Before launch |
| 2 | Enforce MFA for every account (security defaults or Entra ID P1) | No. 10 | Days; licence cost if P1 | Before launch |
| 3 | AWS Backup with a vault in a separate account; first restore test | No. 3 | 1 to 2 weeks | Before launch |
| 4 | Vulnerability disclosure policy and `security.txt` | No. 5 | 1 day | Before launch |
| 5 | Supplier attestations retrieved and dated (AWS, Microsoft, GitHub) | No. 4 | 1 day | Q4 2026 |
| 6 | Baseline training delivered and recorded; management training (NIS2-04) | No. 7 | 1 day per session | Q4 2026 |
| 7 | Move the workload Region from `ap-south-1` to `eu-central-1` | Customer data-location expectations, RISK-011 | Terraform change plus SCP | Before launch |

## Revision history

| Version | Date | Author | Change |
|---|---|---|---|
| 1.0 | 2026-10-06 | CISO | First gap assessment against §30(2) BSIG |
