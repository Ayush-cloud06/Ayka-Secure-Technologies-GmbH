# SIM-SOC2-002: Customer onboarding security pack delivered to Customer A (fictional)

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-SOC2-002 |
| Authored | 2026-11-10 (real date) |
| Scenario date | 2026-05-18 (pilot start). Cross-check against 2026-08-13 and 2026-09-22 |
| Participants | EMP-006 (Product Manager, owns the pack), EMP-010 (Customer Success Manager, delivers it), EMP-009 (Sales Manager, account owner), EMP-004 (GDPR Lead, DPA and register extract), EMP-002 (CISO, approves the commitments text). Customer A (fictional) is not an employee |
| Procedure exercised | [SOC2-08](../../../SOC2/08-control-designs.md#2-governance-people-and-risk) row IC-02 (customer pack and 30-day change-notice rule) |
| Controls | SOC 2 IC-02 (CC2.3); ISO/IEC 27001:2022 A.5.14, A.5.31; related IC-03, OP-06; GDPR Art. 28(3) |

## Scenario

Customer A (fictional) is the pilot customer used in [SIM-INC-001](../incident/SIM-INC-001-inc-2026-001-customer-export-in-public-ci.md), [SIM-DSR-001](../privacy/SIM-DSR-001-access-and-erasure-request.md) and [SIM-NIS2-002](../nis2/SIM-NIS2-002-customer-supplier-security-assessment.md). Its pilot starts on 2026-05-18. The portal is not deployed; the walk-through assumes the pilot ran. EMP-006 assembles the pack on 2026-05-14 to 2026-05-15 from the four parts of the design; EMP-010 sends it on 2026-05-18. Which commitments were true is decided against the documents as their text stands on the Authored date.

## 1. The four parts, as assembled

| Part | What went in | What the walk-through found about it |
|---|---|---|
| (a) Service commitments in plain language | The table of [SOC2-01](../../../SOC2/01-system-description.md) section 2.1, shortened: MFA for administrators, reviewed and scanned changes, incident notice within 24 hours, 99.5 % availability, RPO 24 h and RTO 8 h, encryption, EU hosting, deletion in 30 days with backups ageing out in 35 more | EMP-002 reviewed the text. Five of the eight rows cannot be backed by an operating control in May (MFA is switched off, no uptime probe, no restore test, nothing hosted in the EU, no deletion run). The pack has no field for "target" versus "in operation", so all eight read as promises. Section 2.1 itself says some are "not yet true"; the plain-language copy dropped that note |
| (b) DPA and processor extract | [DPA template](../../../GDPR/data-processing-agreement-template.md) with Annexes I to III filled (see [SIM-GDPR-004](../privacy/SIM-GDPR-004-dpa-conclusion-customer-a.md)); the AWS row of the [processor register](../../../GDPR/processor-register.md) | The DPA says 24 h for a breach notice. POL-IR-01 section 8 says 48 h (found in SIM-INC-001 finding 1). The pack carried both numbers in different parts |
| (c) Security contact and disclosure policy | The disclosure policy file for the repository. As Ayka's security contact the pack names EMP-010 by e-mail, because no security mailbox exists (IC-03 is Designed) | A single named person is not a monitored channel: no cover for absence, no ticket, no two-day triage. The disclosure policy points to a public repository address, not to the customer's route |
| (d) Change-notice rule | One paragraph: material changes announced in writing at least 30 days ahead. The change-notice log is created empty | Material change is not defined beyond the three examples. The log has no owner other than EMP-006 and no entry is possible before something changes |

## 2. Delivery

| Date | Step | Who |
|---|---|---|
| 2026-05-18 | Pack version 0.1 sent to the contact named in the order form by e-mail. Customer A (fictional) confirms receipt on the same day (scenario value) | EMP-010 |
| 2026-05-18 | The pack version and send date are written in the customer file. There is no field for a version in the customer file | EMP-010 |
| 2026-05-18 | EMP-010 asks Customer A (fictional) for its privacy contact for the DPA annex and receives one. Nobody asks for a security contact: no part of the design asks | EMP-010 |

## 3. Cross-check against the incident

The control is one-way: it tells the customer who to call at Ayka. It does not collect the customer's contacts. That is why, on 2026-08-13 09:00, [SIM-INC-001](../incident/SIM-INC-001-inc-2026-001-customer-export-in-public-ci.md) records that no security contact for Customer A (fictional) was registered. The customer file held a privacy contact from the DPA annex and the signatory from the order form (found by EMP-009 at 13:50). The pack of 2026-05-18 and the incident record agree. The contract-signature field that [SIM-CAPA-004](../improvement/SIM-CAPA-004-customer-notice-24h-missed-and-evidence-lost.md) CA-1 added on 2026-09-22 closes it for the future. The design text of IC-02 does not yet contain that step.

## 4. Change notices in the period

Changes between 2026-05-18 and 2026-10-30 that a reader might call material, checked against the rule:

| Change | Material? | Notice before the change? |
|---|---|---|
| Terraform Region default: `ap-south-1` when SIM-SUP-001 looked on 2026-07-06, `eu-central-1` in the source on the Authored date. The move has no scenario date | Arguably a change of the Region in the commitment, but nothing was ever hosted in either | None. The rule does not say whether a source change counts |
| The 24 h incident-notice commitment (POL-IR-01 says 48 h) | A commitment changes, depending on which document is read | None |
| New sub-processor | No | n/a |

## Findings

Defects in the IC-02 design as written:

1. **The pack makes commitments the system does not meet.** The plain-language copy removes the "not yet true" caveat. Add a status column (target, in operation) and the date it was last confirmed, or do not send a commitment that has no operating control.
2. **No inbound half.** The design gives the customer Ayka's contact but never records the customer's security contact, its incident-notice recipient or its privacy contact. This is the gap SIM-INC-001 found 87 days later.
3. **A named person is the security contact** because the mailbox of IC-03 does not exist. IC-02 depends on IC-03 and the design does not say so.
4. **Two numbers for the breach notice** (24 h in the DPA and the system description; 48 h in POL-IR-01) went to the customer together.
5. **"Material change" is undefined**, so whether a source-code Region change needs a notice cannot be answered.
6. **The customer file has no place for the pack version** or the notice log. The operating test needs both.
7. **The pack is built once for all customers**, but the DPA annexes differ per customer. The design does not say whether annex changes are material changes.

## What this does not show

- That a customer, a pilot, a pack or an e-mail exists. Customer A (fictional) is a made-up company and nothing it says is a real statement.
- That the pack is legally sufficient. No counsel reviewed it, and no signed agreement is claimed.
- That the pilot ran: `ayka-portal` was never deployed.
- A tabletop is not an instance for a SOC 2 test. IC-02 would still fail a Type I (SOC2-06).
