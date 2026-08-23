# Risk Criteria

- **Organization:** Ayka Secure Technologies GmbH (simulated case study)
- **Owner:** CISO role
- **Version:** 1.0
- **Historical baseline:** 2026-04-16
- **Document completed:** 2026-08-23
**Applies to:** All records in `03-risk-management`

## 1. Scoring rule

`Risk score = likelihood x impact`

Score inherent risk before additional treatment, current residual risk using safeguards already evidenced, and target risk only after defining the proposed treatment. Round neither component and do not average impact dimensions.

## 2. Likelihood

Likelihood considers exposure, viable attack or failure paths, control maturity, change frequency, and prior evidence.

| Score | Label | Ayka-specific interpretation |
|---:|---|---|
| 1 | Rare | No known viable path in the assessed context; preventive control and recovery are operating and reviewed |
| 2 | Unlikely | Requires several uncommon conditions; design is coherent and at least locally verified, but operating proof may be limited |
| 3 | Possible | A credible path exists or a key safeguard is source-only; no repeated event is evidenced |
| 4 | Likely | The weakness is currently open, broadly exposed, or expected during normal change; control coverage is incomplete |
| 5 | Almost certain | Exposure or failure is already evidenced, repeated, or expected without immediate action |

For plan-only components, use caution before scoring below 3 when runtime behavior is central to the threat.

## 3. Impact

Use the highest credible impact across confidentiality, integrity, availability, legal/compliance, financial, customer, and assurance consequences.

| Score | Label | Example consequence in this case study |
|---:|---|---|
| 1 | Negligible | Local inconvenience; no sensitive data, control decision, or retained evidence affected |
| 2 | Minor | Limited rework or short interruption within one non-critical component |
| 3 | Moderate | Material engineering rework, unreliable evidence for one control, or contained exposure without privileged access |
| 4 | Major | Loss of important audit evidence, broad unauthorized access potential, significant recovery effort, or material service/security failure |
| 5 | Critical | Privileged identity compromise, sensitive state/credential disclosure, unsafe organization-wide access, or consequence capable of invalidating the platform's trust model |

## 4. Rating bands

| Score | Level | Default response |
|---:|---|---|
| 1-5 | Low | Monitor or accept within authority |
| 6-10 | Medium | Treat or document a time-limited acceptance |
| 11-15 | High | Treatment required; acceptance is exceptional and executive-approved |
| 16-25 | Critical | Escalate immediately; do not accept as normal operation |

## 5. Risk matrix

| Impact / Likelihood | 1 | 2 | 3 | 4 | 5 |
|---|---:|---:|---:|---:|---:|
| 5 - Critical | 5 L | 10 M | 15 H | 20 C | 25 C |
| 4 - Major | 4 L | 8 M | 12 H | 16 C | 20 C |
| 3 - Moderate | 3 L | 6 M | 9 M | 12 H | 15 H |
| 2 - Minor | 2 L | 4 L | 6 M | 8 M | 10 M |
| 1 - Negligible | 1 L | 2 L | 3 L | 4 L | 5 L |

`L = Low`, `M = Medium`, `H = High`, `C = Critical`.

## 6. Tolerance and authority

| Residual level | May it be accepted? | Minimum authority | Conditions |
|---|---|---|---|
| Low | Yes | CISO | Rationale, evidence, and next review recorded |
| Medium | Yes, time-limited | CISO and risk owner | Compensating safeguards, expiry, trigger, and target treatment recorded |
| High | Exception only | Managing Director, CISO, and risk owner | Written business rationale, maximum 90-day review, treatment plan, and explicit consequence acknowledgment |
| Critical | No for normal operation | Managing Director receives escalation | Avoid the activity or reduce the risk before proceeding |

Approval is valid only when the log identifies the approver, decision date, scope, expiry or review date, conditions, and evidence. A role label without a named decision does not constitute approval in this repository.

## 7. Due expectations

| Level | Planning expectation | Escalation trigger |
|---|---|---|
| Critical | Immediate containment and named action before the risky activity continues | Any missed containment step or evidence of exploitation |
| High | Treatment defined within 10 working days or before the next relevant deployment/claim, whichever is earlier | Overdue action, widening scope, or failed control |
| Medium | Treatment or acceptance recorded in the current review cycle | Two consecutive reviews without progress |
| Low | Review at least annually or when context changes | Score increase or acceptance condition failure |

## 8. Scoring safeguards

- A source fix can reduce design risk but does not prove runtime effectiveness.
- A disabled or simulated feature may reduce exposure only while the disabling constraint is verified.
- Missing evidence is uncertainty; it is not evidence that the control failed, but it limits how far likelihood can be reduced.
- Scanner findings are grouped into threat scenarios before scoring; raw totals are not multiplied into a risk score.
- Legal or privacy impact is scored only from known processing and obligations. Where processing facts are missing, record the information gap as part of the risk.
- Accepted risk returns to treatment if its condition, expiry, or scope is breached.

## 9. Review triggers

Reassess when a live apply, backend migration, identity integration, new data flow, external rule change, incident, audit finding, major scanner change, or acceptance expiry affects the scenario.
