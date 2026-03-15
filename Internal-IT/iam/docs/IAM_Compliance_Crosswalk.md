# IAM Compliance Mapping Crosswalk

**Organization:** Ayka Secure Technologies GmbH  
**Location:** Stuttgart, Germany  
**System Layer:** Identity & Access Management (Entra ID + AWS Identity Center)  
**Last Updated:** 2026-03-15  
**Owner:** Cloud Platform Engineering / Compliance  

---

## 1. Purpose
This document provides a direct traceability matrix between the Infrastructure-as-Code (Terraform) implemented in the `Internal-IT/iam/` directory and the regulatory requirements of **ISO/IEC 27001:2022** and the **EU General Data Protection Regulation (GDPR)**. 

If an auditor asks, "How do you enforce access control?", this matrix provides the exact programmatic evidence.

---

## 2. The Master Matrix: Code to Compliance

| Technical Implementation (Terraform File) | ISO 27001:2022 Control | GDPR Article | Description & Justification | Status |
| :--- | :--- | :--- | :--- | :--- |
| **`entra-id/modules/security/conditional_access/ca-tier0-mfa.tf`** | A.5.17 (Authentication info), A.8.5 (Secure authentication) | Art. 32 (Security of processing) | Enforces mandatory MFA for all Tier 0 (Admin) access before AWS federation can even occur. | Implemented |
| **`aws-identity-center/assignments.tf`** | A.5.15 (Access control), A.5.18 (Access rights) | Art. 25 (Data protection by design) | Grants AWS permissions via strictly defined RBAC Tier groups rather than direct user attachments. | Implemented |
| **`aws-iam-core/permissions-boundaries.tf`** | A.8.2 (Privileged access rights) | Art. 32 (Security of processing) | Hard boundary preventing privilege escalation. Even if a role is compromised, it cannot modify IAM or Org levels. | Implemented |
| **`aws-iam-core/break-glass-role.tf`** | A.5.15 (Access control), A.8.5 (Secure authentication) | Art. 32 (Security of processing) | Emergency access protocol. Requires manual MFA condition in the trust policy (`aws:MultiFactorAuthPresent == true`). | Implemented |
| **`aws-iam-core/abac-mandatory-tagging.tf`** | A.8.3 (Information access restriction) | Art. 25 (Data protection by design) | Denies resource creation if `Department`, `Environment`, or `Owner` tags are missing, enforcing the ABAC foundation. | Implemented |
| **`aws-iam-core/abac-custom-policies.tf`** | A.5.15 (Access control), A.8.3 (Information access restriction) | Art. 32 (Security of processing) | Evaluates `PrincipalTag/Department` against `ResourceTag/Department`. Prevents cross-department data tampering (e.g., Eng cannot delete Finance buckets). | Implemented |
| **`entra-id/modules/core/personnel.json`** | A.5.16 (Identity management), A.6.2 (Terms of employment) | Art. 30 (Records of processing) | Single source of truth for HR-to-IT identity provisioning. Maps directly to SCIM and ABAC attributes. | Implemented |

---

## 3. Segregation of Duties (SoD) & Least Privilege
**Reference: ISO 27001 A.5.3 (Segregation of duties)**

Our IAM architecture physically enforces SoD via the Tier system:
* **Tier 0 (Platform Admins):** Can manage infrastructure but are prevented by permission boundaries from accessing customer workload data.
* **Tier 2 (Workload Operators):** Can deploy application code and touch customer environments but cannot modify IAM policies, CloudTrail logging, or VPC routing.
* **Identity vs. Authorization:** Microsoft Entra ID controls *who* the user is (Authentication), while AWS Identity Center controls *what* they can do (Authorization). 

---

## 4. Evidence Generation Guide
During an audit, the following artifacts will be generated to prove the effectiveness of these controls:

1. **State Snapshots:** `terraform show -json` proving the active state of ABAC policies.
2. **Entra ID Logs:** Export of Conditional Access sign-in logs showing MFA enforcement blocks.
3. **CloudTrail Asserts:** Logs querying `sts:AssumeRole` events proving the `BreakGlassRole` is only accessed with MFA present.
4. **Access Reviews:** Export of the `personnel.json` matrix mapped against active Identity Store group memberships.