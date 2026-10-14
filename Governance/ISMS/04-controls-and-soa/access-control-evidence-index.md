# Access control evidence index

| Field | Value |
|---|---|
| Document ID | ISMS-04-06 |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or when scope, source configuration or evidence changes |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company. The CI gate operates on plans; the infrastructure has never been deployed.

## 1. Scope

A.5.15–A.5.18 and A.8.2–A.8.5 span governance, provisioning, authentication and review. Plan scanners prove only a limited set of static checks. The [generated IAM extract](../07-technical-evidence/iam-plan-extract.md) lists five workload roles, three managed-policy attachments and one instance profile. No IAM users or Identity Center resources occur in this workload plan; that is not an organization-wide inventory.

## 2. Evidence chain

| Topic | Evidence | What can be concluded | Missing proof |
|---|---|---|---|
| IAM user prohibition / MFA checks | `IAM_USER_PROHIBITED`, `IAM_USER_MFA_MISSING` in [mapping](../../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml); [IAM rules](../../../Internal-IT/engineering/policy-as-code/OPA/terraform/aws_iam.rego) | Implemented plan rules; no IAM users in the sampled plan | Tenant authentication exports and actual MFA behavior; a no-user plan does not exercise MFA |
| Wildcard and inline policies | `IAM_WILDCARD_POLICY`, `IAM_INLINE_POLICY_USAGE`; [control evidence index](../07-technical-evidence/control-evidence-index.md) | Implemented limited checks; OPA cannot inspect JSON unknown at plan time | Effective permission simulation; list-form/unknown-policy limitations must be considered |
| Workload service roles | [IAM extract](../07-technical-evidence/iam-plan-extract.md) and [security module](../../../Internal-IT/workloads/ayka-portal/modules/security/main.tf) | Gated design and planned attachments | Applied trust, resource policies, permission boundaries and representative allow/deny tests |
| Entra and Identity Center | [Identity mapping](iam-iso27001-mapping.md) and [architecture](../../architecture/identity-architecture.md) | Designed only, not present in sampled plan | Live identity inventory, reconciled assignments, SAML/SCIM tests and session evidence |
| Privileged and emergency access | [Justification](privileged-access-justification.md) and [access policy](../../policies/access-control-policy.md) | Proposed need and restrictions | Named authorizations, time-bounded elevation, emergency exercise and post-use review |
| Joiner, mover, leaver and access review | [User access](../06-operational-procedures/user-access-procedure.md), [review procedure](../06-operational-procedures/access-review-procedure.md), [onboarding/offboarding](../01-organization/onboarding-and-offboarding-procedure.md) | Designed procedures | Dated requests, approvals, revocation timestamps and reviewer outcomes; no entries exist |

The sampled evidence is [run 37498007502](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/37498007502), commit `500a26312cff5b35ce70a796c3084a26897fa9ad`, `compliance-evidence`. Its absence of reported IAM findings is not evidence that every identity control passed. See [retrieval and limitations](../07-technical-evidence/control-evidence-index.md).

## 3. Evidence acceptance

CISO would accept a runtime record only if it identifies the scope, actual account/tenant, time, authorizing role, tested entitlement, expected and observed result, reviewer and remediation reference. Store sensitive identity exports outside this public repository; link a restricted record identifier and sanitized result. No signed access reviews, operational authentication exports or emergency-use records are created by this index.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
