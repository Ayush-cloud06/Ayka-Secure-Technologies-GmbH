# SIM-RISK-001 Risk review and risk acceptance minutes

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-RISK-001 |
| Authored | 2026-11-10 |
| Scenario date | 2026-03-16 |
| Participants | EMP-001 (Managing Director, Risk Acceptance Authority), EMP-002 (CISO, method owner), EMP-018 (Governance & Risk Analyst, presenter and minutes) |
| Procedure exercised | [Risk management methodology](../../../ISMS/03-risk-management/risk-management-methodology.md) sections 4.5 to 4.7; [risk criteria](../../../ISMS/03-risk-management/risk-criteria.md) sections 4, 6, 7; [risk acceptance log](../../../ISMS/03-risk-management/risk-acceptance-log.md) acceptance rule |
| Controls | ISO/IEC 27001:2022 clauses 6.1.2, 6.1.3 e) and f), 8.2, 8.3; SOC 2 RA-01, RA-04, MO-03 |

## 1. Inputs

- [Risk register](../../../ISMS/03-risk-management/risk-register.md) version 1.0, RISK-001 to RISK-013, current residual scores as written.
- [Risk treatment plan](../../../ISMS/03-risk-management/risk-treatment-plan.md) version 1.0, approved on 2026-03-02 (SIM-GOV-001 D-05).
- Proposals in the acceptance log: ACC-2026-001 (RISK-008) to ACC-2026-004.

## 2. Rule applied

EMP-018 read the tolerance table aloud before the walk:

- Low: CISO may accept.
- Medium: time-limited acceptance by CISO and risk owner.
- High: exception only. Managing Director, CISO and risk owner. Written business rationale, maximum 90-day review, treatment plan, and an explicit consequence acknowledgment.
- Critical: never accepted for normal operation. Avoid the activity or reduce the risk.

High risks must have treatment defined within 10 working days, so by **2026-03-30**.

## 3. Risk-by-risk decisions

| Decision | Risk | Current residual | Proposal | Scenario decision | Resulting status |
|---|---|---:|---|---|---|
| D-01 | RISK-001 Entra bootstrap passwords in Git history | 15 High | None | Acceptance refused by EMP-001. No business reason to live with an exposed credential. TRT-001 starts now: inventory without secrets by 2026-03-30 | Stays Awaiting external action |
| D-02 | RISK-002 Terraform state custody | 20 Critical | None | Not eligible. Live apply and scheduled drift stay prohibited | Open; activity avoided |
| D-03 | RISK-003 IAM boundaries and ABAC unverified | 15 High | EMP-018 proposed an exception "until identity roots are deployed" | **Refused** by EMP-001. "Not deployed yet" is a reason to avoid deployment, not a business reason to accept the risk. TRT-003 stays a gate before deployment | Stays Treating |
| D-04 | RISK-004 Joiner/mover/leaver authority contradictions | 16 Critical | None | Not eligible. EMP-002 asks EMP-011 for a manual leaver checklist as an interim measure by 2026-03-30 | Open |
| D-05 | RISK-005 Unprotected main and self-approval | 16 Critical | None | Not eligible. POL-CHG-01 section 10 compensating review applies (SIM-GOV-001 R-05) | Stays Treating |
| D-06 | RISK-006 Silent log delivery failure | 12 High | None | Acceptance not requested. Constraint: no statement that logging operates | Stays Treating |
| D-07 | RISK-007 Transient, same-pipeline evidence | 12 High | EMP-002 proposed an exception while the storage budget is decided | **Accepted as a High exception**, scenario decision by EMP-001 with EMP-002. Rationale: paid storage outside GitHub is not funded this quarter. Compensating safeguard: GitHub artifact retention of 90 days and SHA-256 manifests. Consequence acknowledged: evidence older than 90 days will be lost and cannot be re-shown to an auditor. Review due **2026-06-12** (within 90 days). Risk owner: see Finding 1 | Accepted until 2026-06-12, then review |
| D-08 | RISK-008 Plan-only workload mistaken for deployed | 8 Medium | Proposal ACC-2026-001 | **Accepted, time-limited**, scenario decision by EMP-002 as CISO and as co-owner of the risk. EMP-001 noted it. Conditions as in the ACC-2026-001 conditions list. Expiry **2026-09-16** | Monitored; accepted until 2026-09-16 |
| D-09 | RISK-009 Untreated scanner findings | 16 Critical | None | Not eligible. TRT-009 stays a gate before deployment readiness | Open |
| D-10 | RISK-010 Missing operating records | 12 High | None | Acceptance refused. This year's plan (access review, supplier review, incident exercise, audit, management review) is the treatment | Stays Open, treatment scheduled |
| D-11 | RISK-011 Region and privacy statements inconsistent | 12 High | None | Acceptance refused. No personal data may enter the workload design or its fixtures until G09 is closed | Stays Open |
| D-12 | RISK-012 Unsafe bootstrap order | 15 High | None | Acceptance not requested. Live apply avoided | Stays Open |
| D-13 | RISK-013 Emergency access untested | 15 High | None | Acceptance refused. Break-glass exercise to be planned with the DR tabletop (SIM-BCP-001) | Stays Open |

Result: 2 acceptances (one Medium, one High exception), 11 refusals or not eligible. 4 Critical risks stay outside tolerance with the activity avoided.

## 4. Proposals ACC-2026-002 to ACC-2026-004

These were already "do not accept" proposals. The meeting confirmed them as scenario decisions by EMP-001. Nothing changed.

## 5. Next review

Quarterly, per the methodology. Next risk review due by **2026-06-12**, the same day as the D-07 review. Owner: EMP-002.

## Findings

1. **Risk owners are roles nobody holds.** D-07 needs "Managing Director, CISO and risk owner". The owner of RISK-007 is "Assurance owner / CISO". "Assurance owner" exists in no role document. The meeting could only go ahead because the CISO is named as co-owner. The register needs an EMP ID or a role from the roles document for every owner.
2. **The two-person rule collapses when the CISO co-owns the risk.** For D-08, the criteria need "CISO and risk owner". RISK-008's owner is "Repository owner / CISO". One person filled both seats. The criteria should say that the CISO cannot be the second authority for a risk the CISO owns.
3. **No maximum term for Medium acceptance.** High has 90 days. Medium has "time-limited" with no ceiling, so D-08 could have been set for years. Add a ceiling, for example 12 months.
4. **No owner for expiry tracking.** The acceptance log records expiry dates but nobody is named to act on them. Nothing in the methodology raises an alert before 2026-06-12 or 2026-09-16. (The October audit found both dates passed without review: SIM-AUD-003.)
5. **The "10 working days" rule has no output.** The criteria say High treatment must be "defined" within 10 working days. They do not say what "defined" means: a dated plan row, an owner, or evidence. The treatment plan uses due gates, not dates, so the rule cannot be checked.

## What this does not show

- No meeting took place. The participants are roles in the fictional personnel register.
- The register, criteria and treatment plan are used as their text stands on the Authored date (2026-11-10) and treated as in force at the scenario date. Facts in the register dated after 2026-03-16 (for example the 2026-09-28 source fix for RISK-001 and the 2026-10-05 GitHub ruleset) were not used for these decisions.
- The real [risk acceptance log](../../../ISMS/03-risk-management/risk-acceptance-log.md) still has no effective acceptance. That is correct. This record does not change it.
- No risk was rescored. No treatment was completed.
