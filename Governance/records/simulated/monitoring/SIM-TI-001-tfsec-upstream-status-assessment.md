# SIM-TI-001 Threat intelligence assessment: tfsec upstream status

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-TI-001 |
| Authored | 2026-11-10 |
| Scenario date | 2026-05-20 |
| Participants | EMP-017 (Junior Security Analyst, noticed the source), EMP-005 (Security Operations, relevance and decision), EMP-013 (DevOps Engineer, component owner) |
| Procedure exercised | [Threat intelligence procedure](../../../ISMS/06-operational-procedures/threat-intelligence-procedure.md) sections 2 to 4 |
| Controls | ISO/IEC 27001:2022 Annex A A.5.7, A.8.8, A.5.21; SOC 2 OP-01, AC-14 |

## 1. Assessment record (section 4 fields)

| Field | Content |
|---|---|
| Date and reviewer role | 2026-05-20, Security Operations (EMP-005) |
| Source | Upstream project notice that tfsec is being folded into Trivy. The repository [README](../../../../README.md) section 6 already states this. No URL was retrieved in the fiction; the real notice was not re-read for this record |
| Component | tfsec `1.28.14`, pinned in [`toolchain.versions`](../../../../Internal-IT/engineering/ci-cd/toolchain.versions); one of the three scanners the gate needs |
| Decision | No vulnerability is reported, so no finding. Risk: if tfsec stops getting rule updates, new AWS misconfigurations will not be detected by it. Checkov and OPA still run. Decision: **change**, plus a risk-register note |
| Destination | Change proposal to evaluate Trivy's configuration scanner as the replacement, owner EMP-013, due 2026-09-30. Risk note under RISK-009 (scanner coverage). No pull request yet |
| Residual | tfsec stays pinned. Its rule set ages each month the change waits. The gate's fail-closed evaluator still stops a run if tfsec output is missing |

## 2. Timing against the procedure

- Notice: EMP-017 saw it on 2026-05-19 and sent it to EMP-005 the same day. Met.
- Relevance: due within two working days, by 2026-05-21. Decided 2026-05-20. Met.
- Weekly review of advisories for pinned tools: this is the **first** one since the ISMS was approved on 2026-03-02. Eleven weekly reviews before it were not held.

## Findings

1. **"Weekly review" has no owner, day or record.** Section 3 calls the weekly advisory review "the standing requirement" but names no person or weekday and no place to log a "nothing found" week. Missed weeks are invisible. Name the reviewer role, the day and the log.
2. **Sources have no addresses.** Section 2 names source types, not feeds or URLs. EMP-017 found this notice by chance in a project changelog.
3. **"Restricted storage" is undefined.** Section 4 says to write assessments in restricted storage but does not name it. This record had nowhere to go but the simulated store.
4. **End-of-life is not a listed outcome.** The decision list (no change, finding, change, risk update, incident) fits vulnerabilities. A tool going unmaintained needed two outcomes at once. Allow more than one destination.

## What this does not show

- No assessment was made by anyone. The tfsec status comes from the real README, not from a fresh read of the upstream notice.
- The procedure is used as its text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
- No change was opened and no Trivy test was run.
