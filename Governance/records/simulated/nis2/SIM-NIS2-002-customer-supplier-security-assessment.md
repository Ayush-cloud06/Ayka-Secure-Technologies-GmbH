# SIM-NIS2-002: Customer supplier-security assessment by Customer A (fictional)

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-NIS2-002 |
| Authored | 2026-11-10 |
| Scenario date | 2026-10-12 |
| Participants | EMP-009 (Sales Manager, Key Account Lead), EMP-002 (CISO), EMP-021 (Compliance Officer), EMP-010 (Customer Success Manager), EMP-001 (Managing Director) |
| Procedure exercised | [NIS2-05 Part A](../../../NIS2/05-supply-chain-security.md), answered with the [supplier questionnaire response](../../../NIS2/07-supplier-questionnaire-response.md) |
| Controls | NIS2 Art. 21(2)(d), 21(3); §30(2) no. 4 BSIG (customer's duty); ISO/IEC 27001:2022 A.5.19 to A.5.23; SOC 2 CC9.2 |

## 1. Scenario

Customer A (fictional) is an automotive Tier-2 manufacturer with about 180 staff. In the scenario it counts itself as an important entity under NIS2 and must assess its suppliers. Customer A is the same fictional customer as in [SIM-INC-001](../incident/SIM-INC-001-inc-2026-001-customer-export-in-public-ci.md) and [SIM-DSR-001](../privacy/SIM-DSR-001-access-and-erasure-request.md), which already had a pilot contract in August 2026 (scenario decision, added 2026-11-10 to remove a conflict between records). The talks of this record are about extending that relationship, and its procurement team sends Ayka a security questionnaire and a draft addendum. Ayka's Sales Manager forwards it to the CISO, who answers from the pre-filled response, and the Managing Director decides what Ayka will sign.

No statement, score or decision of Customer A is invented here: the record covers only Ayka's side, up to sending the answers.

## 2. Walk-through

| Step | Who (scenario) | What happens | Source used |
|---|---|---|---|
| 1. Receive | EMP-009 | Questionnaire logged on 2026-10-12; deadline given by Customer A: 14 days | - |
| 2. Triage | EMP-002 | Customer A asks for: 12-hour incident notice, EU hosting, MFA for all staff, an ISO/IEC 27001 certificate, on-site audit rights | [NIS2-05](../../../NIS2/05-supply-chain-security.md) A.2 |
| 3. Answer | EMP-002, EMP-021 | 44 answers copied with their status labels | [NIS2-07](../../../NIS2/07-supplier-questionnaire-response.md) |
| 4. Decide | Scenario decision by EMP-001 on advice of EMP-002 | 24-hour notice offered, 12-hour declined; no EU-hosting claim; no certification claim; MFA gap stated; audit limited to remote audit and evidence on request | [NIS2-06](../../../NIS2/06-customer-security-addendum.md) section 2 |
| 5. Send | EMP-010 | Answers sent under NDA with the evidence package listed in NIS2-05 A.3 | NIS2-05 A.3 |
| 6. Record | EMP-021 | Row added to a log of incoming customer assessments | Missing, see Findings 3 |

### Answers that mattered

| Customer A asked | Ayka's answer | Status label sent |
|---|---|---|
| 12-hour incident notice | No; 24 hours from awareness | Designed (+ simulated record [SIM-INC-001](../incident/SIM-INC-001-inc-2026-001-customer-export-in-public-ci.md)) |
| Data in the EU | Target `eu-central-1`; no claim until deployed | Gated design |
| MFA for all staff | No; switched off | Designed |
| ISO/IEC 27001 | None held | Planned |
| Sub-supplier certificates | Public pages read; no report obtained | Partial |

## Findings

1. **Timing mismatch.** The pre-filled response is dated 2026-11-10. On 2026-10-12 several answers would have been weaker: detection, backup and Region were then "Planned" or "Designed" in [NIS2-02](../../../NIS2/02-risk-management-measures.md) version 1.0. A real response must be re-checked against the document state on the day it is sent; the response has no "valid as of" field per answer. Add one.
2. **Deal-breakers are visible only at the end.** Four answers (MFA, EU hosting, 12-hour notice, certificate) are "no" or "not yet". Sales saw them after the questionnaire was filled. Add a one-page "can we meet your must-haves" screen before any questionnaire is started.
3. **No log of incoming assessments.** NIS2-05 B.4 is a template for Ayka's assessments of its suppliers. There is no record for customers' assessments of Ayka (date, customer, answers sent, open commitments). Without it nobody tracks what was promised.
4. **No owner for refresh.** The response needs updating whenever a NIS2-02 status changes. No role is assigned. The CISO is the owner of the document; nobody triggers the review.
5. **Commitments in answers become contract terms.** The 24-hour answer is also a promise. The procedure does not say that the CISO must confirm that the detection measures behind it exist before it is sent; today they are plan-only.
6. **Sub-processor list.** Customer A would ask for locations and transfer mechanisms. The processor register marks every mechanism "to verify"; the answer had to say so.

## What this does not show

- That a customer exists or that any customer asked these questions. Ayka and Customer A are fictional.
- How a customer would score, accept or reject the answers.
- That any control named in the answers operates. Nearly all are Designed or Gated design.
- That the questionnaire matches any real customer's or VDA ISA's format.
- That the 24-hour commitment could be met: Ayka has no live detection.
