# SIM-DSR-001: Access and erasure request from a user of Customer A (fictional)

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-DSR-001 |
| Authored | 2026-11-10 (real date) |
| Scenario date | 2026-09-01 (received) to 2026-09-24 (answered) |
| Participants | EMP-010 (Customer Success Manager), EMP-004 (GDPR Lead), EMP-002 (CISO), EMP-007 (Backend Engineer), EMP-003 (Cloud Platform Engineer). The data subject and Customer A (fictional) are not employees |
| Procedure exercised | [Data subject rights procedure](../../../GDPR/data-subject-rights-procedure.md) (GDPR-08), version 1.0, steps 1 to 8 |
| Controls | GDPR Art. 12(3), 15, 17, 19, 28(3)(a), 28(3)(e); ISO/IEC 27001:2022 A.5.34, A.8.10; [PP-01](../../../GDPR/record-of-processing-activities.md) |

## Scenario

A user of Customer A (fictional), a made-up EU supplier using `ayka-portal`, writes to the Ayka support address and asks for a copy of her personal data and for erasure. The portal is a design and was never deployed; the walk-through assumes it ran. Customer A (fictional) is the controller. Ayka is the processor ([ADR-0005](../../../ADR/0005-gdpr-roles.md)). Figures below are scenario figures, not tool output.

## Step by step

| Step | Date | What the procedure says | What happened in the scenario | Decision by |
|---|---|---|---|---|
| 1 Register | 2026-09-01 | Register date, channel, right, systems. Store outside the public repository | EMP-010 receives the mail through the support channel and forwards it to EMP-004 the same day, as the roles table requires. EMP-004 opens a private register row. The procedure names no register location | EMP-004 |
| 2 Role | 2026-09-02 | Use the processing record. PP-01 is processor work | The requester's data is a portal account and uploaded evidence of Customer A (fictional). Role: processor | Scenario decision by EMP-004 |
| 3 Processor path | 2026-09-02 | Send the request to the customer without deciding its response. Do not contact the user with Ayka's own decision | EMP-010 forwards the request to Customer A's (fictional) privacy contact on 2026-09-02. EMP-004 asks whether Ayka may tell the requester anything. The procedure does not say. Scenario decision: one neutral acknowledgement naming Customer A (fictional) as controller, no decision and no data. Sent 2026-09-02 | Scenario decision by EMP-004, confirmed by EMP-002 |
| 4 Identity | 2026-09-03 | Proportionate check; a contributor can be matched to a commit. No identity document for low-risk confirmation | The procedure speaks about contributors only. Scenario decision: Ayka does not collect an identity document. It asks Customer A (fictional) to confirm the requester is its user before Ayka exports or erases anything | Scenario decision by EMP-002 |
| 5 Find | 2026-09-10 to 2026-09-15 | Search the systems in the processing record | On 2026-09-08 Customer A (fictional) confirms the user and gives a written instruction: export and erase, except one evidence record under Customer A's own legal hold. EMP-007 and EMP-003 search the portal database, object storage and logs by user identifier. Scenario result: 1 account, 2 evidence records (1 under hold), 5 log rows. They cannot search backups. The procedure lists no PP-01 stores | EMP-007, EMP-003 |
| 6 Decide | 2026-09-16 | Apply the right or record an exemption | Erasure follows the customer's instruction. The procedure has no concept of a legal hold; the held record is kept and reported as held on the customer's word. Ayka does not judge the hold | Scenario decision by EMP-004 |
| 7 Respond | 2026-09-17 to 2026-09-24 | Send only what the person is entitled to | Ayka does not send the export to the requester. It gives the export and, after erasure, a completion report to Customer A (fictional) over the agreed channel on 2026-09-17 and 2026-09-23. Customer A (fictional) answers the requester on 2026-09-24, within one month of Ayka receiving it (due 2026-10-01, Art. 12(3)) | EMP-010 delivers, Customer A (fictional) answers |
| 8 Close | 2026-09-23 | Name deletion limits; do not claim the data is gone | Erasure run on 2026-09-22 against the instruction. Audit log kept: table, row, outcome, counts, no personal values. The report says: backups age out under the retention policy (35-day proposal, unsupported today), provider logs not searched, one record held. The sub-processor notice (Art. 19) is not in the procedure; EMP-004 decides AWS needs none because deletion is in Ayka's own stores | Scenario decision by EMP-004 |

The fixture-data model of steps 5 to 8 is the [DSR tool](../../../../Internal-IT/engineering/privacy/dsr_tool.py), tested in [REAL-PRIV-001](../../real/privacy/REAL-PRIV-001-dsr-tool-test-run.md). The tool was not run in this scenario against any real data.

## Findings

Defects in GDPR-08 version 1.0 that the walk-through found:

1. **No forwarding deadline on the processor path.** Step 3 says send the request to the customer. It gives no period. The customer's own one-month clock may already be running (Art. 12(3)). Closed in version 1.1 (2 working days) and in the DPA template clause 2.5.
2. **Acknowledgement unclear.** "Do not contact the customer's user with Ayka's own decision" does not say whether a neutral acknowledgement is allowed. Closed in version 1.1.
3. **Identity check covers contributors only.** On the processor path nothing says who verifies a customer's user. Closed in version 1.1: the customer decides, Ayka asks it to confirm.
4. **No legal hold.** Steps 6 and 8 do not say what to do with a held record or who releases it. Closed in version 1.1.
5. **Customer Success is not in the roles table**, though it is the first recipient on the customer channel. Closed in version 1.1.
6. **No store for the request register.** Step 1 says outside the public repository and names no location. A private records store is absent ([POL-RET-01](../../../policies/records-and-data-retention-policy.md)). Still open.
7. **PP-01 stores are not listed in step 5**, so the search could miss logs or object versions. Partly closed in version 1.1. The portal inventory it needs does not exist.
8. **No Art. 19 step and no audit log of the erasure.** Closed in version 1.1.
9. **No time target for Ayka's own part** (export, erasure). The customer cannot plan. Closed in the DPA template (10 working days, to be agreed).
10. Backups cannot be searched or selectively erased (POL-RET-01 says the 35-day figure cannot be substantiated). Still open.

## What this does not show

- That any customer, user, request or portal exists. All three are fictional and the portal is not deployed.
- That Customer A (fictional) said or decided anything. Its steps are part of the scenario.
- That the DSR tool works on a real system. It was tested on fixture data only.
- That the one-month deadline would be met in practice, or that the neutral acknowledgement is lawful in every case. Both rest on the text of Art. 12 and 28, which counsel has not reviewed.
- No signatures; every decision is a scenario decision.
