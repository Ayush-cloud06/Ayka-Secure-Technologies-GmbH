# SIM-INC-001 Incident record INC-2026-001: customer user list exposed in a public pull request and CI log

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-INC-001 |
| Authored | 2026-11-10 |
| Scenario date | 2026-08-12 (awareness). Event 2026-08-10. Closed 2026-09-15 |
| Participants | EMP-015 (reporter), EMP-005 (Incident Coordinator, acting IC until 11:45), EMP-002 (Incident Commander), EMP-001 (Communications Lead), EMP-004 (Privacy Lead), EMP-003 (Technical Lead), EMP-013 (DevOps, write access to the repository), EMP-007 (author of the commit), EMP-010 (customer contact), EMP-009 (account owner), EMP-018 (scribe) |
| Procedure exercised | [Incident response plan POL-IR-01](../../../policies/incident-response-plan.md) sections 5 to 10; [incident reporting procedure NIS2-03](../../../NIS2/03-incident-reporting-procedure.md) sections 3 to 6 and 9 |
| Controls | ISO/IEC 27001:2022 Annex A A.5.24, A.5.25, A.5.26, A.5.27, A.5.28, A.6.8, A.8.11, A.8.12, A.8.33; SOC 2 OP-06, OP-07, IC-03, CO-05; GDPR Art. 4(12), 28(3)(f), 28(10), 33(2), 33(5), 34; NIS2 Art. 23 (voluntary, Ayka out of scope) |

All times are UTC. "Customer A (fictional)" is a fictional pilot customer. Real names and e-mail addresses were never written into any record.

## 1. Incident record (POL-IR-01 section 10)

| Field | Content |
|---|---|
| Incident ID | INC-2026-001 |
| Opened, closed | 2026-08-12 10:12; 2026-09-15 16:00 (with one open action, section 6) |
| Severity | Initial SEV 2, final SEV 2. Reason: one customer affected; access by outsiders possible but not confirmable |
| Reporter and source | EMP-015 during pull-request review. Posted in the engineering chat; there is no security mailbox |
| Systems and data affected | Public GitHub repository: one commit on a pull-request branch (fictional reference PR-SIM-01) and the logs of two Actions runs. File: onboarding user list of Customer A (fictional), 137 rows: full name, business e-mail, job title, department, intended portal role. No passwords, no special categories |
| Personal data breach | Yes. Unauthorised disclosure (Art. 4(12)). The log rows were public from 2026-08-10 16:07 to 2026-08-12 12:40 (about 44.5 hours). The commit stays reachable through the pull-request ref until GitHub removes it (A-06). Ayka is processor for this data |
| Timeline | Section 2 |
| Notifications | Section 4 and records SIM-INC-002 to SIM-INC-006 |
| Root cause | Section 5 |
| Actions | Section 6 |
| Review | 2026-08-25, SIM-IMP-001 |

## 2. Timeline

