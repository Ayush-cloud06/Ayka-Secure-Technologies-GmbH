# SIM-GDPR-007: Annual review of the processor register and the three TOM documents

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-GDPR-007 |
| Authored | 2026-11-10 (real date) |
| Scenario date | 2026-09-29, the day after [SIM-GDPR-002](SIM-GDPR-002-ropa-annual-review.md) |
| Participants | EMP-004 (GDPR Lead, owner), EMP-021 (Compliance Officer, second reader; reports to EMP-004), EMP-016 (Supplier Risk Coordinator), EMP-002 (CISO), EMP-003 (Cloud Platform Engineer), EMP-013 (DevOps Engineer) |
| Procedure exercised | [Processor and sub-processor register](../../../GDPR/processor-register.md) version 1.1, sections 2 to 4; the three TOM documents: [identity and access](../../../GDPR/technical-and-organization-measures/identity-and-access-toms.md) v2.1, [segregation of duties](../../../GDPR/technical-and-organization-measures/segregation-of-duties.md) v2.0, [encryption, logging, backup](../../../GDPR/technical-and-organization-measures/encryption-logging-backup-toms.md) v1.2 |
| Controls | GDPR Art. 28(1), 28(2), 28(4), 30(2), 32(1); ISO/IEC 27001:2022 A.5.19, A.5.22, A.5.34; related SOC 2 VM-02 |

## Scenario

EMP-004 runs the yearly review of the register and the TOMs. The register says "review each entry annually and whenever the provider changes its terms or sub-processors". None of the three TOM documents says how or when to review. The texts are used as they stand on the Authored date and treated as in force on 2026-09-29. EMP-021 reads EMP-004's documents as second reader; she reports to EMP-004, a recorded independence limit.

## 1. Processor register: the five criteria of section 3 for each provider

| Criterion | SUP-01 AWS | SUP-02 Microsoft Entra ID | SUP-03 GitHub |
|---|---|---|---|
| 1 DPA covering Art. 28(3) filed | None filed. The AWS terms are "to verify" ([SIM-SUP-001](../supplier/SIM-SUP-001-annual-critical-supplier-review.md)) | None filed | None filed. Personal-account terms apply. The choice of an organization plan with a DPA is due 2026-09-30, tomorrow, and not made |
| 2 Region pinned, Terraform matches | No. The source still names `ap-south-1` ([SIM-AUD-003](../audit/SIM-AUD-003-internal-audit-report-2026.md) O-02), and the console-made Identity Center instance is in `ap-south-1` | Tenant country not recorded | United States, by the register |
| 3 Transfer mechanism recorded | "DPF and SCCs", to verify ([SIM-GDPR-005](SIM-GDPR-005-transfer-assessment-review.md)) | Same | Same |
| 4 Sub-processor change notices subscribed | No one subscribed | No one subscribed | No one subscribed |
| 5 Attestation retrieved and dated | None | None | None |

Other checks:

| Check | Result |
|---|---|
| Reality column | SUP-01 and SUP-02 say "Planned". Both are in use for staff sign-in since early 2026 (SIM-PPL-001). The column is stale |
| Providers missing | The website host and the mail service for the contact form (scenario of [SIM-GDPR-006](SIM-GDPR-006-privacy-notice-issue-and-lia-review.md), 2026-03-23) are not in the register. Nor is any provider EMP-016 uses for payroll or tax (none chosen, per the employee notice) |
| Incident link | The register says SUP-03 is not a sub-processor for customer content. On 2026-08-10 customer personal data reached GitHub for about 44 hours ([SIM-INC-001](../incident/SIM-INC-001-inc-2026-001-customer-export-in-public-ci.md)). The register has no field that records this |
| Tier | The register has no tier column (also SIM-SUP-001 finding 5) |
| Link to the DPA annex | Annex III of the customer DPA ([SIM-GDPR-004](SIM-GDPR-004-dpa-conclusion-customer-a.md)) lists AWS only and is not re-read at review |

