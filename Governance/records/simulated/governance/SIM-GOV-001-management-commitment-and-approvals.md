# SIM-GOV-001 Management commitment and ISMS approval decisions

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-GOV-001 |
| Authored | 2026-11-10 |
| Scenario date | 2026-03-02 |
| Participants | EMP-001 (Managing Director, decision maker), EMP-002 (CISO, presenter), EMP-018 (Governance & Risk Analyst, minutes) |
| Procedure exercised | [Document control procedure ISMS-00-07](../../../ISMS/00-context-and-governance/document-control-procedure.md) section 5 (review and approval); [management review agenda ISMS-MR-01](../../../ISMS/10-management-review/management-review-agenda.md) section 3 (initial decisions) |
| Controls | ISO/IEC 27001:2022 clauses 5.1, 5.2, 5.3, 6.1.3, 6.2, 7.1, 7.5.2; Annex A A.5.1, A.5.2, A.5.4; SOC 2 CE-01, CE-03, CE-06 |

## 1. Management commitment statement

Scenario decision by EMP-001, read out at the meeting and filed with this record:

1. Ayka runs an ISMS to ISO/IEC 27001:2022 for the scope in the scope document.
2. Security objectives are set in the ISMS objectives and are reviewed at management review.
3. EMP-002 (CISO) owns the ISMS and reports to EMP-001 every quarter.
4. EMP-001 is the Risk Acceptance Authority. No Critical risk is accepted for normal operation.
5. Ayka meets its legal duties under GDPR. It prepares for NIS2 as if in scope, because customers need it.
6. Ayka provides the people and money the approved objectives need. Items not funded today are named below, not hidden.
7. Everyone reports suspected incidents at once. Reporting your own mistake is never a disciplinary matter.

## 2. Documents presented and decisions

EMP-002 presented each document at its current version. EMP-001 decided each one.

| Item | Document | Version | Decision | Condition |
|---|---|---|---|---|
| D-01 | [ISMS scope](../../../ISMS/00-context-and-governance/scope.md) | 1.0 | Approved as scenario decision by EMP-001 | Scope covers the plan-analysis gate, the ayka-portal design, the identity design and the people in the register. No deployed system is in scope because none exists |
| D-02 | [Information security policy](../../../ISMS/00-context-and-governance/information-security-policy.md) | 1.0 | Approved as scenario decision by EMP-001 | Publish to all staff by 2026-03-13 |
| D-03 | Topic policies POL-AC-01, POL-CHG-01, POL-IR-01, POL-BCDR-01, POL-VEN-01, POL-SDL-01, POL-PRIV-01, POL-RET-01, POL-DATA-01, POL-CRY-01, POL-CLD-01, POL-VUL-01, POL-AUP-01, POL-REM-01, POL-END-01, POL-DESK-01, POL-PHY-01, POL-VDP-01, STD-LOG-01, STD-MSK-01 ([policy index](../../../policies/README.md)) | 1.0 or as listed | Approved as scenario decision by EMP-001 | Same publication date as D-02 |
| D-04 | [Statement of Applicability ISMS-SOA-01](../../../ISMS/04-controls-and-soa/statement-of-applicability.md) | As listed | Approved as scenario decision by EMP-001 | All 93 Annex A controls applicable. Status labels stay as written; approval does not raise any status |
| D-05 | [Risk treatment plan](../../../ISMS/03-risk-management/risk-treatment-plan.md) | 1.0 | Approved as scenario decision by EMP-001 | Treatments TRT-001 to TRT-013 go ahead. Calendar dates are set at the risk review on 2026-03-16 (SIM-RISK-001) |
| D-06 | [ISMS objectives](../../../ISMS/00-context-and-governance/isms-objectives.md) | As listed | Approved as scenario decision by EMP-001 | OBJ-01 to OBJ-11 adopted as written |

## 3. Roles and resources

| Item | Decision |
|---|---|
| R-01 | EMP-021 is appointed internal auditor for the first audit cycle. EMP-004 is also listed as internal auditor in the personnel register, but she is GDPR Lead and Privacy Lead in the incident plan, so she does not lead the first audit. Named role holders and deputies follow in [SIM-PPL-006](../people/SIM-PPL-006-role-holder-appointments.md) (2026-03-02 to 2026-03-04) |
| R-02 | EMP-005 is Incident Coordinator. Deputy as set in SIM-PPL-006 (EMP-020); NIS2-03 section 2 names EMP-014 instead (Finding 6) |
| R-03 | EMP-016 is Supplier Risk Coordinator. The supplier review in July 2026 is scheduled now (SIM-SUP-001) |
| R-04 | Entra ID licence with Conditional Access: **deferred** by EMP-001 to the Q3 budget. Consequence acknowledged: OBJ-04 (MFA for all privileged access) cannot be met before then |
| R-05 | Second maintainer for the repository: **not funded**. POL-CHG-01 section 10 compensating control (monthly review of merged changes by the Managing Director) applies from March 2026 |
| R-06 | Paid evidence storage outside GitHub (TRT-007): deferred to the risk review on 2026-03-16 |

## 4. Communication

EMP-012 publishes D-02 and D-03 to staff by 2026-03-13 through the staff channel in the [communication plan](../../../ISMS/00-context-and-governance/communication-plan.md). Proof of publication belongs to the people area (other author), not to this record.

## Findings

1. **Approval leaves the document unchanged.** The document control procedure (section 5) says approval is recorded as a pull-request approval or a decision-record entry, and the Status changes to "Approved". It does not say who edits the header, by when, or how the approval is linked from the document. After this meeting every document still read "Draft. Not approved". The procedure needs a step: "within 5 business days the document owner updates Status, Effective and Next review and links the decision record".
2. **Policy approval has no distribution evidence step.** CE-01 requires policies to be "published to staff". Neither the document control procedure nor the communication plan names the record that proves publication or acknowledgement.
3. **Two internal auditors in the register, one in the programme.** The personnel register names EMP-004 for "Internal Audit Responsibility" and also gives EMP-021 the security role Internal Auditor. The audit programme says the Managing Director appoints the auditor. The register should name the appointment rule, not a person.
4. **Risk-owner roles are not mapped to people.** The risk register uses "Identity owner", "Repository owner", "Assurance owner" and "Privacy owner". None of these roles exists in the roles document or the personnel register. This meeting did not fix it; SIM-RISK-001 hit it two weeks later.
5. **The compensating change reviewer cannot see the changes.** POL-CHG-01 section 10 makes the Managing Director review all merged changes monthly. In the joiner grants (SIM-PPL-001) EMP-001 has no GitHub access at all. The only required environment reviewer is the single owner-role account. The policy names a reviewer without giving him the access or the input (a list of merged changes) to do it.
6. **Two deputies for one role.** NIS2-03 section 2 names EMP-014 as deputy Incident Coordinator. The appointments in SIM-PPL-006 name EMP-020. Nothing says which document wins.

## What this does not show

- No meeting took place. The participants are roles in the fictional personnel register. Nothing here is a real decision by any person.
- The documents are used as their text stands on the Authored date (2026-11-10) and are treated as in force at the scenario date. Most were first issued in October 2026, after this scenario date.
- No document in the repository is approved. Every header still says Draft, and that is correct.
- No staff publication, budget or licence purchase is evidenced.