| Time (UTC) | Event or decision | Who |
|---|---|---|
| 2026-08-04 08:15 | Customer A (fictional) sends its onboarding list by e-mail. EMP-010 forwards it to EMP-007 to build the user import | EMP-010 |
| 2026-08-10 15:58 | EMP-007 commits `tests/fixtures/customer_a_users.csv` on branch `feat/user-import` and opens a pull request in the public repository | EMP-007 |
| 2026-08-10 16:07 | `unit-tests` job fails. The pytest assertion diff prints 6 rows of the file into the public Actions log. A rerun at 16:31 prints the same rows | CI |
| 2026-08-12 09:40 | EMP-015 sees real-looking names and e-mail addresses while reviewing. Posts in engineering chat | EMP-015 |
| 10:05 | EMP-003 reads the chat and phones EMP-005 | EMP-003 |
| 10:12 | EMP-005 opens INC-2026-001, starts the timeline and the initial assessment | EMP-005 |
| 10:20 | EMP-007 deletes branch `feat/user-import` and closes the pull request "to clean up". **No evidence had been captured yet** | EMP-007 |
| 10:35 | EMP-005 finds the commit still reachable from the closed pull request (GitHub keeps pull-request refs after branch deletion). Captures URL, commit SHA, both run IDs, SHA-256 of the file and screenshots into the restricted incident folder. Values not copied | EMP-005 |
| 10:50 | EMP-010 confirms the file is the Customer A list received on 2026-08-04 | EMP-010 |
| **11:30** | **T0: awareness recorded** (NIS2-03 section 3). Classified SEV 2. EMP-005 acting IC | EMP-005 |
| 11:45 | EMP-002 takes over as IC | EMP-002 |
| 11:50 | EMP-004 joins as Privacy Lead | EMP-004 |
| 12:10 | EMP-001 informed by phone | EMP-002 |
| 12:40 | Containment: EMP-013 deletes the logs of both Actions runs and confirms they no longer load | EMP-013 |
| 13:15 | Decision by IC: repository stays public. Making it private would not remove copies already taken and would break public evidence links. Fork check: no fork created between 2026-08-10 15:58 and now (scenario value) | EMP-002 |
| 13:30 | Privacy assessment (section 3) | EMP-004 |
| 14:30 | Removal request for the pull-request ref and cached views submitted to GitHub Support by EMP-002 (owner role), prepared by EMP-013. No reply is recorded in this simulation; outcome to verify | EMP-002, EMP-013 |
| 15:00 | Significance decision (section 3): not significant under NIS2-03 section 4. No BSI report | EMP-002 |
| 16:00 | Notice clock set: customer notice due **2026-08-13 11:30** (24 h, NIS2-03 section 6). POL-IR-01 section 8 says 48 h; IC chose the stricter 24 h | EMP-002 |
| 17:00 | T-1 draft ready (SIM-INC-002). Needs MD approval because it admits a breach of contract | EMP-005 |
| 20:00 | Management update 3 of the day | EMP-002 |
| 2026-08-13 07:45 | EMP-001 approves T-1 with one wording change | EMP-001 |
| 08:30 | Management update. **12.5 hours after the previous one.** SEV 2 needs one every 4 hours | EMP-002 |
| 09:00 | EMP-010 looks for Customer A's security contact. None is registered; no customer contact list exists | EMP-010 |
| 13:50 | EMP-009 finds the contract signatory and a phone number | EMP-009 |
| 14:30 | Recipient confirmed by phone | EMP-010 |
| **14:40** | **T-1 would have been sent (draft, never sent). T0 + 27 h 10 min. The 24 h commitment was missed by 3 h 10 min.** POL-IR-01's 48 h was met | EMP-010 |
| 16:00 | Eradication of copies: EMP-007 deletes local copies; EMP-007 and EMP-010 delete the e-mail attachments; deletion listed in the incident folder | EMP-007, EMP-010 |
| 2026-08-14 10:00 | Recovery: the import work restarts on synthetic data only (STD-MSK-01). Customer A (fictional) asked to report any phishing aimed at its users during 14 days of watch, until 2026-08-28 | EMP-003 |
| 2026-08-14 16:30 | 72 h customer update would have been sent (SIM-INC-004), ahead of T0 + 72 h (2026-08-15 11:30, a Saturday). Met | EMP-010 |
| 2026-08-19 | Preventive change opened (SIM-CHG-001) | EMP-013 |
| 2026-08-25 | Post-incident review (SIM-IMP-001). Due by 2026-08-26 (10 business days). Met | EMP-002 |
| 2026-09-14 | Final report drafted (SIM-INC-005), one month after the 72 h update. Met | EMP-005 |
| 2026-09-15 16:00 | Incident closed by EMP-002 with one open action (A-06) | EMP-002 |

## 3. Assessments and decisions

**Significance (NIS2-03 section 4), decided by EMP-002 at 15:00.**

- S-1, S-2: no service is running. Not met.
- S-3: confidentiality was compromised, but not by a "suspectedly malicious" action. Not met.
- S-4: the 137 people are not users of a running service. EMP-002 records that S-4 is arguable and decides "not met".
- S-5 to S-9: not met.
- Result: not significant. Ayka is not a NIS2 entity ([NIS2-01](../../../NIS2/01-applicability-assessment.md)). Voluntary BSI report: declined by EMP-002. The T-2 field list was prepared for the drill only (SIM-INC-003).

**Personal data (NIS2-03 section 6, POL-IR-01 section 7.2), assessed by EMP-004 at 13:30.**

- Ayka's role: processor for Customer A (fictional). Customer A is controller.
- Ayka's duty: Art. 33(2), notify the controller without undue delay. Ayka's own commitment: 24 h.
- Art. 33(1) notification to the LfDI Baden-Württemberg and Art. 34 notice to the 137 people: these are **the controller's decisions**. Ayka gives the controller the facts to make them.
- Ayka's view, given in the 72 h update: risk to the people is likely, mainly targeted phishing using name, employer and job title. High risk is unlikely: no credentials, no financial or special-category data. Ayka suggests the controller tells its staff to expect phishing. The controller's Art. 33 clock starts at its own awareness (2026-08-13 14:40), so its 72 h ends 2026-08-16 14:40.
- Open question: copying the list into a test fixture in a public repository was not part of the customer's instruction (build the import). Under Art. 28(10), Ayka may count as controller for that copy. If so, Ayka would owe its own Art. 33(1) notice within 72 h of T0, by 2026-08-15 11:30. EMP-004 asked for legal review on 2026-08-13. No answer is recorded by 2026-08-15. Scenario decision by EMP-001 on 2026-08-14: no Art. 33(1) notice by Ayka; reason recorded: the copy served the instructed purpose (building that customer's import) and the controller is being notified. This decision was made **without** the legal review it waited for.
- No DPO was available to consult. EMP-001 decided on 2026-03-09 to designate an external DPO ([SIM-GDPR-001](../privacy/SIM-GDPR-001-dpo-decision-minutes.md)); no contract existed by 2026-08-12.
- Breach log: T-4 row (SIM-INC-006).

