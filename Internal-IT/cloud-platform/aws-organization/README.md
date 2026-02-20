# AWS Organization Layer

This layer defines the root AWS Organization for Ayka Secure Technologies GmbH.

Scope:
- Creates AWS Organization
- Enables ALL features
- Exposes Root ID for downstream OU structure

This layer does NOT:
- Create OUs
- Create accounts
- Attach SCPs
- Configure security services

It represents the legal and structural root of the enterprise cloud environment.