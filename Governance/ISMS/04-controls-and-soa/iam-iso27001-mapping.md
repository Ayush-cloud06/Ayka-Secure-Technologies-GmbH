# IAM Control Mapping

This document maps the IAM architecture implementation to ISO 27001 controls.

---

## A.5.15 Identity Management

**Control Objective**

Ensure identities are uniquely identifiable and managed securely.

**Implementation**

- Identity source:

  `Internal-IT/iam/entra-id/modules/core/personnel.json`

- User provisioning:

  `Internal-IT/iam/entra-id/modules/core/users.tf`

- Controls implemented:

  - Centralized identity provider (Microsoft Entra ID)
  - SCIM provisioning to AWS Identity Center
  - HR dataset acts as identity source of truth
  - Unique employee IDs enforced (EMP-XXX)

**Evidence**

- `personnel.json`
- `users.tf`
- `SCIM configuration`

---

## A.5.16 Authentication Information

**Control Objective**

Ensure authentication mechanisms are secure.

**Implementation**

- Conditional Access Policies:

  `Internal-IT/iam/entra-id/modules/security/conditional_access`

- Security measures:

  - MFA required for Tier0
  - Legacy authentication blocked
  - Identity federation via SAML

**Evidence**

- `ca-tier0-mfa.tf`
- `ca-block-legacy-auth.tf`

---

## A.5.17 Access Rights

**Control Objective**

Access must be assigned based on least privilege.

**Implementation**

- RBAC model implemented via:

  - AWS Identity Center groups:

    `Internal-IT/iam/aws-identity-center/groups.tf`

  - Permission sets:

    `Internal-IT/iam/aws-identity-center/permission-sets.tf`

  - Tier model:

    - `Tier0`
    - `Tier1`
    - `Tier2`

**Evidence**

- `permission-sets.tf`
- `assignments.tf`
- `memberships.tf`

---

## A.5.18 Access Provisioning

**Control Objective**

Ensure access provisioning follows defined procedures.

**Implementation**

- Provisioning workflow:

  `HR -> Entra ID -> SCIM -> AWS Identity Center -> IAM Roles`

Automation implemented using Terraform.

**Evidence**

- `identity-provisioning-workflow.md`
- `personnel.json`

---

## A.8.2 Privileged Access Management

**Control Objective**

Privileged access must be restricted and monitored.

**Implementation**

- Privileged access controls:

  - Tier0 administrative roles
  - Break-glass emergency role
  - Permission boundaries preventing privilege escalation

**Evidence**

- `aws-iam-core/break-glass-role.tf`
- `aws-iam-core/permissions-boundaries.tf`

---

## A.8.3 Information Access Restriction

**Control Objective**

Access must be restricted to authorized resources.

**Implementation**

- ABAC enforcement:

  Department based resource isolation.

- Policies:

  `aws-iam-core/abac-custom-policies.tf`

- Example:

  `User Department = Engineering`  
  `ResourceTag Department = Engineering`

  Access granted.

  Otherwise denied.

**Evidence**

`ABACDepartmentIsolation policy`

---

## A.8.4 Access to Source Code

**Control Objective**

Source code access must be restricted.

**Implementation**

- Access to Terraform infrastructure controlled via:

  GitHub repository access model.

- Future enforcement:

  CI/CD pipeline with policy-as-code validation.

**Evidence**

`Internal-IT/policy-as-code`
