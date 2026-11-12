# SIM-INC-004 T-1 customer update (72 h), draft never sent

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-INC-004 |
| Authored | 2026-11-10 |
| Scenario date | 2026-08-14 (drafted 16:00 UTC, would have been sent 16:30 UTC) |
| Participants | EMP-005 (drafted), EMP-004 (Art. 33(3) content), EMP-002 (IC, approved), EMP-010 (sender) |
| Procedure exercised | [NIS2-03](../../../NIS2/03-incident-reporting-procedure.md) section 5 (72 h step, applied to the customer), section 6, template T-1 |
| Controls | ISO/IEC 27001:2022 Annex A A.5.26; SOC 2 OP-06; GDPR Art. 28(3)(f), 33(2), 33(3) |

Parent incident: INC-2026-001 (SIM-INC-001). **DRAFT. NEVER SENT.**

NIS2-03 has no customer step at 72 h; its 72 h step is for the BSI. The IC used T-1 again so the customer had an update at the same point. The deadline was T0 + 72 h = 2026-08-15 11:30 UTC, a Saturday. It was sent on the Friday.

## 1. Filled template

```text
Subject: [Ayka Security Notice] Update 1 – exposure of your onboarding user list – 2026-08-14

Incident reference:   AYK-INC-2026-001
Status:               Contained; removal of one remaining reference pending with the repository host
Detected:             2026-08-12, 09:40 UTC; confirmed 11:30 UTC
Services affected:    None in operation
Your data affected:   Yes – 137 people: full name, business e-mail, job title, department,
                      intended portal role. No special categories, no credentials.
Suspected malicious:  No
What happened:        Unchanged from our notice of 2026-08-13. New: the file was reachable in the
                      public pull request from 2026-08-10 15:58 UTC. The six log rows were public
                      from 16:07 UTC until we deleted the logs on 2026-08-12 12:40 UTC.
                      We have no evidence that anyone outside Ayka accessed them. We also
                      cannot rule it out: the host does not show who viewed a public page.
What we have done:    All internal copies deleted on 2026-08-13. Import work now uses
                      synthetic data only. A build check that blocks real e-mail
                      addresses in test files is being added.
Likely consequences:  Targeted phishing or pretexting against the listed staff,
                      using their name, employer and job title. We consider high risk
                      to them unlikely; this is our view to support your decision.
What you should do:   Your Art. 33 deadline runs from your own awareness (2026-08-13 14:40 UTC).
                      Please tell us of any phishing you see until 2026-08-28.
Next update:          Final report by 2026-09-14
Contact:              Incident Coordinator, Security Operations, <phone>, <e-mail>
```

## 2. Clock check

| Item | Due | Actual | Result |
|---|---|---|---|
| 72 h customer update | 2026-08-15 11:30 UTC | 2026-08-14 16:30 UTC | Met |

## Findings

1. **No customer step at 72 h.** NIS2-03 section 5 gives customers a 24 h notice and a one-month summary, nothing between. For a processor, the controller needs Art. 33(3) facts before its own 72 h end. Add a customer update at 72 h.
2. **Weekend deadlines are not addressed.** The 72 h point fell on a Saturday. Neither document says whether deadlines move or who works the weekend.
3. **"Likely consequences" is not a T-1 field.** It had to be added by hand. See SIM-INC-002 finding 1.

## What this does not show

- Nothing was sent. No customer exists.
- NIS2-03 is used as its text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
