# Interested parties and their requirements

| Field | Value |
|---|---|
| Document ID | ISMS-00-04 |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or when the first customer contract is signed |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company with no customers. Rows marked "Not yet" in the "Exists today?" column describe parties Ayka would have once it trades; their requirements are expected, not received.

## 1. Purpose

ISO/IEC 27001:2022 clause 4.2 asks Ayka to determine the interested parties relevant to the ISMS (a), their relevant requirements (b), and which of those requirements will be addressed through the ISMS (c). Amd 1:2024 adds that relevant parties can have requirements related to climate change (section 4). Legal and contractual requirements are listed in detail in the [legal and regulatory register](legal-and-regulatory-register.md); this document names the parties and points there.

## 2. How the list was built

Sources: the [business model](../../../organization/business-model.md) (customers, services), [NIS2-01 §6](../../NIS2/01-applicability-assessment.md#6-step-4-indirect-applicability-through-customers) (what in-scope customers will ask), the [processor register](../../GDPR/processor-register.md) (suppliers), the [roles](../../../organization/roles-and-responsibilities.md) and [personnel register](../../../organization/personnel-register.md) (staff), and the repository itself (public readers). Issues these parties raise are in the [context of the organization](context-of-the-organization.md).

## 3. Register

"Addressed through the ISMS" answers clause 4.2 c: **Yes** = the ISMS owns it; **Partly** = the ISMS covers the security part only; **No** = handled outside the ISMS, with the reason.

| ID | Party | Exists today? | Relevant requirements | Addressed through the ISMS | Where handled | How monitored | Owner role | Next review |
|---|---|---|---|---|---|---|---|---|
| IP-01 | Customers (EU SMEs, EU SaaS start-ups, manufacturing SMEs) | Not yet | Confidentiality of uploaded evidence; availability before their audits; incident notice; data processed in the EU; data return and deletion at exit; GDPR Art. 28 processor terms; sub-processor transparency | Yes. EU data location is addressed but not met (RISK-011) | [POL-DATA-01](../../policies/data-classification-and-confidentiality-policy.md); [POL-BCDR-01](../../policies/business-continuity-and-disaster-recovery-plan.md); [NIS2-05 A.2](../../NIS2/05-supply-chain-security.md#a2-aykas-standard-positions); legal register CR-01 | Security questionnaires and contract drafts reviewed before signature; terms stricter than NIS2-05 A.2 need CISO approval | Product & Engineering | At the first customer contract, then annually |
| IP-02 | Customers in NIS2 scope or in automotive supply chains (Tier-2/3 suppliers with 50+ staff) | Not yet | Supplier security under §30(2) no. 4 BSIG; incident notice fast enough for their 24-hour early warning; right to audit or evidence; TISAX label or VDA ISA answers; vulnerability handling commitments | Yes | [NIS2-05](../../NIS2/05-supply-chain-security.md); legal register LR-03, CR-02; [communication plan](communication-plan.md) | Same as IP-01; NIS2-05 A.3 evidence pack kept current | CISO | With NIS2-01 (six-monthly) |
| IP-03 | Managing Director (founder; no investor or group company recorded, to confirm per [NIS2-01](../../NIS2/01-applicability-assessment.md#9-open-items) open item O-2) | Yes (role) | ISMS supports the business and ISO 27001 certification; duty of care under §43 GmbHG; risk decisions above tolerance come to them; budget is proportionate | Yes | [NIS2-04](../../NIS2/04-management-accountability.md); [risk criteria](../03-risk-management/risk-criteria.md); [ISMS objectives](isms-objectives.md) section 4 | Quarterly CISO security report and annual management review (none held yet) | CISO | Annually |
| IP-04 | Employees and contractors | Yes (fictional staff) | Clear, known rules; training to do their job securely; protection of their personal data (GDPR, §26 BDSG); fair disciplinary handling; workable remote work | Yes | [Training programme](../../../organization/training-and-awareness.md); [competence matrix](../01-organization/competence-matrix.md); [disciplinary process](../01-organization/disciplinary-process.md); [RoPA](../../GDPR/record-of-processing-activities.md) PA-01, PA-04; [remote work policy](../../policies/remote-work-policy.md) | Training records and staff feedback once they exist; questions to the CISO | HR & Administration | Annually |
| IP-05 | Works council (*Betriebsrat*) | None recorded. Could be elected at Ayka's size (to verify) | Co-determination on technical systems able to monitor staff (logging, identity) and on rules of conduct, if elected (to verify) | Yes, conditionally | [Disciplinary process](../01-organization/disciplinary-process.md) section 3; legal register LR-11 | HR & Administration notes any election initiative | HR & Administration | On election, else annually |
| IP-06 | Data protection supervisory authority: LfDI Baden-Württemberg | Yes (authority exists; no contact) | GDPR compliance as controller and processor; role-specific personal-data breach notification under the linked procedure; cooperation | Yes | [NIS2-03 §6](../../NIS2/03-incident-reporting-procedure.md#6-personal-data-breaches-gdpr); [GDPR documents](../../GDPR/README.md); legal register LR-01, LR-02 | Compliance & Risk Management watches guidance and decisions | Compliance & Risk Management | Annually |
| IP-07 | BSI (federal cybersecurity authority) | Yes (no relationship) | Current working assessment places the simulated company outside direct scope; verify applicability before real use. If in scope: registration, measures, incident reporting | Yes (monitoring for scope change) | [NIS2-01](../../NIS2/01-applicability-assessment.md); legal register LR-03 | NIS2-01 triggers T-1 to T-7 | Compliance & Risk Management | With NIS2-01 (next scheduled 2027-04-06) |
| IP-08 | Tax office and auditors of annual accounts | Yes (as obligation) | Retention and readability of commercial and tax records for the statutory period | Partly: integrity and availability of records only; bookkeeping is outside the ISMS | Legal register LR-06; [records and data retention policy](../../policies/records-and-data-retention-policy.md) | Annual accounts process | Managing Director | Annually |
| IP-09 | Suppliers: AWS, Microsoft, GitHub | GitHub real; AWS and Microsoft planned | Compliance with their terms and acceptable use policies; customer-side controls under the shared responsibility model (complementary user entity controls) | Yes | [POL-VEN-01](../../policies/vendor-management-policy.md); [NIS2-05 Part B](../../NIS2/05-supply-chain-security.md#part-b-aykas-own-suppliers); legal register CR-03 to CR-05 | Annual supplier review (none performed); provider status and terms notices (not subscribed, NIS2-05 B.3) | Compliance & Risk Management | Annually, or on a change of terms |
| IP-10 | Certification body or TISAX audit provider | Not engaged | Conformity with clauses 4 to 10, a Statement of Applicability, and records over a period | Yes | [ISMS index](../README.md); [Statement of Applicability](../04-controls-and-soa/statement-of-applicability.md) | Readiness tracked in the ISMS index and audit programme | CISO | When an audit is planned |
| IP-11 | Insurers (cyber, D&O) | None recorded ([NIS2-03 §7](../../NIS2/03-incident-reporting-procedure.md#7-other-parties-to-consider), [NIS2-04 §6](../../NIS2/04-management-accountability.md#6-do-insurance)) | Would set notice periods and minimum controls (for example MFA, backups) | No: no policy exists, so no requirement exists | Revisit when a policy is bought | Managing Director decides on cover | Managing Director | Annually |
| IP-12 | Security researchers and the public | Yes | A way to report vulnerabilities; responsible handling of reports | Partly: no `SECURITY.md` or security mailbox exists (SOC 2 control IC-03, Planned) | [Communication plan](communication-plan.md); [SOC2-03](../../SOC2/03-control-matrix.md#3-information-and-communication-ic) IC-03 | Not monitored until a channel exists | Security Operations | When the channel is set up |
| IP-13 | Readers of the public repository (reviewers evaluating the case study) | Yes, real today | Truthful status labels; no claims of deployment or certification; reproducible results | Yes | [README, capability status](../../../README.md#4-capability-status); RISK-008; [document control](document-control-procedure.md) | The docs gate (links resolve, no title-only files) runs in the required `unit-tests` check on every pull request; the capability-claim check is a manual step before merge. See [document control](document-control-procedure.md) section 8 | CISO | Each release of the README |
| IP-14 | Investors and lenders | None recorded (NIS2-01 open item O-2) | Would expect due diligence on security and compliance | No: no such party exists | Revisit on an investment (NIS2-01 trigger T-3) | Managing Director | Managing Director | On trigger T-3 |

## 4. Climate-related requirements (Amd 1:2024)

| Party | Climate-related requirement known? | Decision |
|---|---|---|
| Customers (IP-01, IP-02) | None received. Automotive supply chains may send sustainability questionnaires (to verify) | Assess any received requirement for security relevance; sustainability-only reporting is handled outside the ISMS by the Managing Director if received. A contract term on climate-related resilience would come into the ISMS through POL-BCDR-01 |
| Regulators (IP-06, IP-07, IP-08) | None known that bind Ayka's ISMS. Whether EU sustainability reporting applies to a company of Ayka's size is to verify, and would be a reporting duty, not an ISMS requirement | Not addressed through the ISMS |
| Suppliers (IP-09) | None identified; accepted provider terms remain to verify | None |
| Employees (IP-04) | None recorded | None |

**Result:** no climate-related requirement is addressed through the ISMS today. The climate issue itself is assessed in [context of the organization §5](context-of-the-organization.md#5-climate-change-amd-12024).

## 5. Monitoring and review

- Each owner watches their parties as in the "How monitored" column and reports changes to the CISO.
- The CISO reviews the whole register at the annual management review and when a trigger in the header or in [context of the organization §6](context-of-the-organization.md#6-review-triggers) fires.
- New or changed legal and contractual requirements go into the [legal and regulatory register](legal-and-regulatory-register.md) first.
- No review of this register has taken place yet.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
