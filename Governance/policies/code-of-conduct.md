# Code of conduct

| Field | Value |
|---|---|
| Document ID | POL-COC-01 |
| Owner | HR & Administration |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or a serious conduct case, a legal change or a change in the way staff report concerns |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company. These are proposed requirements; a written policy is not evidence that its controls operate. Employment-law wording, any works council rights and the lawful scope of the acknowledgement need review by German employment counsel before use.

## 1. Purpose and scope

This code says how everyone who works for Ayka behaves toward customers, colleagues, suppliers and company information. It gives the SOC 2 criterion CC1.1 (commitment to integrity and ethical values) and ISO/IEC 27001:2022 A.5.10, A.6.2 and A.6.4 a single document that staff can read in ten minutes and acknowledge. It applies to employees, managing directors, contractors, interns and any third-party personnel with access to Ayka systems or customer data. The technical rules sit in other policies and are referred to, not repeated.

## 2. What Ayka expects

| Area | Expectation |
|---|---|
| Honesty | Records, reports, timesheets, expense claims, control evidence and statements to customers or auditors are accurate. Nobody backdates a record, alters evidence after the fact or writes down an approval, test or review that did not happen |
| Customer data | Use customer data only for the purpose the customer contracted. Do not look at a customer's data out of curiosity. Access beyond the task needs the approval set out in [POL-AC-01](access-control-policy.md) |
| Confidentiality | Protect non-public information under [POL-DATA-01](data-classification-and-confidentiality-policy.md) and the confidentiality agreement. The duty continues after employment ends, within the limits of section 6 |
| Company assets | Use accounts, devices and services as the [acceptable use policy](acceptable-use-policy.md) allows. Do not share credentials, bypass a control or use a break-glass path without an incident or an approval |
| Conflicts of interest | Tell your line manager and the CISO before taking part in a decision where you, a relative or a close contact has a financial or personal interest. This includes choosing a supplier, hiring, or approving access for a relative |
| Gifts and hospitality | Do not accept or give a gift, payment or favour that could influence a business decision. Modest, occasional hospitality is acceptable. Record anything above 50 EUR in value with the CISO. Never accept or offer anything to a public official |
| Respect | Treat colleagues, customers and suppliers fairly and without harassment or discrimination. Raise a concern in good faith |
| Compliance with law | Follow applicable law, including data protection (GDPR, BDSG), anti-corruption and export rules. Ask Compliance & Risk Management when unsure |
| Reporting | Report a suspected breach of this code, a security incident or a fraud concern as set out in section 4 |
| Cooperation | Cooperate with internal reviews, internal audits and an external auditor. Do not hide, destroy or alter relevant records |

## 3. Separation of duties and trust

Ayka relies on people not holding every key. Nobody approves their own access, change, expense, supplier or exception. Where a small team means one person must do both, the work is flagged and a compensating review is done by another named role. Examples are the monthly review of merged changes in [SOC2-08](../SOC2/08-control-designs.md#3-compensating-monthly-change-review-cm-05-g3) and the quarterly access review in the [access review procedure](../ISMS/06-operational-procedures/access-review-procedure.md). The [fraud and insider-risk assessment](fraud-and-insider-risk-assessment.md) lists the situations to watch.

## 4. Speaking up

Anyone may report a concern, in confidence and without fear of disadvantage.

| Channel | Use it for |
|---|---|
| Line manager | Everyday concerns |
| CISO | Security incidents, misuse of access, suspected data exposure. A security mailbox is to be monitored under control IC-03 |
| Managing Director | Concerns about the CISO or about management conduct |
| Compliance & Risk Management | Legal, privacy, bribery or conflict-of-interest concerns |
| External | Statutory external reporting offices and authorities, where the law provides for them. Nothing in this code limits a legally protected disclosure |

If the concern is about the person you would normally tell, go to the next channel. Reports are handled in confidence and only the people needed to look into the matter are told. Ayka has fewer than 50 staff, so the statutory duty of the German Whistleblower Protection Act (HinSchG) to run an internal reporting office does not apply at this size (to verify if the headcount changes); the channels above are good practice and serve CC2.2.

## 5. No retaliation

Disadvantage of any kind because someone raised a concern in good faith, or because they took part in a review, is itself a breach of this code and is handled under the [security-related disciplinary process](../ISMS/01-organization/disciplinary-process.md).

## 6. Consequences

A breach is handled under the [disciplinary process](../ISMS/01-organization/disciplinary-process.md): facts first, proportionate action, the affected person heard, and legal advice where needed. Containment of a possibly compromised account is a security step and is separate from any employment decision. Nothing in this code removes a right the law gives an employee, including protected disclosures and the right to talk to authorities.

## 7. Acknowledgement

| Item | Rule |
|---|---|
| When | At hire, before access beyond onboarding material is granted, and every 12 months after approval of a new version |
| What | The person confirms they have received and read this code and the [acceptable use policy](acceptable-use-policy.md), and know the channels in section 4 |
| Record | Employee ID, document IDs and versions, date, method and the person who checked it. Kept in the HR system, not in this public repository |
| Missing acknowledgement | HR & Administration reports the names, by employee ID, to the CISO monthly. Access beyond the baseline is reviewed for anyone more than 30 days overdue |
| Evidence for SOC 2 | Control CE-02. A population list from the HR system and a sample of acknowledgements |
| Status | No acknowledgement has been collected from a real person. A tabletop of the process is SIM-PPL-001 (ID only) |

## 8. Related documents

[Acceptable use policy](acceptable-use-policy.md) · [Access control policy](access-control-policy.md) · [Data classification and confidentiality policy](data-classification-and-confidentiality-policy.md) · [Disciplinary process](../ISMS/01-organization/disciplinary-process.md) · [Fraud and insider-risk assessment](fraud-and-insider-risk-assessment.md) · [Personnel screening criteria](../ISMS/01-organization/personnel-screening-criteria.md) · [Training and awareness](../../organization/training-and-awareness.md)

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-11-10 | First draft, written for SOC 2 control CE-02 |
