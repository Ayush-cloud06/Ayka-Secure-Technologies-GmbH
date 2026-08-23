# Risk Management Methodology

- **Organization:** Ayka Secure Technologies GmbH (simulated case study)
- **Document owner:** CISO role
- **Version:** 1.1
- **Last updated:** 2026-08-23
- **Review cycle:** Annual, and after a material change or incident
**Document role:** Normative method; not evidence that a review or approval occurred

## 1. Purpose

This methodology explains how Ayka identifies, assesses, treats, accepts, and reviews information-security risk. It is designed for the repository's actual shape: AWS and Entra infrastructure-as-code, a compliance-gated CI pipeline, a representative workload, governance material, and the supporting audit record.

The method exists to make decisions repeatable. A risk score is not useful on its own; every material risk must also show the affected asset or process, the uncertainty in the evidence, the chosen response, the accountable role, and the condition that proves treatment is complete.

## 2. Scope and evidence boundary

Risk management covers the ISMS scope described in [scope.md](../00-context-and-governance/scope.md), including:

- AWS organization, landing-zone, identity, logging, storage, and workload definitions;
- Microsoft Entra ID and AWS IAM Identity Center integration;
- Terraform state, CI/CD controls, policy-as-code, and generated artifacts;
- governance, privacy, assurance, and supplier dependencies; and
- people and processes represented by the Ayka case study.

This repository is a **non-deploying portfolio case study**. Source definitions and local tests are not treated as proof of cloud deployment or operating effectiveness. Risk entries must preserve the distinctions used by the repository audit:

| Evidence class | What it can support | What it cannot support |
|---|---|---|
| Source | A control or safeguard is defined | The control is deployed or effective |
| Local validation | Syntax, plan, policy, or evaluator behavior was exercised locally | GitHub, AWS, Entra, or runtime behavior |
| Dated external observation | The observed external state on that date | Current state after the observation date |
| Operating evidence | A real activity occurred with an attributable owner and result | Anything outside the evidenced scope and period |

The current evidence boundary is maintained in [AUDIT/CURRENT_STATE.md](../../../AUDIT/CURRENT_STATE.md).

## 3. Roles

Roles are used as case-study accountabilities until named people and approvals are evidenced.

| Role | Responsibility |
|---|---|
| Managing Director | Approves time-limited acceptance of high residual risk and receives critical-risk escalation |
| CISO | Owns the method, challenges scoring, approves low and eligible medium acceptance, and maintains the consolidated view |
| Risk owner | Owns the business consequence and decides whether proposed treatment is sufficient |
| Treatment owner | Delivers the agreed action and supplies completion evidence |
| Control owner | Operates or validates the relevant technical or organizational control |
| Independent reviewer | Checks the evidence and challenges closure where independence is required |

One role may perform more than one function in the simulated organization, but the record must make that overlap visible. An empty approval field never counts as approval.

## 4. Risk workflow

### 4.1 Establish context

Before scoring, record:

- the in-scope asset, process, or obligation;
- whether the subject is source-only, locally tested, externally observed, or operational;
- the evidence date and location; and
- assumptions that could materially change the result.

### 4.2 Write the scenario

Use a cause-event-consequence statement:

> Because **[weakness or condition]**, **[threat event]** could affect **[asset/process]**, resulting in **[specific confidentiality, integrity, availability, legal, financial, or assurance consequence]**.

Avoid control names disguised as risks, such as “lack of MFA.” Explain what could happen and why it matters to Ayka.

### 4.3 Assess inherent risk

Score the credible risk before additional treatment using the likelihood and impact definitions in [risk-criteria.md](risk-criteria.md).

`Risk score = likelihood x impact`

Impact is the highest credible consequence across confidentiality, integrity, availability, legal/compliance, financial, and reputational dimensions. Do not average away a severe consequence.

### 4.4 Record current safeguards and confidence

Current safeguards must state their evidence level:

