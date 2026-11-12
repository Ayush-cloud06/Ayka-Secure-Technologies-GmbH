# Asset ownership register

| Field | Value |
|---|---|
| Document ID | ISMS-02-02 |
| Owner | Cloud Platform Engineering |
| Approver | Managing Director |
| Version | 1.1 |
| Effective | On approval |
| Next review | 12 months after approval, or when scope, source configuration or evidence changes |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company. The CI gate operates on plans; the infrastructure has never been deployed.

## 1. Purpose and boundary

A.5.9 requires accountable ownership. This register proposes role accountability for the designed service and links the actual ownership markers in source. It does not appoint real asset custodians or assert that owner tags have been applied.

The [generated inventory](asset-inventory.md) covers 88 managed resources in one workload plan (CI run 37498007502, 2026-10-06). It excludes data sources, staff devices, information held outside Terraform, and the platform roots. Its summary shows **one resource with an Owner tag out of 88, and zero DataClassification tags**.

That inventory is now stale. A local plan of the same workload at commit `bc11890` on 2026-11-10 (`run-local-chain.sh Internal-IT/workloads/ayka-portal`, counted from `output/tfplan.json`) has **97** managed resources, and `default_tags` put `Owner` and `DataClassification` on **59 of 97** (the rest are resource types that cannot carry tags). Both tags carry one workload-wide value (`var.owner`, `var.data_classification` default `Confidential`): that names a role, not a real custodian, and is not a per-dataset classification. The inventory is regenerated from the first `main` run after this change; it is not hand-edited. A proposed owner below does not repair the custodian gap.

## 2. Proposed accountability

| Asset group | Accountable role | Custodian role | Evidence and present limitation |
|---|---|---|---|
| Workload network, compute, storage, database, security modules | Cloud Platform Engineering | Cloud Platform Engineering | [Module source](../../../Internal-IT/workloads/ayka-portal/modules/) and [inventory](asset-inventory.md); Gated design; Owner tag on 1 of 88 in the generated inventory, 59 of 97 in the current source (one role value) |
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
| 1.1 | 2026-11-10 | Record that the generated inventory is stale: 97 planned resources, Owner and DataClassification on 59 of 97 through `default_tags` (local plan, `bc11890`) |
