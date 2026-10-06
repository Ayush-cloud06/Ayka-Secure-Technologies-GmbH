# Logical Access Control Policy

| Field | Value |
|---|---|
| Document ID | POL-AC-01 |
| Classification | Internal |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval |
| Status | Draft. Not approved |

## 1. Purpose

Access to Ayka's systems and to customer data is granted only to people who need it for their job, only for as long as they need it, and only after their identity is proven strongly. This policy sets the rules; the [identity provisioning workflow](../../../Internal-IT/platform/domains/identity/docs/identity-provisioning-workflow.md) and the [break-glass procedure](../../../Internal-IT/platform/domains/identity/docs/break-glass-procedure.md) describe how they are carried out.

## 2. Scope

All Ayka personnel and contractors, and every system in the [system description](../01-system-description.md): AWS accounts, Microsoft Entra ID, AWS IAM Identity Center, the GitHub repository and its environments, and the Ayka Portal's administrative functions. Customer users' access to their own tenant is managed by the customer (CUEC-01).

## 3. References

| Framework | Requirement |
|---|---|
| SOC 2 | CC6.1, CC6.2, CC6.3, CC5.1 |
| ISO/IEC 27001:2022 | A.5.15, A.5.16, A.5.17, A.5.18, A.8.2, A.8.3, A.8.4, A.8.5 |
| GDPR | Art. 25, Art. 32(1)(b) |
| Controls | AC-01 to AC-09, AC-14 in the [control matrix](../03-control-matrix.md) |

## 4. Policy statements

### 4.1 Identity

1. Every person has exactly one named workforce identity in Entra ID. Shared, generic and team accounts are not allowed, except the two emergency access accounts in 4.5.
2. Identities are created from the personnel source only; nobody creates an Entra ID user by hand outside the documented workflow.
3. AWS access is federated from Entra ID through IAM Identity Center. IAM users and long-lived access keys for people shall not exist. The compliance gate rejects IAM users in any Terraform plan (`IAM_USER_PROHIBITED`).
4. Workloads use IAM roles with short-lived credentials. The CI pipeline holds no cloud credentials while it is plan-only; when it gains apply rights, it shall use OIDC federation scoped to the `main` branch and the approval environments, never stored keys.

### 4.2 Authentication

1. Multi-factor authentication is required for every interactive login to Entra ID, AWS, GitHub and administrative functions of the Ayka Portal.
2. Tier 0 identities (security administration) use phishing-resistant MFA: FIDO2 security keys or platform passkeys.
3. Legacy authentication protocols that cannot do MFA are blocked.
4. Passwords, where still used, are at least 14 characters, are not reused across systems, and are changed only on suspicion of compromise, in line with NIST SP 800-63B. Password managers approved by IT are allowed and encouraged.
5. Secrets are never committed to source control. Initial passwords are generated (`random_password`) and handed over out of band; the person changes them at first login.

### 4.3 Authorization

1. Access is role-based. The roles are the tiered groups in the [identity architecture](../../architecture/identity-architecture.md): Tier 0 security administration, Tier 1 infrastructure operators, Tier 2 developers.
2. Every IAM role created for people carries the permission boundary. Resource access is further limited by ABAC tags (`Department`, `Environment`).
3. Policies shall not grant wildcard actions or use inline policies; the gate enforces this (`IAM_WILDCARD_POLICY`, `IAM_INLINE_POLICY_USAGE`).
4. Administrative sessions last at most 1 hour for the platform administrator permission set and 8 hours for others.
5. No one approves their own access request, and no one reviews their own access.
6. Production customer data is not accessible to Tier 2 by default. Access for support needs a ticket naming the customer, is time-limited, and is logged.

### 4.4 Joiners, movers and leavers

| Event | Trigger | Deadline | Evidence |
|---|---|---|---|
| Joiner | HR confirms the signed contract, the NDA and the completed baseline training | Before first working day | Ticket, Terraform commit adding the user and groups |
| Mover | HR records the role change | Old access removed within 5 business days of the change | Ticket, Terraform commit changing groups |
| Leaver | HR records the last working day | All access disabled by end of the last working day; removed within 1 business day | Ticket, Entra sign-in disabled, Terraform commit |
| Involuntary leaver | HR or Managing Director | Immediately, before the person is told | Ticket with timestamp |

### 4.5 Privileged and emergency access

1. Tier 0 membership is limited to the CISO and at most two Cloud Platform engineers, and is listed by name in the quarterly access review.
2. Two Entra ID emergency access accounts and the AWS `BreakGlassRole` exist for loss of federation or tenant compromise. Their use follows the break-glass procedure, triggers an alert (OP-05, planned), and is reviewed by the CISO within 24 hours.
3. The AWS root user of member accounts is denied by SCP. The management account root user has hardware MFA, no access keys, and its credentials are held under dual control.

### 4.6 Access reviews

1. Every quarter, Security Operations exports all access to AWS, Entra ID privileged roles, GitHub collaborators and GitHub environment reviewers. Line managers confirm each of their reports' access; the CISO confirms Tier 0.
2. Access that is not confirmed is removed within 5 business days.
3. The review is recorded on the template in [SOC2-05](../05-audit-approach-and-evidence.md#71-quarterly-access-review-ac-07).

## 5. Roles

| Activity | HR | Line manager | IT Support / Cloud Platform | Security Operations | CISO |
|---|---|---|---|---|---|
| Trigger joiner, mover, leaver | R | C | I | I | I |
| Approve access | | A | R | | C (Tier 0: A) |
| Provision and remove | | | R | | I |
| Quarterly review | | R | C | R | A |
| Break-glass review | | | C | R | A |

R responsible, A accountable, C consulted, I informed.

## 6. Exceptions

An exception to this policy is requested in writing with a reason, a compensating control and an end date of at most 6 months, and approved by the CISO. Exceptions are listed in the quarterly report to the Managing Director. Technical exceptions to gate rules use [`exceptions.yaml`](../../../Internal-IT/engineering/policy-as-code/metadata/exceptions.yaml).

## 7. Compliance and monitoring

Compliance is shown by: gate results on every change; quarterly access review records; joiner and leaver tickets matched to identity commits; Entra ID and IAM Identity Center configuration exports; break-glass review records. Violations are handled under the disciplinary process.

## 8. Current gaps

- MFA cannot be enforced while Entra ID is on the Free licence and Conditional Access is disabled (`enable_conditional_access = false`). Interim: turn on Security Defaults.
- The identity Terraform has not been applied; there are no tickets or review records yet.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-06 | First issue |
