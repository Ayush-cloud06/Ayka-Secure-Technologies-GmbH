# Trust Services Criteria Mapping

| Field | Value |
|---|---|
| Document ID | SOC2-02 |
| Owner | Compliance and Risk |
| Approver | CISO |
| Version | 1.0 |
| Status as of | 2026-10-06 |
| Criteria version | AICPA TSP section 100, 2017 Trust Services Criteria (with revised points of focus, 2022) |
| Status | Draft. Not approved |

## 1. Purpose

This is the criterion-by-criterion view of the SOC 2 scope: for each criterion in Security, Availability and Confidentiality, which Ayka controls address it, the matching ISO/IEC 27001:2022 requirements, and how ready the criterion is for a Type I examination. The control details are in the [control matrix](03-control-matrix.md).

Criteria are paraphrased in a few words to keep the table readable; the authoritative wording is the AICPA publication.

**Readiness rating**

- **Ready**: at least one Implemented control covers the core of the criterion.
- **Partly ready**: controls are Implemented for part of the criterion or exist only as gated design.
- **Not ready**: controls are Designed or Planned only.

## 2. Common Criteria (Security)

### CC1 Control environment

| Criterion | In short | Ayka controls | ISO/IEC 27001:2022 | Readiness |
|---|---|---|---|---|
| CC1.1 | Commitment to integrity and ethical values | CE-01, CE-02 | 5.1, 5.2, A.5.1, A.6.2 | Not ready |
| CC1.2 | Oversight by those charged with governance | CE-06 | 5.1, 9.3 | Not ready |
| CC1.3 | Structures, reporting lines and authorities | CE-03 | 5.3, A.5.2 | Partly ready |
| CC1.4 | Attract, develop and retain competent people | CE-04, CE-05, CO-03 | 7.2, 7.3, A.6.1, A.6.3, A.6.6 | Not ready |
| CC1.5 | Hold people accountable for their responsibilities | CE-07, RA-04 | A.6.2, A.6.4 | Partly ready |

### CC2 Information and communication

| Criterion | In short | Ayka controls | ISO/IEC 27001:2022 | Readiness |
|---|---|---|---|---|
| CC2.1 | Relevant, quality information supports internal control | IC-01 | 7.5, 9.1 | Ready |
| CC2.2 | Internal communication of objectives and responsibilities | CE-01, CE-05, CE-06, IC-03 | 7.3, 7.4, A.6.8 | Not ready |
| CC2.3 | Communication with external parties | IC-02, IC-03 | 7.4, A.5.14 | Not ready |

### CC3 Risk assessment

| Criterion | In short | Ayka controls | ISO/IEC 27001:2022 | Readiness |
|---|---|---|---|---|
| CC3.1 | Objectives clear enough to identify risks | RA-01 | 6.2 | Partly ready |
| CC3.2 | Identify and analyse risk | RA-01, RA-04, VM-01 | 6.1.2, 8.2 | Partly ready |
| CC3.3 | Consider the potential for fraud | RA-02 | 6.1.2 | Not ready |
| CC3.4 | Identify and assess significant change | RA-03 | 6.1.2, 6.3 | Partly ready |

### CC4 Monitoring activities

| Criterion | In short | Ayka controls | ISO/IEC 27001:2022 | Readiness |
|---|---|---|---|---|
| CC4.1 | Ongoing and separate evaluations | MO-01, MO-02 | 9.1, 9.2 | Partly ready: ongoing evaluation of the gate is Implemented; no separate evaluation |
| CC4.2 | Evaluate and communicate deficiencies | MO-03, CE-06 | 10.2 | Partly ready |

### CC5 Control activities

| Criterion | In short | Ayka controls | ISO/IEC 27001:2022 | Readiness |
|---|---|---|---|---|
| CC5.1 | Select and develop control activities that reduce risk | CA-01, CM-05 | 6.1.3 | Partly ready: segregation of duties missing |
| CC5.2 | General controls over technology | CA-01, CA-02 | A.5.36, A.8.9, A.8.25 | Ready |
| CC5.3 | Deploy controls through policies and procedures | CE-01, RA-04 | A.5.1, A.5.37 | Partly ready |

### CC6 Logical and physical access

| Criterion | In short | Ayka controls | ISO/IEC 27001:2022 | Readiness |
|---|---|---|---|---|
| CC6.1 | Logical access security over protected assets | AC-01 to AC-05, AC-08, AC-09, AC-13, AC-14 | A.5.15, A.8.2, A.8.3, A.8.4, A.8.5, A.8.24 | Partly ready: repository access Implemented; workforce identity and MFA Designed |
| CC6.2 | Register and authorise users before issuing credentials; remove them | AC-01, AC-06, AC-07 | A.5.16, A.5.18 | Not ready |
| CC6.3 | Role-based, least-privilege access with segregation of duties | AC-04, AC-06, AC-07 | A.5.15, A.5.18, A.8.2 | Not ready |
| CC6.4 | Restrict physical access | AC-17 (carved out to AWS) | A.7.1 to A.7.4 | Ready through CSOC, subject to VM-02 |
| CC6.5 | Dispose of assets only once data cannot be recovered | AC-16, AC-18 | A.7.10, A.7.14, A.8.10 | Not ready for laptops; carved out for production |
| CC6.6 | Protect against threats from outside the boundary | AC-10, AC-11, CO-02 | A.8.20, A.8.21, A.8.23 | Partly ready: gate rules Implemented, network Gated design |
| CC6.7 | Restrict transmission and movement of information | AC-12, AC-13 | A.5.14, A.8.24 | Partly ready (Gated design) |
| CC6.8 | Prevent or detect unauthorised or malicious software | AC-11, AC-14, AC-15, AC-16 | A.8.7, A.8.19 | Partly ready: pipeline supply chain Implemented; images and endpoints Planned |