| Confidence | Meaning |
|---|---|
| E0 - Claimed | Planned, assumed, or described without supporting source |
| E1 - Defined | Present in policy, documentation, or source code |
| E2 - Locally verified | Exercised by a reproducible local test or plan |
| E3 - Externally verified | Confirmed by a dated GitHub, AWS, Entra, or equivalent observation |
| E4 - Operating | Repeated operation and review are evidenced over the stated period |

A source change may improve design without lowering residual risk if the relevant threat depends on deployment or operation.

### 4.5 Select treatment

Use one primary response:

- **Mitigate:** reduce likelihood or impact with defined actions;
- **Avoid:** stop the activity creating the risk;
- **Transfer:** allocate part of the consequence contractually or through insurance; or
- **Accept:** make a documented, time-limited decision within the authority in the risk criteria.

Every mitigation entry needs an owner, a due gate or date, required evidence, target score, and fallback if the treatment fails.

### 4.6 Assess residual risk

Residual risk is the expected level after verified current safeguards. Target risk is the intended level after planned treatment. Keep these separate:

- **Inherent score:** before safeguards;
- **Current residual score:** supported by safeguards already evidenced;
- **Target score:** expected after the treatment plan is completed and checked.

### 4.7 Decide and monitor

The risk owner recommends a decision. The required authority approves acceptance, closure, or continued treatment. Open risks are reviewed quarterly and when a trigger occurs.

## 5. Treatment completion and closure

A task being merged or a document being written does not close a risk. Closure requires:

1. the treatment action is complete;
2. the required evidence exists and is attributable;
3. the residual likelihood and impact are rescored;
4. the reviewer records the result; and
5. any remaining risk is accepted by the correct authority.

If evidence is missing, the status remains **Open**, **Treating**, or **Awaiting external action**.

## 6. Review triggers

Review the affected risks when any of the following occurs:

- a live Terraform backend, apply path, or scheduled drift process is introduced;
- AWS account, Region, trust, or Identity Center assumptions change;
- a credential exposure, security incident, or material scanner finding is identified;
- a new supplier, data flow, regulated activity, or customer-facing workload enters scope;
- a control fails, evidence becomes stale, or an accepted-risk expiry is reached;
- a significant audit finding or management decision changes priorities; or
- the ISMS scope changes.

## 7. Records and traceability

| Record | Purpose |
|---|---|
| [risk-criteria.md](risk-criteria.md) | Scoring, tolerance, escalation, and acceptance authority |
| [threat-scenarios-catalog.md](threat-scenarios-catalog.md) | Reusable scenarios grounded in this architecture |
| [risk-register.md](risk-register.md) | Consolidated current risk position |
| [risk-treatment-plan.md](risk-treatment-plan.md) | Actions, gates, evidence, and target scores |
| [risk-acceptance-log.md](risk-acceptance-log.md) | Proposed and approved acceptance decisions |
| [risk-assessment-results/](risk-assessment-results/) | Dated assessment and review records |

Risk records are retained for five years under the case-study policy. In a real implementation, retention, access, and deletion must be approved and evidenced rather than inferred from this statement.

## 8. Quality rules

- Use stable IDs and do not recycle them.
- Link each score to evidence, not intuition alone.
- Do not lower a score merely because a policy or Terraform resource exists.
- Do not backdate meetings, approvals, tests, or management decisions.
- Mark retrospective reconstruction clearly.
- Record contradictory evidence instead of choosing the more convenient version.
- Keep closed risks in the register with closure evidence and date.
- Treat scanner totals as triage input, not as a compliance percentage.

## 9. References

- [Current State and Audit Conclusion](../../../AUDIT/CURRENT_STATE.md)
- [Findings, Compliance, and Identity Notes](../../../AUDIT/FINDINGS.md)
- [Roadmap and Pipeline Reference Notes](../../../AUDIT/ROADMAP_AND_PIPELINE_NOTES.md)
- [ISMS Scope](../00-context-and-governance/scope.md)
