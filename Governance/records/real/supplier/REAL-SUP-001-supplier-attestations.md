# REAL-SUP-001: Published supplier assurance pages read (AWS, Microsoft, GitHub)

> **REAL RECORD.** Performed on the date shown. Scope and limits are stated below.

| Field | Value |
|---|---|
| Record ID | REAL-SUP-001 |
| Performed | 2026-11-10 |
| Performed by | Claude Code (AI agent) with the `WebFetch` tool, on behalf of the repository owner. The owner has not re-read these pages; open item REAL-SUP-001-O1 |
| Controls | NIS2 Art. 21(2)(d); ISO/IEC 27001:2022 A.5.19 to A.5.23; POL-VEN-01; processor register SUP-01 to SUP-03; ISMS-MON-02 |
| Supports | [NIS2-05](../../../NIS2/05-supply-chain-security.md) Part B, [processor register](../../../GDPR/processor-register.md) |

## 1. What this is, and is not

This record lists what the **public** compliance pages of three providers say today. It is the first step of the supplier review in [ISMS-MON-02](../../../ISMS/08-monitoring-and-measurement/supplier-performance-review.md). It is **not** a supplier assessment:

- No report (SOC 1, SOC 2, C5 attestation, ISO certificate) was downloaded or read. All of them sit behind AWS Artifact, the Microsoft Service Trust Portal or the GitHub enterprise Compliance tab, which need an account. Ayka has none of those accounts (AWS: not deployed; Microsoft: lab tenant on the Free plan; GitHub: personal account).
- No certificate validity date, audit period, auditor opinion, exception or CUEC was read. None is stated in this file except where a page printed it and the line says so.
- The pages say what a provider **offers**. They do not say what plan, tenant or account Ayka uses is covered. Coverage for Ayka's plans is **to verify**.

How the pages were read: `WebFetch` returns either the raw page text (Microsoft Learn pages) or a short extract written by a small model from the page (all other pages). Rows marked "extract" are therefore second-hand and should be re-read on the page before they are quoted to a customer. Rows marked "raw" were read as page text. "Retrieved 2026-11-10" below means exactly that: the fetch succeeded in this session on that date.

## 2. AWS (SUP-01)

| Fact | Source URL | Retrieved | How read | What the page says |
|---|---|---|---|---|
| ISO/IEC certification | <https://aws.amazon.com/compliance/iso-27001-faqs/> | 2026-11-10 | extract | AWS holds certification for ISO/IEC 27001:2022, 27017:2015 and 27018:2019. Certifying body named: EY CertifyPoint. The page links a PDF "AWS ISO/IEC 27001:2022 Certification" that lists in-scope Regions. **No dates shown on the page.** ISO/IEC 27701 not mentioned |
| BSI C5 | <https://aws.amazon.com/compliance/bsi-c5/> | 2026-11-10 | extract | Report available through AWS Artifact. Regions in scope listed as Frankfurt, Ireland, London, Paris, Milan, Stockholm, Singapore, Zurich and Spain. The page does not say whether the AWS report is Type 1 or Type 2 and gives no report date. It mentions C5:2020 (finalised January 2020) |
| SOC 1, SOC 2, SOC 3 | <https://aws.amazon.com/compliance/soc-faqs/> | 2026-11-10 | extract | SOC 1 and SOC 2 through AWS Artifact, NDA required. SOC 2 covers Security, Availability, Confidentiality and Privacy, published twice a year for 12-month periods ending 3/31 or 9/30. SOC 3 is public. Page says reports are released "approximately 9-10 weeks after the end date of that period". The page states a pattern, not the date of any specific report |
| GDPR DPA and SCCs | <https://aws.amazon.com/compliance/gdpr-center/> | 2026-11-10 | extract | The page says the AWS DPA confirms that the SCCs apply automatically, and that the Service Terms include the SCCs adopted by the European Commission in June 2021. It describes no signing step. It does **not** mention the EU-US Data Privacy Framework |
| EU-US Data Privacy Framework listing | <https://www.dataprivacyframework.gov/list> | 2026-11-10 (page opened) | extract | The list page is a search form; the fetch showed no participant data. **AWS listing: not retrieved - to verify** |
| SOC 2 page `/compliance/soc/` | <https://aws.amazon.com/compliance/soc/> | not retrieved | - | HTTP 404 on 2026-11-10; the FAQ URL above worked instead |
| AWS Artifact contents (actual reports) | AWS Artifact console | not retrieved - to verify | - | Needs an AWS account |

## 3. Microsoft: Azure and Entra ID (SUP-02)

