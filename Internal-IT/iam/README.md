# IAM Architecture — Ayka Secure Technologies GmbH

This directory implements the **full identity and access management architecture** of the simulated enterprise environment.

It models how a real company manages:

* workforce identities
* federated login
* role-based access control
* cloud permissions
* privilege escalation protection
* cross-account security access

The system is designed so that **identity, authentication, authorization, and infrastructure permissions are separated into clean layers**.

---

# High-Level Identity Flow

The identity model follows a **multi-layer architecture** similar to enterprise cloud platforms.

```
HR Dataset (personnel.json)
        ↓
Microsoft Entra ID (Identity Provider)
        ↓
SCIM Provisioning
        ↓
AWS Identity Center Users
        ↓
Tier Groups
        ↓
Permission Sets
        ↓
sts:AssumeRole
        ↓
IAM Roles (aws-iam-core)
        ↓
Custom Policies + Permission Boundaries
        ↓
AWS Resources
```

This layered model ensures:

* **identity lifecycle management**
* **RBAC enforcement**
* **least-privilege permissions**
* **controlled privilege escalation**
* **multi-account security**

---

# Repository Structure

```
iam/
│
├── README.md
│
├── bootstrap/
│   └── remote-state/
│
├── entra-id/
│
├── aws-identity-center/
│
├── aws-iam-core/
│
├── futureplan.md
├── plan.md
└── tree.md
```

Each directory represents a **separate identity layer**.

---

# Identity Layers Explained

## 1. Identity Source (Entra ID)

Directory:

```
iam/entra-id/
```

Purpose:

* Identity provider for the organization
* User lifecycle management
* Group-based role modeling
* Federation into AWS

### HR Source of Truth

```
entra-id/modules/core/personnel.json
```

This file acts as the **HR dataset**.

Example record:

```
EMP-003
  Name: Lukas Weber
  Department: Engineering
  Security Role: Privileged Administrator
  Tier: tier1
```

Attributes define:

* department
* security role
* privilege tier
* manager relationships

Terraform converts these into identity objects.

---

### User Creation

File:

```
entra-id/modules/core/users.tf
```

Creates Entra users using:

```
resource "azuread_user"
```

Users are automatically mapped to:

* department groups
* security role groups
* privilege tier groups

---

### Group Architecture

Defined in:

```
group_roles.tf
groups_departments.tf
groups_tiers.tf
```

Group examples:

```
grp-tier-tier0
grp-tier-tier1
grp-tier-tier2

grp-dept-engineering
grp-dept-security
grp-dept-finance

grp-sec-risk-analyst
grp-sec-incident-handler
```

This structure enables **RBAC modeling at the identity layer**.

---

### Conditional Access

Directory:

```
entra-id/modules/security/conditional_access
```

Implements security controls such as:

```
Block legacy authentication
Require MFA for Tier0
```

These policies protect the identity layer before AWS access even begins.

---

# 2. Federation and SCIM Provisioning

File:

```
entra-id/aws_enterprise_app.tf
```

This configures the **AWS enterprise application** inside Entra ID.

Responsibilities:

* federation setup
* SAML authentication
* SCIM user provisioning

Identity flow becomes:

```
Entra User
    ↓
SCIM
    ↓
AWS Identity Center User
```

AWS Identity Center becomes a **consumer of identities**, not the source.

---

# 3. AWS Identity Center Layer

Directory:

```
aws-identity-center/
```

This layer controls:

* login sessions
* permission sets
* group access
* AWS account assignments

Identity Center does **not define real permissions**.

It only defines **which roles a user may assume**.

---

## Identity Center Groups

Defined in:

```
groups.tf
```

Groups mirror the **tier model**:

```
Tier0
Tier1
Tier2
```

Users are added through:

```
memberships.tf
```

This keeps AWS aligned with Entra identity groups.

---

## Permission Sets

File:

```
permission-sets.tf
```

Permission sets represent **access tiers**, not raw permissions.

Examples:

