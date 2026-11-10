# Data subject rights procedure

| Field | Value |
|---|---|
| Document ID | GDPR-08 |
| Owner | Compliance & Risk Management |
| Approver | Managing Director |
| Version | 1.1 |
| Effective | On approval |
| Next review | 12 months after approval, or after the first real request |
| Status | Draft. Not approved. No real request has been received. One tabletop walk-through exists ([SIM-DSR-001](../records/simulated/privacy/SIM-DSR-001-access-and-erasure-request.md)) |

Ayka Secure Technologies GmbH is a simulated company. Articles 12 to 22 of the GDPR describe the rights this procedure is built to handle. Check the current text of the applicable law before the first real request. The response clock starts on receipt of a request (Art. 12(3)).

## 1. Purpose

Tell staff how to recognise a request, who answers, and which role Ayka is playing. The [data protection policy](../policies/data-protection-policy.md) states the duty. This procedure is the sequence. It covers access, rectification, erasure, restriction, portability, objection, and a complaint that a person addresses to Ayka rather than to an authority.

## 2. Roles

| Role | Duty |
|---|---|
| Anyone who receives a request, including Customer Success for requests that arrive through the customer channel | Forward it the same day to Compliance & Risk Management through the [communication plan](../ISMS/00-context-and-governance/communication-plan.md). Do not answer on the merits in the original channel |
| Compliance & Risk Management | Open the private register, decide whether Ayka is controller or processor for that data, and draft the response |
| CISO | Decide identity-verification steps that would themselves collect more personal data, and any refusal |
| Managing Director | Approves a refusal, a restriction of the right, or a notice to an authority |
| Customer Success Manager (EMP-010) | Sends the forwarding message and the neutral acknowledgement on the processor path (step 3) from templates Compliance & Risk Management approves |
| Product & Engineering or Cloud Platform Engineering | Locate and export or delete the data in the systems named in the register. A Git history deletion is a separate decision because history rewrite has its own risk |

With one maintainer, the same person may hold every role. Record that fact. Do not invent a second reviewer (RISK-005).

## 3. Sequence

| Step | Action |
|---|---|
| 1. Register | Date received, channel, which right is asked for, and the systems that might hold the data. Store the request outside this public repository |
| 2. Role | Use the [processing record](record-of-processing-activities.md). Controller activities are PA-01 to PA-04. The customer-evidence activity PP-01 is processor work |
| 3. Processor path | If Ayka is the processor, forward the request to the customer **within 2 working days** (the period in the [DPA template](data-processing-agreement-template.md) clause 2.5) without deciding the customer's response, and help with what the contract requires. Ayka may send the person one neutral acknowledgement that names the customer as controller and says the request was passed on. Ayka gives no decision, no data and no opinion on the merits to the customer's user. Ayka acts on the customer only on a written instruction |
| 4. Identity | Check identity in proportion to the data. A repository contributor can often be matched to the GitHub account already on the commit. Do not demand a copy of an identity document for a low-risk confirmation. On the processor path the customer decides the identity checks; Ayka asks the customer to confirm that the requester is its user before any export or erasure |
| 5. Find | Search the systems in the processing record. For PA-02 that includes Git history and Actions logs. For PA-01 it includes `personnel.json` and any future tenant. For PP-01 that includes the portal database, object storage and the logs that carry the user identifier. The [DSR tool](../../Internal-IT/engineering/privacy/dsr_tool.py) is the model of that search on fixture data. State where a search was not possible, and always name backups and provider-side logs |
| 6. Decide | Apply the right, or record the exemption and its source. An exemption that has not been checked against the current text is not used. A record under a legal hold is kept, reported to the requester or customer as held with the reason class, and released only by the person who placed the hold. Other records of the same person are still handled |
| 7. Respond | Send only the data the person is entitled to, over a channel that fits its classification. Record the date sent |
| 8. Close | Keep an audit log of what was found and erased (table, row, outcome; no personal values). Tell recipients of an erasure or correction where required (Art. 19), including sub-processors. Note deletion limits: backups, logs the retention rules keep, and Git history may retain a copy. Say so. Do not claim the data is gone |

The controller responds without undue delay and at the latest within one month of receipt (Art. 12(3)). Where necessary because of the complexity and number of requests, it may extend by two further months. Tell the person within the first month and give reasons. If no action is taken, tell the person within one month of receipt, with reasons and the right to complain to a supervisory authority and seek a judicial remedy (Art. 12(4)). Additional information to verify identity may be requested under Art. 12(6) where there are reasonable doubts. Identity verification does not justify ignoring the deadline.

## 4. Status

Designed, with one tabletop walk-through and a tool tested on fixture data ([REAL-PRIV-001](../records/real/privacy/REAL-PRIV-001-dsr-tool-test-run.md)). The rights register has no real rows. G09 stays open until a real request is handled against verified law, and until the Region conflict is resolved for any system that would have to be searched.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
| 1.1 | 2026-11-10 | Changes from SIM-DSR-001: forwarding period, neutral acknowledgement, identity check on the processor path, Customer Success role, legal hold, audit log and Art. 19 step |
