# Supplier Questionnaire Response (pre-filled)

| Field | Value |
|---|---|
| Document ID | NIS2-07 |
| Organization | Ayka Secure Technologies GmbH (simulated case study) |
| Owner | CISO |
| Contributors | Sales Manager, Compliance Officer, Security Engineer |
| Version | 1.1 |
| Date | 2026-11-10 |
| Status | Draft. Not approved. Not sent to any customer (there are none) |
| Classification | Internal; share under NDA after CISO review |

## 1. How to use this

The 44 questions below are the ones an in-scope customer's supplier-risk team asks, in the order of Art. 21(2) NIS2 and §30(2) BSIG, followed by contract and data questions. Each answer is written so that it is true on 2026-11-10 and cannot be read as more than it is.

Rules:

- Copy the **Answer** and the **Status** together. Never copy one without the other.
- Statuses: Implemented, Partial, Gated design, Designed, Planned. "Simulated operation" appears only where a record owned by the NIS2 set links to it; elsewhere a walk-through is written as "+ simulated record SIM-xxx" next to a weaker label. A simulated record is a tabletop walk-through; it shows a procedure can be followed, not that it ran.
- "Gated design" means Terraform exists, is checked by the CI compliance gate on a plan, and has never been applied. Ayka has no deployed system and no customers.
- Where the honest answer is "no", the answer says no.
- Evidence paths were checked on 2026-11-10: each linked file exists. A file that exists is not a system that runs.

Worked example of use: [SIM-NIS2-002](../records/simulated/nis2/SIM-NIS2-002-customer-supplier-security-assessment.md).

## 2. Governance and risk (Art. 21(2)(a), Art. 20)

| # | Question | Answer | Status | Evidence |
|---|---|---|---|---|
| 1 | Do you have an approved information security policy? | A policy exists. Nobody has approved it: the case-study company has no approval record. | Designed | [Information security policy](../ISMS/00-context-and-governance/information-security-policy.md) |
| 2 | Is there a named person responsible for information security, and does management oversee it? | Yes, by role: the CISO (EMP-002) owns the ISMS; the Managing Director (EMP-001) is the management body. A walk-through of the oversight cycle was done; real management reviews have not happened. | Designed (+ simulated record [SIM-MR-001](../records/simulated/management-review/SIM-MR-001-management-review-2026.md), scenario 2026-10-26) | [NIS2-04](04-management-accountability.md); [management review agenda](../ISMS/10-management-review/management-review-agenda.md) |
| 3 | Is your management trained in cybersecurity? | A training session for management is specified and was walked through once. No real course has been attended. | Simulated operation | [SIM-NIS2-001](../records/simulated/nis2/SIM-NIS2-001-management-cybersecurity-training.md) |
| 4 | Do you perform a documented risk assessment? | A methodology, criteria and a register with 13 risks exist. They describe the repository and the planned service, not a running service. | Partial | [Risk register](../ISMS/03-risk-management/risk-register.md); [methodology](../ISMS/03-risk-management/risk-management-methodology.md) |
| 5 | How often is risk reassessed? | At least yearly and on change, per the methodology. No reassessment cycle has been completed. | Designed | [Risk management methodology](../ISMS/03-risk-management/risk-management-methodology.md) |
| 6 | Are you in scope of NIS2 yourself? | No. Staff 24, below the 50 in §28(2) no. 3 BSIG; turnover and balance sheet not yet recorded. Reassessed every six months; last 2026-11-10. | Designed (analysis done; not approved) | [NIS2-08](08-applicability-reassessment-2026-11.md) |
| 7 | Do you hold a certification (ISO/IEC 27001, TISAX, SOC 2, C5)? | No. ISO/IEC 27001 is the target; TISAX on demand. | Planned | [NIS2-05](05-supply-chain-security.md) A.2 |
| 8 | Have you been audited internally or externally? | One internal audit has been walked through as a tabletop. No real internal or external audit exists. | Designed (+ simulated record [SIM-AUD-001](../records/simulated/audit/SIM-AUD-001-internal-audit-plan-2026.md)) | [Audit programme](../ISMS/09-internal-audit/audit-programme.md) |

## 3. Incident handling (Art. 21(2)(b), Art. 23)

