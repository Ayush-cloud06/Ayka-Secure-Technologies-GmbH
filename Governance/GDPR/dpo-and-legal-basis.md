# DPO decision and legal-basis register

| Field | Value |
|---|---|
| Document ID | GDPR-11 |
| Owner | Compliance & Risk Management |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or when headcount, core processing or a purpose changes |
| Status | Draft. The DPO obligation is not concluded. Legal bases are proposed and not reviewed |

Ayka Secure Technologies GmbH is a simulated company. This is not a legal opinion. Primary texts are **to verify**, as in the [legal register](../ISMS/00-context-and-governance/legal-and-regulatory-register.md).

## 1. Data protection officer

Article 37 and BDSG § 38 are the rules that would decide whether a data protection officer is mandatory. The fictional headcount, the absence of customers, and a target Region do not answer that question.

| Question | Recorded position |
|---|---|
| Is Ayka a public authority? | No. The case study is a private GmbH |
| Are core activities large-scale regular monitoring of people, or large-scale special-category data? | Not today. Repository metadata (PA-02) is real and limited. Portal logging and customer uploads are designed and not operating. They must be reassessed before launch ([DPIA screening](dpia-screening.md)) |
| Does BDSG § 38 require an officer at the designed size? | **To verify.** No threshold number is adopted here |
| Is an officer appointed? | No |
| Who is accountable for the decision until then? | The Managing Director. Compliance & Risk Management prepares the reassessment |
| Published contact for data-protection requests | None. Requests follow the [rights procedure](data-subject-rights-procedure.md) and the [communication plan](../ISMS/00-context-and-governance/communication-plan.md) |

Appointing an officer, or deciding formally that none is required, needs a dated management decision. This section is not that decision.

## 2. Legal-basis register

Bases below are copied from the [processing record](record-of-processing-activities.md) so they can be reviewed in one place. None has been reviewed by counsel. Employee consent is not used as the default, because of the imbalance in employment. A legitimate-interest basis without a written balancing test is only a proposal.

| Activity | Proposed basis | Balancing test or contract | Reviewed? |
|---|---|---|---|
| PA-01 Employee identity and access | Art. 6(1)(b), with BDSG § 26 for employee data | Employment contract is designed, not signed. § 26 after CJEU C-34/21 is **to verify** | No |
| PA-02 Repository and CI | Art. 6(1)(f) legitimate interest in traceable changes | No balancing test is written. The repository is public, which is part of the interest and part of the impact | No |
| PA-03 Security logging | Art. 6(1)(f), and Art. 32 as a security duty | Not written. Logging is not operating | No |
| PA-04 Personnel administration and training | Art. 6(1)(b) and § 26, **to verify** | No real training records | No |
| PP-01 Customer evidence | The customer as controller determines the Art. 6 lawful basis. Ayka processes under documented Art. 28 instructions. Ayka's own purpose would need its own basis | No customer contract | No |

Special categories (Art. 9) are not proposed for any activity. Customers are expected not to upload them (system description CUEC-04). That expectation is not a control.

## 3. Status

Designed as an open decision and an unreviewed register. LR-02 stays unmet as a legal conclusion. The document that was missing now exists; the determination does not.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
