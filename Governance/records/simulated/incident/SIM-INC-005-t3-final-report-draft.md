# SIM-INC-005 T-3 final report (one month), draft never sent

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-INC-005 |
| Authored | 2026-11-10 |
| Scenario date | 2026-09-14 |
| Participants | EMP-005 (drafted), EMP-004 (privacy review), EMP-002 (IC, approved), EMP-001 (approved customer version, scenario decision), EMP-010 (customer version sender) |
| Procedure exercised | [NIS2-03](../../../NIS2/03-incident-reporting-procedure.md) section 5 (final report, customer closing report), template T-3 |
| Controls | ISO/IEC 27001:2022 Annex A A.5.26, A.5.27; clause 10.2; SOC 2 OP-06, OP-07; GDPR Art. 33(2) |

Parent incident: INC-2026-001 (SIM-INC-001). **DRAFT. NEVER SENT.** Due one month after the 72 h update of 2026-08-14, so 2026-09-14. Ready on 2026-09-14. Met. Only the customer summary would have gone out; no BSI version exists, because no BSI report was made.

## 1. Filled outline

**1. Summary and timeline.** On 2026-08-10 at 15:58 UTC an engineer committed Customer A's (fictional) onboarding list to a public pull request. A failing test printed six rows to the public CI log at 16:07. A reviewer noticed on 2026-08-12 at 09:40. Awareness (T0) 11:30. Logs deleted 12:40. Copies deleted 2026-08-13. Work resumed on synthetic data 2026-08-14. Watch period ended 2026-08-28 with no phishing reported by the customer.

**2. Severity and impact.** SEV 2. 137 people, contact and job data. Not significant against NIS2-03 S-1 to S-9. No evidence of outside access; outside access cannot be ruled out.

**3. Root cause.** Real customer data used as test data, against STD-MSK-01 and SOC 2 CO-05. No route for handling customer onboarding files. No automated check for personal data in fixtures. No detection or alerting.

**4. Mitigation applied and ongoing.**

| Item | State on 2026-09-14 |
|---|---|
| CI fixture check (SIM-CHG-001) | Merged 2026-08-27. Blocks non-reserved e-mail domains in test fixtures |
| Onboarding file route (SIM-CAPA-003) | In progress, due 2026-09-30 |
| Customer security contact at contract signature (SIM-CAPA-004) | In progress, due 2026-09-30 |
| Single customer deadline in POL-IR-01 and NIS2-03 (SIM-CAPA-004) | In progress, due 2026-09-30 |
| Removal of the pull-request ref | **Open.** Requested 2026-08-12. Not confirmed |

**5. Cross-border impact.** None known.

**6. Lessons and corrective actions.** Post-incident review on 2026-08-25 (SIM-IMP-001). Corrective actions SIM-CAPA-003 and SIM-CAPA-004.

## 2. Clock summary for INC-2026-001

| Clock | Due | Done | Result |
|---|---|---|---|
| Initial assessment, under 4 h from first sight by the coordinator (10:05) | 2026-08-12 14:05 | T0 at 11:30 | Met |
| Customer notice, 24 h | 2026-08-13 11:30 | 2026-08-13 14:40 | **Missed** |
| Customer update, 72 h | 2026-08-15 11:30 | 2026-08-14 16:30 | Met |
| Final report, 1 month after 72 h update | 2026-09-14 | 2026-09-14 | Met |
| SEV 2 management update every 4 h | Rolling | 12.5 h gap overnight | **Missed** |
| Evidence before clean-up (POL-IR-01 section 7.5) | Before any deletion | Branch deleted before capture | **Missed** |
| Post-incident review, 10 business days | 2026-08-26 | 2026-08-25 | Met |

## Findings

1. **"One month" has two readings.** NIS2-03 section 5 says one month after the 72 h notification. For the customer, the 72 h item is an update Ayka chose to send. If no 72 h update is sent, the customer closing report has no start date. Fix the customer clock to T0.
2. **T-3 has no "open items at report time" field.** The ref removal is still open. T-3 item 4 says "mitigation applied and still ongoing", which hides the difference between work in progress and work blocked on a third party.
3. **No approval rule for the final report.** NIS2-03 says who sends it, not who approves it. The IC and MD both approved here to be safe.

## What this does not show

- Nothing was sent. No customer exists.
- NIS2-03 is used as its text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
- The CI fixture check is a simulated change (SIM-CHG-001). It does not exist in the repository.
