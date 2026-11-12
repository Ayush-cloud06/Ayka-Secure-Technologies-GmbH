# SIM-INC-003 T-2 BSI early warning and notification fields, prepared for the drill and not submitted

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-INC-003 |
| Authored | 2026-11-10 |
| Scenario date | 2026-08-12 (early-warning fields, 15:30 UTC); 2026-08-14 (notification fields, 15:00 UTC) |
| Participants | EMP-005 (prepared), EMP-002 (decision not to report) |
| Procedure exercised | [NIS2-03](../../../NIS2/03-incident-reporting-procedure.md) sections 4 and 5, template T-2 |
| Controls | ISO/IEC 27001:2022 Annex A A.5.5, A.5.26; SOC 2 OP-06; NIS2 Art. 23(4) (voluntary use, Ayka out of scope) |

Parent incident: INC-2026-001 (SIM-INC-001). **NOT SUBMITTED.** Ayka is not a NIS2 entity and EMP-002 declined a voluntary report on 2026-08-12 at 15:00 UTC. The fields were filled to test whether the 24 h and 72 h answers could be produced in time.

## 1. Filled field list

| Field | Early warning (would be due 2026-08-13 11:30 UTC) | Notification (would be due 2026-08-15 11:30 UTC) |
|---|---|---|
| Entity, registration number, 24/7 contact | Ayka Secure Technologies GmbH (fictional). **No registration number** (not registered). **No 24/7 contact** | Same gaps |
| Awareness time (T0) and detection method | 2026-08-12 11:30 UTC. Staff member noticed during code review | Unchanged |
| Suspected unlawful or malicious cause | No. Accidental use of customer data as test data | Unchanged |
| Possible cross-border impact | Not known. Repository is public worldwide; the 137 people work for one German customer (fictional) | Not known; no evidence of access |
| Services and Member States affected | No service in operation. Germany | Germany |
| Severity and impact assessment | — | One customer, 137 people, contact data only. Not significant against S-1 to S-9 |
| Indicators of compromise | — | None. No malicious actor |
| Measures taken | — | Logs deleted; pull request closed; ref removal requested; copies deleted; fixture check planned (SIM-CHG-001) |

| Item | Ready at | Would be due | Result |
|---|---|---|---|
| Early warning fields | 2026-08-12 15:30 UTC | 2026-08-13 11:30 UTC | Ready in time |
| Notification fields | 2026-08-14 15:00 UTC | 2026-08-15 11:30 UTC | Ready in time |

## Findings

1. **Two mandatory fields cannot be filled.** T-2 needs a registration number and a 24/7 contact. NIS2-03 section 8 defers portal access until 40 employees and there is no on-call rota. If Ayka came into scope tomorrow, the early warning could not be submitted. Name the trigger that starts registration, not only a head count.
2. **The submitter role is idle while the incident runs.** NIS2-03 makes the Compliance Officer the submitter. When no report goes out, the procedure gives the role nothing to do, so no one checks the voluntary-report decision. Add "Compliance Officer records the decision not to report".
3. **No field for "decision not to report".** POL-IR-01 section 8 says the reason for every decision not to notify is recorded. T-2 and T-4 have no place for it. This record is the only trace.

## What this does not show

- Nothing was sent to the BSI. Ayka is fictional and not registered.
- NIS2-03 is used as its text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
- The field list is the repository's own preparation list, not the BSI's form.
