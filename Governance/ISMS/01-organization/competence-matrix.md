# Competence requirements and assessment matrix

| Field | Value |
|---|---|
| Document ID | ISMS-01-02 |
| Owner | HR & Administration |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or a role, technology, risk or legal requirement change |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company. These are proposed requirements; a written policy is not evidence that its controls operate.

## 1. Purpose and scope

Define competence needed for ISMS work and how it will be assessed (ISO/IEC 27001:2022 clause 7.2, clause 7.3 and A.6.3). Use the [role register](../../../organization/roles-and-responsibilities.md) and [training programme](../../../organization/training-and-awareness.md). The 24 fictional personnel entries are not evidence of qualified staff. No individual has been assessed by this document.

## 2. Role requirements

All roles need classification, phishing/authentication, acceptable-use, privacy, remote-work and incident-reporting awareness. Baseline awareness is required before production access, with annual refresh; the training programme's onboarding requirement takes precedence over the broader three-month objective.

| Role | Additional competence required | Assessment method and evidence | Review frequency |
|---|---|---|---|
| Managing Director | Risk acceptance, resource decisions, legal escalation, incident communications and management review | Scenario discussion; explain a risk decision and escalation using actual criteria; dated assessor record | On appointment and annually |
| CISO | ISMS scope, risk method, SoA, control limitations, incident governance and independent review | Review a risk/control chain and conduct a tabletop; written rationale with evidence links | On appointment, annually and after material scope change |
| Cloud Platform Engineering | Terraform and state safety, AWS IAM/KMS/networking/logging, CI gate operation, recovery and patch validation | Practical exercise in an isolated environment: interpret a failed gate, remediate, verify and explain rollback | Before privileged access, annually and on major platform change |
| Compliance & Risk Management | Processing records, supplier assessment, legal-source monitoring, retention and evidence handling | Assess a fictional processing/vendor case; distinguish verified facts, unresolved applicability and designed controls | On appointment and annually |
| Security Operations | Triage, evidence preservation, severity, notifications, access reviews and vulnerability tracking | Incident tabletop and access-review sample; demonstrate escalation and accurate record creation | Before operational duty and annually |
| Product & Engineering | Secure design/coding, threat modelling, dependency review, privacy by design, tenant isolation and secure test data | Review a change/design and its negative tests; demonstrate handling of a security finding | Before relevant work, annually and on major stack change |
| HR & Administration | Joiner/mover/leaver control, confidentiality, policy acknowledgement, private record handling and fair investigations | Complete a simulated onboarding/offboarding case without granting or fabricating real access | On appointment and annually |

Roles may be combined, but evaluation of one's own privileged or audit work requires a separately competent reviewer. The single-maintainer constraint is RISK-005; no independent assessor has been appointed.

## 3. Assessment and gap treatment

Use four evidence-based outcomes: **Not assessed**, **Needs development**, **Competent for supervised work**, **Competent for assigned work**. Course attendance alone does not prove ability. The assessor records the role-specific exercise, criteria, result, evidence and any restrictions. External certifications may support competence but must be relevant and verified.

When a gap exists, HR & Administration agrees training, mentoring, supervised work or external support with the role owner. Record due date and who will reassess. Restrict tasks or access that exceed demonstrated competence until reassessment succeeds. The CISO reviews overdue actions quarterly and requests resources through [ISMS objectives](../00-context-and-governance/isms-objectives.md).

## 4. Record template and awareness effectiveness

| Assessment ID | Private person reference | Role/task | Required competence | Evidence/method | Assessor | Assessment date | Outcome | Development action/owner/due | Reassessment |
|---|---|---|---|---|---|---|---|---|---|

No entries yet: no training, exercise, competence assessment or certification verification has taken place. Do not infer outcomes from the fictional personnel register or job titles. Keep populated records privately under the [retention policy](../../policies/records-and-data-retention-policy.md).

Evaluate awareness with a short role-relevant exercise and ability to locate the reporting channel, not merely a completion percentage. Include duties, consequences of policy breaches and each role's contribution to the ISMS. Report completion and unassessed roles separately through [KPIs](../08-monitoring-and-measurement/kpis-and-metrics.md).

## 5. Status

Designed: role requirements and assessment method are defined here. Operational assessment, training delivery, records and effectiveness measurement are Planned. No record has been entered in this matrix.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
