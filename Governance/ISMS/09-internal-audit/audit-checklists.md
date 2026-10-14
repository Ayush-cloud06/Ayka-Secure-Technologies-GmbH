# Internal audit checklists

| Field | Value |
|---|---|
| Document ID | ISMS-AUD-03 |
| Owner | Compliance & Risk Management |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or audit criteria or control design change |
| Status | Draft. Not approved: no approval record exists (simulated company) |

Ayka Secure Technologies GmbH is a simulated company; this document does not establish a performed activity.

## 1. Use and result rules

These are unexecuted test prompts for the [audit programme](audit-programme.md) and [audit plan](audit-plan.md), not an audit report. For every test record criterion, evidence reference/date, population/sample, actual steps and result. Allowed results: Not tested, Conforming within tested scope, Potential nonconformity, Observation, or Not applicable with justification. All prompts below are **Not tested** until an appointed auditor performs and records the work.

Never infer an approved policy from a file's existence, independent review from a role label, live control behavior from Terraform, or historical period effectiveness from one CI run. Verify exact normative requirements using the authorized source for the audit.

## 2. Management-system checklist

| ID | Criterion | Test prompt and expected evidence |
|---|---|---|
| C-01 | Clauses 4.1–4.2 | Compare context/interested parties to business model, simulation boundary and climate relevance decision; check reviewed rationale and change triggers |
| C-02 | Clause 4.3 | Trace scope boundaries, interfaces and dependencies to [scope](../00-context-and-governance/scope.md), assets and actual processing; identify unsupported company/service claims |
| C-03 | Clause 5 | Inspect actual policy approval, leadership/resource decisions, role assignments and conflicts; a draft header alone fails to establish adoption |
| C-04 | Clause 6.1 | Reperform a selected risk score, trace treatment/owner, verify all 93 SoA dispositions and reasoned applicability; challenge acceptance without authority |
| C-05 | Clauses 6.2–6.3 | Check measurable objectives, owner/resources/due trigger, evaluation method and planned ISMS-change impacts |
| C-06 | Clauses 7.1–7.4 | Inspect resource availability, actual competence/training evidence and communication records; fictional employees cannot populate attendance |
| C-07 | Clause 7.5 | Trace one document's version, approval, distribution/access, revision history and retained evidence; confirm obsolete content handling |
| C-08 | Clause 8 | Trace selected operational changes through risk reassessment, acceptance criteria and external-process oversight; inspect source-to-runtime boundary |
| C-09 | Clause 9.1 | Recompute one [metric](../08-monitoring-and-measurement/kpis-and-metrics.md) with its numerator/denominator and cutoff; challenge missing-as-zero and narrow-sample extrapolation |
| C-10 | Clause 9.2 | Verify auditor independence, programme coverage, plan, actual tests/report and communicated findings |
| C-11 | Clause 9.3 | Inspect actual review inputs, attendance, decisions on resources/changes and action tracking; agenda is not minutes |
| C-12 | Clause 10 | Trace a real issue through correction, cause, similar-process assessment, action and effectiveness; closure requires evidence |

## 3. Control checklist

| ID | Criterion | Test prompt and evidence |
|---|---|---|
| A-01 | A.5.9–A.5.14 | Reconcile plan-derived inventory to source scope; check ownership/classification and safe transfer/disposal records; exclude fictitious runtime assets |
| A-02 | A.5.15–A.5.18, A.8.2, A.8.5 | Reconcile HR/Entra/AWS/GitHub populations, access requests and removal times; test reviewer independence and privileged justifications; inspect RISK-004 contradictions |
| A-03 | A.5.19–A.5.23 | Inspect actual service-plan contracts, report scope, customer responsibilities, subservices, transfer/location facts, review decisions and exit conditions |
| A-04 | A.5.24–A.5.28 | Verify incident roles/contact routes and performed exercise/incident evidence, decision timing and preserved logs; templates do not prove readiness |
| A-05 | A.5.29–A.5.30, A.8.13 | Inspect backup settings and actual restore evidence separately; recompute RTO/RPO and challenge zero-loss claims based only on versioning |
| A-06 | A.5.31–A.5.34 | Trace applicable obligations, privacy roles, retention/holds and deletion decisions; check Region mismatch and unverified transfer statements |
| A-07 | A.6.1–A.6.8 | Trace actual joiner/mover/leaver, training and confidentiality records with restricted handling; inspect remote/endpoint requirements |
| A-08 | A.7.1–A.7.14 | Test SoA physical-control responsibility split and relevant provider assurance coverage; cloud hosting does not remove endpoint/remote-work duties |
| A-09 | A.8.8–A.8.9, A.8.19 | Reconcile software/configuration scope, scan completeness, overdue fixes, patch tests and approved exceptions; configuration scanning is not dependency scanning |
| A-10 | A.8.15–A.8.16 | Inspect log delivery/retrieval/alert tests and access/retention; source settings alone leave runtime logging unproven |
| A-11 | A.8.20–A.8.24 | Trace network, storage and cryptographic requirements through mapped rules and plan evidence; check residual findings and key custody |
| A-12 | A.8.25–A.8.34 | Sample change and secure-development evidence, branch/environment settings, independent reviews, scanner decisions, regression controls and evidence integrity |

## 4. Working-paper and finding fields

For each performed test use: engagement ID; checklist ID; requirement/version; population count; selected items and reason; evidence locator/SHA/time; actual observation; result; limitation; auditor; owner response; linked finding/action. Record potential findings using [audit-findings-log](audit-findings-log.md) after factual validation. Preserve sensitive evidence under the [retention policy](../../policies/records-and-data-retention-policy.md).

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
