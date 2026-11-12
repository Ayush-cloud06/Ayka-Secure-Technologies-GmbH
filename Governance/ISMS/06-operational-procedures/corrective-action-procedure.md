# Corrective action procedure

| Field | Value |
|---|---|
| Document ID | ISMS-OPS-08 |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.1 |
| Effective | On approval |
| Next review | 12 months after approval, or nonconformity recurrence or ineffective corrective action |
| Status | Draft. Not approved: no approval record exists (simulated company) |

Ayka Secure Technologies GmbH is a simulated company; this document does not establish a performed activity.

## 1. Purpose and trigger

Respond to actual nonconformities and prevent recurrence under ISO/IEC 27001:2022 clause 10.2. Inputs may be an audit, incident, failed test, missed policy deadline, complaint or measurement showing a failed requirement. This procedure is **Designed**; the [NC/CA register](../11-improvement/nonconformity-and-corrective-action-log.md) is empty because no formal decision is evidenced. Worked examples are the simulated SIM-CAPA-001 to SIM-CAPA-007 in the [simulated records index](../../records/simulated/INDEX.md); they are not entries in the register. A known risk alone is not automatically a nonconformity.

## 2. Confirm and contain

1. Reporter records date, source, exact applicable requirement/version, objective evidence, affected assets/data and immediate consequence. CISO assigns an ID and owner role; preserve original evidence and disputed facts. If two documents state conflicting requirements, record both with their versions; the CISO decides in writing which one applies until the conflict is corrected, and the correction becomes one of the actions.
2. Validate whether the requirement applies and evidence supports the failure. Record Not substantiated with rationale where it does not; use the [improvement register](../11-improvement/improvement-register.md) for voluntary opportunities. A draft policy is not retroactively effective. An approved exception makes a condition conforming only while the exception's own conditions are met; if a condition fails, the exception does not cover it. A requirement that is known to fail and whose fix is deferred (for example for lack of budget) is either a time-limited risk acceptance under the [risk criteria](../03-risk-management/risk-criteria.md) or an open nonconformity here, never neither.
3. React according to risk: contain the condition, correct the immediate failure and address consequences. Suspected compromise follows the [incident response plan](../../policies/incident-response-plan.md) immediately; do not wait for cause analysis or a committee meeting.
4. Record temporary measures, who authorized them, expiry and residual exposure. Preserve recovery and evidence before destructive changes; keep affected parties informed through the approved [communication plan](../00-context-and-governance/communication-plan.md).

## 3. Cause and corrective-action plan

The owner investigates why the failure occurred, supported by logs, changes, interviews actually held and reproducible tests where appropriate. Ask why existing prevention/detection did not work; identify contributing process, technical and resource conditions. "Human error" alone is not a sufficient causal explanation. Check whether the same cause exists in other assets, procedures, teams or suppliers and record the population examined and what was not examined, with the reason. The CISO may assign this search to a role other than the action owner where it needs different skills or access.

| Plan element | Required content |
|---|---|
| Correction versus prevention | Separate immediate repair from the change intended to prevent recurrence |
| Scope and cause | Evidence-supported cause, uncertainties and similar exposures investigated |
| Action and owner | Specific deliverable, responsible role, dependencies/resources and approving authority |
| Due date | Risk-based calendar deadline or explicit prerequisite trigger; CISO approves and records reason; do not invent a past deadline |
| Verification | Test method, acceptance criteria, evidence location, reviewer, observation period long enough to detect recurrence, and an effectiveness check **date** (a calendar date, never "at the next review" or another event). If the check depends on an event that has not occurred by that date, the CISO either sets one new calendar date with the reason, or decides on the evidence available and records why |
| Risk/doc changes | Related risk reassessment, SoA/control implications, policy/procedure/training updates and communications |

CISO reviews the plan; Managing Director decides material resources or residual-risk acceptance. Independent review is required where the owner would otherwise approve their own work. With one maintainer, record the gap and leave that verification pending until a competent separate reviewer is available.

## 4. Implement and test effectiveness

Implement approved technical changes through the [change procedure](change-management-procedure.md) and document changes through [document control](../00-context-and-governance/document-control-procedure.md). Keep actual revisions, approvals, test outputs and dates. An action may be implemented while effectiveness remains unverified.

The reviewer retests against the original failed requirement and the defined acceptance criteria, examines the observation period, and checks for adverse effects or similar failures elsewhere. Source/plan tests prove only source/plan behavior; runtime failures require actual runtime verification. If ineffective, reopen the record, revise cause analysis and escalate risk rather than extending closure language.

## 5. Close, escalate and retain

Close only when correction/consequences are addressed, agreed actions complete, effectiveness evidence accepted, relevant risk/documents updated and the authorized reviewer records a dated decision. Preserve unresolved residual risk and its separate acceptance status. Missed deadlines or unavailable resources are escalated to Managing Director; risk acceptance does not erase a nonconformity or prove effectiveness.

CISO reviews open actions monthly and reports recurrence/overdue work through [M-09](../08-monitoring-and-measurement/kpis-and-metrics.md) and [management review](../10-management-review/management-review-agenda.md). Record transferable [lessons](../11-improvement/lessons-learned-log.md) only after an actual review. Retain evidence, changes and verification under the [retention policy](../../policies/records-and-data-retention-policy.md).

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
| 1.1 | 2026-11-10 | Findings of the simulated corrective actions: effectiveness check is a calendar date (SIM-CAPA-001 finding 1) with a rule when the awaited event does not come (SIM-CAPA-003 finding 2); record what was not examined (SIM-CAPA-001 finding 3); CISO may assign the similar-exposure search (SIM-CAPA-003 finding 1); an exception conforms only while its conditions hold (SIM-CAPA-002 finding 1); conflicting requirements (SIM-CAPA-004 finding 2); deferred fixes are an acceptance or a nonconformity (SIM-CAPA-006 finding 1). Others are open in the improvement register |
