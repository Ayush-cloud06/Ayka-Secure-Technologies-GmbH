# User access procedure

| Field | Value |
|---|---|
| Document ID | ISMS-OPS-01 |
| Owner | Cloud Platform Engineering |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or identity architecture or access incident |
| Status | Draft. Not approved: no approval record exists (simulated company) |

Ayka Secure Technologies GmbH is a simulated company; this document does not establish a performed activity.

## 1. Scope and operating boundary

This procedure implements [POL-AC-01](../../policies/access-control-policy.md) for workforce identities, AWS permission sets, GitHub repository access and approval environments. Identity infrastructure is **Designed**, with source in the [identity domain](../../../Internal-IT/platform/domains/identity/README.md); it has not been applied. A code change or fictional personnel entry is not evidence of an account being provisioned. Customer tenant membership requires a separate product workflow before customer onboarding.

## 2. Request and authorization

| Step | Responsible role | Required record and exit condition |
|---|---|---|
| Request | HR & Administration for joiners/movers; requesting role for temporary access | Ticket with unique identity reference, start/end time, business task, system/account, permission set, data classification and sponsoring role; do not include passwords |
| Confirm need | Receiving function owner from [roles](../../../organization/roles-and-responsibilities.md) | Confirm minimum access and existing access to remove; map technical permissions to the task |
| Approve | CISO for privileged access; relevant function owner for routine access | Dated decision by someone other than requester/recipient; escalation to Managing Director where roles overlap |
| Check prerequisites | Cloud Platform Engineering | Confirm HR authorization, NDA/training prerequisites, approved identity source, MFA capability, access expiry and safe change/recovery path |
| Implement | Cloud Platform Engineering | Reviewed change and before/after entitlement diff; no access granted before approval |
| Verify and close | Security Operations | Read-only effective-membership check, intended allow/deny test and expiry proof; requester confirms the task works without broader privileges |

One maintainer cannot supply independent approval by changing role names. Until a separate authorized reviewer exists, record the conflict and keep the access request pending. These are proposed role assignments, not evidence of staffed functions.

## 3. Technical sequence

1. Compare the approved request against Entra identity data, AWS Identity Center membership/assignment source and GitHub permissions separately. GitHub access is not proven by an Entra Terraform diff.
2. For an offline design change, edit only the authoritative source chosen for that system and use the [change procedure](change-management-procedure.md). Inspect generated password handling without exporting values or state to the ticket.
3. Before any real lifecycle operation, resolve RISK-001, RISK-003, RISK-004 and RISK-012 in the [risk register](../03-risk-management/risk-register.md): identify tenant/account ownership, reconcile SCIM and Terraform authority, validate lifecycle and permission tests, and obtain authorization for live operation. The older [provisioning workflow](../../../Internal-IT/platform/domains/identity/docs/identity-provisioning-workflow.md) contains manual creation, obsolete paths and apply instructions; it is not a validated execution runbook and must be reconciled first.
4. In an authorized future implementation, establish the identity before assigning downstream membership; confirm synchronization from actual logs rather than assuming a fixed delay. Fail closed on missing/duplicate identities, incomplete MFA, denied provisioning or unknown memberships. Preserve error evidence, remove any partial grant and escalate to CISO.
5. For movers, remove obsolete memberships within five business days of the role change; document any temporary overlap with an expiry. For leavers, follow the [offboarding procedure](../01-organization/onboarding-and-offboarding-procedure.md).
6. Record verification time, affected systems and reviewer. Remove temporary access on expiry and verify active sessions/tokens as well as group membership. A planned removal is not a completed removal.

## 4. Privileged and emergency access

Use [privileged access justification](../04-controls-and-soa/privileged-access-justification.md) for Tier 0/administrative access, including task, duration, scope, alternatives and reviewer. Emergency access follows [POL-AC-01](../../policies/access-control-policy.md) and the [break-glass design](../../../Internal-IT/platform/domains/identity/docs/break-glass-procedure.md). RISK-013 remains open: custody, authentication, alerting and a successful exercise must exist before relying on the path. Record each use and CISO review within 24 hours; suspected misuse follows the [incident response plan](../../policies/incident-response-plan.md).

## 5. Evidence and references

Keep ticket ID, system inventory, approval, commit/PR, timestamped redacted membership evidence, verification and removal/expiry confirmation in a restricted record under the [retention policy](../../policies/records-and-data-retention-policy.md). Link only sanitized evidence in this public repository. No access request or provisioning event is asserted by this document. ISO/IEC 27001:2022 A.5.15–A.5.18, A.8.2 and A.8.5.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