| Fact | Source URL | Retrieved | How read | What the page says |
|---|---|---|---|---|
| ISO/IEC 27001 | <https://learn.microsoft.com/en-us/compliance/regulatory/offering-iso-27001> | 2026-11-10 | raw | Page title still says ISO/IEC 27001:2013. Azure is audited once a year by a third-party accredited certification body. Azure and Azure DevOps Services are in the in-scope list. In the Office 365 (Commercial) table, **Microsoft Entra ID** is listed. A link on the page is titled "Microsoft 365 - ISO 27001:2022 Certificate (2024-2027)". That is the link text only; the certificate itself was not opened, so no validity date is stated here. Reports are requested through the Service Trust Portal |
| BSI C5 | <https://learn.microsoft.com/en-us/compliance/regulatory/offering-c5-germany> | 2026-11-10 | raw | "Microsoft Azure, Azure Government, and Azure Germany maintain a combined report (C5, SOC 2 Type 2, CSA STAR Attestation)". Page links "Microsoft 365 - C5 Worldwide - C5 Type 2 Report" on the Service Trust Portal. The in-scope list names Azure and Microsoft 365 Germany; **Entra ID is not named** on this page. Page says a customer needs its own C5 attestation for components built on top |
| SOC 2 Type 2 | <https://learn.microsoft.com/en-us/compliance/regulatory/offering-soc-2> | 2026-11-10 | raw | Azure is in scope. In the Office 365 table, Entra ID appears for GCC, GCC High and DoD but **not in the "Commercial" row** as printed. Whether the commercial Entra ID service Ayka would use is covered by a SOC 2 report is therefore **not established**. Office 365 SOC 2 Type 2 runs on a period of 1 October to 30 September; quarterly bridge letters exist. A subscription or trial account is needed to download reports. Reports contain "Management Response" and "User Entity Responsibilities" sections (the CUECs) |
| EU Standard Contractual Clauses | <https://learn.microsoft.com/en-us/compliance/regulatory/offering-eu-model-clauses> | 2026-11-10 | raw | Microsoft offers the EU SCCs, available as described in the Online Services Terms Data Protection Addendum. Entra ID is in the Office 365 (Commercial) in-scope table. The page mentions the Privacy Shield being invalidated in July 2020 and does **not** mention the Data Privacy Framework |
| EU-US Data Privacy Framework listing | <https://www.dataprivacyframework.gov/list> | see AWS row | - | **Microsoft listing: not retrieved - to verify** |
| Actual SOC/C5/ISO documents on the Service Trust Portal | <https://servicetrust.microsoft.com> | not retrieved - to verify | - | Needs a Microsoft sign-in |

## 4. GitHub (SUP-03)

| Fact | Source URL | Retrieved | How read | What the page says |
|---|---|---|---|---|
| Compliance reports offered | <https://docs.github.com/en/enterprise-cloud@latest/admin/overview/accessing-compliance-reports-for-your-enterprise> | 2026-11-10 | extract | Enterprise owners find them under the enterprise's **Compliance** tab. Listed: SOC 1 Type 2, SOC 2 Type 2, CSA CAIQ (Level 1), ISO/IEC 27001:2022 certification, CSA STAR (Level 2). No report dates on the page. **These are for GitHub Enterprise accounts. Ayka's repository is on a personal account, so Ayka has no access to this tab** |
| GitHub Data Protection Agreement | <https://github.com/customer-terms/github-data-protection-agreement> | 2026-11-10 | extract | Forms part of the GitHub Customer Agreement. Applies to all Online Services except bespoke-terms products and Previews. Includes the SCCs (Implementing Decision 2021/914) and lists GitHub's Data Privacy Framework participation as an alternative transfer basis "subject to GitHub's self-certification". The page shows "Version: October 2025". The page does not confirm current certification |
| Whether the DPA applies to a personal account | same | not established - to verify | - | The processor register says the DPA applies to paid and organization plans. The extract talked about the Customer Agreement and did not settle this |
| EU-US Data Privacy Framework listing | <https://www.dataprivacyframework.gov/list> | see AWS row | - | **GitHub listing: not retrieved - to verify** |
| Security overview page | <https://github.com/security> | 2026-11-10 | extract | Contains only the heading "GitHub's API stays secure with ISO, SOC 2, and GDPR". It does not name ISO 27001 or link a report. Not usable as evidence |
| `docs.github.com/.../github-data-protection-agreement` and `resources.github.com/security/` | - | not retrieved | - | The first returned a privacy-policies index, the second HTTP 404 |

## 5. What this changes in the repository

| Before | After |
|---|---|
| Processor register and NIS2-05: "no attestation retrieved" | Public pages read and dated; the attestations themselves are still not retrieved |
| ISO/IEC 27001 certificate dates | Still unknown. Do not quote any |
| Entra ID assurance | Open question: Entra ID is named on the Microsoft ISO page (Office 365 Commercial table) and the SCC page, but not on the SOC 2 Commercial row or on the C5 page as read |

## 6. Open items (owner)

| ID | Item | Needs |
|---|---|---|
| REAL-SUP-001-O1 | Owner re-reads the rows marked "extract" on the live pages before quoting them externally | Owner, 30 minutes |
| REAL-SUP-001-O2 | Download SOC 2 Type 2, C5 and ISO certificate from AWS Artifact and the Service Trust Portal; record period, opinion, exceptions, CUECs | An AWS account and a Microsoft sign-in |
| REAL-SUP-001-O3 | Search the Data Privacy Framework list for Amazon Web Services, Microsoft and GitHub and record the result and the date | Owner, browser, 10 minutes |
| REAL-SUP-001-O4 | Confirm which GitHub terms govern the personal account that hosts this repository | Owner |

## 7. Reproduce

Open each URL above. Compare with the "What the page says" column. Pages change; a different result later does not make this record wrong, it makes it dated.

## Limit

A page that says a provider holds a certification is not the certificate. Nothing here shows that Ayka's own use of any service is in scope of those certifications, and Ayka runs none of these services in production.
