# Data processing agreement: customer template

| Field | Value |
|---|---|
| Document ID | GDPR-17 |
| Owner | Compliance & Risk Management |
| Approver | Managing Director |
| Version | 0.1 |
| Effective | On approval |
| Next review | Before the first customer contract, then every 12 months or when a sub-processor, Region or TOM changes |
| Status | **Template.** Not approved, not offered to anyone, no signed instance exists. Not legal advice and not reviewed by counsel |

> Ayka Secure Technologies GmbH is fictional. This text is a template for an agreement under Art. 28(3) GDPR between a customer (controller, "Customer") and Ayka (processor, "Ayka") for the `ayka-portal` service. Square brackets are filled per customer. No party has signed it. Signature blocks are intentionally absent.

## 1. Parties and subject matter

1. The Customer is the controller. Ayka is the processor (Art. 4(7), (8); working roles in [ADR-0005](../ADR/0005-gdpr-roles.md)).
2. This agreement governs the processing of personal data that the Customer or its users put into `ayka-portal`, as described in Annex I. It forms part of [the main service agreement, reference to be inserted].
3. Duration: as long as Ayka processes the data under the service agreement.

## 2. Ayka's obligations (Art. 28(3))

| Clause | Content | Article |
|---|---|---|
| 2.1 Instructions | Ayka processes personal data only on the Customer's documented instructions, including on transfers to a third country, unless Union or Member State law requires otherwise. Then Ayka informs the Customer before processing, unless the law forbids it. Ayka tells the Customer at once if it believes an instruction infringes data protection law | 28(3)(a), 28(3) last subparagraph |
| 2.2 Confidentiality | Persons authorised to process are bound to confidentiality | 28(3)(b) |
| 2.3 Security | Ayka implements the measures in Annex II (Art. 32) | 28(3)(c) |
| 2.4 Sub-processors | Ayka uses only the sub-processors in Annex III. Ayka gives the Customer [30] days' notice of an intended addition or replacement. The Customer may object on reasonable data-protection grounds in that time. If the parties cannot agree, the Customer may terminate the affected service. Ayka imposes on each sub-processor the same data-protection obligations by contract and stays liable to the Customer for its performance | 28(2), 28(4) |
| 2.5 Assistance with rights requests | Ayka forwards a request from a data subject to the Customer **within [2] working days** of receipt, without answering it on the merits. Ayka may send the data subject a neutral acknowledgement that names the Customer as controller and says the request has been passed on. Ayka does not verify the identity of a data subject on the Customer's behalf unless instructed; the Customer decides the identity checks. On the Customer's instruction Ayka finds, exports, corrects or erases the data within [10] working days, honours a legal hold the Customer notifies, and returns a log of what was done. Ayka states what it cannot reach (backups, provider-side logs) | 28(3)(e) |
| 2.6 Assistance with security, breach, DPIA and consultation | Ayka notifies the Customer of a personal data breach **without undue delay and within 24 hours** of becoming aware, with the information in Art. 33(3) as far as known, then updates it. This matches the Ayka commitment in the [incident reporting procedure](../NIS2/03-incident-reporting-procedure.md) section 6. Ayka supports the Customer's DPIA and prior consultation with the information in Annexes I to III and the [DPIA](dpia-ayka-portal.md) summary for logging | 28(3)(f), 33(2) |
| 2.7 Deletion or return | At the end of the service Ayka deletes or returns all personal data, at the Customer's choice, and deletes existing copies unless law requires storage. Backups expire within [35] days; this period is a design target that the [retention policy](../policies/records-and-data-retention-policy.md) says cannot yet be substantiated | 28(3)(g) |
| 2.8 Audit | Ayka makes available the information needed to show compliance and allows audits, including inspections, by the Customer or its auditor with [30] days' notice, during business hours, subject to confidentiality and without access to other customers' data. Ayka may meet the request first with an independent report where one exists. None exists yet | 28(3)(h) |
| 2.9 Transfers | Processing takes place in the EU/EEA. Ayka's target Region is Frankfurt (`eu-central-1`). A transfer to a third country, including remote access, occurs only with the safeguards described in the [transfer assessment](data-flow-and-transfer-assessment.md) and on the Customer's instruction | 28(3)(a), Chapter V |
| 2.10 Records | Ayka keeps the record of processing required of processors | 30(2) |

## 3. Customer's obligations

The Customer is responsible for the lawfulness of its instructions and of its data, for providing the information to data subjects, and for not uploading special-category data (Art. 9) or criminal-offence data unless it has said so in Annex I and a separate assessment has been done.

## 4. Liability, term, governing law

[To be agreed in the main agreement. Not drafted here. Law of the Federal Republic of Germany is the working assumption.]

## Annex I: Details of the processing

| Item | Entry |
|---|---|
| Subject matter | Hosting and operation of the compliance evidence platform `ayka-portal` |
| Nature | Storage, display, search, export and deletion of Customer content and user accounts |
| Purpose | Provide the service to the Customer |
| Categories of data subjects | Customer's users and staff, and persons named in uploaded evidence |
| Categories of data | User name, e-mail, role; log data (IP address, user identifier); any personal data inside uploaded evidence. Special categories: **none permitted unless listed here** [none] |
| Duration | Term of the service agreement plus the deletion period in clause 2.7 |
| Location | EU/EEA; target `eu-central-1` |
| Records | Processing activity PP-01 in the [processing record](record-of-processing-activities.md) |

## Annex II: Technical and organizational measures

Measures are those in the following documents. Status labels are Ayka's and are stated honestly; at the time of this draft nothing is deployed.

- [Identity and access](technical-and-organization-measures/identity-and-access-toms.md)
- [Segregation of duties](technical-and-organization-measures/segregation-of-duties.md)
- [Encryption, logging and backup](technical-and-organization-measures/encryption-logging-backup-toms.md)
- [Data masking standard](../policies/data-masking-standard.md)
- [Data protection policy](../policies/data-protection-policy.md)

A customer must be given this Annex with the status column as it stands on signature date. A measure labelled Planned or Designed is not a promise that it operates.

## Annex III: Authorised sub-processors

| Sub-processor | Service | Location | Safeguards | Register entry |
|---|---|---|---|---|
| Amazon Web Services (entity to verify) | Hosting: IAM Identity Center, S3, RDS, ECS, CloudTrail, KMS | Target `eu-central-1` | AWS data processing terms; transfer position in the [transfer assessment](data-flow-and-transfer-assessment.md) (**to verify**) | SUP-01 in the [processor register](processor-register.md) |

Microsoft (SUP-02) and GitHub (SUP-03) process Ayka's own staff and repository data and are not sub-processors for Customer content. If that changes, Annex III changes first.

## Revision history

| Version | Date | Change |
|---|---|---|
| 0.1 | 2026-11-10 | First draft. Forwarding period and breach period written to close findings of SIM-DSR-001 |
