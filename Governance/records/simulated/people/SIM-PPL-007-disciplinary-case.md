# SIM-PPL-007 Security-related disciplinary case: the customer file in a public pull request

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-PPL-007 |
| Authored | 2026-11-10 |
| Scenario date | 2026-08-17 (case opened) to 2026-08-27 (outcome communicated) |
| Participants | EMP-007 (Backend Engineer, the person concerned); EMP-012 (HR & Administration, case lead); EMP-001 (Managing Director, decision-maker); EMP-002 (CISO, impact assessment); EMP-005 (Incident Coordinator, technical facts); EMP-004 (Compliance Analyst, privacy and legal checks); EMP-003 (line manager, consulted on workload and excluded from the decision); EMP-010 (who forwarded the file; witness) |
| Procedure exercised | [Security-related disciplinary process ISMS-01-03](../../../ISMS/01-organization/disciplinary-process.md) sections 2 to 5; [Incident response plan POL-IR-01](../../../policies/incident-response-plan.md) section 7.1 (staff reports and "reporting a mistake you made yourself is never a disciplinary matter"); [Acceptable use policy POL-AUP-01](../../../policies/acceptable-use-policy.md) section 3 (fair handling) |
| Controls | ISO/IEC 27001:2022 Annex A A.6.4; A.5.24, A.6.3 (looked at). SOC 2 CE-02 |

This is a walk of the process, not a finding of fault about a real person. The staff are fictional. Legal and works-council points are marked **to verify** and no legal conclusion is drawn. The record keeps only what the process requires; the real personnel file would sit in a private store, not in this repository.

## 1. Receive and contain (process step 1)

| Field | Content |
|---|---|
| Allegation | In INC-2026-001 ([SIM-INC-001](../incident/SIM-INC-001-inc-2026-001-customer-export-in-public-ci.md)), EMP-007 (a) committed a file containing real data of Customer A (fictional) as a test fixture on 2026-08-10, against STD-MSK-01 rule 1, and (b) deleted the pull-request branch and closed the pull request at 10:20 on 2026-08-12, before evidence was captured, after a colleague had reported the exposure in the engineering chat |
| Source | The incident record and the post-incident review ([SIM-IMP-001](../improvement/SIM-IMP-001-lessons-learned-inc-2026-001.md)) |
| Date opened, by | 2026-08-17 by EMP-002, passed to HR |
| Immediate risk | None continuing. His local copies were deleted on 2026-08-13 under the incident actions (SIM-INC-001 timeline). EMP-007 keeps normal access. No restriction. Containment of the incident is separate (the process says restricting an account is not a finding) |
| Evidence preserved | The incident evidence (SHA-256 of the file, run IDs, screenshots) collected by EMP-005. No new collection about EMP-007 |

## 2. Case lead, conflicts and legal checks (steps 2 and section 3)

| Question | Result |
|---|---|
| Impartial case lead | EMP-012. She is not in Engineering, was not in the incident and is not EMP-007's manager |
| Conflict: EMP-003 | He is EMP-007's line manager and was Technical Lead in the incident. Consulted for workload and context only. He does not decide and does not hear |
| Conflict: EMP-002 | She was Incident Commander and impact assessor. Her role is the security impact (process section 2). She does not decide |
| Conflict: EMP-001 | He was Communications Lead and approved the customer notice. He did not take part in the cause. He decides, and the process says to arrange independent handling where there is a conflict. **No independent person exists** (single-maintainer model, RISK-005). Recorded as a limit |
| Works council | None recorded. Whether the company must or may have one, and whether co-determination applies to this kind of case (BetrVG §87(1) nos. 1 and 6, read in the process document), is **to verify** |
| Employment contract and notice rules | Not reviewed by counsel. A formal written warning ("Abmahnung") and its preconditions, deadlines, hearing and file-retention duties are **to verify** with counsel |
| Evidence limits | Only relevant facts from the incident record. No review of EMP-007's mail, chat or device beyond the incident evidence. The process does not authorise broader access |
| Privacy of the case record | The record is restricted to EMP-012, EMP-001 and EMP-004. Retention expiry: the retention policy has no schedule for disciplinary records ("Planned"). Interim: 18 months, a scenario decision by EMP-004 |

Because counsel and a works council cannot be checked, EMP-001 decided on 2026-08-19 that the outcome would be limited to measures that do not require a formal legal step (see section 5). This is a design decision of the case, not a legal conclusion.

## 3. Establish the facts (step 3)

| Element the process names | Finding |
|---|---|
| Duty communicated | STD-MSK-01 rule 1 and POL-DATA-01 section 5.2 item 4 forbid production data in tests. EMP-007 completed baseline awareness on 2026-03-16 at the second attempt ([SIM-PPL-003](SIM-PPL-003-training-completion.md)). **Real observation (2026-11-10):** the training programme document [`organization/training-and-awareness.md`](../../../../organization/training-and-awareness.md) has no mention of test data, fixtures, production data in tests or of leaving things untouched during an incident. Whether the 2026-03 module covered it is not shown |
| Relevant training | Baseline only. No developer-specific module on test data |
| Sequence of events | As in the incident record |
| Instruction given | EMP-010 forwarded the Customer A file by e-mail on 2026-08-04 to EMP-007 to build the user import. **Nobody told him not to put it in the repository.** No route existed for customer files (SIM-INC-001 section 5) |
| Technical safeguards | None. `fixture-check` was merged on 2026-08-27, after the event (SIM-CHG-001) |
| The 10:20 deletion | At 09:40 EMP-015 posted the exposure. EMP-007 deleted the branch at 10:20 "to clean up". POL-IR-01 version 1.1 now says staff who are not on the response team must not delete and must tell the IC (section 7.1). **That sentence was added on 2026-11-10.** In the fiction at 2026-08-12 the written plan did not contain it. The "preserve before cleaning" briefing was given on 2026-09-11 (action A-05) |
| Alternative explanations | System design (no route, no check), unclear instruction, missing training, workload (the import was due that week, scenario), good-faith intent to limit exposure |
| Proven, unresolved | Proven: the file was committed by EMP-007's account; the branch was deleted by it. Unresolved: whether he understood the file contained real data; he says he thought e-mail addresses of a customer's staff "were not really personal" |

