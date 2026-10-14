# Privileged access justification

| Field | Value |
|---|---|
| Document ID | ISMS-PA-01 |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or privileged role, membership, trust or emergency access change |
| Status | Draft. Not approved: no approval record exists (simulated company) |

This simulated-company register records proposed business need and current source configuration. It grants no access. Identity and platform entries are Designed; workload service entries are Gated design. All access approvals and operational verification remain pending; no approval or access-review record exists.

## 1. Approval and review rules

Use the [access control policy](../../policies/access-control-policy.md), [user access procedure](../06-operational-procedures/user-access-procedure.md), and [access review procedure](../06-operational-procedures/access-review-procedure.md). The approver below is a required role, not a completed approval. CISO assesses scope, risk and separation of duties; the Managing Director approves privileged access. The requester must not approve their own request. The single-maintainer repository does not supply an independent approver merely by assigning two role names.

Before any grant, record the actual principal, task, target accounts/resources, permitted actions, start/end time, authentication method, requester, independent approver, evidence location and revocation plan. Review privileged access at the cadence in POL-AC-01 and after a role change, incident or emergency use. Design-session values below are not approved durations and do not prove actual session limits.

## 2. Role and account justifications

| Role / identity | Proposed business need | Current source and limitations | Responsible owner | Required approver | Approval / status |
|---|---|---|---|---|---|
| Entra privileged administrator accounts | Separate administrative work from ordinary user work | `azuread_user.admin_users` and Tier0/security-group memberships; group names are not proof of tenant administrator role grants. Bootstrap password/state handling needs RISK-001/RISK-002 review. [admin accounts](../../../Internal-IT/platform/domains/identity/entra-id/modules/privileged/admin_accounts.tf) | Cloud Platform Engineering | Managing Director, following CISO review | Pending; Designed |
| Entra emergency account | Recover tenant access when ordinary authentication is unavailable | Existing account lookup through `break_glass_upn`; membership only, no proof of its directory role, credential custody or tested sign-in. [emergency account design](../../../Internal-IT/platform/domains/identity/entra-id/modules/privileged/break_glass.tf) | CISO | Managing Director, following CISO review | Pending; Designed |
| Platform-Admin (Tier0) | Proposed route to approved emergency AWS administration | 8-hour permission set; permits `sts:AssumeRole` to `BreakGlassRole` across wildcard account IDs. Routine assignment to an emergency route requires redesign/review. [permission sets](../../../Internal-IT/platform/domains/identity/aws-identity-center/permission-sets.tf) | Cloud Platform Engineering | Managing Director, following CISO review | Pending; Designed |
| Tier1-Ops | Operate approved infrastructure and inspect security configuration | 8-hour permission set; assume-role targets include PlatformOperationsRole and SecurityAuditRole across wildcard account IDs. All current assignment blocks target the management account. [assignments](../../../Internal-IT/platform/domains/identity/aws-identity-center/assignments.tf) | Cloud Platform Engineering | Managing Director, following CISO review | Pending; Designed |
| Tier2-Workload | Perform scoped application operations | 8-hour permission set targeting WorkloadOperatorRole across wildcard account IDs; no evidence of approved team-to-account restrictions. [permission sets](../../../Internal-IT/platform/domains/identity/aws-identity-center/permission-sets.tf) | Product & Engineering | Managing Director, following CISO review | Pending; Designed |
| Restricted-Admin | Proposed shorter administrative session | 1-hour permission set exists without an assignment or policy attachment in this root; it does not shorten the other permission sets. [session design](../../../Internal-IT/platform/domains/identity/aws-identity-center/session-controls.tf) | Cloud Platform Engineering | Managing Director, following CISO review | Pending; Designed |
| PlatformOperationsRole | Manage approved platform resources | 1-hour role; broad EC2, RDS, S3, load balancing, scaling and logging permissions. Attached boundary has no Allow statements; trust and effective access unresolved. [roles](../../../Internal-IT/platform/domains/identity/aws-iam-core/cross-account-roles.tf); [policies](../../../Internal-IT/platform/domains/identity/aws-iam-core/custom-policies.tf) | Cloud Platform Engineering | Managing Director, following CISO review | Pending; Designed |
| WorkloadOperatorRole | Start, stop and inspect workloads and access approved application objects | 1-hour role; object actions currently use resource `*`. ABAC and boundary composition do not establish department isolation. [roles](../../../Internal-IT/platform/domains/identity/aws-iam-core/cross-account-roles.tf); [policies](../../../Internal-IT/platform/domains/identity/aws-iam-core/custom-policies.tf) | Product & Engineering | Managing Director, following CISO review | Pending; Designed |
| SecurityAuditRole | Read configuration and investigate security posture | 1-hour role; trusts security-account root in source. `guardduty:*`, `config:*`, `securityhub:*` exceed a read-only purpose; narrow actions before approval. [policies](../../../Internal-IT/platform/domains/identity/aws-iam-core/custom-policies.tf); [trust](../../../Internal-IT/platform/domains/identity/aws-iam-core/trust-policies.tf) | Security Operations | Managing Director, following CISO review | Pending; Designed |
| BreakGlassRole | Time-limited emergency recovery when normal access is unavailable | 1-hour role with AdministratorAccess and management-account-root trust subject to MFA context condition. Independent recovery path, MFA compatibility and alerts are untested. [role](../../../Internal-IT/platform/domains/identity/aws-iam-core/break-glass-role.tf); [trust](../../../Internal-IT/platform/domains/identity/aws-iam-core/trust-policies.tf) | CISO | Managing Director, following CISO review | Pending; Designed |
| aws-admin-role | Proposed landing-zone administration | AdministratorAccess attachment and same-account-root trust in [core roles](../../../Internal-IT/platform/foundation/landing-zone/modules/core/iam/roles.tf). Reconcile with the identity-domain roles; no approved principal list or MFA condition in this trust. | Cloud Platform Engineering | Managing Director, following CISO review | Pending; Designed |
| aws-security-role | Inspect landing-zone security | SecurityAudit managed-policy attachment and inherited admin-role trust in [core roles](../../../Internal-IT/platform/foundation/landing-zone/modules/core/iam/roles.tf). Verify current managed-policy actions and actual source principals before approval. | Security Operations | Managing Director, following CISO review | Pending; Designed |
| aws-automation-role | Proposed infrastructure automation | PowerUserAccess attachment, permission boundary and EC2 service trust in [core roles](../../../Internal-IT/platform/foundation/landing-zone/modules/core/iam/roles.tf). This is not evidence of a GitHub runner identity or reviewed automation scope. | Cloud Platform Engineering | Managing Director, following CISO review | Pending; Designed |
| emergency-break-glass-role | Recover landing-zone accounts | AdministratorAccess and a variable trusted principal with an MFA condition in [landing-zone emergency role](../../../Internal-IT/platform/foundation/landing-zone/modules/break_glass/main.tf). Distinct from BreakGlassRole; approve one coherent recovery design and test each retained path. | CISO | Managing Director, following CISO review | Pending; Designed |
| siem-firehose-delivery-role | Deliver security events to approved storage | Firehose service trust in [SIEM module](../../../Internal-IT/platform/foundation/landing-zone/modules/siem/main.tf); no delivery-permission policy attached in that module. Delivery authorization and confidentiality remain unproven. | Security Operations | Managing Director, following CISO review | Pending; Designed |

