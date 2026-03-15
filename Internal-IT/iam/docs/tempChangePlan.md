# Temporary Identity Architecture Change Plan

## Context

During implementation of Microsoft Entra ID (External IdP) federation with AWS IAM Identity Center, the original architectural intent was:

- Entra ID → Authoritative identity provider
- SCIM → Synchronize users and groups
- AWS Identity Center → Authorization layer
- Terraform → Manage permission sets and assignments

However, group-based SCIM provisioning in Microsoft Entra requires Entra ID P1/P2 licensing.

The current tenant operates on the Free plan, which does not support assigning groups to Enterprise Applications. Enabling P2 trial requires commercial billing setup (GSTIN/PAN and payment details), which is not appropriate for this lab environment.

---

## Decision

Adopt a boundary-based identity model:

### Entra ID (Authoritative for Users Only)
- SAML authentication
- MFA / Conditional Access
- SCIM user provisioning
- User lifecycle management

### AWS IAM Identity Center (Authoritative for Groups)
- Group creation and lifecycle
- Role-based access control (RBAC)
- Account assignments
- ABAC configuration

### Terraform
- Permission sets
- Account assignments
- Dynamic lookup of AWS Identity Store groups
- Drift detection via plan failures

---

## Rationale

1. Avoid unnecessary commercial subscription activation.
2. Maintain clean architectural boundaries.
3. Preserve automation where licensing allows.
4. Document limitation transparently.
5. Enable future upgrade path to full SCIM group sync.

This approach reflects real-world enterprise constraints where identity domains may be split due to licensing or organizational boundaries.

---

## Known Limitation

- Entra groups are not synchronized to AWS.
- AWS groups must be manually maintained.
- Logical group structure may be mirrored in Entra for modeling/documentation purposes only.

---

## Future Improvement

When Entra ID P1/P2 licensing is available:

- Enable group-based SCIM provisioning.
- Remove manual AWS group lifecycle.
- Consolidate identity authority fully into Entra.
- Simplify Terraform assignments.

---

## Current Status

- SAML federation operational.
- SCIM user provisioning operational.
- AWS Identity Center instance active.
- Next step: create AWS groups and finalize Terraform dynamic assignments.

---

## Governance Note

This deviation is intentional and documented.  
Identity boundary is clearly defined.  
No security posture degradation has occurred.