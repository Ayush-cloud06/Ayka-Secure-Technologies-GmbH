# Processor and Sub-processor Register

- **Organization:** Ayka Secure Technologies GmbH (simulated case study)
- **Framework:** GDPR Art. 28 (processors), Art. 44–46 (transfers); ISO/IEC 27001:2022 A.5.19–A.5.22 (supplier relationships)
- **Owner:** GDPR Lead role (fictional), with the CISO role
- **Version:** 1.0
- **Last updated:** 2026-10-05
- **Status:** Draft. Not approved: no approval record exists.

## 1. Read this first

- The simulated company has signed nothing. "DPA" below names the provider's standard data processing terms that **would** apply, not a contract Ayka holds.
- Provider entities, terms and certifications are **to verify** against the provider's current documentation before relying on them. They are general knowledge at the time of writing, not checked sources.
- GitHub is the only provider in real use, under the repository owner's personal account and GitHub's standard terms.

## 2. Register

| ID | Provider | Service | Used for | Reality | Data location | Transfer outside EU/EEA | Transfer mechanism (to verify) | DPA (to verify) |
|---|---|---|---|---|---|---|---|---|
| SUP-01 | Amazon Web Services | AWS (IAM Identity Center, S3, RDS, ECS, CloudTrail, KMS) | PA-01, PA-03, PP-01 | Planned | Target `eu-central-1` (Frankfurt). Terraform currently `ap-south-1` | None intended; possible remote support access | EU–US Data Privacy Framework and SCCs in the AWS DPA | AWS GDPR DPA, part of the AWS Service Terms |
| SUP-02 | Microsoft | Entra ID | PA-01 | Planned (lab tenant on the Free plan) | EU Data Boundary when tenant country is in the EU | Limited; see Microsoft EU Data Boundary documentation | DPF and SCCs in the Microsoft Products and Services DPA | Microsoft Products and Services DPA |
| SUP-03 | GitHub (Microsoft) | Repository hosting, Actions CI | PA-01 (public file), PA-02 | **Real** | United States | Yes | DPF and SCCs in the GitHub DPA | GitHub Data Protection Agreement (applies to paid/organization plans; personal accounts use the GitHub Privacy Statement) |

## 3. Selection and review criteria

Before any provider processes real personal data:

1. A DPA covering Art. 28(3) items is in place and filed.
2. Data location is pinned to `eu-central-1` or another EU Region, and the Terraform matches.
3. The transfer mechanism for any remaining access from outside the EU is recorded, with a transfer impact assessment (planned slice G-06).
4. Sub-processor change notifications are subscribed to.
5. The provider's security attestations (for example ISO/IEC 27001 certificate, SOC 2 report) are retrieved and dated.

Review each entry annually and whenever the provider changes its terms or sub-processors.

## 4. Gaps

- No DPA, attestation or sub-processor notice has been retrieved for any provider.
- SUP-03 is real today and transfers data (commit metadata, `personnel.json`) to the United States, publicly.
- SUP-01 Region does not match the target.
