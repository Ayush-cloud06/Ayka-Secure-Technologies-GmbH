# Identity Architecture

## Tiers

- **Tier 0 – Security Administration**
- **Tier 1 – Infrastructure Operators**
- **Tier 2 – Developers**

## High-Level Identity Flow

The identity model follows a **multi-layer architecture** similar to enterprise cloud platforms.

```mermaid
flowchart TD
    subgraph Identity_Source [IdP & Provisioning]
        A[HR Dataset: personnel.json] --> B[Microsoft Entra ID]
        B --> C{SCIM Sync}
    end

    subgraph AWS_Identity_Center [Authorization Layer]
        C --> D[Users & Tier Groups]
        D --> E[Permission Set Assignments]
    end

    subgraph AWS_Account_Execution [Technical Enforcement]
        E --> F[sts:AssumeRoleWithSAML]
        F --> G[IAM Role: Session]
        G --> H[Permission Boundary: Hard Limit]
        H --> I[ABAC Policy: Tag Match]
    end

    subgraph Resource_Layer [Data Plane]
        I --> J{Resource Tag Evaluation}
        J -->|Match| K[Access Granted]
        J -->|Mismatch| L[Access Denied]
    end

    %% Documentation Links
    style A fill:#f9f,stroke:#333,stroke-width:2px
    style G fill:#bbf,stroke:#333,stroke-width:2px
    style I fill:#dfd,stroke:#333,stroke-width:2px
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