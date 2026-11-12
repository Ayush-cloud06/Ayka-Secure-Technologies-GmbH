# ADR-0005: Working GDPR roles, not a legal conclusion

| Field | Value |
|---|---|
| Status | Recorded |
| Date | 2026-10-14 |
| Deciders | Roles already stated in the GDPR index and the processing record. No counsel review and no customer contract |

## Context

The repository really processes contributor metadata and publishes a personnel file. The portal that would hold customer evidence does not exist. Calling Ayka a processor for everything, or a controller for everything, would hide that split.

## Drivers

- Article 28 duties apply to a processor. Article 30(1) duties apply to a controller.
- The personnel file contains one real person and many fictional rows.
- A role label is not a lawful basis and not a DPO decision.

## Options

1. Leave the role blank until a lawyer writes an opinion.
2. Record the working split, mark it unconfirmed, and attach the open basis and DPO questions.

## Outcome

Option 2.

| Processing | Working role | Why |
|---|---|---|
| Repository and CI metadata (PA-02) | Controller | The repository owner decides this processing, and it is real |
| Designed employment and access data (PA-01, PA-04) | Controller | The case study has Ayka deciding the purpose. Staff are fictional, except the public owner record |
| Designed customer evidence (PP-01) | Processor | Customers would decide what is uploaded. No customer exists |

Confirmation against actual purposes remains open. The [legal-basis register](../GDPR/dpo-and-legal-basis.md) does not upgrade these rows to a reviewed basis.

## Consequences

Breach notification, rights requests and TOMs branch on the role. Positive: a future customer contract has a place to land. Negative: a reader can quote the table and drop the words "working" and "unconfirmed". The GDPR index repeats the limit in its header.

## Evidence

- [GDPR index](../GDPR/README.md)
- [Processing record](../GDPR/record-of-processing-activities.md)
- [DPO decision and legal-basis register](../GDPR/dpo-and-legal-basis.md)

## Links

- [ADR-0003](0003-target-region.md)
