# DPO decision and legal-basis register

| Field | Value |
|---|---|
| Document ID | GDPR-11 |
| Owner | Compliance & Risk Management |
| Approver | Managing Director |
| Version | 1.1 |
| Effective | On approval |
| Next review | 12 months after approval, or when headcount, core processing or a purpose changes |
| Status | Draft. DPO designation reasoned and recommended, not yet carried out. Legal bases reviewed by the repository owner with AI assistance, not by counsel |

Ayka Secure Technologies GmbH is a simulated company. This is not a legal opinion. Primary texts not fetched in this work are **to verify**, as in the [legal register](../ISMS/00-context-and-governance/legal-and-regulatory-register.md). BDSG § 38 was read from the official text on 2026-11-10 ([REAL-PRIV-002](../records/real/privacy/REAL-PRIV-002-bdsg-38-reading.md)).

## 1. Data protection officer

### 1.1 The rules

- Art. 37(1): a DPO is mandatory for a public body, or where the core activities consist of regular and systematic monitoring of data subjects on a large scale (b), or of large-scale processing of special categories or criminal-offence data (c).
- BDSG § 38(1) sentence 1 adds a threshold: controller and processor designate a DPO "soweit sie in der Regel mindestens 20 Personen ständig mit der automatisierten Verarbeitung personenbezogener Daten beschäftigen".
- BDSG § 38(1) sentence 2: regardless of the number of persons, a DPO is mandatory where the processing is subject to a DPIA under Art. 35, or where personal data is processed commercially for transfer, anonymised transfer, or market or opinion research.
- BDSG § 38(2): § 6(4) (dismissal protection, only where designation is mandatory), (5) sentence 2 (confidentiality) and (6) apply.

### 1.2 Application to Ayka

| Test | Finding |
|---|---|
| Art. 37(1)(a) public body | No. Private GmbH |
| Art. 37(1)(b) core activity is large-scale regular monitoring | No. The core activity is a compliance SaaS. Security logging (PA-03) is ancillary and not large scale at 24 staff and a small customer base |
| Art. 37(1)(c) large-scale special categories | No. None intended; customers are expected not to upload them (CUEC-04). That expectation is not a control |
| § 38(1) sentence 1: 20 persons constantly engaged | See the count below. On the narrow reading the threshold is not reached; on the reading adopted here it is |
| § 38(1) sentence 2: processing subject to a DPIA | The [DPIA](dpia-ayka-portal.md) finds PA-03 subject to Art. 35. Once that processing is undertaken, a DPO is mandatory whatever the headcount |
| § 38(1) sentence 2: commercial transfer or market research | No |

Count of staff "constantly engaged" in automated processing of personal data, from the [personnel register](../../organization/personnel-register.md) (24 persons, all full-time):

| Group | Basis for counting | Persons |
|---|---|---|
| Office work on personal data: executive, HR, finance, sales and customer success, marketing, compliance, governance, IT support | Staff, customer-contact, payroll or supplier records are part of daily work | EMP-001, 009, 010, 011, 012, 016, 018, 021, 022, 023, 024, 004: 12 |
| Security roles with sight of logs and identities | Designed log sources carry IP addresses and user identifiers | EMP-002, 005, 014, 017, 020: 5 |
| Platform administrators with access to identity and personnel data | Entra ID and AWS administration | EMP-003, 013, 019: 3 |
| Developers and product, working on synthetic data under the secure development policy | Not counted as constant, because live personal data is forbidden in development | EMP-006, 007, 008, 015: 4 |

Narrow reading: 12 + 5 = 17. Reading adopted: 12 + 5 + 3 = 20. Widest reading: 24. The statutory word is "ständig" (constantly) and "in der Regel" (as a rule). The case law and authority guidance on how to count are **to verify**; the threshold figure of 20 is verified from the official text. The count is uncertain by about three persons around the line, and the headcount grows (joiners are recorded in the people records, not here).

### 1.3 Decision

