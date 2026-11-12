# SIM-INF-001 Classification, labelling and transfer review

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-INF-001 |
| Authored | 2026-11-10 |
| Scenario date | 2026-07-20 |
| Participants | EMP-018 (Governance & Risk Analyst, runs the sample), EMP-004 (Compliance Analyst, reviews the transfer), EMP-002 (CISO, owner of the classification scheme), EMP-009 (Sales Manager, sender), EMP-010 (Customer Success Manager, prepares the pack), EMP-012 (HR, acknowledgement records) |
| Procedure exercised | [Data classification and confidentiality policy POL-DATA-01](../../../policies/data-classification-and-confidentiality-policy.md) sections 4, 5.1, 5.4 and 7; [Acceptable use policy POL-AUP-01](../../../policies/acceptable-use-policy.md) sections 2 and 4; [Cryptography policy POL-CRY-01](../../../policies/cryptography-policy.md) (transport rows) |
| Controls | ISO/IEC 27001:2022 Annex A A.5.10, A.5.12, A.5.13, A.5.14; SOC 2 CO-01 to CO-03 |

"Customer A (fictional)" is a fictional pilot customer. All facts about its contacts and about the files sent are scenario values. Real observations about the repository are marked as such.

## 1. What the policies require

- POL-DATA-01 section 4: four levels (Public, Internal, Confidential, Restricted). Customer data is Confidential by default. Unlabelled information is treated as Internal until the owner classifies it.
- Section 5.1: every AWS resource that stores data carries a `DataClassification` tag. The system description's data table (section 3.6) is the inventory of confidential data stores.
- Section 5.4: Confidential information goes to third parties only under an NDA or a DPA and only "through approved channels". Security findings and the SOC 2 report go to customers only under NDA.
- POL-AUP-01 section 2: "Staff must ask the information owner before sharing non-public material with a new recipient or service"; no customer evidence or credentials in public Git, public issues or personal mail; publication needs owner approval.
- POL-AUP-01 section 4: the CISO reviews acknowledgements annually. HR issues the policy before access.

## 2. Sample (A.5.12 and A.5.13, scenario)

EMP-018 drew 12 items on 2026-07-20: 4 shared drive documents, 3 repository documents, 3 items from the restricted HR and finance stores, and 2 outbound attachments from the previous two weeks.

| # | Item | Owner | Label found | Class by policy | Result |
|---|---|---|---|---|---|
| 1 | Architecture overview (PDF) | EMP-003 | None | Internal (default) | Correct by default. Not labelled |
| 2 | Customer proposal for Customer A (fictional) | EMP-009 | "Confidential" in the file name only | Confidential | Label in name is not a marking |
| 3 | Pilot onboarding checklist | EMP-010 | None | Internal, but it names pilot users: Confidential | **Wrong default** |
| 4 | Supplier list with contract values | EMP-016 | None | Confidential | **Wrong default** |
| 5 | Policy POL-AC-01 | EMP-002 | `Classification: Internal` in the header | Public (published in a public repository) | **Label contradicts the policy** (see real observation) |
| 6 | Policy POL-PHY-01 | EMP-012 | No label | Public (published) | Unlabelled |
| 7 | Risk register | EMP-018 | No label | Internal/Public (published) | Unlabelled |
| 8 | HR recruitment folder | EMP-012 | Folder named "HR-private" | Confidential (personnel data) | Folder name is a de facto label |
| 9 | Payroll export | EMP-024 | None | Confidential | Held in finance store. No label |
| 10 | Break-glass vault entry | EMP-003 | "Restricted" in the entry title | Restricted | Correct |
| 11 | E-mail attachment sent to Customer A (fictional), 2026-07-14: customer proposal | EMP-009 | None | Confidential | See section 3 |
| 12 | E-mail attachment sent on 2026-07-20: pilot pack | EMP-010 | None | see section 3 | See section 3 |

Result: 2 of 12 labelled in a way a recipient would recognise as a classification (items 5 and 10). 1 of 12 labelled wrongly (item 5). 3 of 12 classified wrongly by default (items 3, 4 and 9 if left unlabelled). Nobody knew where to put a label on a Word or PDF file: POL-DATA-01 says "labelling" only for cloud resources. There is no rule for documents.

### Real observation (2026-11-10), not scenario

- Of 121 non-record Markdown files under `Governance/`, 16 carry a `Classification` row in their header. All 16 say "Internal" (three add "share under NDA" wording). None says "Public".
- Of the 22 policy and standard files in `Governance/policies/`, 7 carry a classification row and 15 carry none.
- The repository is public ([POL-SDL-01](../../../policies/secure-development-policy.md) section 4.9). POL-DATA-01 section 4 lists "published policies, this repository" as Public examples. An "Internal" label on a document in a public repository contradicts the scheme.
- `DataClassification` on resources: POL-DATA-01 section 8 states that the tag is one workload-wide default on 59 of 97 planned resources and is not a classification by dataset.