## 4. Hear the response (step 4)

On 2026-08-24, EMP-012 met EMP-007 with EMP-004 present as note-taker (not as representative). He was told the allegations in writing two days before. He was offered the chance to bring a representative. **No works council exists, so none was available; he declined to bring a colleague.** (Whether he had a legal right to a particular kind of representation is to verify.)

His response (scenario text): he did not self-report because he did not know it was a problem until EMP-015 raised it; he deleted the branch because he thought it would stop the exposure; he had asked EMP-010 on 2026-08-04 whether the file was alright to use and was told "it's for the import". The last statement was not confirmed by EMP-010, who did not remember it. Recorded as unresolved.

One correction to the facts was made after the hearing: the first draft said he had received the file by e-mail from the customer. It came from EMP-010, who forwarded it. The hearing note also recorded his statement about the e-mail in his own words.

## 5. Decision (step 5 and 6)

Scenario decision by EMP-001 on 2026-08-26, written reasons:

- **Outcome: no formal warning.** A documented conversation with EMP-012 and the CISO in which the rule and the reason for it are explained, followed by role-specific training on test data and incident behaviour, completed by EMP-007 by 2026-09-30.
- Reasons: the cause is mainly systemic (no route for onboarding files, no check, no instruction, no developer module); the deletion of the branch was a good-faith reaction that the plan did not yet forbid; EMP-007 did not conceal anything and attended the lessons-learned review; there is no earlier case; the harm is a breach of confidentiality towards a customer, which the incident record handles; the process says to consider unclear instructions, missing training and design before attributing blame.
- What would change this: concealment, a repeat, or refusal of the training.
- Not used: restriction of duties (no risk of repetition after the CI check), formal warning (legal checks not possible), any wording about dismissal.
- Communicated to EMP-007 on 2026-08-27 by EMP-012, in writing, with a review route. **The review route has no person.** The process asks for "an uninvolved authorised person". None exists. EMP-007 was told he may ask EMP-001 to reconsider, and EMP-001 is the decision-maker. Recorded as a limit.

## 6. Close and improve (step 7)

| Item | Result |
|---|---|
| Actions complete | Conversation held 2026-08-27. Training due 2026-09-30 (not yet checked on this record's scenario date) |
| Temporary restrictions | None |
| Record expiry | 18 months (interim) |
| Systemic causes | Passed to SIM-CAPA-003 (route, check, output) and SIM-IMP-001 lessons. Developer module on test data: not yet an action. Proposed as an improvement entry |
| Publish lessons | Anonymised wording only: "a customer file used as test data" |

The disciplinary case and the blameless lessons review ([SIM-IMP-001](../improvement/SIM-IMP-001-lessons-learned-inc-2026-001.md)) ran within the same week. EMP-007 attended the lessons review on 2026-08-25, the day after his hearing. Nothing says what use may be made of what he said there.

## Findings

1. **The process has no independent decision-maker or reviewer.** The Managing Director decides, and the review route returns to the same person. The process itself says none is available. State the fallback: external counsel or an external adviser for the review, paid for by the company.
2. **No test of what counts as a duty "communicated".** Step 3 asks for the duty communicated and relevant training. The training programme document does not mention test data. The case could not show that the rule had been taught.
3. **The process does not say how it relates to the blameless lessons review.** POL-IR-01 section 9 and the lessons-learned log invite the person whose action caused the incident. The disciplinary process may use facts from the same incident. Nothing says whether statements at the review are protected. Say so, because a person who fears use will stop speaking.
4. **A rule that did not yet exist cannot be broken.** The "do not delete" duty appeared in POL-IR-01 1.1 after the event. Disciplinary cases need the version of the duty in force on the event date. The document control procedure does not make the version in force on a past date easy to show.
5. **No retention period for disciplinary records.** POL-RET-01 marks personnel and disciplinary records "Planned". The case needed an interim period (18 months, chosen by the analyst).
6. **The legal and representation checks cannot be done.** Section 3 of the process lists checks and gives no way to do them: no counsel, no works-council status, no list of the cases that need a formal step. The case avoided the need by choosing a non-formal outcome. That choice should be stated as a rule: without the checks, only measures that need none.
7. **"Hear the response" has no representation rule.** The process says "with representation where applicable". Where it is not applicable, the person may bring a colleague. The process should say that this is offered.
8. **Who the process covers when a decision-maker was in the incident.** Section 2 says an allegation against a decision-maker requires an uninvolved reviewer, but not what to do when the decision-maker was involved in the incident and not in the cause, as EMP-001 was here.
9. **A near-miss training gap is a corrective action.** The proposed developer module is not tracked anywhere. The process refers to the corrective-action procedure, which lists nonconformities, not training gaps.

## What this does not show

- No disciplinary case, hearing, warning or statement by any person. The staff are fictional.
- A formal warning, a dismissal or a works-council step. None was exercised.
- That the outcome would be lawful or proportionate under German employment law. That question is not answered.
- That EMP-007's account of the 2026-08-04 exchange is true or false. It stays unresolved.
- Any real person's data. The case record that the process asks for would sit in a private store.
