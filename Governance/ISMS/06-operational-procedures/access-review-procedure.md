# Access review procedure

| Field | Value |
|---|---|
| Document ID | ISMS-OPS-02 |
| Owner | Security Operations |
| Approver | Managing Director |
| Version | 1.1 |
| Effective | On approval |
| Next review | 12 months after approval, or identity scope change or access incident |
| Status | Draft. Not approved: no approval record exists (simulated company) |

Ayka Secure Technologies GmbH is a simulated company; this document does not establish a performed activity.

## 1. Scope and timing

Review workforce and service access quarterly and after material role changes, suspected compromise or a change to privileged paths. [POL-AC-01](../../policies/access-control-policy.md) supplies the requirements. This procedure is **Designed**; no completed quarterly review is evidenced. A tabletop walk-through exists ([SIM-ACC-001](../../records/simulated/access/SIM-ACC-001-q2-2026-access-review.md), simulated); it is not a review.

**Business day** in this procedure and in [POL-AC-01](../../policies/access-control-policy.md): Monday to Friday, excluding public holidays at Ayka's registered seat (Baden-Württemberg). Count from the day after the trigger date. Platform identity remains [Designed](../../../Internal-IT/platform/domains/identity/README.md). Repository settings and identities must be collected from GitHub at review time rather than inferred from Terraform.

## 2. Prepare a complete population

Security Operations opens a review ID, records the period and cutoff timestamp, and exports the following using authorized read-only access. Keep identities and exports outside the public repository.

| Population | Reconciliation and evidence |
|---|---|
| Workforce | HR active roster and authorized contractors against Entra accounts, disabled accounts, groups, privileged roles and application assignments |
| AWS | Identity Center users, groups, permission sets and account assignments; IAM users/keys, role trusts, service identities and emergency access; distinguish intended source from actual settings |
| GitHub | Collaborators, teams where used, repository roles, deploy keys, applications/tokens and reviewers for both approval environments |
| SaaS tools with local accounts | Every tool in the [asset ownership register](../02-asset-management/asset-ownership-register.md) that has its own logins (not federated through Entra ID): accounts, admin roles and last sign-in |
| Leavers and movers in the period | For every leaver and mover since the last cutoff: HR effective date against the actual removal or change date in each system above. A late removal is a finding even if the access is gone at the cutoff |
| Exceptions | From the access exception register kept by Security Operations (ID, identity, entitlement, reason, approver, condition, end date): open and expired entries, temporary/support access, last review's removals, privileged justifications and emergency use. Security Operations hands the register extract to the reviewers at the cutoff |

Record export command/API or screen, collector, time, system/tenant/account, row counts and checksum; explain omissions and unavailable systems. Reconcile to the [asset ownership register](../02-asset-management/asset-ownership-register.md). A source-only review must be labelled design review, not runtime recertification. Never treat an empty export or failed API call as no access.

## 3. Decide and remediate

1. Function owners confirm each entitlement against current role and need. CISO reviews Tier 0 and administrative permissions; Managing Director appoints an independent reviewer for the CISO's access. Nobody reviews their own access. With one maintainer, a full independent review remains blocked until another reviewer is appointed.
2. For each identity/entitlement record: retain, change, remove or investigate; add a reason, reviewer and decision date. Nonresponse is unconfirmed access, not approval.
3. Cloud Platform Engineering removes unconfirmed access within five business days. This period applies only to access a reviewer did not confirm. A leaver's access has its own deadline in [POL-AC-01 section 4.4](../../policies/access-control-policy.md) (disabled by the end of the last working day, removed within one business day); a review that finds a leaver's access still present treats it as overdue, not as unconfirmed. Suspected compromise is handled immediately through the [incident response plan](../../policies/incident-response-plan.md); do not wait for the review deadline.
4. Use the [user access procedure](user-access-procedure.md) and [change procedure](change-management-procedure.md) for changes. Verify actual removal, active sessions and credentials where relevant. Re-export the affected population and compare before/after.
5. Security Operations reconciles all reviewed rows to the original population, resolves duplicates, and records incomplete scope explicitly. The CISO records a dated closeout decision on the review only after exceptions and overdue actions are visible; incomplete review stays open. There are no signatures.

## 4. Review record and follow-up

Use the access-review template in [SOC2 evidence guidance](../../SOC2/05-audit-approach-and-evidence.md), with these required fields: review ID; period/cutoff; collector; scope/counts; excluded scope and reason; per-entitlement decision and reviewer; change ticket; removal due/completed date; verification; exceptions; closeout decision. Preserve sensitive exports under the [retention policy](../../policies/records-and-data-retention-policy.md).

Send coverage, overdue removals and unresolved independence gaps to [metrics](../08-monitoring-and-measurement/kpis-and-metrics.md) and the [management review](../10-management-review/management-review-agenda.md). Record an observed missed requirement through the [corrective action procedure](corrective-action-procedure.md). ISO/IEC 27001:2022 A.5.18 and A.8.2.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
| 1.1 | 2026-11-10 | Findings of the simulated walk-through SIM-ACC-001: SaaS tools with local accounts added to the population (finding 1); leaver and mover date reconciliation (2); access exception register owned by Security Operations (3); "signs" replaced by a dated closeout decision (4); leaver deadline distinguished from the five-day period (6); business day defined (7). Finding 5 (who reviews the Managing Director's access) is open in the improvement register |
