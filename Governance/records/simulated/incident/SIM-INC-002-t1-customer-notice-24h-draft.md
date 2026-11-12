# SIM-INC-002 T-1 customer incident notice (24 h), draft never sent

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-INC-002 |
| Authored | 2026-11-10 |
| Scenario date | 2026-08-13 (drafted 2026-08-12 17:00 UTC, approved 2026-08-13 07:45 UTC, would have been sent 14:40 UTC) |
| Participants | EMP-005 (drafted), EMP-004 (privacy wording), EMP-001 (approved, scenario decision), EMP-010 (sender) |
| Procedure exercised | [NIS2-03](../../../NIS2/03-incident-reporting-procedure.md) section 5 (24 h customer notice), section 6 (Art. 33(2)), template T-1 |
| Controls | ISO/IEC 27001:2022 Annex A A.5.24, A.5.26; SOC 2 OP-06, IC-02; GDPR Art. 28(3)(f), 33(2) |

Parent incident: INC-2026-001 (SIM-INC-001). **DRAFT. NEVER SENT.** The recipient is fictional.

## 1. Filled template

```text
Subject: [Ayka Security Notice] Your onboarding user list was exposed in our public code repository – 2026-08-13

Incident reference:   AYK-INC-2026-001
Status:               Contained
Detected:             2026-08-12, 09:40 UTC (reported internally); confirmed 11:30 UTC
Services affected:    None in operation. Affected: Ayka's public source repository and its build logs
Your data affected:   Yes – the onboarding list you sent on 2026-08-04:
                      137 rows with full name, business e-mail, job title,
                      department and intended portal role. No passwords.
Suspected malicious:  No. An Ayka engineer used the file as test data by mistake.
What happened:        On 2026-08-10 at 15:58 UTC an Ayka engineer committed your list to a
                      pull request in Ayka's public repository. A test failure printed six
                      rows into a public build log. We cannot tell whether anyone
                      outside Ayka opened the file or the log.
What we have done:    Deleted both build logs (2026-08-12 12:40 UTC). Closed the pull
                      request and asked the repository host to remove the remaining
                      reference. We are deleting all internal copies today. Our
                      evidence record holds a hash of the file, not the data.
What you should do:   As controller, please assess your notification duties under
                      GDPR Art. 33 and 34. We suggest warning the listed staff about
                      targeted phishing. Tell us of any phishing you see.
Next update:          2026-08-15, 11:30 UTC at the latest
Contact:              Incident Coordinator, Security Operations, <phone>, <e-mail>
```

## 2. Clock check

| Item | Due | Actual | Result |
|---|---|---|---|
| Customer notice (NIS2-03, Ayka commitment) | 2026-08-13 11:30 UTC (T0 + 24 h) | 2026-08-13 14:40 UTC | **Missed by 3 h 10 min** |
| Customer notice (POL-IR-01 section 8) | 2026-08-14 11:30 UTC (48 h) | 2026-08-13 14:40 UTC | Met |
| Art. 33(2) "without undue delay" | No fixed hour | 27 h 10 min after T0 | Delay caused by the missing security contact, not by the facts |

The text was ready at 07:45. The 7 hours after that were spent finding out who at Customer A (fictional) should receive it.

## Findings

1. **T-1 has no field for the controller's duties.** When Ayka is processor, the notice must tell the controller what it needs for its own Art. 33 decision (categories, number of people, likely consequences, measures). T-1 has "Your data affected" only. Add the Art. 33(3) items.
2. **"Detected" is ambiguous.** T-1 asks for "Detected" but the clocks run from awareness (T0). Ask for both.
3. **No field for what is unknown.** "We cannot tell whether anyone opened the file" had to go into "What happened". Add "Not known yet".
4. **Approval step not in the template.** NIS2-03 section 2 says the MD approves notices that admit a breach of contract. T-1 has no "approved by / at" line, so the 7-hour approval wait is not visible on the notice itself.

## What this does not show

- No notice was sent. No customer exists. The phone and e-mail placeholders are left blank on purpose.
- NIS2-03 is used as its text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
