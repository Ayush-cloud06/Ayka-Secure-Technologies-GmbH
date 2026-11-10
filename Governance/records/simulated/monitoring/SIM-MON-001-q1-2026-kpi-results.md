# SIM-MON-001 Q1 2026 KPI and monitoring results

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-MON-001 |
| Authored | 2026-11-10 |
| Scenario date | 2026-04-08 |
| Participants | EMP-018 (Governance & Risk Analyst, collector), EMP-004 (Compliance Analyst, denominator check), EMP-002 (CISO, challenge and receipt) |
| Procedure exercised | [ISMS KPIs and metrics ISMS-MON-01](../../../ISMS/08-monitoring-and-measurement/kpis-and-metrics.md) sections 1, 2 and 4 |
| Controls | ISO/IEC 27001:2022 clauses 6.2, 9.1; Annex A A.5.36; SOC 2 CE-06, MO-01, CM-02, CM-05 |

## 1. Measurement frame

- Period: 2026-01-01 to 2026-03-31. Cutoff 2026-03-31 23:59 CET.
- The ISMS was approved on 2026-03-02 (SIM-GOV-001). Process metrics count from that date. Gate metrics count the whole quarter, because the pipeline ran all quarter.
- Gate numbers below marked "scenario value" are plausible values inside the fiction. They were not read from GitHub.
- Rule from section 1: missing evidence is **Not measured**, never zero. A zero denominator gives no percentage.

## 2. Results

| Metric | Numerator / denominator | Result | Target | Note and action |
|---|---|---|---|---|
| M-01 Gate evidence completeness | 41 / 41 workload assessments (scenario value) | 100 % | 100 % | Met. Regression fixtures excluded as the definition requires |
| M-02 CI checks completed | 50 / 50 jobs in 10 sampled `main` runs (scenario value) | 100 % of sample | 5/5 per run | Met in sample. Sample of 10 picked by EMP-018, one per week; no period-wide claim |
| M-03 Independent change review | 0 / 14 sampled merged PRs reviewed by someone other than the author (scenario value) | 0 % | 100 % before live operation | **Missed.** The POL-CHG-01 section 10 monthly Managing Director review for March 2026 is not recorded. Owner: EMP-002 to raise with EMP-001 |
| M-04 Access-review completion | No review due | Not applicable | 100 % | Reason: first quarterly review falls in Q2 (ISMS approved 2026-03-02). Reviewed by EMP-002 |
| M-05 Vulnerability remediation | 0 findings due in period | No percentage (zero denominator) | 100 % | 6 LOW active and 14 excepted gate findings in ayka-portal (scenario value). None has a policy due date in Q1 |
| M-06 Restore effectiveness | — | not measurable: no deployed system | 100 % | No database or bucket exists to restore |
| M-07 Supplier review completion | No Critical/High review due | Not applicable | 100 % | First annual review scheduled 2026-07-06 (SIM-GOV-001 R-03) |
| M-08 Training completion | — | Not measured in this record | 100 % | Training records belong to the people area (SIM-PPL series, other author). Not copied here |
| M-09 Corrective-action effectiveness | 0 actions due | No percentage (zero denominator) | 100 % | No corrective action existed in Q1 |
| M-10 Gate mapping traceability | 38 / 38 gate control IDs with ISO references | 100 % | 100 % | Structural count only. It does not measure Annex A implementation |

## 3. Objectives with a direct measure

| Objective | Result | Note |
|---|---|---|
| OBJ-03 Independent change approval | 0 % (same sample as M-03) | Missed |
| OBJ-04 MFA for all privileged access | Not measurable: no tenant export | Licence deferred (SIM-GOV-001 R-04). Design default `enable_conditional_access = false` in [`entra-id/variables.tf`](../../../../Internal-IT/platform/domains/identity/entra-id/variables.tf) |
| OBJ-09 Only the approved EU Region | 11 files name `ap-south-1` (10 Terraform, 1 SCP) | Missed. Target is 0 files. See [`ayka-portal/variables.tf`](../../../../Internal-IT/workloads/ayka-portal/variables.tf) |
| OBJ-10 Fixed risk cycle | First review held 2026-03-16 (SIM-RISK-001) | Next due 2026-06-12 |

## 4. CISO challenge

EMP-002 asked two questions. Who picked the 10 runs, and could a failed run be missing? Answer: EMP-018 picked one per week; the method is in section 1. Why is M-03 not escalated? Answer: the procedure says "operational owners investigate missed thresholds" but names no owner for M-03 beyond Compliance & Risk Management, who only measure it. EMP-002 took the action herself: raise the March review with EMP-001 by 2026-04-30.

## Findings

1. **No escalation owner for a missed threshold.** Section 1 says "operational owners investigate missed thresholds". M-03 has Compliance & Risk Management as owner, which collects but cannot fix. Add an "action owner" column to the metric table.
2. **No due date for the quarterly presentation.** Section 1 says results are presented "quarterly". It does not say by when after quarter end. This record came 8 days after cutoff; nothing would have flagged 80 days.
3. **Gate metrics and process metrics have different start dates.** The procedure does not say whether a metric counts from ISMS approval or from the start of the period. This record had to decide (section 1).
4. **Sample selection for M-02 and M-03 is not defined.** The definitions say "sampled" without a method or size. Two collectors could report different numbers for the same quarter.

## What this does not show

- No measurement was taken. Gate values marked "scenario value" are invented inside the fiction. Only M-10 (38/38) and the OBJ-09 file count match real repository counts, and those were observed on 2026-10-14, not in Q1.
- The KPI document is used as its text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
- Nothing here shows that any control operates.
