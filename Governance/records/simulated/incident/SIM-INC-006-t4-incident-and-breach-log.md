# SIM-INC-006 T-4 incident and breach log

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-INC-006 |
| Authored | 2026-11-10 |
| Scenario date | 2026-09-15 (row closed). Row opened 2026-08-12 |
| Participants | EMP-005 (log keeper), EMP-004 (GDPR fields), EMP-002 (closure) |
| Procedure exercised | [NIS2-03](../../../NIS2/03-incident-reporting-procedure.md) sections 3, 6 and template T-4 |
| Controls | ISO/IEC 27001:2022 Annex A A.5.25, A.5.26, A.5.28; SOC 2 OP-06; GDPR Art. 33(5) (as processor support), Art. 30(2) |

**Simulated log. Not the real T-4 table**, which correctly has no entries.

## 1. Log

| Ref | Opened | T0 (awareness) | Summary | Significant (S-ref) | Personal data | Customer notice sent | BSI early warning | BSI notification | GDPR Art. 33 | Final report | Closed | Owner |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| AYK-INC-2026-001 (INC-2026-001) | 2026-08-12 10:12 UTC | 2026-08-12 11:30 UTC | Customer A (fictional) onboarding list (137 people) committed to a public pull request; 6 rows printed to a public CI log | No (S-3 not met: not malicious; S-4 arguable, decided not met) | Yes. Ayka processor; Customer A controller | 2026-08-13 14:40 UTC, **24 h missed by 3 h 10 min** (draft, never sent; SIM-INC-002). Update 2026-08-14 16:30 UTC (SIM-INC-004) | Not submitted: not in scope, voluntary report declined (SIM-INC-003) | Not submitted (SIM-INC-003) | Art. 33(2) to controller via the customer notice. No Art. 33(1) by Ayka; reason recorded in SIM-INC-001 section 3; legal review on Art. 28(10) not received | 2026-09-14, customer summary only (SIM-INC-005) | 2026-09-15 16:00 UTC, one action open (ref removal) | EMP-005 |

## 2. Second entry considered

On 2026-08-12 EMP-004 asked whether the deleted CI logs, which also hold GitHub usernames of staff (PA-02, Ayka as controller), make a second breach. Decision by EMP-004: no. The usernames were already public in the repository by design and nothing new was disclosed. Logged here so the "not a breach" reasoning is kept.

## Findings

1. **No column for the reason not to notify.** POL-IR-01 section 8 and GDPR Art. 33(5) both expect the reasoning to be kept. The T-4 columns hold dates only. The reasoning sits in other files.
2. **No column for processor/controller role.** The GDPR Art. 33 column cannot say "processor: notified controller" without free text. Add a role column.
3. **No row for events judged "not an incident" or "not a breach".** Section 2 above had nowhere to go. Art. 33(5) and good practice keep these too. Allow "not a breach" rows.
4. **The log keeper is not named.** NIS2-03 section 3 says the Incident Coordinator writes T0 in the log, but nothing says who closes a row or checks it is complete.

## What this does not show

- No incident took place. The real T-4 log in NIS2-03 has no entries, and that is correct.
- NIS2-03 is used as its text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