| # | Question | Answer | Status | Evidence |
|---|---|---|---|---|
| 9 | Do you have a documented incident response plan? | Yes, a plan and a separate reporting procedure. Neither has been approved or used on a real incident. | Designed | [Incident response plan](../policies/incident-response-plan.md); [NIS2-03](03-incident-reporting-procedure.md) |
| 10 | Within what time do you notify customers of an incident? | Early warning within 24 hours of awareness, update at 72 hours, final report within one month. | Designed (+ simulated record [SIM-INC-001](../records/simulated/incident/SIM-INC-001-inc-2026-001-customer-export-in-public-ci.md), scenario 2026-08-12) | [NIS2-03](03-incident-reporting-procedure.md) section 5; [NIS2-06](06-customer-security-addendum.md) C-2 to C-4 |
| 11 | When does your 24 hours start? | At awareness: reasonable certainty after an initial assessment that began without delay (aim: under four hours). Not at the start of the incident. | Designed | [NIS2-03](03-incident-reporting-procedure.md) section 3 |
| 12 | What defines a significant incident? | Fixed thresholds S-1 to S-9 taken from Implementing Regulation 2024/2690, for example platform unavailable over 30 minutes, or confirmed malicious compromise of data. | Designed | [NIS2-03](03-incident-reporting-procedure.md) section 4 |
| 13 | How do you detect incidents? | Detection services (GuardDuty, Security Hub, Config, five EventBridge rules to an SNS alert topic with an e-mail subscription) are in Terraform and in the CI gate (local run [REAL-INFRA-001](../records/real/infra/REAL-INFRA-001-gate-run-all-roots.md); the CI job has not run on GitHub); they have never been applied to an account. Today there is no live detection and no paging. | Gated design | [detection module](../../Internal-IT/platform/foundation/landing-zone/modules/detection/); [logging and monitoring standard](../policies/logging-and-monitoring-standard.md) |
| 14 | Do you have a 24-hour incident contact? | A role chain exists on paper (Incident Coordinator, deputy, CISO). No on-call rota or paging exists. | Designed | [NIS2-03](03-incident-reporting-procedure.md) section 2 |
| 15 | Have you tested your incident process? | Once, as a tabletop with fictional staff. Not a real exercise. | Designed (+ simulated record [SIM-INC-001](../records/simulated/incident/SIM-INC-001-inc-2026-001-customer-export-in-public-ci.md)) | Simulated record SIM-INC-001 and the drafts [SIM-INC-002](../records/simulated/incident/SIM-INC-002-t1-customer-notice-24h-draft.md) to [SIM-INC-006](../records/simulated/incident/SIM-INC-006-t4-incident-and-breach-log.md) |
| 16 | Do you keep logs, and for how long? | The standard sets 365 days online for flow, WAF, application and access logs, 90 days for database logs, and one year plus archive for CloudTrail. Entra ID and GitHub log export is Planned. Nothing runs. | Designed | [Logging and monitoring standard](../policies/logging-and-monitoring-standard.md) section 4 |

## 4. Business continuity (Art. 21(2)(c))

| # | Question | Answer | Status | Evidence |
|---|---|---|---|---|
| 17 | Do you have a BC/DR plan with RTO and RPO? | A plan with objectives exists. The plan itself states that a Region failure or an account compromise would exceed them today. | Designed | [BC/DR plan](../policies/business-continuity-and-disaster-recovery-plan.md) |
| 18 | Are backups kept outside the production account? | **No.** AWS Backup with a locked vault is in Terraform and the gate (plan-only), but the vault is in the workload account and nothing is copied to another account or Region. No backup exists. | Gated design (vault; no copy outside the account) | [backup module](../../Internal-IT/workloads/ayka-portal/modules/backup/); [backup and restore procedure](../ISMS/06-operational-procedures/backup-and-restore-procedure.md) |
| 19 | Have you tested a restore? | A tabletop ([SIM-BCP-001](../records/simulated/continuity/SIM-BCP-001-restore-and-dr-tabletop.md)), and one run of the restore-and-verify method on a local PostgreSQL container with synthetic data. No restore from AWS Backup or RDS, and no measured recovery time. | Designed (+ simulated record SIM-BCP-001; method run locally, [REAL-INFRA-002](../records/real/infra/REAL-INFRA-002-restore-test-local-postgres.md)) | Simulated record SIM-BCP-001; [REAL-INFRA-002](../records/real/infra/REAL-INFRA-002-restore-test-local-postgres.md) |
| 20 | Do you run in more than one Region or provider? | One Region, one provider. Concentration on AWS, Microsoft and GitHub is a recorded risk. | Designed | [BC/DR plan](../policies/business-continuity-and-disaster-recovery-plan.md); [NIS2-05](05-supply-chain-security.md) B.3 |

## 5. Supply chain (Art. 21(2)(d), 21(3))

