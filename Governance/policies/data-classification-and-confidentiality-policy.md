# Data Classification and Confidentiality Policy

| Field | Value |
|---|---|
| Document ID | POL-DATA-01 |
| Classification | Internal |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval |
| Status | Draft. Not approved |

## 1. Purpose

Customers trust Ayka with the documents they will show their own auditors: policies, risk registers, contracts, screenshots of their systems. This policy makes sure that information is recognised, protected for as long as Ayka holds it, and destroyed when Ayka no longer should.

## 2. Scope

All information Ayka creates, receives or stores, in any form, and every person who handles it.

## 3. References

| Framework | Requirement |
|---|---|
| SOC 2 | C1.1, C1.2, CC6.5, CC6.7 |
| ISO/IEC 27001:2022 | A.5.12, A.5.13, A.5.14, A.5.33, A.6.6, A.8.10, A.8.12, A.8.24 |
| GDPR | Art. 5(1)(e), Art. 17, Art. 28(3)(g), Art. 32 |
| Controls | CO-01 to CO-05, AC-12, AC-13, AV-03 |

## 4. Classification levels

| Level | Meaning | Examples | Minimum handling |
|---|---|---|---|
| **Public** | Approved for anyone | Marketing site, published policies, this repository | Approved by the owner before publication |
| **Internal** | For Ayka staff and contractors | Internal procedures, architecture documents, application logs | Company systems only; no sharing outside Ayka without NDA |
| **Confidential** | Harm to customers or Ayka if disclosed | All customer data and evidence files, customer contracts, security findings, personnel data | Encrypted at rest and in transit; access by role; shared externally only under NDA or DPA; never in tickets or chat in full |
| **Restricted** | Severe harm if disclosed | Secrets and keys, break-glass credentials, customer data the customer marks Restricted, the SOC 2 report draft | As Confidential, plus named-person access, MFA on every access, no local copies, use is logged and reviewed |

Customer data is Confidential by default. Information without a label is treated as Internal until its owner classifies it.

## 5. Rules

### 5.1 Labelling and inventory

1. Every AWS resource that stores data carries a `DataClassification` tag with one of the four levels. A gate rule enforcing the tag is to be added next to `EC2_MISSING_TAGS`.
2. The system description's data table (section 3.6) is the inventory of confidential data stores and is reviewed with it.

### 5.2 Protection

1. Confidential and Restricted data at rest is encrypted with the customer-managed KMS key; in transit, TLS 1.2 or higher. The gate enforces this for the workload (`S3_ENCRYPTION_MISSING`, `S3_KMS_ENCRYPTION_REQUIRED`, `ALB_TLS_ENFORCEMENT`, `RDS_ENCRYPTION_IN_TRANSIT`, among others).
2. No data store holding customer data is publicly reachable (`S3_PUBLIC_ACCESS`, `S3_ACLS_DISABLED`).
3. Customer data is not copied to laptops, personal cloud storage, e-mail or AI tools that are not approved by the CISO for that purpose.
4. Production customer data is never used for development or testing (CO-05).
5. Staff and contractors sign a confidentiality agreement before receiving access (CO-03). The obligation survives the end of employment.

### 5.3 Retention and disposal

| Data | Retention | Disposal method |
|---|---|---|
| Customer data in the portal | Contract term + 30 days | Deletion of the customer's records and S3 prefix; KMS-encrypted backups age out within 35 further days (7-day RDS backups, 30-day S3 noncurrent versions) |
| Application and access logs | 365 days | Automatic expiry (CloudWatch retention, S3 lifecycle). The access-log bucket still needs a noncurrent-version expiry (readiness gap G13) |
| CloudTrail | 1 year online, 6 years archive | Lifecycle expiry |
| SOC 2 and audit evidence | Report period + 12 months, at least 18 months | Lifecycle expiry after Object Lock period |
| Personnel records | Per HR retention rules under German law | HR system deletion |
| Laptops and storage media | End of use | Certified wipe or physical destruction, with certificate (AC-18) |

On contract end, Ayka deletes the customer's data, confirms deletion in writing within 30 days, and records the deletion ticket (CO-04). A customer may request an export before deletion.

### 5.4 Sharing

1. Confidential information goes to third parties only under an NDA or a DPA and only through approved channels.
2. Security findings, penetration test reports and the SOC 2 report are shared with customers only under NDA.

## 6. Roles

| Role | Responsibility |
|---|---|
| Information owner | Classifies information and approves access and sharing |
| CISO | Maintains this policy and the classification scheme; approves Restricted access |
| Cloud Platform Engineering | Implements tagging, encryption, retention and deletion in Terraform |
| Head of Product | Runs customer offboarding and deletion confirmation |
| All staff | Handle information according to its class; report mishandling as an incident |

## 7. Exceptions

Exceptions are approved by the CISO in writing with an end date, and listed in the quarterly report.

## 8. Current gaps

No Terraform sets a `DataClassification` tag. No confidentiality agreements, deletion tickets or disposal certificates exist, because the company and its customers are simulated.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-06 | First issue |
