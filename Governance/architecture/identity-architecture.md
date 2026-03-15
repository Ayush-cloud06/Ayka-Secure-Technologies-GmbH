# Identity Architecture

## Tiers

- **Tier 0 – Security Administration**
- **Tier 1 – Infrastructure Operators**
- **Tier 2 – Developers**

## User Lifecycle

```mermaid
flowchart TD
    A[personnel.json] --> B[Entra ID users]
    B --> C[SCIM]
    C --> D[AWS Identity Center users]
    D --> E[Tier groups]
    E --> F[Permission sets]
    F --> G[sts:AssumeRole]
    G --> H[IAM roles]
    H --> I[Custom IAM policies]
    I --> J[AWS resources]
```

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