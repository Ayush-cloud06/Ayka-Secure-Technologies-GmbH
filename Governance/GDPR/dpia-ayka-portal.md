# Data protection impact assessment: security logging and the ayka-portal design

| Field | Value |
|---|---|
| Document ID | GDPR-14 |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | Against the built system before PA-03 collects any personal data, then every 12 months, or on a change of purpose, log source, retention or recipient |
| Status | Draft. Compact DPIA of a design. Not approved. DPO advice outstanding (no officer appointed). Not legal advice |

Ayka Secure Technologies GmbH is a simulated company. The processing assessed here does not exist yet: no log is delivered and `ayka-portal` is not deployed. Art. 35(1) requires the assessment before the processing starts, so it is done on the design and must be repeated on the built system.

## 1. Decision from the screening

The [screening](dpia-screening.md) (GDPR-07) left four outcomes open. This document settles them.

| Activity | Decision | Reason |
|---|---|---|
| PA-03 Security logging (controller: Ayka) | **DPIA required.** This document is the DPIA | Two EDPB criteria are met (section 2). The screening already called it likely |
| PP-01 Customer evidence (processor: Ayka) | **No DPIA by Ayka.** The customer, as controller, owes it (Art. 35(1)). Ayka assists (Art. 28(3)(f)), see section 7 | Ayka does not decide purposes or means for customer content |
| PA-01, PA-04 | Not required on the facts recorded. Rescreen before a real tenant or real personnel files | Staff data used for access provisioning and training; no monitoring, no scoring, small scale. The screening result stands |
| PA-02 | Not required on the facts recorded | Commit metadata and workflow logs; no Art. 35 trigger found. Rescreen if monitoring or content scanning of personal data is added |
| PA-05, PA-06 | Not required on the facts recorded | Ordinary website and contract-contact data; rescreen when tools (analytics, profiling) are chosen |

Consequence for the DPO question: a DPIA obligation for PA-03 triggers BDSG § 38(1) sentence 2, so a DPO is mandatory once PA-03 operates ([DPO decision](dpo-and-legal-basis.md)). Art. 35(2) requires the controller to seek the DPO's advice. The advice is outstanding.

## 2. Why Art. 35 applies to PA-03

Art. 35(1): a DPIA is required where processing, in view of its nature, scope, context and purposes, is likely to result in a high risk. Art. 35(3) lists three cases; none matches (no systematic extensive evaluation with legal effect, no large-scale special categories, no large-scale public-area monitoring).

EDPB criteria (Article 29 Working Party guidelines WP248 rev.01, endorsed by the EDPB; the guideline says two or more criteria will usually require a DPIA; text **to verify**):

| Criterion | Met? | Note |
|---|---|---|
| 1 Evaluation or scoring | No | Logs are for detection, not scoring. Detection rules that rank users would change this |
| 2 Automated decision with legal or similar effect | No | |
| 3 Systematic monitoring | **Yes** | Authentication and administrative actions are recorded continuously and attributed to a person |
| 4 Sensitive or highly personal data | No | None intended. Content is not logged |
| 5 Large scale | No | 24 staff, customer count unknown, small. Reassess with customers |
| 6 Matching or combining datasets | Partly | Logs are correlated with the identity directory |
| 7 Vulnerable data subjects | **Yes** | Employees are in a dependency relationship (the guideline names them) |
| 8 Innovative technology | No | Standard cloud logging |
| 9 Prevents exercise of a right or service | No | |

Two criteria are met (3 and 7), a third partly. DSK list (Datenschutzkonferenz list of processing operations that require a DPIA under Art. 35(4), non-public bodies): the current list was not fetched. No item was matched by reading from memory, and the item numbers are **to verify**. If a listed item for systematic employee monitoring applies, the result is the same.

## 3. Description of the processing (Art. 35(7)(a))

| Item | Entry |
|---|---|
| Nature | Collection, storage, search and review of logs from the landing-zone CloudTrail, ALB, S3 access and WAF logs and VPC flow logs of `ayka-portal` ([PA-03](record-of-processing-activities.md)) |
| Scope | Staff using AWS and Entra ID; customer users using the portal. Fields: IP address, user or role identifier, request metadata, timestamps. No request bodies, no evidence content |
| Context | Staff are in an employment relationship; customers are EU SMEs and suppliers. Logs are reviewed by security roles (EMP-005 and others) |
| Purpose | Detect and investigate security events; support Art. 33 notifications |
| Controller | Ayka |
| Recipients | AWS as processor (SUP-01). Security staff. Authorities on lawful request |
| Retention | Proposed 365 days for selected logs; CloudTrail longer, under proportionality review. Not approved |
| Transfers | None intended; `eu-central-1`. Remote support access: [transfer assessment](data-flow-and-transfer-assessment.md) |
| Technology | Logs are encrypted and gated in the plan ([TOMs](technical-and-organization-measures/encryption-logging-backup-toms.md)). Nothing is delivered |

