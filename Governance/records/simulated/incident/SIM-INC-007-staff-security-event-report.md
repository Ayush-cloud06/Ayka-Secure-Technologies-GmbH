# SIM-INC-007 Staff security event report: a phishing mail

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-INC-007 |
| Authored | 2026-11-10 |
| Scenario date | 2026-05-06 |
| Participants | EMP-022 (Marketing Specialist, reporter), EMP-002 (CISO, first contact), EMP-005 (Incident Coordinator), EMP-020 (SOC Analyst), EMP-013 (mail administration), EMP-009 and EMP-010 and EMP-016 (other recipients) |
| Procedure exercised | [Communication plan ISMS-00-08](../../../ISMS/00-context-and-governance/communication-plan.md) row IC-I-04 and section 4; [Incident response plan POL-IR-01](../../../policies/incident-response-plan.md) sections 7.1 and 7.2; [Acceptable use policy POL-AUP-01](../../../policies/acceptable-use-policy.md) section 2 (messages and browsing) and section 3 (reporting) |
| Controls | ISO/IEC 27001:2022 Annex A A.6.8, A.5.25 (looked at). SOC 2 IC-03 |

All times are local (CEST). Names of senders, domains and the mail platform are scenario placeholders. No real mail was received.

## 1. What the documents say about reporting

- POL-IR-01 section 7.1: every member of staff reports suspected incidents immediately "to the security mailbox or the on-call number".
- Communication plan IC-I-04: the same; "neither exists yet; until then, directly to the CISO using an established contact; this document supplies no live contact endpoint".
- POL-AUP-01 section 3: report suspicious prompts to Security Operations or the CISO through the communication plan; "a missing monitored reporting channel is an open gap".
- Communication plan section 4: no security mailbox, no on-call number, no out-of-band channel. GitHub issues are public and "not a security channel".

So the documented route on the scenario date is "directly to the CISO using an established contact". No contact is named anywhere in the documents.

## 2. Timeline (scenario)

| Time | Event | Who |
|---|---|---|
| 09:12 | A mail arrives: "Document waiting for your signature", from a look-alike of a supplier name, with a link | |
| 09:20 | EMP-022 opens it and clicks the link. A page that looks like a company sign-in appears. She stops because the address bar looks wrong. She does not enter anything | EMP-022 |
| 09:24 | She does not know where to report. She remembers the training slide that says "tell security". She sends a direct chat message to EMP-002 with a screenshot | EMP-022 |
| 09:31 | EMP-002 reads it between meetings. She asks EMP-005 to take it | EMP-002 |
| 09:50 | EMP-005 opens a ticket. Triage per POL-IR-01 section 7.2: what is the event, which data, which systems | EMP-005 |
| 10:05 | EMP-020 examines the headers and link from the screenshot and the forwarded mail. The link leads to a page that asks for a username and password. The sender domain is newly registered (scenario) | EMP-020 |
| 10:20 | EMP-013 uses the mail platform's administrator search (assumed to exist in the scenario) to find the same message. 6 recipients: EMP-022, EMP-009, EMP-010, EMP-016, EMP-024, EMP-018 | EMP-013 |
| 10:35 | EMP-013 removes the message from all six mailboxes. Before removal EMP-020 saves the message headers and the link text (not the page) into the incident folder | EMP-013, EMP-020 |
| 10:50 | EMP-020 asks the other five by chat whether they opened or clicked. EMP-009 and EMP-010 opened it. Nobody else clicked. EMP-018 had it in the junk folder | EMP-020 |
| 11:10 | EMP-013 checks the Entra sign-in log for EMP-022 and the other two for sign-ins from unfamiliar places in the last 2 hours. **The free tier keeps 7 days of sign-in data and shows no risk detections** (scenario value for the limits stated in STD-LOG-01 section 4). No unusual sign-in seen | EMP-013 |
| 11:20 | Decision by EMP-005: **event, not an incident.** No credentials entered, no execution, no data affected. EMP-022 changes her password as a precaution | EMP-005 |
| 11:30 | The domain is added to the mail block list (scenario) | EMP-013 |
| 2026-05-07 14:00 | EMP-005 thanks EMP-022 in person and tells her what happened. This is 28 hours after the report | EMP-005 |

## 3. Triage record

| Field | Content |
|---|---|
| Event ID | EVT-2026-001 (scenario number; no event register exists) |
| Reported by, route | EMP-022, direct chat message to the CISO |
| Time from first sight (09:12) to first report (09:24) | 12 minutes |
| Time from report to someone acting | 26 minutes (09:24 to 09:50) |
| Classification | Event, not an incident. Reason: no credentials entered, no compromise found, scope limited to one mail. Entra log limits noted |
| Customer data or personal data | None involved |
| Actions | Message removed; headers kept; block list; password changed; reporter informed |
| Lessons | No new rule. Two findings below |

## 4. Why this walk does not raise A.6.8

The report reached the right people because EMP-022 knew EMP-002 and trusted her to read the chat. The documents did not tell her where to go, and the plan says it supplies no live endpoint. A shy new joiner, a person on leave or a message sent while EMP-002 was in a meeting would have waited. The written design says "mailbox or on-call number". Neither exists. The interim route ("directly to the CISO using an established contact") is a single person's attention, and nothing in the design measures how long it takes. The Statement of Applicability rules that a walk whose own findings show the reporting channel does not exist does not raise the row. This walk shows that. A.6.8 stays Designed.

## Findings

1. **No named contact in the interim route.** IC-I-04 says "using an established contact" and names none. Staff chose the person they knew. Name a person and a deputy, with a way to reach them out of hours, until the mailbox exists.
2. **No event register.** POL-IR-01 section 10 gives a record template for incidents. A reported event that turns out not to be an incident has no home. EVT-2026-001 is a number made up for this walk. This repeats [SIM-INC-006](SIM-INC-006-t4-incident-and-breach-log.md) finding 4.
3. **No time target for acknowledging a staff report.** POL-IR-01 section 7.2 has a 30-minute triage target for SEV 1 and 2. A report of an event has no target. Here 26 minutes passed before action, by luck.
4. **No feedback to the reporter.** The plan and POL-AUP-01 encourage good-faith reporting but do not say that the reporter is told the result. EMP-022 heard 28 hours later.
5. **No rule on who may remove a message from other people's mailboxes.** EMP-013's removal from six mailboxes is a use of an administrator tool. No document says who may use it or how it is logged (this touches A.8.18).
6. **Log limits decide what can be checked.** STD-LOG-01 section 4 says the Entra Free tier keeps 7 days and the export is Planned. A report made on day 8 could not be checked for sign-ins.
7. **No simple instruction for staff.** The training programme says "tell security" but gives no steps ("do not delete, forward the mail as an attachment, do not click again"). POL-IR-01 section 7.1 says do not delete, which conflicts with a user who deletes a phishing mail as a habit.
8. **Communication plan is inconsistent about the disclosure channel.** Section 4 says there is no `SECURITY.md`; section 6 (version 1.1) says `SECURITY.md` exists with a placeholder address. The repository has the file. Section 4 is stale (real observation of the documents on 2026-11-10).

## What this does not show

- No mail, link, page or sender exists. No platform administrator search was run.
- That a real reporter would use the chat. This is how the scenario chose to run.
- A phishing mail that succeeded. The scenario has no credential entered and no compromise.
- Any statement by a mail provider or by the owner of the look-alike domain.
- That the six-recipient search is possible on the real mail platform. The platform is not named in the repository.
