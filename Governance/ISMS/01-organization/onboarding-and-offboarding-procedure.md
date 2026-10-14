# Onboarding and offboarding procedure

| Field | Value |
|---|---|
| Document ID | ISMS-ORG-04 |
| Owner | HR & Administration |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or role change, personnel incident or identity change |
| Status | Draft. Not approved: no approval record exists (simulated company) |

Ayka Secure Technologies GmbH is a simulated company; this document does not establish a performed activity.

## 1. Purpose and boundary

Coordinate people, equipment and access under [POL-AC-01](../../policies/access-control-policy.md), the [roles model](../../../organization/roles-and-responsibilities.md) and [training programme](../../../organization/training-and-awareness.md). Ayka is simulated; the personnel register is fictional and supplies no employment, signature, training or account-removal evidence. This procedure is **Designed** and becomes operational only after roles and real record storage are assigned.

## 2. Joiners and movers

| Stage | Responsible role | Completion evidence |
|---|---|---|
| Confirm engagement | HR & Administration | Authorized engagement/start date, role, appropriate screening decision, confidentiality terms using [NDA template](nda-template.md), and restricted record reference |
| Prepare workspace | Cloud Platform Engineering | Authorized device/asset assignment, security configuration check, recovery/contact information and asset-owner record |
| Prepare access | Receiving function owner and CISO where privileged | Task-based request, least-privilege approval, expiry and independent approver using the [user access procedure](../06-operational-procedures/user-access-procedure.md) |
| Induct | HR & Administration with Security Operations | Policy acknowledgement and completed baseline security training before access; incident reporting, acceptable use, remote working and data handling covered |
| Verify | Cloud Platform Engineering | Identity/MFA and intended access verified; real system evidence separate from code changes |
| Role change | HR & Administration and receiving function owner | Changed responsibilities, revised competence/training needs, removed old access within five business days, updated assets and approvals |

The [competence matrix](competence-matrix.md) defines role needs, not evidence that an individual meets them. Do not create a signed NDA index or training attendance entry without the actual event. Provisioning identity remains blocked by RISK-004 until an authoritative lifecycle is reconciled and tested.

## 3. Leavers and urgent removals

HR & Administration records the effective departure time and notifies CISO and Cloud Platform Engineering through a restricted channel. Normal access is disabled by the end of the last working day and removed within one business day. Involuntary departure requires immediate disablement before notification, coordinated with Managing Director. Suspected compromise follows the [incident response plan](../../policies/incident-response-plan.md) without waiting for HR paperwork.

| Checklist | Responsible role | Verification required |
|---|---|---|
| Workforce/privileged identities | Cloud Platform Engineering | Disable sign-in, revoke sessions, remove Entra/Identity Center roles, groups and application assignments; verify each system rather than assuming synchronization |
| Repository and integrations | Cloud Platform Engineering | Remove GitHub collaborator/team/environment access; revoke tokens/keys and integrations held by the person; rotate shared secrets they could access when relevant |
| Information and ownership | Receiving function owner with Compliance & Risk Management | Transfer business records and service/asset ownership, preserve holds and continuity, remove unnecessary personal copies under retention rules |
| Asset return | HR & Administration with Cloud Platform Engineering | Device serial/asset ID, security keys, badges, removable media and documents; expected/returned date, condition, custodian and unresolved items |
| Device disposal or reassignment | Cloud Platform Engineering | Authorized wipe/reset record and verification, preserving required records first; do not claim a remote wipe succeeded without confirmation |
| Confidentiality and final closure | HR & Administration | Remind continuing obligations, confirm return/deletion requests and record unresolved access/assets; no fabricated acknowledgement |

Security Operations independently verifies removal completion and checks for orphaned identities and downstream access. CISO receives missed deadlines immediately; incomplete removal stays open until evidence exists. If the sole maintainer cannot obtain independent verification, record the limitation and escalate rather than self-certifying independence.

## 4. Record and retention

One restricted lifecycle record links trigger/time, employee or contractor reference, role, system population, approvals, training/NDA references, access events, device checklist, verifier and unresolved actions. Store sensitive identity/personnel evidence outside this public repository under the [retention policy](../../policies/records-and-data-retention-policy.md). Feed access gaps to [access review](../06-operational-procedures/access-review-procedure.md) and observed failures to [corrective action](../06-operational-procedures/corrective-action-procedure.md). ISO/IEC 27001:2022 A.5.11, A.5.16, A.5.18 and A.6.1–A.6.6.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
