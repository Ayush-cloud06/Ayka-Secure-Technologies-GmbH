# ISMS KPIs and metrics

| Field | Value |
|---|---|
| Document ID | ISMS-MON-01 |
| Owner | Compliance & Risk Management |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or objective, measurement scope or evidence-source change |
| Status | Draft. Not approved: no approval record exists (simulated company) |

Ayka Secure Technologies GmbH is a simulated company; this document does not establish a performed activity.

## 1. Purpose and measurement rules

Measure the [ISMS objectives](../00-context-and-governance/isms-objectives.md) using reproducible evidence under ISO/IEC 27001:2022 clause 9.1. This is the metrics dashboard and measurement specification. It contains a bounded repository/CI observation, not quarterly results or a claim of operating ISMS effectiveness.

Compliance & Risk Management collects monthly, validates denominators and presents results quarterly to CISO and at [management review](../10-management-review/management-review-agenda.md). Operational owners investigate missed thresholds. Record period, cutoff/timezone, source revision/run, collector, inclusion/exclusion rules, numerator, denominator, target, result, limitations and action. Preserve raw restricted evidence under the [retention policy](../../policies/records-and-data-retention-policy.md). Missing evidence is **Not measured**, never zero or green. Use **Not applicable** only with a reason and owner review; a zero denominator yields no percentage.

## 2. Metric specification

Targets below are proposed until objectives and policies are approved. They do not replace policy deadlines.

| ID / metric | Calculation and scope | Cadence / owner role | Target and response |
|---|---|---|---|
| M-01 Gate evidence completeness | Selected workload assessments with required plan, scanner outputs, summary, manifest and verified checksums / all selected workload assessments in period; include failed/error assessments, exclude separately labelled regression fixtures | Monthly / Cloud Platform Engineering | 100%; missing bundle blocks reliance on the assessment, investigate under change procedure |
| M-02 CI checks completed successfully | Five expected verification jobs successful / five expected for each sampled default-workload run; keep overall workflow and approval state separate | Per change; monthly aggregation / Cloud Platform Engineering | 5/5 before merge; investigate failure or missing check; this is not a deployment-success metric |
| M-03 Independent change review | Sampled merged PRs with a reviewer other than author / all sampled merged PRs, plus sample/population count and sampling rationale | Monthly / Compliance & Risk Management | 100% before live operation; single-maintainer gap reported explicitly |
| M-04 Access-review completion | In-scope entitlements with dated independent decisions / total reconciled entitlements; separately count overdue removals | Quarterly / Security Operations | 100% and no removal overdue against five-business-day rule; escalate unconfirmed access |
| M-05 Timely vulnerability remediation | Findings resolved and verified by policy due date / all findings due in period, including overdue open findings; accepted risks reported separately | Monthly / Security Operations | 100%; report ageing and exceptions, escalate missed deadlines |
| M-06 Restore effectiveness | Completed scheduled tests meeting both RTO and RPO / all tests due; report missing tests, measured elapsed time and data age | Per scheduled test; quarterly review / Cloud Platform Engineering | 100%; investigate failure and reassess commitments before reliance |
| M-07 Supplier review completion | Due Critical/High supplier reviews with evidence and decision / all Critical/High reviews due | Quarterly / Compliance & Risk Management | 100%; escalate expired assurance and outstanding contractual conditions |
| M-08 Training completion | In-scope people completing required training by due date / all people due; fictional roster excluded | At onboarding and annually / HR & Administration | 100%; restrict access where onboarding prerequisite is missing |
| M-09 Corrective-action effectiveness | Actions due for effectiveness review with verified effective closure / all actions due for review; count overdue open actions | Monthly / CISO | 100%; reopen ineffective action, escalate overdue action |
| M-10 Gate mapping traceability | Gate control IDs with ISO references / all gate control IDs at a fixed commit | On mapping changes / Compliance & Risk Management | 100% structurally mapped, plus manual relevance review; does not measure Annex A implementation |

## 3. Bounded observation as of 2026-10-14

| Measure | Observation | Evidence and boundary |
|---|---|---|
| M-02 sampled verification jobs | **5/5 successful** in one deliberately selected recent `main` run; sample n=1, not a period-wide success rate | [Run 37498007502](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/37498007502), created 2026-10-06T16:43:56Z, SHA `500a26312cff5b35ce70a796c3084a26897fa9ad`; observed using `gh run view` on 2026-10-14 |
| Overall sampled workflow state | **Waiting**, conclusion empty; simulated apply awaiting approval; medium-risk approval skipped | Same run; five jobs are `validate-scripts`, `unit-tests`, `Control Validation Regression`, `compliance / validate`, `compliance / compliance`; do not call the whole run successful or approved |
| M-10 mapping structure | **38/38** gate IDs have nonempty ISO references at repository baseline `8b83257df99222dbe8de82eb457202cecab7a45f` | [Control mapping](../../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml), counted on 2026-10-14; metadata coverage only, not 38 operating controls or a percentage of all 93 Annex A controls |
| M-01, M-03–M-09 | **Not measured** for an operating reporting period | No complete measurement population or performed access, restore, supplier, training or corrective-action review is evidenced here; empty logs are not passing measurements |

Reproduce the CI observation with `gh run view 37498007502 --repo Ayush-cloud06/Ayka-Secure-Technologies-GmbH --json headSha,status,conclusion,jobs`. Count mapping entries under YAML `controls` and count entries with nonempty `frameworks.iso27001`; record the exact revision before comparing. A later run state can differ; this table is a dated observation.

## 4. Evaluation and follow-up

CISO challenges missing scope and changed definitions before interpreting trends. Keep prior snapshots and explain population changes. Open corrective action only for an evidenced failure against a requirement, and improvement proposals for desirable changes; use the [corrective-action procedure](../06-operational-procedures/corrective-action-procedure.md). Management review determines resource or objective changes. The [control evidence index](../07-technical-evidence/control-evidence-index.md) supplies technical provenance; it does not turn these samples into a continuous monitoring record.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