### CC7 System operations

| Criterion | In short | Ayka controls | ISO/IEC 27001:2022 | Readiness |
|---|---|---|---|---|
| CC7.1 | Detect configuration changes and new vulnerabilities | OP-01, OP-02, OP-08, CA-01, MO-01 | A.8.8, A.8.9 | Partly ready: IaC scanning Implemented; runtime and dependency scanning Planned |
| CC7.2 | Monitor components for anomalies | OP-03, OP-04, OP-05, AV-05 | A.8.15, A.8.16 | Not ready: logs designed, no alerting |
| CC7.3 | Evaluate security events to decide if they are incidents | OP-05, OP-06, IC-03 | A.5.25 | Not ready |
| CC7.4 | Respond to incidents | OP-06 | A.5.24, A.5.26 | Not ready |
| CC7.5 | Recover from incidents | OP-07, RM-01 | A.5.27, A.5.29 | Not ready |

### CC8 Change management

| Criterion | In short | Ayka controls | ISO/IEC 27001:2022 | Readiness |
|---|---|---|---|---|
| CC8.1 | Authorise, design, test, approve and implement changes | CM-01 to CM-06, AC-09, AC-14 | A.8.25, A.8.29, A.8.32 | Partly ready: strongest area, but approval is self-approval (CM-05) |

### CC9 Risk mitigation

| Criterion | In short | Ayka controls | ISO/IEC 27001:2022 | Readiness |
|---|---|---|---|---|
| CC9.1 | Mitigate risks of business disruption | RA-01, RA-03, RM-01, RM-02 | A.5.29, A.5.30 | Not ready |
| CC9.2 | Assess and manage vendor and partner risk | VM-01, VM-02 | A.5.19 to A.5.22 | Not ready |

## 3. Availability

| Criterion | In short | Ayka controls | ISO/IEC 27001:2022 | Readiness |
|---|---|---|---|---|
| A1.1 | Manage and monitor capacity | AV-01, AV-05 | A.8.6 | Not ready |
| A1.2 | Environmental protection, backup and recovery infrastructure | AV-02, AV-03, AC-17 | A.8.13, A.8.14, A.7.5 | Partly ready (Gated design) |
| A1.3 | Test recovery procedures | AV-04, RM-01 | A.5.30, A.8.13 | Not ready |

## 4. Confidentiality

| Criterion | In short | Ayka controls | ISO/IEC 27001:2022 | Readiness |
|---|---|---|---|---|
| C1.1 | Identify and protect confidential information | CO-01, CO-02, CO-03, CO-05, AC-13 | A.5.12, A.5.13, A.6.6, A.8.12 | Partly ready |
| C1.2 | Dispose of confidential information | CO-04, AV-03 | A.8.10 | Not ready |

## 5. Criteria outside the chosen scope

| Category | Criteria | Why excluded |
|---|---|---|
| Processing Integrity | PI1.1 to PI1.5 | The portal does not process transactions whose accuracy customers rely on; see [README](README.md#2-scope-chosen) |
| Privacy | P1.1 to P8.1 | GDPR documents in [Governance/GDPR](../GDPR/README.md) cover privacy for EU customers |

## 6. Summary

| Readiness | Criteria (of 38 in scope) |
|---|---:|
| Ready | 2 (CC2.1, CC5.2), plus CC6.4 through the AWS carve-out |
| Partly ready | 17 |
| Not ready | 18 |

What this says in one line: Ayka's change management and configuration controls are close to audit grade because they run in CI on every change; everything that needs a running system or people doing recurring work (access reviews, alerting, incident handling, vendor reviews, restore tests) is not yet in place.

## 7. ISO/IEC 27001 reuse

Of the 65 control rows in the matrix, all but RM-02 (insurance) map to an ISO/IEC 27001:2022 clause or Annex A control. An ISO 27001 certification audit and a SOC 2 examination could therefore draw on one evidence set. The differences that matter in practice:

- SOC 2 Type II tests operating effectiveness over a period with samples; ISO 27001 surveillance audits look at a few samples per year. Recurring controls (AC-07, VM-02, CE-06) need records for every occurrence in the period.
- SOC 2 requires the system description and explicit CUECs and CSOCs; ISO 27001 has no equivalent.
- ISO 27001 requires management review, internal audit and the Statement of Applicability as named documents; SOC 2 asks for the same activities through CC1.2, CC4.1 and CC5.1 without naming them.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-06 | First issue |
