# SIM-GDPR-004: Data processing agreement prepared for Customer A (fictional)

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-GDPR-004 |
| Authored | 2026-11-10 (real date) |
| Scenario date | 2026-05-18 (pilot start). Cross-check against 2026-08-10 to 2026-09-24 |
| Participants | EMP-004 (GDPR Lead, fills the annexes), EMP-010 (Customer Success Manager, hands it over), EMP-009 (Sales Manager, account owner, inserts the agreement reference), EMP-006 (Product Manager, Annex I facts), EMP-002 (CISO, Annex II status check), EMP-001 (Managing Director, scenario decision for Ayka). Customer A (fictional) is not an employee |
| Procedure exercised | [Customer DPA template GDPR-17](../../../GDPR/data-processing-agreement-template.md) version 0.1, sections 1 to 4 and Annexes I to III; [processor register](../../../GDPR/processor-register.md) |
| Controls | GDPR Art. 28(2), 28(3)(a) to (h), 28(4), 28(9), 30(2); ISO/IEC 27001:2022 A.5.19, A.5.34; related SOC 2 IC-02, CO-04 |

## Scenario

On the day the pilot starts, EMP-004 prepares the DPA for Customer A (fictional) from the template and EMP-010 hands it over together with the rest of the customer pack ([SIM-SOC2-002](../soc2/SIM-SOC2-002-customer-onboarding-security-pack.md)). Customer A (fictional) is the controller; Ayka is the processor for the content its users put into `ayka-portal` ([ADR-0005](../../../ADR/0005-gdpr-roles.md)). **No signed instance is claimed.** This record covers preparation and handover only. Whether and when anyone executed it is not recorded, and the later records (SIM-INC-001, SIM-DSR-001) simply treat the DPA as the working basis.

## 1. Step by step

| Step | What the template says | What happened in the scenario |
|---|---|---|
| 1 Roles and subject matter (clauses 1.1 to 1.3) | Customer is controller, Ayka processor; part of the main agreement "reference to be inserted" | EMP-009 inserts the reference of the pilot order form. The pilot is not yet a main agreement; the clause refers to something not yet written |
| 2 Bracketed values (clauses 2.4, 2.5, 2.7, 2.8) | [30] days' notice of a sub-processor; [2] working days to forward a request; [10] working days to act on an instruction; [35] days for backups; [30] days' notice of an audit | EMP-004 keeps the figures as written. Scenario decision by EMP-001: the figures are Ayka's offer; Customer A (fictional) may ask for different ones |
| 3 Breach notice (clause 2.6) | Without undue delay and within 24 hours of becoming aware | Kept. [POL-IR-01](../../../policies/incident-response-plan.md) section 8 says 48 hours at the time (SIM-INC-001 finding 1). The DPA carries the stricter figure |
| 4 Deletion (clause 2.7) | Deletes or returns all data at the end; backups expire within [35] days | The clause has no limit for live stores. The system description and SOC 2 CO-04 promise 30 days. The two are not the same promise |
| 5 Audit (clause 2.8) | Audits with [30] days' notice; an independent report may be offered first, "none exists yet" | Kept. The sentence "none exists yet" goes to the customer |
| 6 Liability (section 4) | "[To be agreed in the main agreement.]" | Left open. See [SIM-SOC2-005](../soc2/SIM-SOC2-005-insurance-coverage-review.md): no cap exists for sizing cover |
| 7 Annex I, details of the processing | Subject matter, nature, purpose, data subjects, data categories, special categories, duration, location, records | Filled by EMP-006 and EMP-004 (section 2). One field the annex does not have: the customer's contacts |
| 8 Annex II, measures | Five documents; "a customer must be given this Annex with the status column as it stands on signature date" | EMP-002 reads the status of each document. Most rows are Planned or Designed; none is deployed. The annex is the list of documents, so the customer receives five drafts with their labels. The status column the template calls for is not in the annex; it is in the documents |
| 9 Annex III, sub-processors | AWS only (SUP-01); Microsoft and GitHub "are not sub-processors for Customer content" | Handed over as it stands. The AWS entity is "to verify" and the transfer safeguard is "to verify" |
| 10 Approval | Document status: "Template. Not approved, not offered to anyone" | Scenario decision by EMP-001: offer it for the pilot. There is no approval record for the template and no step that approves an instance |
| 11 Handover | n/a | EMP-010 sends it on 2026-05-18 with the customer pack. Customer A (fictional) gives a privacy contact for the annex (scenario value). Nobody asks for a security contact |

