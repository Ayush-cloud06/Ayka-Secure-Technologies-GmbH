# Implementation mapping

| Field | Value |
|---|---|
| Document ID | ISMS-07-02 |
| Owner | Cloud Platform Engineering |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or when scope, source configuration or evidence changes |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company. The CI gate operates on plans; the infrastructure has never been deployed.

## 1. Reading the mapping

This maps source locations to intended safeguards, not to certification or operating effectiveness. **Implemented** describes the real CI mechanism; **Gated design** describes the workload it scans; **Designed** describes other source or draft procedures. The [SoA](../04-controls-and-soa/statement-of-applicability.md) decides applicability; the [control evidence index](control-evidence-index.md) supplies dated scanner evidence.

## 2. Source and control relationships

| Source | Role in design or operation | Annex A references | Evidence status and boundary |
|---|---|---|---|
| [Workload networking](../../../Internal-IT/workloads/ayka-portal/modules/networking/main.tf) | VPC, public/private/DB subnets, routes, flow-log configuration | A.8.20, A.8.21, A.8.22, A.8.15 | Gated design; no observed traffic or log delivery |
| [Workload security](../../../Internal-IT/workloads/ayka-portal/modules/security/main.tf) | Service roles and security-group rules | A.5.15, A.8.2, A.8.3, A.8.20 | Gated design; no effective-permission simulation |
| [Workload compute](../../../Internal-IT/workloads/ayka-portal/modules/compute/) | EC2, ECS, ALB, WAF, log groups | A.8.9, A.8.15, A.8.20, A.8.24 | Gated design; placeholder AMI/image/certificate, no running application |
| [Workload storage](../../../Internal-IT/workloads/ayka-portal/modules/storage/main.tf) | S3 encryption, versioning, lifecycle and logging configuration | A.8.13, A.8.15, A.8.24 | Gated design; versioning is not a restore test or separate backup |
| [Workload database](../../../Internal-IT/workloads/ayka-portal/modules/database/main.tf) | RDS, secret storage, monitoring role and backup settings | A.5.17, A.8.13, A.8.14, A.8.24 | Gated design; no recovery, rotation or failover results |
| [Workload root](../../../Internal-IT/workloads/ayka-portal/) | Module composition, providers and variables | A.8.9, A.8.31 | Gated design; target eu-central-1 versus source Region mismatch tracked in RISK-011 |
| [Platform roots](../../../Internal-IT/platform/) | Organization, landing zone and account controls | A.5.23, A.8.9, A.8.20 | Designed; excluded from this CI workload plan |
| [Identity roots](../../../Internal-IT/platform/domains/identity/) | Entra, Identity Center, IAM trust and boundaries | A.5.15–A.5.18, A.8.2–A.8.5 | Designed; [identity architecture](../../architecture/identity-architecture.md) records unresolved assumptions |
| [CI scripts](../../../Internal-IT/engineering/ci-cd/scripts/) and [workflows](../../../.github/workflows/) | Scan, normalize, decide, package and verify evidence | A.8.8, A.8.29, A.8.32, A.5.33 | Implemented plan checks, [dated run](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/37498007502); apply remains simulated |
| [OPA rules](../../../Internal-IT/engineering/policy-as-code/OPA/) and [mapping](../../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml) | Resource checks and mapping of scanner findings to 38 controls | As declared per control in the evidence index | Implemented checks; a metadata reference alone does not cover an entire Annex A control |
| [Negative scenarios](../../../Internal-IT/workloads/control-validation-scenarios/) | Intentionally insecure examples and named detection contract | A.8.29 | Implemented regression check; only the named cases demonstrate detection |
| [Company policies](../../policies/README.md) and [operational procedures](../06-operational-procedures/) | Responsibilities and intended ways of working | A.5.1, A.5.37 and topic-specific controls | Designed; policy publication does not prove use |

## 3. Updating the map

For a new module, Cloud Platform Engineering records its path, applicable controls, gate inclusion and source/run evidence. Compliance & Risk Management compares the change with the SoA and [gap analysis](../04-controls-and-soa/control-gap-analysis.md). A moved file requires link validation. A new runtime claim requires operating evidence; successful `validate` or `plan` output is insufficient.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
