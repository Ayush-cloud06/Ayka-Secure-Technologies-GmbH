# IAM mapping to ISO/IEC 27001:2022

| Field | Value |
|---|---|
| Document ID | ISMS-IAM-01 |
| Owner | Cloud Platform Engineering |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or identity architecture, source or control evidence change |
| Status | Draft. Not approved: no approval record exists (simulated company) |

Ayka Secure Technologies GmbH is simulated. This mapping describes source design as of 2026-10-14. Identity Terraform is under `Internal-IT/platform/domains/identity/`, outside the workload compliance gate, and never deployed as this platform. No live tenant or account evidence is supplied here.

## 1. Reading the mapping

The labels below use the 2022 control numbering: A.5.15 access control, A.5.16 identity management, A.5.17 authentication information, A.5.18 access rights. A source file establishes design intent only. The [SoA](statement-of-applicability.md) is the complete selection register; the [identity architecture](../../architecture/identity-architecture.md) records unresolved design contradictions.

## 2. Control mappings

| Annex A control | Status | Source or process evidence | What remains unproven |
|---|---|---|---|
| A.5.15 — Access control | Designed | [permission sets](../../../Internal-IT/platform/domains/identity/aws-identity-center/permission-sets.tf); [account assignments](../../../Internal-IT/platform/domains/identity/aws-identity-center/assignments.tf); [access policy](../../policies/access-control-policy.md) | Role approval, account scoping and effective authorization; all three assignment blocks target management_account_id |
| A.5.16 — Identity management | Designed | [personnel fixture](../../../Internal-IT/platform/domains/identity/entra-id/modules/core/personnel.json); [users](../../../Internal-IT/platform/domains/identity/entra-id/modules/core/users.tf); [memberships](../../../Internal-IT/platform/domains/identity/aws-identity-center/memberships.tf); [lifecycle procedure](../01-organization/onboarding-and-offboarding-procedure.md) | Actual authoritative personnel data, SAML/SCIM configuration, consistent usernames and tested joiner/mover/leaver handling; fixture is not employment evidence |
| A.5.17 — Authentication information | Designed | [bootstrap passwords](../../../Internal-IT/platform/domains/identity/entra-id/modules/core/passwords.tf); [admin passwords](../../../Internal-IT/platform/domains/identity/entra-id/modules/privileged/passwords.tf); [manual emergency account lookup](../../../Internal-IT/platform/domains/identity/entra-id/modules/privileged/break_glass.tf); [access policy](../../policies/access-control-policy.md) | Historical credential investigation and rotation, state custody and secure credential delivery; random generation does not close RISK-001 |
| A.5.18 — Access rights | Designed | [group membership source](../../../Internal-IT/platform/domains/identity/aws-identity-center/memberships.tf); [access review procedure](../06-operational-procedures/access-review-procedure.md) | Approval, timely revocation, membership reconciliation and periodic access-review records |
| A.8.2 — Privileged access rights | Designed | [role justifications](privileged-access-justification.md); [emergency role](../../../Internal-IT/platform/domains/identity/aws-iam-core/break-glass-role.tf); [boundaries](../../../Internal-IT/platform/domains/identity/aws-iam-core/permissions-boundaries.tf) | Approved scopes, usable restricted permissions, independent emergency recovery, session evidence and monitoring |
| A.8.3 — Information access restriction | Designed | [ABAC policies](../../../Internal-IT/platform/domains/identity/aws-iam-core/abac-custom-policies.tf); [policy attachments](../../../Internal-IT/platform/domains/identity/aws-iam-core/cross-account-roles.tf); [attributes](../../../Internal-IT/platform/domains/identity/aws-identity-center/session-controls.tf) | Department and Environment attributes are not mapped there; conditional Allow is not an overriding restriction; effective permissions need positive/negative tests |
| A.8.4 — Access to source code | Partial | [CODEOWNERS](../../../.github/CODEOWNERS); [workflow](../../../.github/workflows/terraform-workflow.yml); [dated ruleset observation](../03-risk-management/risk-register.md) | Required checks and the recorded ruleset provide limited repository evidence; no independent second maintainer or complete collaborator-access review is established |
| A.8.5 — Secure authentication | Designed | [Conditional Access switch](../../../Internal-IT/platform/domains/identity/entra-id/variables.tf); [Tier0 MFA design](../../../Internal-IT/platform/domains/identity/entra-id/modules/security/conditional_access/ca-tier0-mfa.tf); [legacy-auth design](../../../Internal-IT/platform/domains/identity/entra-id/modules/security/conditional_access/ca-block-legacy-auth.tf) | Conditional Access defaults off; actual licence, tenant settings, MFA challenge, recovery and bypass behavior remain to verify |

## 3. Gate evidence boundary

The [gate metadata](../../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml) maps IAM pattern checks such as `IAM_WILDCARD_POLICY`, `IAM_INLINE_POLICY_USAGE`, `IAM_USER_PROHIBITED` and `IAM_USER_MFA_MISSING`. Those checks run against the gated workload, not these platform identity roots. In particular, an IAM-user MFA finding means Terraform cannot prove MFA; it is not a real sign-in test. No absence of a workload finding establishes platform identity compliance.

Use the [access evidence index](access-control-evidence-index.md) for actual run/source references and the [gap analysis](control-gap-analysis.md) for treatment tracking. Retain plan evidence as design evidence until actual configuration and behavior are independently verified.

## 4. Review and correction

Cloud Platform Engineering maintains paths and source facts; CISO reviews control selection and evidence strength. Before any operational claim, reconcile legacy documents with current source, approve roles, verify actual provider/tenant configuration and test lifecycle, permission and emergency paths. Do not inherit the legacy boundary document's claims that federation and SCIM are operational without fresh evidence.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | Correct paths and 2022 control labels; distinguish design from operating evidence |
