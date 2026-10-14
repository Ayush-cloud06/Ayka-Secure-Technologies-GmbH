# Internal audit programme

| Field | Value |
|---|---|
| Document ID | ISMS-AUD-01 |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or material risk change, audit result or ISMS scope change |
| Status | Draft. Not approved: no approval record exists (simulated company) |

Ayka Secure Technologies GmbH is a simulated company; this document does not establish a performed activity.

## 1. Purpose and status

Plan risk-based internal audits under ISO/IEC 27001:2022 clause 9.2. The programme is **Designed**, as documented here; no audit has been commissioned, scheduled with a real auditor or completed. An independent auditor and management authorization are prerequisites. Document reviews and CI checks are evidence sources, not an internal audit by themselves.

Audit criteria are the [ISMS scope](../00-context-and-governance/scope.md), approved policies/procedures, the [SoA](../04-controls-and-soa/statement-of-applicability.md), risk decisions and applicable requirements in the [legal register](../00-context-and-governance/legal-and-regulatory-register.md). Until documents are approved, assess design and readiness separately from conformity to an effective company requirement. Verify normative wording against an authorized standards copy; this programme is not a substitute for it.

## 2. Programme coverage

Schedule the first cycle within 12 months of ISMS approval and before any claim of operational conformity; complete all applicable clauses and controls across each annual cycle. Set real dates only when auditor and resources are appointed.

| Audit area | Criteria and priority | Method / planned cadence |
|---|---|---|
| Context, leadership, scope and obligations | Clauses 4–5; climate relevance and interested-party requirements; explicit simulated-company boundary | Document review and management interview annually |
| Objectives, risk and SoA | Clauses 6–7; full 93-control disposition, RISK-001–013, resource/competence/document decisions | Full design review annually and after scope change |
| Identity and access | A.5.15–A.5.18, A.8.2, A.8.5; RISK-001, 003, 004, 013 | Source/approval review initially; runtime population and independent access sampling only when systems operate |
| Change, gate and evidence | A.8.9, A.8.25, A.8.29, A.8.32; RISK-005, 007, 008, 009 | CI/PR evidence and negative tests annually; special review after a material gate failure |
| Operations and suppliers | Clauses 8–9; backup/logging/incident/supplier requirements and RISK-002, 006, 010, 011, 012 | Design review now; operating samples across a stated period when available |
| Evaluation and improvement | Clauses 9–10; metrics, audits, management reviews and corrective actions | Reconcile all due activities and follow-up actions annually |

Prior findings, high current risks, incidents and material changes may increase frequency and sample sizes. CISO records reasons and programme changes; low risk is not a reason to omit an applicable area indefinitely.

## 3. Independence, competence and resources

Managing Director appoints a competent auditor who did not design, implement or operate the audited work. Record relevant audit/security competence, confidentiality commitment, conflicts, scope and access authorization. With one maintainer, another role label does not create independence; obtain an external qualified reviewer or an independent person before claiming an internal audit. Do not audit unapproved third-party systems or expose secrets through evidence exports.

CISO proposes time, access and budget; Managing Director approves resources and resolves conflicts. If independent competence cannot be provided, report the programme as not started and record the gap for management review. Technical contributors may explain evidence but do not approve their own findings or closure.

## 4. Execution and reporting

For each engagement use the [audit plan](audit-plan.md) and [checklists](audit-checklists.md). Retain population definitions, selection rationale, evidence references, interviews actually held, findings and limitations. Record findings in the [findings log](audit-findings-log.md); confirmed nonconformities follow [corrective action](../06-operational-procedures/corrective-action-procedure.md).

Issue an audit report only after an actual audit. It must state criteria, scope/period, auditors/independence, sampled populations, objective evidence, findings, unresolved objections and conclusions limited to tested scope. Deliver results to relevant management and [management review](../10-management-review/management-review-agenda.md). Follow up prior findings in the next audit or sooner according to risk. Retain records under the [retention policy](../../policies/records-and-data-retention-policy.md).

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
