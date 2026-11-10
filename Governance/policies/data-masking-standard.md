# Data masking standard

| Field | Value |
|---|---|
| Document ID | STD-MSK-01 |
| Owner | Product & Engineering |
| Approver | Managing Director |
| Version | 1.1 |
| Effective | On approval |
| Next review | 12 months after approval, or before personal data is copied into a non-production system |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company. This standard is the rule for when real personal data would have to be hidden. No masking tool is selected and no transformation has been tested.

## 1. Purpose

Limit exposure of personal data in development, test, support and analysis (ISO/IEC 27001:2022 A.8.11). Test-data handling in A.8.33 uses the same rule. Encryption under the [cryptography policy](cryptography-policy.md) protects a store. It does not mask a value from someone who is allowed to read the store.

## 2. What the repository holds today

| Data | Where | Masking position |
|---|---|---|
| Fictional staff rows and one real repository owner in `personnel.json` | Public Git history | Not masked. The [processing record](../GDPR/record-of-processing-activities.md) PA-01 records the disclosure. This standard does not reclassify that file as anonymised |
| Git author name and email, GitHub usernames, workflow logs | GitHub, real | Not masked. Operational identifiers for PA-02. Do not add further personal data to logs to make them "more useful" |
| Customer evidence and customer accounts | [`ayka-portal`](../../Internal-IT/workloads/ayka-portal/) design only | No customer exists. Fixtures, plans and screenshots must stay synthetic |
| Security logs with IP addresses and user identifiers | Designed, not delivered | Future logs follow [STD-LOG-01](logging-and-monitoring-standard.md). Collection is not a reason to copy those logs into a developer laptop |

## 3. Rules

1. Production personal data is not copied into development, test, CI, screenshots, fixtures, tickets or prompts. The portal design uses synthetic users until a customer exists.
2. A support or incident exception names the fields, the people who can see them, the purpose, the expiry and the deletion step. The default is removal of the field. The CISO accepts any exception that keeps a direct identifier, for at most 30 days.
3. Permitted transformations, once a case exists, are removal, replacement with synthetic values, or tokenisation whose token store is access-controlled and separate from the masked set. A hash of a name or email is not treated as anonymous. Pseudonymised data remains personal data under the [data protection policy](data-protection-policy.md).
4. Masked sets are labelled with the source system, the date, the transformation and the fields that remain identifying. A file without that label is treated as production data and removed from the non-production location.
5. Backups and logs that still hold the original are listed in the exception. Masking the primary store and leaving the copy is not completion.
6. The workload WAF and S3 public-access checks are leakage controls under A.8.12. They are not masking.

No product is selected. A sample transformation exists since 2026-11-10: [`masking.py`](../../Internal-IT/engineering/privacy/masking.py), run only against fixture data ([REAL-PRIV-001](../records/real/privacy/REAL-PRIV-001-dsr-tool-test-run.md)). It has not been run against `personnel.json` or any real record.

## 4. Before any real customer data

Product & Engineering writes the fields the product needs in non-production, the transformation for each field, and a test that a known identifier does not survive in the output. Compliance & Risk Management confirms the test against PA-01 and PP-01. A fixture-level leak test exists ([`test_masking.py`](../../tests/privacy/test_masking.py)); the product-field test against PA-01 and PP-01 does not, because no product data model exists. RISK-011 (Region) is a separate prerequisite: masking does not cure a wrong processing location.

## 5. Status

Designed by this standard. G09 stays open for the unimplemented transformation, the missing test, and the unresolved residency decision. [Secure development](secure-development-policy.md) already forbids live personal data in development. This standard is the specific rule that was missing for A.8.11.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
| 1.1 | 2026-11-10 | Point at the fixture-tested masking function. No product is selected |