## 2. Annex I as filled

| Item | Entry in the instance | Note |
|---|---|---|
| Categories of data subjects | Customer A's (fictional) users and staff; persons named in uploaded evidence | |
| Categories of data | User name, e-mail, role; log data (IP address, user identifier); personal data inside uploaded evidence | See Finding 2 |
| Special categories | None | The template says "none permitted unless listed here [none]" |
| Location | EU/EEA, target `eu-central-1` | Nothing is hosted. The pilot is a walk-through |
| Contact | A **privacy** contact of Customer A (fictional), written under the table by hand | The annex has no field for it. No security contact is recorded |
| Record | PP-01 in the [processing record](../../../GDPR/record-of-processing-activities.md) | |

## 3. Cross-check against later records

| Date | Record | What it showed about the DPA |
|---|---|---|
| 2026-08-04 | [SIM-INC-001](../incident/SIM-INC-001-inc-2026-001-customer-export-in-public-ci.md) | Customer A (fictional) sends a 137-row onboarding list with name, business e-mail, **job title, department and intended portal role**. Annex I names user name, e-mail and role only |
| 2026-08-10 | SIM-INC-001 | The list is committed to a public repository on GitHub. Annex III says GitHub is not a sub-processor for Customer content. In fact it held customer personal data for about 44 hours. The annex was right about the design and wrong about what happened |
| 2026-08-13 | SIM-INC-001 | No customer security contact on file. The annex held a privacy contact only |
| 2026-09-02 | [SIM-DSR-001](SIM-DSR-001-access-and-erasure-request.md) | EMP-010 takes the privacy contact from the DPA annex in the customer file to forward the request. This is the only contact the file holds |
| 2026-09-17 to 09-23 | SIM-DSR-001 | The 2-day forwarding period and 10-day action period of clause 2.5 are used. The deletion confirmation says what backups keep: the same statement clause 2.7 makes |

## Findings

Defects in GDPR-17 version 0.1 as written:

1. **No contact fields.** Annex I has no place for the customer's privacy contact, security contact or incident-notice recipient, and no place for Ayka's. The contact that SIM-DSR-001 used had to be added by hand, and the one SIM-INC-001 needed was never asked for.
2. **Annex I data categories are narrower than real onboarding data.** "User name, e-mail, role" does not include job title or department. A customer list will contain them.
3. **Annex III's statement about GitHub is a prediction, not a control.** Nothing stops customer data from reaching GitHub (it did in SIM-INC-001). The annex needs the rule that customer data never goes to Microsoft or GitHub, and a clause on what Ayka does if it does (a notice and an update of Annex III).
4. **Deletion limits differ between the DPA and the system description.** Clause 2.7 has no live-store period; SOC2-01 and CO-04 say 30 days. One number should appear in both.
5. **No execution step.** The template has no signature or execution block (intended) but also no record that says which version applied, from what date, to which order form.
6. **An unapproved template is offered.** Version 0.1 says "not approved, not offered to anyone". The design has no rule for who approves an instance, or for tracking changes the customer asks for.
7. **The annex II status column is not in the annex.** The template requires the customer to see the status at signature date but the annex is a list of links. A snapshot of the labels on that date should be attached.
8. **"Reference to be inserted" assumes a main agreement.** A pilot order form is not one.
9. **Liability is left blank**, which blocks sizing insurance (SIM-SOC2-005 finding 1).

## What this does not show

- That any customer, contract, order form, DPA or signature exists. Customer A (fictional) said nothing real. Nothing here is signed.
- That the clauses are legally sufficient. No counsel reviewed the template, and the 24-hour, 30-day and 35-day figures are Ayka's own offer.
- That any sub-processor terms are in place. The AWS DPA, entity and certification remain "to verify" ([REAL-SUP-001](../../real/supplier/REAL-SUP-001-supplier-attestations.md)).
- That the portal was ever deployed or hosts data in the EU.