## 4. Evidence handling (A.5.28)

- Collected by EMP-005 between 10:35 and 11:20: pull-request URL, commit SHA, run IDs, SHA-256 of the file, screenshots of the PR page and of one log line with values blurred. Stored in the restricted incident folder; collector and time written next to each item.
- Lost: the branch, deleted at 10:20 before any capture. The commit itself survived only because of the pull-request ref.
- The run logs were deleted at 12:40 as containment. Before deletion EMP-005 had recorded the run IDs and the hash of the 6 printed rows, not their content.
- No copy of the personal data is held in the evidence. The file hash proves which file it was.

## 5. Root cause

- Immediate: real customer data was used as a test fixture. STD-MSK-01 rule 1 and SOC 2 CO-05 forbid it.
- Why it reached a public place: the repository is public; no check looks for personal data in fixtures; secret scanning and push protection are disabled, and they would not flag names or business e-mails anyway.
- Why it went to an engineer at all: no route exists for customer onboarding data. It was forwarded by e-mail.
- Why detection took 42 hours: no alerting exists (OP-05 planned); a reviewer noticed by chance.
- Gate check (POL-IR-01 section 9): the Terraform gate cannot see test fixtures. A separate CI check can (SIM-CHG-001).

## 6. Actions

| Action | Description | Owner | Due | Link |
|---|---|---|---|---|
| A-01 | CI check that fails when a fixture holds an e-mail outside reserved example domains | EMP-013 | 2026-08-28 | SIM-CHG-001 |
| A-02 | Route for customer onboarding files: restricted folder, named handlers, deletion date; no e-mail forwarding | EMP-006 | 2026-09-30 | SIM-CAPA-003 |
| A-03 | Customer security contact captured at contract signature | EMP-010 | 2026-09-30 | SIM-CAPA-004 |
| A-04 | One customer-notice deadline across POL-IR-01 and NIS2-03 | EMP-002 | 2026-09-30 | SIM-CAPA-004 |
| A-05 | "Preserve before cleaning" briefing for engineering | EMP-005 | 2026-09-11 | SIM-IMP-001 |
| A-06 | Confirm removal of the pull-request ref and cached views | EMP-013 | Open at closure | — |

## Findings

1. **Two different customer deadlines.** POL-IR-01 section 8 (and SOC 2 OP-06) say 48 hours from confirming a breach. NIS2-03 sections 5 and 6 say 24 hours from awareness. The IC had to choose during the incident. One number is needed.
2. **NIS2-03 calls the incident procedure "still planned".** Section 1 says containment "belongs in the incident response procedure, which is still planned". POL-IR-01 exists. Fix the reference.
3. **Nobody owns "register the customer security contact".** NIS2-03 section 2 says the Customer Success Manager "keeps the customer contact list current", and section 8 says the list does not exist. No step creates an entry at contract signature. This cost 5 hours.
4. **"Every 4 hours, 24 x 7" with no rota.** POL-IR-01 section 5 sets 4-hourly updates for SEV 2, but section 12 says no on-call rota exists. The overnight update could not happen.
5. **Communications Lead deputy does not exist in the plan's terms.** POL-IR-01 section 6 names "Head of Sales and Customer Success". No such role is in the personnel register. SIM-PPL-006 named EMP-009 as stand-in, but the plan still points to the missing post, so nobody on the response team knew to call him until the contact search.
6. **Evidence preservation comes after containment in the plan.** Section 7.5 is placed after containment and eradication, and nothing tells staff who are not on the response team to leave things alone. Move "do not delete, tell the IC" into section 7.1 for all staff.
7. **No path for "processor acting outside instructions".** Neither document covers the Art. 28(10) case, where Ayka may become controller for one copy. The 72 h decision had to be made without the legal review it waited for.
8. **No reporting channel.** POL-IR-01 section 7.1 says report to the security mailbox or on-call number. Neither exists (section 12, IC-03 planned). The report went to a chat channel by luck.
9. **"Immediately" for the MD is not measurable.** POL-IR-01 section 8 says immediately; NIS2-03 section 2 says within 4 hours. EMP-001 was told 40 minutes after T0. Pick one figure.

## What this does not show

- No incident happened. No customer exists. No list was committed, no CI log printed personal data and nothing was sent to anyone.
- No statement by GitHub, the LfDI, the BSI or any customer is recorded. The GitHub Support request outcome is unknown inside the fiction.
- The plan and the procedure are used as their text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
- The legal view on Art. 28(10) is not a legal opinion.
- Times are scenario values chosen to test the clocks.
