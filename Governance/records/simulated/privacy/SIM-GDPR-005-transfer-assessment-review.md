# SIM-GDPR-005: Review of the data-flow map and transfer assessment

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-GDPR-005 |
| Authored | 2026-11-10 (real date) |
| Scenario date | 2026-07-07, the day after [SIM-SUP-001](../supplier/SIM-SUP-001-annual-critical-supplier-review.md). Cross-check against 2026-08-10 |
| Participants | EMP-004 (GDPR Lead, owner), EMP-016 (Supplier Risk Coordinator), EMP-003 (business owner of AWS and Entra ID), EMP-013 (business owner of GitHub), EMP-002 (CISO), EMP-001 (Managing Director, scenario decisions) |
| Procedure exercised | [Data-flow map and international transfer assessment GDPR-06](../../../GDPR/data-flow-and-transfer-assessment.md) version 1.2, sections 1 to 4, for AWS, Microsoft and GitHub |
| Controls | GDPR Art. 44, 45, 46(2)(c), 49; ISO/IEC 27001:2022 A.5.19, A.5.34; related SOC 2 VM-01, VM-02 |

## Scenario

The supplier review of 2026-07-06 left the GDPR side open: no certification, contract or location is verified. On 2026-07-07 EMP-004 takes the transfer assessment through each supplier. The text is used as it stands on the Authored date and treated as in force on 2026-07-07. The supplier facts are those of SIM-SUP-001. No statement of AWS, Microsoft or GitHub is used or recorded.

## 1. Reconcile the flows with what exists (section 2)

| Flow | The map says | What the scenario shows on 2026-07-07 |
|---|---|---|
| DF-01 Git metadata to GitHub | Real, United States | Correct |
| DF-02 `personnel.json` in the public repository | Real, broader than a transfer, "justified or stopped" | The file carries names, roles, departments, managers and start dates of 23 staff (24 until EMP-023 left on 2026-05-29, SIM-PPL-004). Still public |
| DF-03 Staff identity to Entra ID, then AWS | **Planned**, "assess before the first real staff data is provisioned" | Provisioned. SIM-PPL-001 shows Entra accounts from 2026-01 and Identity Center tiers from 2026-03. The assessment was not made first |
| DF-04, DF-05 Customer data and logs to AWS | Not applied; no customer | A pilot customer exists in the scenario since 2026-05-18 ([SIM-GDPR-004](SIM-GDPR-004-dpa-conclusion-customer-a.md)), but nothing is hosted, so no flow runs |

## 2. Position per supplier (section 3.2)

| Supplier | Position in the map | Review on 2026-07-07 | Decision |
|---|---|---|---|
| AWS (SUP-01) | No transfer for data stored in `eu-central-1`; DPF or SCCs for remote support access | The source defaults to `ap-south-1` (SIM-SUP-001, section 3.1). The Identity Center instance made in the console is in `ap-south-1` and holds the identity data of DF-03. Section 3.5 of the map says a resource there is a transfer needing safeguards, and "none is prepared" | Scenario decision by EMP-001: the instance is to be re-created in `eu-central-1`; owner EMP-003; date not set. Until then the DF-03 transfer to a third country is on record as unauthorised |
| Microsoft (SUP-02) | EU Data Boundary where the tenant is in the EU; DPF or SCCs otherwise | Tenant country is not recorded; whether it is in the boundary is not checked. EMP-003 notes the lab tenant uses the Free plan | Unchanged: to verify |
| GitHub (SUP-03) | DPF if certified; SCCs module 1 for a personal account, 2 or 3 with an organization plan | Personal-account terms apply (processor register). SIM-SUP-001 gave EMP-016 and EMP-004 until 2026-09-30 to choose a plan with a DPA or record why not | Unchanged: to verify, due 2026-09-30 |

For all three, "to verify" means three checks nobody has performed: whether the importer is on the Data Privacy Framework list (for HR data in particular, which section 3.1 says is a separate category), whether the standard contract terms contain the SCCs for Ayka's plan, and what support access the provider has. EMP-004 and EMP-016 agree that none can be recorded as done: there is no place to write the result, no required evidence (URL and retrieval date) and no owner. The review records the three as open items with EMP-016 as owner.

## 3. DF-02 and the short transfer impact assessment (sections 3.3, 3.4)

- **DF-02.** The map says the disclosure has no Chapter V solution: "justified or stopped". EMP-004 asks for the legal basis for publishing 23 staff records. EMP-001 decides to stop it: names are to leave the public file and only employee IDs stay. Owner EMP-013. Not done on 2026-07-07. The history keeps the names unless rewritten, which the legitimate-interests assessment already says.
- **Section 3.4 conclusion.** "DF-01 accepted as a working position, not approved by anyone." Scenario decision by EMP-001: accepted for 12 months, review by 2027-07-06. DF-03 to DF-05: no conclusion, stays as written.

## 4. Cross-check against a later record

On 2026-08-10 [SIM-INC-001](../incident/SIM-INC-001-inc-2026-001-customer-export-in-public-ci.md) shows 137 rows of Customer A's (fictional) users reaching a public repository and a CI log hosted by GitHub, Inc. DF-01 lists author names, e-mails, pull-request text and logs; it has no row for customer personal data. For about 44 hours the "low-sensitivity, already-public data set" conclusion of section 3.4 did not hold. A map that is reviewed once a year cannot see this: the data category is the problem, not the supplier.

## Findings

Defects in GDPR-06 version 1.2 as written:

1. **DF-03 is labelled Planned while the flow runs.** The rule "assess before first staff data" has no check and no trigger. Staff data was provisioned months before this review.
2. **Section 3.5 forbids and does not say what to do.** It says a resource in `ap-south-1` is a transfer needing safeguards and none are prepared. It gives no owner, date or exit when such a resource already exists. The console-made instance is that case.
3. **The map reads the Region from the repository.** It says no Terraform root names `ap-south-1` "since 2026-11-10". On 2026-07-07 the source did. A map that fixes the Region state to one date cannot be reviewed at another. Facts need the date they were read.
4. **"To verify" has no procedure.** No place to record the DPF check, no required evidence (URL, date, entity), no owner, no deadline. The three suppliers stay "to verify" indefinitely.
5. **The review clock never starts.** Section 4 says review 12 months after approval. The document is not approved, so no review is ever due. The same defect SIM-GDPR-002 found for the RoPA.
6. **DF-02 is a decision in the wrong document.** The map says the disclosure "has to be justified or stopped" and "does not cure it". Nothing assigns the decision. EMP-001 had to take it in this session.
7. **The map has no row for customer data in tools.** DF-01 covers metadata. A customer file in a pull request, a log or a ticket is the common way personal data reaches GitHub, and it is outside the map.
8. **The short assessment has no approver.** Section 3.4 ends "not approved by anyone". The design does not say who may approve it.
9. **Chapter V analysis rests on texts marked "to verify"** (EDPB guidelines, court challenge status) with no schedule for checking them.

## What this does not show

- That any DPF listing, certificate, contract term or supplier statement was read. Nothing from AWS, Microsoft or GitHub is recorded here.
- That the Identity Center instance exists in `ap-south-1` in any real account: the fact comes from repository documents ([GDPR index](../../../GDPR/README.md#region)), not from a tenant that was examined.
- That `personnel.json` is public in a way that harms anyone: the staff are fictional, and one entry is the real repository owner.
- That the decisions were taken. They are scenario decisions; nothing in the repository changed.
- Legal conclusions. No counsel reviewed the Chapter V reasoning.