| Item | Decision |
|---|---|
| Designate a DPO | **Yes.** Reasons: the adopted count reaches 20; sentence 2 applies when PA-03 is switched on; the cost of an external officer is lower than the cost of a wrong "no" with a regulator. This is a recommendation to the Managing Director until a dated management decision exists. A walk-through of that decision is in [SIM-GDPR-001](../records/simulated/privacy/SIM-GDPR-001-dpo-decision-minutes.md) |
| Internal or external | **External** (Art. 37(6)). Every internal role is conflicted under Art. 38(6): EMP-001 decides purposes and means; EMP-002 owns the ISMS and security processing; EMP-004 writes and maintains the processing record and reports to the CISO; EMP-021 and EMP-012 run processing operations. A DPO cannot monitor their own work |
| Named officer | **None.** No provider selected and no contract. Until then no "DPO" is published and nobody holds the title |
| Tasks | Art. 39: inform and advise, monitor compliance, advise on the DPIA (Art. 35(2)), cooperate with the authority, act as contact point |
| Resources and independence | Art. 38(2), (3): access to records and staff, no instructions on the exercise of tasks, reports to the Managing Director. Budget not set |
| Publication and notification | Art. 37(7): contact details published in both [privacy notices](privacy-notice-employees.md) and communicated to the competent authority (LfDI Baden-Württemberg, as in the breach procedure). Not done: no officer |
| Until appointed | The Managing Director is accountable. Compliance & Risk Management prepares the file. Decisions that need DPO advice (the DPIA) are marked "advice outstanding" |

Uncertainty stated: the headcount reading, the counting of developers, the possibility that the authority or a court would count differently, and § 38 amendments after the version read. A different reading would not change the decision, because sentence 2 carries it once PA-03 operates.

## 2. Legal-basis register

Reviewed on 2026-11-10 by the repository owner with AI assistance. **Not reviewed by counsel.** A basis is a working conclusion. Employee consent is not used, because of the imbalance in employment (Recital 43; § 26(2) BDSG, **to verify**).

| Activity | Basis | Reasoning | Balancing test or contract | Reviewed |
|---|---|---|---|---|
| PA-01 Employee identity and access | Art. 6(1)(b), with § 26(1) BDSG; Art. 6(1)(c) for statutory duties | Accounts and access are needed to perform the employment contract. After CJEU C-34/21 (30 March 2023) the status of § 26(1) sentence 1 as a national rule under Art. 88 is **to verify**; Art. 6(1)(b) stands on its own for contract performance, so the basis survives that question | Employment contract is designed, not signed. Staff are fictional except the public owner record. The public disclosure in `personnel.json` has no basis for a third party's data and is an open gap | Owner, AI-assisted. Not counsel |
| PA-02 Repository and CI | Art. 6(1)(f) | Traceable change history | [Legitimate interests assessment](legitimate-interests-assessment.md) section 2 | Owner, AI-assisted. Not counsel |
| PA-03 Security logging | Art. 6(1)(f); Art. 32 supports necessity; for staff § 26 and C-34/21 **to verify** | Recital 49 | [Legitimate interests assessment](legitimate-interests-assessment.md) section 1 and the [DPIA](dpia-ayka-portal.md) | Owner, AI-assisted. Not counsel. Not operating |
| PA-04 Personnel administration and training | Art. 6(1)(b) with § 26(1) BDSG; Art. 6(1)(c) for statutory records | Role assignment, onboarding and training are part of employment | No real training records. Retention per record type is not set | Owner, AI-assisted. Not counsel |
| PA-05 Website and contact enquiries | Art. 6(1)(f) for server logs and enquiry handling; Art. 6(1)(a) for any non-essential cookie or newsletter, with § 25 TDDDG for terminal-equipment access (**to verify**) | See the [website notice](privacy-notice-website.md) | Website is a draft. No consent mechanism is built | Owner, AI-assisted. Not counsel |
| PA-06 Customer contacts and billing | Art. 6(1)(b) for the contract; Art. 6(1)(c) for commercial-law bookkeeping | Ayka is controller for the contact persons of its customers | No customer exists | Owner, AI-assisted. Not counsel |
| PP-01 Customer evidence | The customer, as controller, determines the Art. 6 basis. Ayka processes on documented instructions (Art. 28(3)(a)). Ayka's own purposes (service security, billing) need their own basis, which is PA-03 and PA-06 | See the [DPA template](data-processing-agreement-template.md) | No customer contract | Not applicable to Ayka as basis owner |

Special categories (Art. 9) are not proposed for any activity.

## 3. Status

Designed. The DPO position is reasoned and recommended; the appointment is not made. The legal-basis register has a stated review that is not a legal review. LR-02 stays unmet as a legal conclusion until counsel confirms the count and § 26.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
| 1.1 | 2026-11-10 | DPO designation reasoned (Art. 37, § 38 BDSG read from the official text); bases reviewed and extended to PA-05, PA-06 |
