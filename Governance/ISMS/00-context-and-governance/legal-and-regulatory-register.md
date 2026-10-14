# Legal, regulatory and contractual requirements register

| Field | Value |
|---|---|
| Document ID | ISMS-00-05 |
| Owner | Compliance & Risk Management |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or on a change in law, a new or changed contract, or a [NIS2-01 trigger](../../NIS2/01-applicability-assessment.md#7-when-this-assessment-must-be-repeated) |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company. It has signed no customer contract and holds no legal opinion. This register states which requirements would apply to the company as designed, and marks every legal threshold, period or contract term that was not checked against a primary source as **to verify**. It is not legal advice.

## 1. Purpose

ISO/IEC 27001:2022 clause 4.2 b asks for the requirements of interested parties, and Annex A controls A.5.31 (legal, statutory, regulatory and contractual requirements), A.5.32 (intellectual property rights) and A.5.34 (privacy and protection of PII) ask Ayka to identify them, keep them up to date and say how it meets them. This register identifies the requirements and the evidence gaps; it does not establish legal compliance. The parties behind each requirement are in [interested parties](interested-parties.md); the issues they raise are in [context of the organization](context-of-the-organization.md).

## 2. How to read this register

- **Applies?** Yes, No, Not yet (would apply once Ayka trades) or To verify, with the reason.
- **Status** uses the weakest true label from the [SOC 2 status vocabulary](../../SOC2/README.md#4-status-vocabulary): Implemented, Partial, Gated design, Designed, Planned. A written document that nobody has approved or operated is at most Designed.
- **Owner role** watches the requirement for changes and keeps the "How met" column true. Role names follow [roles and responsibilities](../../../organization/roles-and-responsibilities.md). Where a source document names a sub-role (for example "Compliance Officer" in NIS2-01, "Financial Controller", "Supplier Risk Coordinator" in NIS2-05), this register uses the role it belongs to.
- **Review** is the minimum. Every row is also reviewed when its law or contract changes.

## 3. Laws and regulations

| ID | Requirement | Source | Applies? Why | Owner role | How met | Status | Review |
|---|---|---|---|---|---|---|---|
| LR-01 | Data protection: lawful processing, records of processing, processor terms, security of processing, role-specific breach notification and deadlines, data subject rights | [GDPR, Regulation (EU) 2016/679](https://eur-lex.europa.eu/eli/reg/2016/679/oj), in particular Art. 5, 6, 28, 30, 32 to 34; current text/applicability to verify | **Yes.** Real repository metadata exists; workforce and customer processing are designed cases. Controller/processor roles require confirmation against actual purposes (PA-01, PA-02) | Compliance & Risk Management | [GDPR documents](../../GDPR/README.md): [RoPA](../../GDPR/record-of-processing-activities.md), [processor register](../../GDPR/processor-register.md), TOMs; [data protection policy](../../policies/data-protection-policy.md); breach path in [NIS2-03 §6](../../NIS2/03-incident-reporting-procedure.md#6-personal-data-breaches-gdpr) | Designed. DPIA screening, transfer assessment, data subject rights and breach procedures are Planned ([GDPR README](../../GDPR/README.md#documents)); EU data location not met (RISK-011) | Annually |
| LR-02 | German supplement to the GDPR: employee data processing, designation of a data protection officer | BDSG, in particular §26 (employment) and §38 (DPO) | **For the designed employment model.** Staff are fictional. Whether §26 can still be relied on after CJEU case C-34/21, and whether Ayka reaches the §38 threshold for a mandatory DPO, are **to verify** | Compliance & Risk Management | RoPA PA-01 and PA-04; DPO decision is Planned ([GDPR README](../../GDPR/README.md#documents)) | Planned | Annually, and at the T-1 headcount check in NIS2-01 |
| LR-03 | Cybersecurity risk-management measures, incident reporting, registration and management duties for essential and important entities | NIS2, Directive (EU) 2022/2555; BSIG as amended by the NIS2UmsuCG; Implementing Regulation (EU) 2024/2690 | **Outside direct scope in the current working assessment, to verify before real use.** Result of [NIS2-01 §1](../../NIS2/01-applicability-assessment.md#1-result): sector test probably met, size test not met (24 staff). This register does not re-decide it. Applies indirectly through customer contracts, see CR-02 | CISO | Voluntary measures in [NIS2-02](../../NIS2/02-risk-management-measures.md); reporting process in [NIS2-03](../../NIS2/03-incident-reporting-procedure.md); triggers in [NIS2-01 §7](../../NIS2/01-applicability-assessment.md#7-when-this-assessment-must-be-repeated) | Designed (assessment written, decision record empty) | Six-monthly with NIS2-01; next scheduled 2027-04-06 |
| LR-04 | Consent for storing or reading information on users' devices (cookies, local storage) in the portal and on any website | TDDDG (formerly TTDSG), §25 | **To verify.** No website or portal is live. Applies as soon as either sets non-essential cookies or similar | Product & Engineering | Nothing designed yet | Planned | Before the first public launch |
| LR-05 | Managing director's duty of care, including organising adequate risk management and information security | GmbHG §43 | **For the designed company.** The case study describes a GmbH with one managing director ([NIS2-04 §1](../../NIS2/04-management-accountability.md#1-who-management-is-at-ayka)) | Managing Director | [NIS2-04](../../NIS2/04-management-accountability.md); [risk criteria](../03-risk-management/risk-criteria.md); [management review agenda](../10-management-review/management-review-agenda.md) | Designed. No quarterly report or management review has taken place | Annually |
| LR-06 | Readable commercial/tax records; category-dependent retention and retrieval | [HGB §257](https://www.gesetze-im-internet.de/hgb/__257.html); [AO §147](https://www.gesetze-im-internet.de/ao_1977/__147.html), read 2026-10-14 | **Not yet operational.** Normal periods are 10 years for books/accounts, 8 for accounting vouchers, 6 for business letters; category, transition provisions and open tax matters must be checked for each actual record | Managing Director | [Retention policy](../../policies/records-and-data-retention-policy.md) sets trigger rules and remaining validation | Designed. No commercial records exist in the case study | Annually, with annual accounts |
| LR-07 | Protection of trade secrets requires "appropriate confidentiality measures" by the holder | GeschGehG §2 no. 1 | **Yes**, for non-public information (customer lists, pricing, security findings). Not for the source code, which is published under Apache 2.0 | Compliance & Risk Management | [NDA template](../01-organization/nda-template.md); [POL-DATA-01](../../policies/data-classification-and-confidentiality-policy.md#4-classification-levels) | Designed. No signed NDA exists | Annually |
| LR-08 | Respect copyright and licence terms of software and content Ayka uses; license its own work clearly | UrhG, in particular §§69a ff. (computer programs); licence terms of each tool | **Yes.** Details in section 5 | Product & Engineering | Repository licence: [Apache 2.0](../../../LICENSE); pinned tools in [`toolchain.versions`](../../../Internal-IT/engineering/ci-cd/toolchain.versions); [secure development policy](../../policies/secure-development-policy.md) | Partial. Ayka's own licence is set; no licence inventory or licence check of tools and dependencies exists | Annually, and when a tool is added or upgraded |
| LR-09 | Export control of cryptography and dual-use items | Regulation (EU) 2021/821 (dual-use) | **To verify.** Ayka uses standard encryption through AWS KMS and TLS and exports no cryptographic product. Classification and any exemption or authorisation are not determined | CISO | [Cryptography policy](../../policies/cryptography-policy.md) | Planned | Annually |
| LR-10 | Duties associated with use or provision of AI systems, including literacy and prohibited practices | [Regulation (EU) 2024/1689](https://eur-lex.europa.eu/eli/reg/2024/1689/oj), including Art. 4 and Art. 5; current applicability **to verify** | **To verify.** Assess actual systems, intended purpose and provider/deployer role; no product-feature classification is established here | CISO | Legal assessment before adopting affected uses; role-specific training under the [competence matrix](../01-organization/competence-matrix.md) | Planned; no applicability approval or training record | Annually and on new system/use |
| LR-11 | Works-council co-determination for workplace conduct and specified monitoring systems | [BetrVG §87(1) nos. 1 and 6](https://www.gesetze-im-internet.de/betrvg/__87.html), read 2026-10-14 | **Conditional.** No council recorded; actual representation, statutory conditions and case-specific duties must be established before use | HR & Administration | [Disciplinary process](../01-organization/disciplinary-process.md); [communication plan](communication-plan.md) | Designed process; operating checks Planned | On an election initiative or monitoring change, else annually |
| LR-12 | Switching and exit obligations for providers of data processing services | EU Data Act, Regulation (EU) 2023/2854, Chapter VI | **To verify.** Whether the SaaS counts as a "data processing service" and which obligations apply to a provider of Ayka's size is not checked | Product & Engineering | Exit position in [NIS2-05 A.2](../../NIS2/05-supply-chain-security.md#a2-aykas-standard-positions) (designed only) | Planned | Before the first customer contract |
| LR-13 | Security requirements for products with digital elements | Cyber Resilience Act, Regulation (EU) 2024/2847 | **To verify.** Assess the actual product, related remote processing and supply model before deciding scope | Product & Engineering | None needed if out of scope | Planned | Annually |
| LR-14 | Internal whistleblowing channel | HinSchG §12 | **To verify.** Assess actual employer, headcount and any sector-specific rules before deciding whether a channel is required | HR & Administration | Security reporting channel in the [communication plan](communication-plan.md) | Planned | At the NIS2-01 T-1 headcount check |

## 4. Contracts

| ID | Requirement | Source | Applies? Why | Owner role | How met | Status | Review |
|---|---|---|---|---|---|---|---|
| CR-01 | Customer terms: service description, security commitments, GDPR Art. 28 processor terms, availability, data return and deletion at exit | Customer contracts (MSA, DPA, SLA) | **Not yet.** No customer contract exists | Product & Engineering | Standard positions in [NIS2-05 A.2](../../NIS2/05-supply-chain-security.md#a2-aykas-standard-positions); [SOC2-03](../../SOC2/03-control-matrix.md#3-information-and-communication-ic) IC-02 | Planned | At each contract, then annually |
| CR-02 | Supplier-security terms from NIS2-scope and automotive customers: incident notice (usually 24 hours), right to audit or evidence, subcontractor transparency, TISAX label or VDA ISA answers, vulnerability handling | Customer contracts and questionnaires; customers' duty under §30(2) no. 4 BSIG | **Not yet.** Expected from the first in-scope customer ([NIS2-01 §6](../../NIS2/01-applicability-assessment.md#6-step-4-indirect-applicability-through-customers)) | CISO | [NIS2-05 Part A](../../NIS2/05-supply-chain-security.md#part-a-ayka-as-a-supplier-to-nis2-entities); terms stricter than A.2 need CISO approval | Designed. Several A.2 positions cannot be kept today (24-hour notice, EU data location) | At each contract; with NIS2-01 |
| CR-03 | AWS terms: customer agreement, service terms including the AWS GDPR DPA, acceptable use policy; customer-side controls under the shared responsibility model | AWS contract documents (current versions to verify) | **To verify.** AWS is the planned host (SUP-01). CI uses mock credentials; no evidence in the repository shows an AWS account or accepted terms | Cloud Platform Engineering | [Processor register](../../GDPR/processor-register.md) SUP-01; [POL-VEN-01](../../policies/vendor-management-policy.md); [cloud security policy](../../policies/cloud-security-policy.md) | Planned. No attestation retrieved, no CUEC review ([NIS2-05 B.3](../../NIS2/05-supply-chain-security.md#b3-what-is-missing)) | Annually, or on a change of terms |
| CR-04 | GitHub terms: terms of service, acceptable use policies; data protection terms (the GitHub DPA applies to paid or organization plans; personal accounts use the privacy statement, per the processor register, to verify) | GitHub contract documents (current versions to verify) | **Yes.** The repository and CI run on GitHub today (SUP-03, real). Which plan and agreement apply is **to verify** | Cloud Platform Engineering | Processor register SUP-03; [POL-VEN-01](../../policies/vendor-management-policy.md); pinned actions per [NIS2-05 B.2](../../NIS2/05-supply-chain-security.md#b2-what-is-already-controlled) | Partial. Service in use; agreement not identified; no attestation retrieved | Annually, or on a change of terms |
| CR-05 | Microsoft terms for Entra ID: customer agreement or online subscription agreement, product terms, Products and Services DPA | Microsoft contract documents (current versions to verify) | **To verify.** A lab tenant on Entra ID Free is recorded (SUP-02); the agreement it runs under is not recorded | Cloud Platform Engineering | Processor register SUP-02; [POL-VEN-01](../../policies/vendor-management-policy.md) | Planned | Annually, or on a change of terms |
| CR-06 | Confidentiality and acceptable-use obligations of staff and contractors | Employment and contractor contracts; NDAs | **Yes** once staff are employed. The staff are fictional: no contract or signed NDA exists | HR & Administration | [NDA template](../01-organization/nda-template.md); [acceptable use policy](../../policies/acceptable-use-policy.md); [disciplinary process](../01-organization/disciplinary-process.md) | Designed (templates only) | Annually |
| CR-07 | Terms for additional development and automated-processing services: permitted data, retention, onward use and locations | Applicable provider agreement/version **to verify** for each selected service | **To verify per service.** No approval of terms or non-public data use is implied | CISO | [Vendor policy](../../policies/vendor-management-policy.md); record services, processing roles and agreements before use with non-public data | Planned | On selection and changes, then annually |

## 5. Intellectual property (A.5.32)

| Topic | Rule | Status |
|---|---|---|
| Ayka's own repository | Published under [Apache 2.0](../../../LICENSE). Ayka-owned contributions are intended for publication under it; third-party rights and notices still need checking. Nothing intended to remain proprietary may be committed | Implemented (licence file present) |
| Pipeline tools | Terraform 1.7.5, TFLint, conftest/OPA, tfsec, Checkov, pinned in [`toolchain.versions`](../../../Internal-IT/engineering/ci-cd/toolchain.versions). Each tool's licence and whether Ayka's use is permitted are **to verify**; identify the exact terms covering Terraform 1.7.5 before relying on any licence classification | Planned (no licence inventory) |
| Third-party GitHub Actions and Terraform providers | Pinned by commit SHA or lock file; licences not recorded | Planned |
| Standards text | ISO/IEC, SOC 2 and VDA texts are copyrighted. ISMS documents cite clause and control numbers and paraphrase; they do not reproduce the standards | Designed (writing rule; no check exists) |
| Third-party content and contributions | Review origin, rights and licence compatibility before merge; do not assume the repository licence grants rights in material Ayka does not own | Designed requirement in the [secure development policy](../../policies/secure-development-policy.md); checks Planned |

## 6. Privacy and protection of PII (A.5.34)

Covered by LR-01 and LR-02. The detailed documents are in [Governance/GDPR](../../GDPR/README.md) and the [data protection policy](../../policies/data-protection-policy.md). The [processing record](../../GDPR/record-of-processing-activities.md) records repository/CI metadata and a personnel-file classification question. The personnel register labels its entries fictional; do not infer real employment or a lawful basis from that file.

## 7. Keeping the register current

| Source watched | Who | How often |
|---|---|---|
| BSI and NIS2 publications (NIS2-01 trigger T-6) | Compliance & Risk Management | Monthly |
| EDPB and LfDI Baden-Württemberg guidance; German and EU data protection law changes | Compliance & Risk Management | Quarterly |
| Provider terms and notices for AWS, GitHub, Microsoft and additional tools | Cloud Platform Engineering; CISO for additional processing services | When notified, and annually |
| Customer contract drafts and questionnaires | Product & Engineering, with the CISO | At each contract |
| Headcount and works council status | HR & Administration | Quarterly (NIS2-01 T-1 check) |
| Tool and dependency licences | Product & Engineering | On each tool upgrade |

A change goes into this register first, then into the [risk register](../03-risk-management/risk-register.md) if it creates a risk, then into the affected policy. No review of this register has taken place yet, and no subscription to any of these sources exists.

## 8. Open items

| ID | Item | Owner role |
|---|---|---|
| LO-1 | Verify every "to verify" entry above against the primary source (law text, current provider terms) | Compliance & Risk Management |
| LO-2 | Decide on a DPO (BDSG §38, GDPR Art. 37) | Managing Director |
| LO-3 | Identify the GitHub, AWS and Microsoft agreements actually accepted, and record version and date | Cloud Platform Engineering |
| LO-4 | Validate HGB/AO category mapping and transitions before real retention starts; reconcile SOC2-05 and POL-DATA-01 with the retention policy | Managing Director |
| LO-5 | Build a licence inventory for pipeline tools and dependencies | Product & Engineering |

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
