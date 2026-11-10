# SIM-GDPR-003: DPIA decision and sign-off for security logging

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-GDPR-003 |
| Authored | 2026-11-10 (real date) |
| Scenario date | 2026-10-02 |
| Participants | EMP-001 (Managing Director, decides), EMP-002 (CISO, DPIA owner), EMP-004 (GDPR Lead), EMP-005 (Security Operations Analyst, log user), EMP-003 (Cloud Platform Engineer, log sources) |
| Procedure exercised | [DPIA screening](../../../GDPR/dpia-screening.md) (GDPR-07) section 2, then [DPIA](../../../GDPR/dpia-ayka-portal.md) (GDPR-14) sections 1 to 6 |
| Controls | GDPR Art. 35(1), 35(2), 35(7), 36; BDSG § 38(1) sentence 2; ISO/IEC 27001:2022 A.5.34, A.8.15; PA-03 |

## Scenario

EMP-002 presents the DPIA for PA-03 before any log source delivers personal data, as the screening requires.

| Item | Scenario outcome |
|---|---|
| Screening outcome | PA-03: DPIA likely required. Carried forward |
| Trigger test | EDPB criteria: systematic monitoring and vulnerable data subjects (employees) met; matching partly. DSK list not fetched; item numbers unverified |
| Necessity and proportionality | Basis Art. 6(1)(f), assessment attached. Fields limited to four categories |
| Risks | R1 to R6. R2 (function creep) rated high before measures |
| Residual | No residual risk high with the measures. Art. 36 consultation: not triggered, on the conditions in DPIA section 6 |
| DPO advice (Art. 35(2)) | Sought. **No DPO exists** (SIM-GDPR-001 decided to designate; no contract). The advice field stays outstanding |
| Decision | Scenario decision by EMP-001: accept the DPIA as a design assessment. PA-03 stays off for personal data. Collection may start only after the DPO's advice, a repeat on the built system, and the R2, R3 and R6 measures |
| Staff consultation (Art. 35(9)) | Not done. No representation recorded. EMP-012 to ask whether any exists |

## Findings

1. **The screening cannot be turned into a decision while the DPO seat is empty.** Art. 35(2) needs the DPO's advice; the document has no rule for the gap. A conditional approval was improvised.
2. **The screening has no DPIA template**, so the headings of Art. 35(7)(a) to (d) had to be chosen. The new DPIA follows them.
3. **No rule for who decides "high residual risk".** The screening names the Managing Director as approver only. EMP-002 proposed that the DPO advises and the Managing Director decides.
4. **Art. 35(9) staff views were not planned** in the screening. Added as an open item in the DPIA.
5. **PP-01 is a customer DPIA question**, and the screening did not say Ayka's job there is assistance (Art. 28(3)(f)). Closed in DPIA section 7.
6. **No time limit on a conditional approval.** Nothing forces the repeat on the built system. Review trigger added in the DPIA header; no owner assigned.

## What this does not show

- That a DPIA was approved, signed or reviewed by anyone. "Decides" means scenario decision.
- That DPO advice or staff consultation took place.
- That the log pipeline exists, delivers anything or has been tested.
- That a supervisory authority has seen or would accept the assessment.