| # | Question | Answer | Status | Evidence |
|---|---|---|---|---|
| 21 | Who are your critical sub-suppliers? | Amazon Web Services (hosting), Microsoft (Entra ID), GitHub (source and CI). | Designed | [Processor register](../GDPR/processor-register.md) |
| 22 | How do you assess them? | A policy and a review template exist. Public assurance pages were read on 2026-11-10. No SOC 2, C5 or ISO report has been obtained and none reviewed. A review was walked through once. | Partial (+ simulated record [SIM-SUP-001](../records/simulated/supplier/SIM-SUP-001-annual-critical-supplier-review.md), scenario 2026-07-06) | [REAL-SUP-001](../records/real/supplier/REAL-SUP-001-supplier-attestations.md); [vendor management policy](../policies/vendor-management-policy.md) |
| 23 | Do your sub-suppliers hold certifications? | Their public pages say yes (AWS: ISO/IEC 27001:2022, 27017, 27018; Microsoft: ISO/IEC 27001 for Azure; GitHub: ISO/IEC 27001:2022 for Enterprise accounts). Ayka has not seen a certificate or its validity dates, and Ayka's GitHub account is personal, not Enterprise. | Partial | [REAL-SUP-001](../records/real/supplier/REAL-SUP-001-supplier-attestations.md) |
| 24 | Do you notify customers of changes to sub-processors? | Commitment: 30 days' notice and a right to object. No subscription to provider change notices exists yet. | Designed | [NIS2-06](06-customer-security-addendum.md) C-7; [vendor management policy](../policies/vendor-management-policy.md) |
| 25 | Do you protect your software supply chain? | CI actions are pinned to commit SHAs; scanner versions and checksums are pinned; the gate has a CODEOWNERS rule. Secret, workflow, shell, Python and dependency checks and an SBOM were added to CI on 2026-11-10; they ran once locally ([REAL-SDLC-001](../records/real/sdlc/REAL-SDLC-001-first-local-scan.md)), not on GitHub, and are not required checks. | Implemented (pinning and gate, infrastructure code); Designed for the added checks | [NIS2-05](05-supply-chain-security.md) B.2; [`security-checks.yml`](../../.github/workflows/security-checks.yml) |
| 26 | Do you have an exit plan for your critical suppliers? | No written exit note exists per supplier. Terraform makes compute and networking portable; managed services (RDS, KMS) are not. | Planned | [Vendor management policy](../policies/vendor-management-policy.md) section 6 |

## 6. Secure development and vulnerabilities (Art. 21(2)(e))

| # | Question | Answer | Status | Evidence |
|---|---|---|---|---|
| 27 | Do you have a secure development policy and process? | Yes, a policy; and a pull-request gate for infrastructure code (Checkov, tfsec and OPA mapped to 38 controls) that fails closed and produces checksummed evidence. | Implemented (infrastructure code only) | [README](../../README.md); [secure development policy](../policies/secure-development-policy.md) |
| 28 | Do you run SAST, dependency and container scanning? | Checks (Bandit, pip-audit, gitleaks, actionlint, shellcheck, SBOM) were added to CI on 2026-11-10 and ran once locally ([REAL-SDLC-001](../records/real/sdlc/REAL-SDLC-001-first-local-scan.md)); they have not run on GitHub. There is no application code of the SaaS in this repository to scan; no container image scanning exists. | Designed (+ one local run) | [`security-checks.yml`](../../.github/workflows/security-checks.yml) |
| 29 | Do you do penetration tests? | No. One is required before the first production release by policy. | Planned | [Secure development policy](../policies/secure-development-policy.md) section on testing |
| 30 | What are your patch times for vulnerabilities? | Critical 7 days, high 30 days. These are proposed targets; no measurement exists. | Designed | [Vulnerability and patch policy](../policies/vulnerability-and-patch-management-policy.md) |
| 31 | Do you have a vulnerability disclosure policy? | A policy, `SECURITY.md` and `security.txt` were added on 2026-11-10. They sit in a public repository; no company domain serves them and no mailbox is monitored. | Designed | [`SECURITY.md`](../../SECURITY.md); [`.well-known/security.txt`](../../.well-known/security.txt); [vulnerability disclosure policy](../policies/vulnerability-disclosure-policy.md) |
| 32 | Do you have change management with review and approval? | Pull requests with required checks and a branch ruleset on `main`. For infrastructure code only. | Implemented (infrastructure code only) | [Change management policy](../policies/change-management-policy.md); [README](../../README.md) |

## 7. Cryptography, access, MFA (Art. 21(2)(h), (i), (j))

