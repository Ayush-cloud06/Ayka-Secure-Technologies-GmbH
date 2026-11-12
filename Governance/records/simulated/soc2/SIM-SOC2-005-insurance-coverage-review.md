# SIM-SOC2-005: Cyber insurance coverage review

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-SOC2-005 |
| Authored | 2026-11-10 (real date) |
| Scenario date | 2026-06-08 |
| Participants | EMP-001 (Managing Director, decides), EMP-016 (Finance & Procurement Officer, gathers inputs), EMP-002 (CISO, control facts), EMP-004 (Compliance Analyst, contract and DPA terms), EMP-009 (Sales Manager, customer contracts) |
| Procedure exercised | [SOC2-08](../../../SOC2/08-control-designs.md#2-governance-people-and-risk) row RM-02 (annual sizing of cover and decision) |
| Controls | SOC 2 RM-02 (CC9.1); no ISO/IEC 27001:2022 mapping (SOC2-02 section 7); related RA-01, OP-06, IC-02 |

## Scenario

EMP-001 asks for the first annual review of cyber cover three weeks after the pilot with Customer A (fictional) began ([SIM-SOC2-002](SIM-SOC2-002-customer-onboarding-security-pack.md), 2026-05-18). The review follows the design step by step. **No insurer, broker, quote, premium, limit or policy is named or invented here.** The result is a list of what any cover would have to satisfy and one open decision.

## 1. Step 1: required limit

The design says the limit is the larger of (a) and (b).

| Input | What the review found |
|---|---|
| (a) Highest liability cap in a customer contract | One contract exists, the pilot with Customer A (fictional). EMP-009 and EMP-004 find that liability is not drafted: [DPA template section 4](../../../GDPR/data-processing-agreement-template.md) says "to be agreed in the main agreement", and no cap figure is held in any Ayka document. Input (a) is **missing**. Whether liability without a cap is limited by law is a question for counsel and is not answered here |
| (b) Severe but plausible loss | The design lists five heads: forensics, legal advice, notifications, customer credits, lost revenue during the 8-hour recovery objective. EMP-016 holds no cost data for any of them: no forensic retainer, no legal engagement, no price list, no revenue forecast. Input (b) is **missing**, and the review does not guess figures |

Result: the required limit cannot be computed. The design says only that sizing needs a customer contract; it does not say what to do when the contract exists but states no cap.

## 2. Step 2: what a quote would be compared against

The design compares a broker quote against the limit, the exclusions and the notice duty. There is no quote, so the review lists the comparison inputs Ayka can already state.

| Comparison | Ayka position on 2026-06-08 |
|---|---|
| Exclusion the design names: missing MFA | MFA is not enforced. Conditional Access is switched off on the Entra ID Free licence (AC-03) |
| Exclusion the design names: unpatched known vulnerabilities | Application scanning is not running (OP-02) and the container image is an unpinned tag (AC-15) |
| Other conditions a cyber policy typically asks about (to verify) | Backups are untested (AV-04), nothing is monitored (OP-05), no incident rota exists. A form that asks "is X in place" must be answered "no" for each; "planned" is not "yes" |
| Notice duty | [Communication plan](../../../ISMS/00-context-and-governance/communication-plan.md) IC-E-12: "per policy terms, Managing Director, none: no policy recorded". NIS2-03 section 7 repeats that no cyber insurance is recorded |
| Forensic provider restrictions | A policy may restrict who can be hired. The incident plan (POL-IR-01) has no named provider, so nothing conflicts today |

## 3. Step 3: decision

The design has two outcomes: a policy schedule, or a decision not to buy cover with the residual risk entered in the [risk acceptance log](../../../ISMS/03-risk-management/risk-acceptance-log.md).

Scenario decision by EMP-001: **neither**. The inputs are missing and the controls an underwriter would ask about are mostly not in place. The decision is deferred and left open, owner EMP-001, to be taken before the pilot becomes a paid contract or before any real customer data enters the portal, whichever is earlier. EMP-016 is to ask the pilot's counterpart what cap, if any, the main agreement will carry. No acceptance entry is written: the risk is neither accepted nor treated, only unreviewed.

## 4. D&O

[NIS2-04 section 6](../../../NIS2/04-management-accountability.md) asks separately whether a directors' and officers' policy exists. None is recorded. EMP-001 notes it as a second open question and does not decide it.

## Findings

Defects in the RM-02 design as written:

1. **Sizing needs a figure the contract does not yet have.** Step (a) assumes every customer contract carries a cap. The pilot's does not.
2. **Step (b) has no data source.** No cost catalogue, no revenue forecast and no loss scenario is referenced, so a "severe but plausible" loss cannot be built by the owner. The design should name the inputs and the person who supplies each.
3. **No state for "deferred".** The design allows a policy or a recorded acceptance. A decision to wait is neither, and the control would read as failed for as long as it lasts.
4. **No linked risk.** The [risk register](../../../ISMS/03-risk-management/risk-register.md) has no row for uninsured loss, so an acceptance entry would have no risk ID to point at.
5. **Conflicts with the honesty rule.** An application form answered truthfully lists the missing controls. The design does not say who signs the answers or checks them against the matrix.
6. **The incident plan does not name the insurer step.** POL-IR-01 says "per policy terms" in its notification table; with no policy the step is empty, and the design does not require the plan to be updated when cover is bought.
7. **The control has no ISO mapping**, so the ISMS has no clause to review it under.
8. **No review trigger.** The annual rhythm ignores a first contract, a new Region or an incident.

## What this does not show

- That any insurer, broker, quote or policy exists. None is named.
- That any limit, premium or loss figure is right: none is stated.
- That the decision was taken by anyone. It is a scenario decision to defer.
- That the risk acceptance log has a new entry. It does not; this record is not an entry.
- A tabletop is not an instance for a SOC 2 test. RM-02 would still fail a Type I (SOC2-06): there is no policy.