## 4. Necessity and proportionality (Art. 35(7)(b))

- Basis: Art. 6(1)(f), see the [legitimate interests assessment](legitimate-interests-assessment.md). Art. 32 supports necessity.
- Minimisation: fields limited to the four categories; no content; user identifiers only where the event needs them.
- Purpose limitation: no use for performance or attendance review. Any such use needs a new assessment.
- Storage limitation: a period per source before collection starts ([POL-RET-01](../policies/records-and-data-retention-policy.md)).
- Transparency: [employee notice](privacy-notice-employees.md) and [website notice](privacy-notice-website.md), including the Art. 21 right to object.
- Rights: handled by the [rights procedure](data-subject-rights-procedure.md). The [DSR tool](../../Internal-IT/engineering/privacy/dsr_tool.py) can find user identifiers in a fixture of the log table ([REAL-PRIV-001](../records/real/privacy/REAL-PRIV-001-dsr-tool-test-run.md)). Real logs may be exempt from erasure while a legal hold or an open incident applies (Art. 17(3), **to verify** the exact limb).
- Processor: AWS under Art. 28; DPA not retrieved.

## 5. Risks to the people (Art. 35(7)(c))

Likelihood and severity are judged on a three-step scale (low, medium, high) for the design, not measured.

| ID | Risk to the person | Likelihood | Severity | Inherent |
|---|---|---|---|---|
| R1 | Unauthorised access to the log store reveals who did what and from where | Medium | Medium | Medium |
| R2 | Function creep: logs used to assess an employee's performance or conduct | Medium | High | High |
| R3 | Logs kept longer than needed, so old behaviour stays searchable | Medium | Medium | Medium |
| R4 | Inference of private habits from working-time patterns or IP location | Low | Medium | Low |
| R5 | Access from outside the EEA by provider support without a safeguard | Low | Medium | Low |
| R6 | A person cannot find out what is held or object, because the log is not searchable by identifier | Medium | Low | Medium |

## 6. Measures and residual risk (Art. 35(7)(d))

| Risk | Measure | Status of the measure | Residual |
|---|---|---|---|
| R1 | Access to the log archive limited to security roles; encryption with managed keys; plan checks | Planned (design-only); encryption and logging settings Implemented (plan check only) in the [TOMs](technical-and-organization-measures/encryption-logging-backup-toms.md) | Low once the archive exists and an access review has run |
| R2 | Written purpose limit in the [logging standard](../policies/logging-and-monitoring-standard.md) and both notices; review of a named person's activity only with a recorded trigger; staff representatives consulted if they exist | Designed. No review trigger log | Medium until a trigger log exists, then low |
| R3 | Retention per source approved before collection; lifecycle expiry; deletion tested | Planned. Retention not approved. Log bucket expiry exists in the design; noncurrent-version expiry is missing | Medium until approved and tested |
| R4 | Minimised fields; no precise geolocation from IP in the review tool | Designed | Low |
| R5 | Position in the [transfer assessment](data-flow-and-transfer-assessment.md): DPF or SCCs; key control in the EU | Designed. Provider terms not checked | Low |
| R6 | Search by user identifier in the log tables; erasure and access path proven on a fixture | Fixture tool tested ([REAL-PRIV-001](../records/real/privacy/REAL-PRIV-001-dsr-tool-test-run.md)). Not on real logs | Low once the same search exists on the real log store |

Conclusion of the design assessment: with the measures, no residual risk is rated high. Art. 36 prior consultation of the supervisory authority is therefore not triggered by this design. That conclusion depends on conditions:

1. Do not collect personal data in logs until R2, R3 and R6 measures exist.
2. Repeat this DPIA on the built system and with the DPO's advice before collection starts.
3. Repeat it if logs are used for anything other than security.

## 7. PP-01: assistance to customers (Art. 28(3)(f))

The customer decides whether its use of the portal needs a DPIA. Ayka supplies, on request: the processing description in Annex I of the [DPA template](data-processing-agreement-template.md), the TOMs in Annex II, the sub-processor list in Annex III, the data-flow map, and the Region position. A customer with systematic or large-scale uploads of personal data should expect to complete its own DPIA before using the portal for that purpose.

## 8. Review and status

- Consultation of staff or representatives: not done.
- DPO advice (Art. 35(2)): outstanding; no officer.
- Sign-off: a walk-through of the decision is in [SIM-GDPR-003](../records/simulated/privacy/SIM-GDPR-003-dpia-sign-off.md). It is not an approval.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-11-10 | First issue |
