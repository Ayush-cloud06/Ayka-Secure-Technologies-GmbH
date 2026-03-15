# Technical and Organizational Measures (TOMs): Identity & Access

**Organization:** Ayka Secure Technologies GmbH  
**Framework:** GDPR (Art. 25 Data Protection by Design, Art. 32 Security of Processing)  
**System Scope:** Cloud Infrastructure (Entra ID & AWS)  
**Last Updated:** 2026-03-15  

---

## 1. Objective
To outline the specific Technical and Organizational Measures (TOMs) implemented by Ayka Secure Technologies to ensure the confidentiality, integrity, and availability of personal data through strict access control mechanisms.

## 2. Authentication Measures
Ayka enforces a zero-trust authentication perimeter before any user can interact with cloud resources.

* **Centralized Identity Provider (IdP):** All cloud access is federated through Microsoft Entra ID. No local IAM users are permitted in AWS.
* **Phishing-Resistant MFA:** Hardware-based FIDO2 tokens or Microsoft Authenticator are strictly enforced via Entra ID Conditional Access policies for all access. 
* **Legacy Protocol Blocking:** Legacy authentication methods (e.g., IMAP, POP3) that cannot process MFA are technically blocked at the tenant level.
* **Session Risk Evaluation:** Entra ID Identity Protection evaluates sign-in risk in real-time. High-risk sessions (e.g., impossible travel, leaked credentials) are automatically blocked.

## 3. Authorization Measures
Once authenticated, access to systems processing personal data is strictly minimized.

* **Attribute-Based Access Control (ABAC):** AWS permissions are dynamically granted based on tagging. A user with the `Department = Engineering` attribute in Entra ID can only interact with AWS resources tagged `Owner = Engineering`. This physically prevents cross-department data exposure.
* **Default Deny:** All network and IAM policies default to implicit deny. Access must be explicitly granted via version-controlled Infrastructure-as-Code (Terraform).
* **Automated Provisioning/Deprovisioning (SCIM):** User lifecycle is automated. When HR terminates an employee in the core system, Entra ID immediately revokes AWS Identity Center sessions, ensuring zero lingering access.

## 4. Evidence & Traceability
To demonstrate compliance with Art. 5(2) (Accountability), the following technical evidence can be provided upon request:
* Entra ID Conditional Access configuration states.
* Terraform state files verifying ABAC policy deployment (`aws-iam-core/abac-custom-policies.tf`).
* SCIM provisioning logs demonstrating automated offboarding within SLAs.