# Internal audit plan template

| Field | Value |
|---|---|
| Document ID | ISMS-AUD-02 |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or audit scope or assigned auditor change |
| Status | Draft. Not approved: no approval record exists (simulated company) |

Ayka Secure Technologies GmbH is a simulated company; this document does not establish a performed activity.

## 1. Planned engagement and authorization

This is an unfilled engagement plan for the first ISMS audit under the [audit programme](audit-programme.md). It records no booking, interview or completed audit. The proposed first engagement is an evidence-bounded design assessment of the repository, followed by a separately scoped operating assessment only when real records and systems exist.

| Required plan field | Current state / completion rule |
|---|---|
| Engagement ID and approved dates | Not assigned; auditor and CISO agree before work |
| Sponsor and accountable owner | Managing Director; CISO coordinates |
| Auditor and independence | Not appointed; document competence and conflict check before authorization |
| Scope and period | Proposed: ISMS documents, risk/SoA and repository/CI controls; fix source SHA and observation cutoff when approved |
| Criteria | Approved requirements plus ISO/IEC 27001:2022 clauses 4–10 and applicable Annex A controls; distinguish draft design criteria |
| Exclusions | No live AWS/Entra or service operating-effectiveness opinion without authorized access and real evidence; justify every excluded area |
| Resources and evidence access | Time budget, read-only permissions, contacts and restricted evidence location to be approved |
| Reporting and follow-up date | Agree after scope and auditor availability are confirmed |

## 2. Evidence and sampling plan

| Population | Proposed selection | Evidence needed and limits |
|---|---|---|
| Scope/context/objectives and SoA | All governing documents and all 93 SoA dispositions | Version/approval records and relevant source links; draft review does not prove adoption |
| Risk register/treatments | All Critical/High current risks plus every changed or accepted risk; record exact population at cutoff | Scores, owners, approvals, treatment evidence and residual review |
| Repository changes and CI | Enumerate all merged PRs in the chosen period; select all emergency/gate/identity/exception changes and at least three other changes, or all if fewer exist | Author/reviewer, SHA, checks, decisions, approval settings, bundle integrity; label judgement sample and no statistical inference |
| Negative-control evidence | Relevant regression cases for public exposure, identity privileges and evidence integrity | Expected and actual outcomes on a fixed revision; test failure expected by fixture is distinct from a failed CI job |
| Access, suppliers, restore and training | Reconcile full due population; sample all available records in initial small population | Actual records only; report absent population or evidence, do not create examples to satisfy a sample |
| Improvement and review | All overdue/open high-priority actions plus closed actions due for effectiveness review | Original finding, root cause, change evidence, independent verification and review minutes if actually held |

Extend a sample after an exception to establish scope and recurrence; record why it changed. Missing or inaccessible evidence is a limitation or potential finding to assess, never a passed test. Historical CI artifact expiry may limit repeatability; request retained evidence and record the limitation.

## 3. Execution sequence

1. Opening meeting: confirm scope, criteria, contacts, confidentiality, sampling, escalation route and management access; record actual attendees/date only after it happens.
2. Evidence collection: capture stable source references and timestamps; keep restricted exports outside public Git; use [checklists](audit-checklists.md) without prefilled results.
3. Test and challenge: compare each requirement with objective evidence; distinguish design, gated plans and runtime outcomes; seek owner response without allowing owners to erase contrary evidence.
4. Closing meeting: present supported findings and limitations, receive factual corrections and agree action ownership/dates. Record unresolved disputes and refer them to Managing Director.
5. Report and follow-up: auditor issues the actual report, records findings in the [log](audit-findings-log.md), and checks corrective-action effectiveness at the agreed date. No certificate or full-scope conformity conclusion follows from this template.

## 4. Working papers and protection

Each test record contains test ID, criterion, population and selection, evidence locator/revision/time, steps, actual outcome, auditor judgement, owner response and finding link. Separate confidential material from a sanitized report. Apply the [retention policy](../../policies/records-and-data-retention-policy.md); log corrections as additions without silently rewriting evidence. ISO/IEC 27001:2022 clause 9.2.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
