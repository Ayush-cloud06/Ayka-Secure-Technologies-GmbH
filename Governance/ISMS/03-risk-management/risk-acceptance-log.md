# Risk Acceptance Log

- **Organization:** Ayka Secure Technologies GmbH (simulated case study)
- **Log owner:** CISO role
- **Version:** 1.0
- **Last updated:** 2026-08-23
**Effective approved acceptances:** None evidenced

## Acceptance rule

An entry is effective only when it has a named approver, decision date, defined scope, conditions, expiry or next review, and evidence. “Pending” is not acceptance. High residual risk requires the authority defined in [risk-criteria.md](risk-criteria.md); critical risk cannot be accepted for normal operation.

## Decision log

| Decision ID | Risk | Residual level | Proposed decision | Rationale and constraints | Required authority | Expiry / review | Decision status |
|---|---|---:|---|---|---|---|---|
| ACC-2026-001 | RISK-008 | 8 Medium | Accept the limitations of a plan-only demonstration | Permitted only while the workload uses mock credentials, no real apply occurs, results are labelled simulation, and no deployment/compliance claim is made | CISO and repository risk owner | 2026-09-30 or immediately if a live credential/apply path is introduced | **Pending** - no named approval evidenced |
| ACC-2026-002 | RISK-001 | 15 High | Do not accept | Public-history exposure cannot be normalized through documentation; operational investigation and rotation are required | Managing Director, CISO, and identity owner if an exception were proposed | Review on external-action update | **Treatment required** |
| ACC-2026-003 | RISK-002 | 20 Critical | Do not accept | Unknown state custody and recovery make live apply or drift unsafe | Critical risk is outside acceptance tolerance | Review after TRT-002 evidence | **Activity constrained** - live apply/drift prohibited |
| ACC-2026-004 | RISK-005 | 16 Critical | Do not accept | Missing independent branch/environment protection cannot support a real apply workflow | Critical risk is outside acceptance tolerance | Review after dated GitHub settings evidence | **Activity constrained** - apply remains simulated |

## Conditions for ACC-2026-001

The proposed acceptance for the plan-only workload becomes invalid if any of the following occurs:

- real AWS or other cloud credentials are introduced;
- `terraform apply` can change resources;
- a backend connects the workload to authoritative state;
- the repository describes runtime security or operating effectiveness;
- customer or production data enters the workload; or
- the audit boundary is removed from user-facing documentation.

If a trigger occurs, reopen RISK-008 as treatment or avoidance before continuing.

## Approval record

No named person, signature, ticket, meeting decision, or external approval artifact is present in the repository for these decisions. The log therefore records proposals and non-acceptance constraints, not completed management approvals.

When approval occurs, append—not overwrite—the following information:

- approver name and role;
- decision date;
- exact scope;
- conditions and compensating safeguards;
- expiry or next review;
- evidence link; and
- withdrawal or superseding decision, when applicable.

## Review history

| Date | Reviewer | Outcome |
|---|---|---|
| 2026-08-23 | CISO role (document preparation only) | No acceptance made effective; one medium proposal and three treatment constraints recorded |
