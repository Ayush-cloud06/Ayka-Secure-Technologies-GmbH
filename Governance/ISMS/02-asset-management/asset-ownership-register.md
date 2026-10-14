# Asset ownership register

| Field | Value |
|---|---|
| Document ID | ISMS-02-02 |
| Owner | Cloud Platform Engineering |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or when scope, source configuration or evidence changes |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company. The CI gate operates on plans; the infrastructure has never been deployed.

## 1. Purpose and boundary

A.5.9 requires accountable ownership. This register proposes role accountability for the designed service and links the actual ownership markers in source. It does not appoint real asset custodians or assert that owner tags have been applied.

The [generated inventory](asset-inventory.md) covers 88 managed resources in one workload plan. It excludes data sources, staff devices, information held outside Terraform, and the ungated platform roots. Its summary shows **one resource with an Owner tag out of 88, and zero DataClassification tags**. A proposed owner below does not repair that gap.

## 2. Proposed accountability

| Asset group | Accountable role | Custodian role | Evidence and present limitation |
|---|---|---|---|
| Workload network, compute, storage, database, security modules | Cloud Platform Engineering | Cloud Platform Engineering | [Module source](../../../Internal-IT/workloads/ayka-portal/modules/) and [inventory](asset-inventory.md); Gated design; only one of 88 resources has an Owner tag |
| Platform organization, landing zone and identity roots | Cloud Platform Engineering | Cloud Platform Engineering | [Platform](../../../Internal-IT/platform/); Designed, outside the workload inventory and gate |
| Application and source repository | Product & Engineering | Product & Engineering | [Workload](../../../Internal-IT/workloads/ayka-portal/); placeholder application, no live service |
| Policy mapping, exceptions, evaluator and CI evidence | CISO | Cloud Platform Engineering | [CODEOWNERS](../../../.github/CODEOWNERS) routes policy, scripts and workflow changes to the repository maintainer; code review routing is not legal asset ownership |
| ISMS, risks and supplier records | CISO | Compliance & Risk Management | [Document register](../README.md); draft records and proposed role owners |
| Personnel and competence information | HR & Administration | HR & Administration | [Personnel register](../../../organization/personnel-register.md); fictional data, no real staff assessment |
| Customer information | Product & Engineering | Cloud Platform Engineering | [Processing inventory](../../GDPR/README.md); intended service only, no customers or production data |
| User endpoint devices and removable media | HR & Administration | Security Operations | [Endpoint policy](../../policies/user-endpoint-device-policy.md); actual device inventory and custody records absent |

Role authority comes from [roles and responsibilities](../../../organization/roles-and-responsibilities.md). Acceptance by a named real owner is pending for every proposed assignment.

## 3. Maintenance and gaps

Cloud Platform Engineering would regenerate the inventory after workload changes, compare additions/deletions with the prior snapshot, and obtain an accountable role for each new group before any deployment. Product & Engineering would identify information owners separately from infrastructure custodians. HR & Administration would maintain device serial numbers and signed handover/return records in restricted storage, not in this public repository.

Before claiming A.5.9 operational coverage: define mandatory tags and controlled owner values; reconcile source tags with this register; inventory non-Terraform information and devices; confirm owners; and record a dated reconciliation. Missing metadata is a governance gap even when a scanner reports no finding. See [RISK-010](../03-risk-management/risk-register.md) and [classification policy](../../policies/data-classification-and-confidentiality-policy.md).

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