| # | Question | Answer | Status | Evidence |
|---|---|---|---|---|
| 33 | Is data encrypted at rest and in transit? | At rest: KMS customer-managed keys in Terraform; encryption checks run on the plan. In transit: the load balancer listener pins TLS policy `ELBSecurityPolicy-TLS13-1-2-2021-06` but carries a self-signed placeholder certificate. | Partial | [Cryptography policy](../policies/cryptography-policy.md); [S3 encryption chain](../ISMS/04-controls-and-soa/control-chain-s3-encryption.md) |
| 34 | Do you enforce MFA for all staff and administrators? | **No.** The Conditional Access policy exists in Terraform but is switched off, because the lab tenant is on Entra ID Free. Security Defaults or Entra ID P1 is the pending decision. | Designed | [NIS2-02](02-risk-management-measures.md) No. 10; [access control policy](../policies/access-control-policy.md) |
| 35 | Do you apply least privilege and review access? | Permission boundaries, ABAC and permission sets are designed; IAM checks run in the gate. No access review has been performed. | Designed (identity); Implemented for the IAM gate checks | [Identity domain](../../Internal-IT/platform/domains/identity/); [access review procedure](../ISMS/06-operational-procedures/access-review-procedure.md) |
| 36 | Do you keep an asset inventory? | A generated inventory of 88 planned resources exists (from a plan dated 2026-10-06, before the `DataClassification` default tag). It lists no endpoints and no live assets. | Gated design | [Asset inventory](../ISMS/02-asset-management/asset-inventory.md) |
| 37 | Do you manage staff devices? | A device policy exists; no device management is deployed. | Designed | [Endpoint device policy](../policies/user-endpoint-device-policy.md) |
| 38 | Do you have a break-glass procedure? | Yes, on paper, for Entra ID and AWS. Never used. | Designed | [Break-glass procedure](../../Internal-IT/platform/domains/identity/docs/break-glass-procedure.md) |

## 8. People (Art. 21(2)(g), (i))

| # | Question | Answer | Status | Evidence |
|---|---|---|---|---|
| 39 | Do staff receive security awareness training? | A programme is defined. A baseline session was walked through once. No real training has been delivered. | Designed (+ simulated record [SIM-PPL-003](../records/simulated/people/SIM-PPL-003-training-completion.md)) | [Training and awareness](../../organization/training-and-awareness.md) |
| 40 | Are staff screened and bound to confidentiality? | Criteria exist and nobody has been screened; no signed agreements exist. | Designed | [NIS2-02](02-risk-management-measures.md) No. 9 |

## 9. Data protection and contract

| # | Question | Answer | Status | Evidence |
|---|---|---|---|---|
| 41 | Where is customer data stored? | Target: `eu-central-1`. The Terraform was moved to that Region on 2026-11-10 and the source was checked ([REAL-INFRA-003](../records/real/infra/REAL-INFRA-003-region-migration-verification.md)); nothing is deployed, so **no EU-location claim is made yet**. | Gated design | [ADR-0003](../ADR/0003-target-region.md); [processor register](../GDPR/processor-register.md) |
| 42 | Do you transfer data outside the EU? | None intended for customer data. Remote support access and GitHub (United States) are recorded transfers in the register. | Designed | [Data-flow and transfer assessment](../GDPR/data-flow-and-transfer-assessment.md) |
| 43 | Do you sign a data processing agreement? | Yes, a template is intended; none exists as a signed contract. | Planned | [Processor register](../GDPR/processor-register.md) |
| 44 | Do you accept audit rights and a security addendum? | In the limited form of [NIS2-06](06-customer-security-addendum.md) C-8; some clauses cannot be signed yet (see its section 2). | Designed | [NIS2-06](06-customer-security-addendum.md) |

## 10. What not to say

- "NIS2 compliant", "certified", "ISO 27001", "audited", "EU-hosted", "MFA enforced", "24/7 monitoring".
- Any date from a provider's certificate: none was read ([REAL-SUP-001](../records/real/supplier/REAL-SUP-001-supplier-attestations.md)).

## Revision history

| Version | Date | Author | Change |
|---|---|---|---|
| 1.0 | 2026-11-10 | CISO role (AI-drafted) | First pre-filled response, 44 questions |
| 1.1 | 2026-11-10 | CISO role (AI-drafted) | Q13, Q18, Q25, Q28, Q31, Q41 checked against the files. Corrected: Q18 answer is No (vault in the same account); Q33 TLS policy is pinned; Q19 cites the local restore run; Q25 and Q28 use Designed because the checks never ran on GitHub; SIM-INC-00x replaced; paths linked |
