# Company security policies

These policies form one shared set for the [ISMS](../ISMS/README.md), [SOC 2](../SOC2/README.md) and other governance mappings. Ayka Secure Technologies GmbH is a simulated company. All policies remain drafts: no management approval or operating compliance is implied.

## 1. Policy register

Owners are proposed accountable roles; review periods begin after approval unless an event trigger occurs first. The documents distinguish intended requirements, gated workload design, ungated platform design and the CI controls that operate today. The [document control procedure](../ISMS/00-context-and-governance/document-control-procedure.md) governs approval, versioning and distribution.

| Document ID | Policy | Accountable role | Next review / trigger |
|---|---|---|---|
| POL-AUP-01 | [Acceptable use policy](acceptable-use-policy.md) | CISO | 12 months after approval, or a material misuse event or new class of company tool |
| POL-AC-01 | [Logical Access Control Policy](access-control-policy.md) | CISO | 12 months after approval |
| POL-BCDR-01 | [Business Continuity and Disaster Recovery Plan](business-continuity-and-disaster-recovery-plan.md) | CISO | 12 months after approval, after every test and after every activation |
| POL-CHG-01 | [Change Management Policy](change-management-policy.md) | CISO | 12 months after approval |
| POL-DESK-01 | [Clean desk and clear screen policy](clean-desk-and-clear-screen-policy.md) | HR & Administration | 12 months after approval, or a workplace change or information-exposure incident |
| POL-CLD-01 | [Cloud Security Policy](cloud-security-policy.md) | CISO | 12 months after approval, or when a cloud provider, Region or AWS account is added |
| POL-CRY-01 | [Cryptography Policy](cryptography-policy.md) | CISO | 12 months after approval, or when an algorithm is deprecated, a data store is added or a key is compromised |
| POL-DATA-01 | [Data Classification and Confidentiality Policy](data-classification-and-confidentiality-policy.md) | CISO | 12 months after approval |
| POL-PRIV-01 | [Data protection policy](data-protection-policy.md) | Compliance & Risk Management | 12 months after approval, or a new processing purpose, processor, transfer or personal-data incident |
| POL-IR-01 | [Incident Response Plan](incident-response-plan.md) | CISO | 12 months after approval, and after every Severity 1 incident or exercise |
| STD-LOG-01 | [Logging and Monitoring Standard](logging-and-monitoring-standard.md) | CISO | 12 months after approval, or when a log source is added |
| POL-RET-01 | [Records and data retention policy](records-and-data-retention-policy.md) | Compliance & Risk Management | 12 months after approval, or a legal change, new record category, hold or deletion failure |
| POL-REM-01 | [Remote work policy](remote-work-policy.md) | CISO | 12 months after approval, or a change in working locations, access methods or relevant incident |
| POL-SDL-01 | [Secure Development Policy](secure-development-policy.md) | Product & Engineering | 12 months after approval, or when the required checks or the pipeline stages change |
| POL-END-01 | [User endpoint device policy](user-endpoint-device-policy.md) | Cloud Platform Engineering | 12 months after approval, or a supported-platform change, device loss or baseline failure |
| POL-VEN-01 | [Vendor and Subservice Organization Management Policy](vendor-management-policy.md) | Compliance & Risk Management | 12 months after approval |
| POL-VUL-01 | [Vulnerability and patch management policy](vulnerability-and-patch-management-policy.md) | Security Operations | 12 months after approval, or a critical advisory, material incident or change to the scanner toolchain |

## 2. Shared coverage

| Topic | Authoritative document |
|---|---|
| Passwords, authentication, MFA, privileged and emergency access | [Access control](access-control-policy.md), sections 4.2 and 4.5 |
| Incident response policy and procedure | [Incident response plan](incident-response-plan.md); notification requirements also in [NIS2/GDPR reporting](../NIS2/03-incident-reporting-procedure.md) |
| Backup policy, business continuity and disaster recovery | [BC/DR plan](business-continuity-and-disaster-recovery-plan.md); operational sequence in [backup and restore](../ISMS/06-operational-procedures/backup-and-restore-procedure.md) |
| Vulnerability and patch management | [Combined policy](vulnerability-and-patch-management-policy.md); scanning and patch procedures in the [ISMS register](../ISMS/README.md) |
| Record protection, data retention and disposal | [Combined retention policy](records-and-data-retention-policy.md); handles legal holds, proposed schedules and configuration gaps |
| Asset and information classification | [Data classification and confidentiality](data-classification-and-confidentiality-policy.md) |
| User devices, mobile devices and media | [User endpoint devices](user-endpoint-device-policy.md) |

## 3. Approval and unresolved implementation

Read a requirement as an intended rule, not proof that it is met. In particular, recovery objectives and backup-deletion periods are untested; independent review is unavailable with one maintainer; actual supplier terms, data flows, device controls and legal applicability need verification. The [SoA](../ISMS/04-controls-and-soa/statement-of-applicability.md) and [gap analysis](../ISMS/04-controls-and-soa/control-gap-analysis.md) retain that work explicitly.

Seven policies previously under `Governance/SOC2/policies/` now live here so that frameworks share the same requirements. New operational records belong in restricted storage; this public repository contains drafts, templates and sanitized technical evidence only.
