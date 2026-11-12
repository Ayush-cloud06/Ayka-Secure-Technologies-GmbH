# SIM-MON-002 Q2 2026 KPI and monitoring results

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-MON-002 |
| Authored | 2026-11-10 |
| Scenario date | 2026-07-08 |
| Participants | EMP-018 (collector), EMP-004 (denominator check), EMP-005 (M-04 owner), EMP-002 (CISO, challenge and receipt) |
| Procedure exercised | [ISMS KPIs and metrics ISMS-MON-01](../../../ISMS/08-monitoring-and-measurement/kpis-and-metrics.md) sections 1, 2 and 4 |
| Controls | ISO/IEC 27001:2022 clauses 6.2, 9.1; Annex A A.5.18, A.5.36; SOC 2 CE-06, AC-07, CM-02, CM-05, MO-03 |

## 1. Measurement frame

- Period: 2026-04-01 to 2026-06-30. Cutoff 2026-06-30 23:59 CEST.
- Same rules and sampling as SIM-MON-001. Values marked "scenario value" are invented inside the fiction.
- The supplier review on 2026-07-06 (SIM-SUP-001) falls in Q3. It is not counted here.

## 2. Results

| Metric | Numerator / denominator | Result | Target | Trend vs Q1 | Note and action |
|---|---|---|---|---|---|
| M-01 Gate evidence completeness | 38 / 38 workload assessments (scenario value) | 100 % | 100 % | Same | Met |
| M-02 CI checks completed | 50 / 50 jobs in 10 sampled `main` runs (scenario value) | 100 % of sample | 5/5 per run | Same | Met in sample |
| M-03 Independent change review | 0 / 12 sampled merged PRs (scenario value) | 0 % | 100 % before live operation | Same | **Missed again.** No monthly MD review recorded for April, May or June. EMP-002's April action (SIM-MON-001 section 4) produced no record |
| M-04 Access-review completion | 144 / 144 rows with a dated decision by someone other than the holder (SIM-ACC-001) | 100 % decided | 100 % and 0 overdue removals | First measure | **1 removal overdue** in the quarter (leaver GitHub seat, 12 days after the disable deadline, SIM-CAPA-001). 1 exception without its compensating control (mover, SIM-CAPA-002). 2 rows still "investigate" |
| M-05 Vulnerability remediation | 0 findings due in period | No percentage (zero denominator) | 100 % | Same | 6 LOW active, 14 excepted (scenario value). No exception expired in Q2 |
| M-06 Restore effectiveness | — | not measurable: no deployed system | 100 % | Same | DR tabletop planned for 2026-09-15 (SIM-BCP-001) |
| M-07 Supplier review completion | No Critical/High review due in Q2 | Not applicable | 100 % | Same | Reason: first annual review set for 2026-07-06 |
| M-08 Training completion | — | Not measured in this record | 100 % | — | Training records belong to the people area (SIM-PPL series, other author) |
| M-09 Corrective-action effectiveness | 0 actions due for effectiveness review | No percentage (zero denominator) | 100 % | — | 2 actions opened on 2026-06-22. Effectiveness checks fall in Q4. 0 overdue |
| M-10 Gate mapping traceability | 38 / 38 | 100 % | 100 % | Same | Structural only |

## 3. Objectives with a direct measure

| Objective | Result | Note |
|---|---|---|
| OBJ-03 Independent change approval | 0 % | Missed two quarters running |
| OBJ-04 MFA for all privileged access | Not measurable: no tenant export | Licence decision still deferred |
| OBJ-07 Access reviews per quarter | 1 review held (SIM-ACC-001) | First one |
| OBJ-09 Only the approved EU Region | 11 files name `ap-south-1` | Missed. No change since Q1 |
| OBJ-10 Fixed risk cycle (at most 92 days) | 114 days since the last risk review on 2026-03-16, measured on 2026-07-08 | **Missed.** The review due 2026-06-12, and the High exception review for RISK-007 due the same day (SIM-RISK-001 D-07), did not happen |

## 4. CISO challenge and response

EMP-002 accepted the results. She noted that OBJ-10 and the RISK-007 review are late and said she would "schedule them". No date and no owner other than herself were recorded. (The October audit found them still not held: SIM-AUD-003.)

## Findings

1. **A missed threshold creates no tracked action.** Section 4 says open a corrective action "only for an evidenced failure against a requirement". M-03 at 0 % for two quarters failed POL-CHG-01 section 10, yet nothing in the procedure turned it into an action with a date. Add: "a missed target in two consecutive periods opens a corrective action".
2. **Trend has no definition.** The management review asks for "trends" but this procedure does not say how many periods, or what counts as a change.
3. **OBJ-10 is measured here but owned elsewhere.** The risk review schedule lives in the methodology; this record can only report the miss. Nobody between the two documents owns the calendar.
4. **The procedure has no step for objectives.** Section 2 lists M-01 to M-10 only. The objectives (OBJ-01 to OBJ-11) carry their own measures, but this procedure does not say to report them. This record added them anyway.

## What this does not show

- No measurement was taken. Values marked "scenario value" are invented inside the fiction.
- The KPI document is used as its text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
- Nothing here shows that any control operates.
