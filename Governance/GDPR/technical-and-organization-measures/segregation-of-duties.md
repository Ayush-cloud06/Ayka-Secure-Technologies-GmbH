# Segregation of Duties (SoD) Protocol

**Organization:** Ayka Secure Technologies GmbH  
**Framework:** GDPR (Art. 32), ISO 27001 (Control A.5.3)  
**System Scope:** Platform Engineering & Workload Operations  
**Last Updated:** 2026-03-15  

---

## 1. Objective
To prevent any single individual from having the capability to independently compromise personal data, alter security logging, or bypass compliance guardrails without explicit detection and approval.

## 2. Architectural Separation (Tiered Access Model)
Ayka Secure Technologies implements a strict Tiered access model enforced by AWS permission boundaries and Entra ID RBAC.

| Tier Level | Role Definition | Access Scope | Data Access (PII) |
| :--- | :--- | :--- | :--- |
| **Tier 0** | Cloud Platform Admins | AWS Management Account, Core Network, Identity | **NONE.** Prevented by SCPs and Permission Boundaries. |
| **Tier 1** | Security Operations | Security Account, GuardDuty, CloudTrail, SIEM | **READ-ONLY.** Can view logs but cannot modify infrastructure. |
| **Tier 2** | Workload Operators / Devs | Application Accounts (Dev/Staging/Prod) | Restricted by environment. Prod access requires justification. |

## 3. Environment Segregation (Dev vs. Prod)
Production environments containing live personal data are physically and logically isolated from development environments.

* **No Standing Access to Prod:** Tier 2 developers possess permanent access to Sandbox and Development environments. They **do not** have standing access to Production PII.
* **Just-in-Time (JIT) Escalation:** If a developer requires production access for troubleshooting, they must request time-bound, JIT access via Entra ID PIM (Privileged Identity Management), requiring approval from a designated Data Owner or Engineering Manager.

## 4. Pipeline Segregation
Infrastructure and application code cannot be deployed unilaterally.

* **Peer Review Mandate:** All Terraform changes (`Internal-IT/cloud-platform`) require a minimum of one approved Pull Request from a peer before the CI/CD pipeline executes the deployment.
* **Compliance Gating:** The pipeline automatically runs Open Policy Agent (OPA) / Checkov scans. If a commit violates security baseline controls (e.g., creating an unencrypted S3 bucket), the pipeline fails and blocks the deployment, removing human error from the compliance enforcement process.

## 5. Emergency Override (Break-Glass)
In the event of a catastrophic failure requiring Tier 0 intervention that bypasses standard SoD, the documented **SOP-IAM-001 (Break-Glass Procedure)** is invoked. This action guarantees high-severity automated alerting and mandates a post-incident compliance review.