## 2. TOM documents: is each label still the weakest true label?

Method improvised by EMP-004 and EMP-021: for each row, check the label against the repository and the records of the year.

| Document | Result |
|---|---|
| Identity and access (v2.1) | **Session limits row** says "8 h standard, 1 h high-privilege". `permission-sets.tf` sets `Platform-Admin` to 8 hours; the 1-hour set is never assigned ([SIM-SOC2-006](../soc2/SIM-SOC2-006-joiner-identity-provisioning-trace.md)). **Section 6** calls the processing record "planned, slice G-04"; the RoPA exists since v1.0 and was reviewed on 2026-09-28. **Section 7** says the identity and workload Terraform name `eu-central-1`; on 2026-09-29 the source still names `ap-south-1`. **Lifecycle rows** are "Planned (text only)" while joiner, leaver and mover were walked as SIM-PPL-001, 004, 005, and showed SCIM was not what removed access |
| Segregation of duties (v2.0) | Says the compliance gate "scans the two workloads only, not `Internal-IT/platform/`". The other two TOMs say the platform roots are scanned in a local run. The label set (Implemented, Simulated, Planned, Not designed) has no Gated design or Simulated operation. The change-pipeline row "peer review of every pull request" is "Not configured", correct, and sits next to a "monthly review" the document never mentions |
| Encryption, logging, backup (v1.2) | Rows labelled "Implemented (plan check only)". The [GDPR index](../../../GDPR/README.md) places this document at Gated design. "Implemented" here means a plan passes a rule, not that anything runs. The detection row says "no on-call"; SIM-INC-001 found the same. The restore row is correct (local test only) |

Across the three, the word "Implemented" has three meanings: a CI check that runs (identity, SoD), a plan check on code that is not applied (encryption), and "mapped, not exercised". A customer reading Annex II of the DPA cannot tell them apart.

## 3. Decisions

Scenario decisions by EMP-004, accepted by EMP-002:

- Register: correct the reality column; add a tier column; add the website host and the form mailer; add "events" (a dated note per provider for incidents and changes). Subscribe to sub-processor notices for AWS and GitHub, owner EMP-016, by 2026-10-31.
- TOMs: fix the stale sentences found above; state one label vocabulary at the top of all three documents. EMP-003 to confirm or correct the session limit.
- Not decided: the DPA for GitHub (due 2026-09-30, owner EMP-016 with EMP-004) and the transfer verification.

## Findings

Defects in the register and TOM documents as written:

1. **No review procedure for the TOMs.** The register has a review sentence; the TOM documents have none. This record's method was improvised. There is no checklist, no named reviewer and no evidence requirement.
2. **The register's reality column stales fast.** It states what is "Planned" or "Real" without a date. Two of three rows were wrong six months after the first sign-in.
3. **The register cannot record events.** An incident that changes a provider's role (GitHub holding customer data) has nowhere to go.
4. **The register omits suppliers that exist only in the privacy documents** (website host, form mailer, payroll and tax). Nothing compares the notices to the register.
5. **Review needs inputs from other records** (supplier review, transfer review, incident log, RoPA review) that are not listed in the register's review sentence.
6. **TOM documents state facts as of different dates**, and some of them were already wrong at the review (Region, session limit, RoPA status).
7. **One word, three meanings.** "Implemented" is not defined the same way in the three TOM documents. The customer annex uses all three.
8. **The TOM documents are the DPA's Annex II.** A review that changes a label changes what customers were told. The DPA template has no rule for notifying a change to Annex II.
9. **The reviewer reports to the author.** EMP-021 works for EMP-004. The register and TOMs name no independent reader.

## What this does not show

- That any DPA, report or provider term was retrieved. All provider facts are "to verify".
- That the repository was changed by the decisions above. They are scenario decisions.
- That the TOM documents are wrong about the deployed system. Nothing is deployed; the findings are inconsistencies between the documents and the repository.
- That a review meeting took place. Answers and dates are scenario values.
