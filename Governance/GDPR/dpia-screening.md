# DPIA screening

| Field | Value |
|---|---|
| Document ID | GDPR-07 |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | Before any new processing purpose, or 12 months after approval |
| Status | Draft. Screening only. Not a data protection impact assessment and not legal advice |

Ayka Secure Technologies GmbH is a simulated company. Article 35 of the GDPR requires an impact assessment for processing that is likely to result in a high risk. The current text, the European Data Protection Board guidance and the German supervisory-authority list of processing that requires an assessment are **to verify** before this screening is used operationally. No impact assessment is written.

## 1. Questions asked

For each activity in the [processing record](record-of-processing-activities.md):

1. Does the activity exist, or is it only designed?
2. Does it match a case the organization already knows must be assessed, including large-scale special-category data, systematic monitoring of a public place, or automated evaluation that produces legal effects? Those examples are a reading aid. They are not a closed list.
3. Does the activity combine several ordinary risk factors (systematic monitoring, vulnerable people, innovative use, cross-border transfer, data that prevents people exercising a right) such that a high risk is plausible?
4. What happens before the activity starts?

A "no assessment yet" result is not a finding that the processing is lawful.

## 2. Results

| Activity | Reality | Screening result | What must happen next |
|---|---|---|---|
| PA-01 Employee identity file | Simulated rows plus one real owner, public in Git | High risk is not formally established in this file. Public disclosure of a real identity is already an open gap in the processing record. A DPIA is not started | Keep the file out of any further real identities. Rescreen before the identity design is applied to a tenant. Do not treat publication as compatible with a future DPIA |
| PA-02 Repository and CI metadata | Real | On the facts recorded (author identity, usernames, workflow logs), no Art. 35 trigger is established here. This is not a legal opinion | Rescreen if staff monitoring, secret scanning of personal content, or new categories are added |
| PA-03 Security logging | Planned | Designed logs include IP addresses and user identifiers for detection. That can be systematic monitoring of users. A DPIA is likely to be required before collection at the scale of the portal design | Do not enable the log sources for personal data until a screening is repeated against the built system and any required DPIA is finished |
| PA-04 Personnel administration and training | Simulated; no training record | No processing of real training or disciplinary data | Screen when the first real personnel file is opened |
| PP-01 Customer evidence in the portal | Planned; no customer | The design stores whatever a customer uploads, which may include personal data Ayka does not control in advance, and shows it back to customer users | Repeat this screening against the product and the contract before the first customer. Expect a DPIA if uploads are systematic or the volume is large. No DPIA is started while the system is unbuilt |

## 3. What was not done

No consultation with a supervisory authority, no data-subject consultation, and no data protection officer review. A DPO is not appointed ([DPO decision](dpo-and-legal-basis.md)). The [data protection policy](../policies/data-protection-policy.md) still requires the screening to be repeated before launch. This document is that first screen, not the launch screen.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