## 3. Outbound transfer to Customer A (fictional), 2026-07-20 (A.5.14)

**Scenario.** On 2026-07-20 at 10:42 EMP-010 sent "the pilot pack" to the technical contact of Customer A (fictional): a 6-page architecture overview (item 1), the sub-processor list taken from the processor register, and a one-page description of the audit-log format. EMP-009 had asked her to send it. EMP-004 reviewed the transfer on 2026-07-20 at 15:00 from the sent folder.

| Check (POL-DATA-01 5.4 and POL-AUP-01) | Result |
|---|---|
| Is there an NDA or a DPA? | A mutual NDA with Customer A (fictional) was agreed on 2026-07-08 (scenario decision by EMP-001; the signature itself is not recorded). No DPA yet. The sub-processor list is not personal data. The NDA is not in any index. The [NDA index](../people/SIM-PPL-002-nda-index.md) covers staff only |
| Classification of the pack | Items 1 and 3 Internal. The sub-processor list is a customer-facing commitment: Internal, shared under NDA. **No label on any page**, so the recipient sees no handling instruction |
| Did the owner approve sharing with a new recipient? | EMP-003 owns the architecture overview. He was not asked. EMP-009 asked EMP-010 to send. Sharing with a "new recipient" has no recorded owner approval |
| Approved channel? | E-mail with attachments from EMP-010's mailbox. **POL-DATA-01 names no approved channel.** The word "approved" has nothing to point at. Opportunistic transport encryption was not confirmed |
| Right recipient? | The address was copied from a previous message of 2026-07-14. A second check of the recipient address was not done. No rule asks for one |
| Content check | The sub-processor list says "AWS, Microsoft, GitHub" with locations. The processor register marks every transfer mechanism "to verify" (see [SIM-NIS2-002](../nis2/SIM-NIS2-002-customer-supplier-security-assessment.md) finding 6). The list was sent without that qualifier |
| Record kept | None except the sent folder |

Decision by EMP-004 (scenario): the transfer was allowed in substance (NDA in place, Internal content). The missing qualifier on the sub-processor list is corrected by a follow-up note sent 2026-07-21 by EMP-010. No recall is possible. Future sends of Confidential content must use a shared folder with an expiry date, set up by EMP-011 on 2026-07-31 (scenario).

## 4. Acceptable-use acknowledgement (A.5.10)

POL-AUP-01 section 1 says no acknowledgement exists. Scenario: EMP-012 produced the acknowledgements for the 24 staff signed at joining (scenario text, no signatures). 22 of 24 had the version "1.0". Two joined before the policy existed and have no acknowledgement (EMP-001, EMP-002; the register start date is 2026-01-01). EMP-012 asked both; neither had answered by the review date. The annual CISO review of acknowledgements (POL-AUP-01 section 4) has no first date.

## Findings

1. **No rule for labelling documents.** POL-DATA-01 5.1 defines a tag for cloud resources only. There is no marking convention for files, e-mails or PDFs, so recipients see no classification. Add a footer or file-header convention and an example.
2. **Repository documents are labelled Internal while the repository is public.** 16 documents carry "Internal". POL-DATA-01 lists the repository as Public. Decide: either the classification header is dropped for published documents, or the policy says "Internal" means "approved for the public repository". (Real finding.)
3. **"Approved channels" is empty.** POL-DATA-01 5.4 and POL-AUP-01 section 2 refer to approved channels. None is listed in either document or in the communication plan. List them (for example, a shared folder with expiry for customers).
4. **Section 5.4 covers only outbound sharing.** This sample drew no inbound item. The only inbound case in the fiction is the customer onboarding file that arrived by e-mail on 2026-08-04 ([SIM-INC-001](../incident/SIM-INC-001-inc-2026-001-customer-export-in-public-ci.md)). Nothing in the policy says how Ayka receives Confidential files.
5. **No owner approval step is recorded.** POL-AUP-01 requires "ask the information owner". Nothing records the answer. The pack went out without EMP-003 being asked.
6. **Customer NDAs have no index.** The NDA template's index covers people. A customer NDA is not listed anywhere. It decides whether Confidential content may be sent.
7. **Classification by default is wrong for mixed documents.** An "Internal until classified" default put a list of pilot users and a supplier list with contract values at Internal. The policy needs a short test: "does it name a customer, a user or a price? Then Confidential".
8. **Acknowledgements for the top of the company are missing.** POL-AUP-01 relies on the onboarding procedure. The two people who adopted the policy had no onboarding.
9. **Sub-processor statements go out without the "to verify" status.** The processor register marks transfer mechanisms "to verify" and the transfer check has no step to carry that status into the outgoing text.

## What this does not show

- No customer, NDA, pack or e-mail exists. Times and contents are scenario values.
- That any real recipient received, opened or relied on anything. No statement by any third party is recorded.
- A transfer of Restricted information. Not exercised.
- A transfer by a supplier. Only the customer direction is walked.
- Any check of encryption in transit. Not performed, only noted as unknown.
