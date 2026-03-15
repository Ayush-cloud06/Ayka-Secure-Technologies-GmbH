# Identity Architecture

## Tiers

- **Tier 0 – Security Administration**
- **Tier 1 – Infrastructure Operators**
- **Tier 2 – Developers**

## High-Level Identity Flow

The identity model follows a **multi-layer architecture** similar to enterprise cloud platforms.

```mermaid
flowchart TD
    A[HR Dataset (personnel.json)] --> B[Microsoft Entra ID (Identity Provider)]
    B --> C[SCIM Provisioning]
    C --> D[AWS Identity Center Users]
    D --> E[Tier Groups (RBAC)]
    E --> F[Permission Sets]
    F --> G[sts:AssumeRole]
    G --> H[IAM Roles (aws-iam-core)]
    H --> I[ABAC Policies + Permission Boundaries]
    I --> J[Resource Tag Evaluation]
    J --> K[AWS Resources]
```

This layered model ensures:

- **Identity lifecycle management**
- **RBAC enforcement**
- **ABAC resource isolation**
- **Least-privilege permissions**
- **Controlled privilege escalation**
- **Multi-account security**

## Components

```
entra-id/
   ├── identity provider
   ├── HR source
   └── user lifecycle

aws-identity-center/
   ├── login layer
   ├── permission sets
   └── group mapping

aws-iam-core/
   ├── real permissions
   ├── IAM roles
   ├── boundaries
   └── policies
```