```
Platform-Admin
Tier1-Ops
Tier2-Workload
```

In this architecture permission sets **do not contain service permissions**.

Instead they grant:

```
sts:AssumeRole
```

Example:

```
Tier1 Permission Set
    ↓
Allow AssumeRole → PlatformOperationsRole
```

This design follows the **enterprise IAM pattern**.

---

## Account Assignments

File:

```
assignments.tf
```

Defines which group receives which permission set in which account.

Example model:

```
Tier0 → Platform-Admin → Management Account
Tier1 → Tier1-Ops → Workload Accounts
Tier2 → Tier2-Workload → Application Accounts
```

---

# 4. IAM Core (Real Permission Layer)

Directory:

```
aws-iam-core/
```

This layer defines **actual AWS privileges**.

Identity Center only grants **permission to assume these roles**.

---

## Trust Policies

File:

```
trust-policies.tf
```

Defines **who is allowed to assume roles**.

Examples:

```
Identity Center sessions
Security account
Management account
```

Example trust model:

```
SSO Session
    ↓
AssumeRole
    ↓
PlatformOperationsRole
```

---

## Break Glass Role

File:

```
break-glass-role.tf
```

Purpose:

Emergency administrative access.

Used when:

* SSO fails
* identity provider compromised
* disaster recovery operations required

Security controls include:

```
MFA requirement
short session duration
CloudTrail monitoring
```

---

## Custom Policy Library

File:

```
custom-policies.tf
```

Defines reusable permission policies.

Examples:

```
PlatformEngineerPolicy
WorkloadOperatorPolicy
SecurityAuditExtended
```

These policies replace overly broad AWS managed policies.

---

## Permission Boundaries

File:

```
permissions-boundaries.tf
```

Implements **privilege escalation protection**.

Prevents roles from performing dangerous IAM actions such as:

```
CreatePolicyVersion
AttachUserPolicy
PutRolePolicy
organizations:*
```

Effective permission becomes:

```
Role Policy
    ∩
Permission Boundary
```

This ensures developers cannot escalate privileges even if misconfigured policies are attached.

---

## Cross Account Roles

File:

```
cross-account-roles.tf
```

These roles allow **other AWS accounts to access this account**.

Example:

```
Security Account
    ↓
AssumeRole
    ↓
SecurityAuditRole
```

Used for:

```
centralized security monitoring
incident response
compliance auditing
```

---

# Example Login Flow

Example user:

```
Lukas Weber
Tier: Tier1
Department: Engineering
Role: Platform Engineer
```

Full login path:

```
Lukas Weber
    ↓
Entra ID authentication
    ↓
AWS Identity Center
    ↓
Tier1-Ops Permission Set
    ↓
sts:AssumeRole
    ↓
PlatformOperationsRole
    ↓
PlatformEngineerPolicy
    ↓
Access AWS resources
```

---

# Security Controls in the System

This architecture provides multiple security layers.

```
Identity provider MFA
SCIM lifecycle automation
RBAC group model
Permission sets
IAM roles
Custom policies
Permission boundaries
Cross account isolation
```

These controls ensure that **compromise of a single identity cannot destroy the platform**.

---

# Design Principles

The architecture follows several principles.

### Separation of Concerns

```
Identity Provider → who you are
Identity Center → what tier you belong to
IAM Roles → what actions are possible
Policies → exact permissions
```

---

### Least Privilege

Roles only receive permissions required for their function.

Overly broad AWS managed policies are avoided.

---

### Defense in Depth

Multiple layers protect the environment:

```
identity controls
session controls
role permissions
permission boundaries
cross account isolation
```

---

# Key Takeaway

This IAM system models a realistic enterprise cloud environment.

It demonstrates how identity flows from **HR data → identity provider → cloud access → infrastructure permissions** while maintaining strict governance and security boundaries.

```
Identity Center grants access to roles.
Roles contain permissions.
Policies define actions.
Boundaries limit privilege escalation.
```