### 2.1 Workload service identities

These service roles are Gated design, pending CISO review and Managing Director approval of scope. They are included to avoid overlooking non-human access; service trust alone does not prove narrow effective permissions. Names use the workload `name_prefix`; do not assume these are live account identifiers.

| Source role | Proposed need | Source / limit | Owner | Required approver / status |
|---|---|---|---|---|
| ecs_execution | Fetch container images and send task logs | [Security module](../../../Internal-IT/workloads/ayka-portal/modules/security/main.tf); ECS service trust and AmazonECSTaskExecutionRolePolicy attachment; review current provider-managed permissions | Cloud Platform Engineering | Managing Director after CISO review; pending, Gated design |
| ecs_task | Proposed application AWS API access | [Security module](../../../Internal-IT/workloads/ayka-portal/modules/security/main.tf); ECS service trust, no attached application policy in this module; do not infer application data access | Product & Engineering | Managing Director after CISO review; pending, Gated design |
| ec2 | Proposed instance AWS API access | [Security module](../../../Internal-IT/workloads/ayka-portal/modules/security/main.tf); EC2 service trust and instance profile, no attached permissions in this module | Cloud Platform Engineering | Managing Director after CISO review; pending, Gated design |
| rds_monitoring | Publish database monitoring data | [Database module](../../../Internal-IT/workloads/ayka-portal/modules/database/main.tf); monitoring service trust and AmazonRDSEnhancedMonitoringRole attachment; live delivery unverified | Security Operations | Managing Director after CISO review; pending, Gated design |
| flow_logs | Write VPC flow records | [Networking module](../../../Internal-IT/workloads/ayka-portal/modules/networking/main.tf); log-write actions scoped to the defined log group; actual trust and delivery untested | Security Operations | Managing Director after CISO review; pending, Gated design |

Repository administrator, CI secret custodian and any future Terraform execution identity also require a scoped approval before operational use. Current Terraform role inventory is not a complete inventory of external privileged access; verify GitHub and tenant administrators separately. No AWS root or provider administrator entitlement is granted by this register.

## 3. Conditions before approval

1. Resolve the trust, boundary, ABAC and account-assignment gaps in the [identity architecture](../../architecture/identity-architecture.md); test permitted and denied actions against the exact proposed roles.
2. Replace broad action/resource patterns with approved scope or document an expiring exception with justification. Confirm separate audit duties and emergency-use restrictions.
3. Prove authentication for each normal and emergency path. Conditional Access defaults off in source. Do not equate a group membership, MFA condition or unassigned permission set with effective protection.
4. Establish an independent emergency path, credential custody, notification and revocation; exercise it under authorization. The [legacy emergency procedure](../../../Internal-IT/platform/domains/identity/docs/break-glass-procedure.md) describes safes, hardware keys and automatic paging that have no current evidence; treat those as unverified requirements, not available safeguards.
5. Complete actual access approval and review records. Track unresolved work under G02 in the [gap analysis](control-gap-analysis.md) and RISK-001, RISK-003, RISK-004 and RISK-013 in the [risk register](../03-risk-management/risk-register.md).

## 4. Grant and review records

No entries yet: no actual grant, approval or completed review is evidenced by this design review. Record real decisions only when they occur, in a restricted location linked from the [access evidence index](access-control-evidence-index.md). Do not store credentials or sensitive principal lists in this public register.

Required record fields: request ID, role, principal reference, scope, business justification, reviewer/approver, decision timestamp, expiry, implementation evidence, authentication check, last review, next review, and revocation evidence. A declined or expired request must remain traceable without suggesting that access was granted.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
