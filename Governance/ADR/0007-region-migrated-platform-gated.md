# ADR-0007: Region migrated in source; platform roots gated

| Field | Value |
|---|---|
| Status | Recorded |
| Date | 2026-11-10 |
| Deciders | Repository owner, in commit `bc11890`. No separate approval record |

## Context

Two recorded facts changed on 2026-11-10. [ADR-0003](0003-target-region.md) states the target Region `eu-central-1` and records that the source still named `ap-south-1`. [ADR-0001](0001-evidence-labels.md) and the SoA defined Gated design as "scanned workload Terraform", because only `ayka-portal` passed through the gate. Commit `bc11890` moved every Terraform root and the region SCP to `eu-central-1` and added CI jobs that scan the platform roots. ADR-0003 and ADR-0001 stay as written; this record states what is now different.

## Drivers

- A reader of ADR-0003 alone would think the source still names Mumbai.
- Platform Terraform that a gate scans is no longer "ungated platform Terraform", but it is not workload evidence either: the jobs have run locally only and do not block a merge.
- A source change does not show where data is processed.

## Options

1. Edit ADR-0003 and the SoA definition in place.
2. Add this record, keep ADR-0003 as the decision on the target, and widen Gated design with its limits stated.
3. Treat the residency question as closed now that the source matches.

## Outcome

Option 2.

- **Region.** The target in ADR-0003 is unchanged. The source now matches it: [REAL-INFRA-003](../records/real/infra/REAL-INFRA-003-region-migration-verification.md) shows no `ap-south-1` in Terraform, variable files, the SCP or CI code. Still open: an owner-approved residency decision, real processing facts, and re-creating the console-created Identity Center instance (in `ap-south-1`, if it exists). RISK-011 stays Open. Option 3 is rejected for the reason ADR-0003 gave.
- **Platform gate.** Gated design now covers Terraform scanned by the compliance gate in either place: the workload in CI, and the platform roots in the jobs `Platform Gate` (plan mode: `aws-organization`, `landing-zone`, `evidence-archive`, `aws-iam-core`; source mode without OPA: `remote-state`, `aws-identity-center`) and `Platform Validate` (Entra ID, no scanner coverage). Evidence today is the local run in [REAL-INFRA-001](../records/real/infra/REAL-INFRA-001-gate-run-all-roots.md). Until the jobs have run on GitHub and are required checks in `protect-main`, a row that rests only on a platform root says so.

## Consequences

The SoA (version 1.2), the gap analysis, the cloud, cryptography, physical and data protection policies, and the context register state the migrated source. Positive: no document repeats a mismatch that no longer exists in code. Negative: "the source says Frankfurt" can be misread as "the data is in Frankfurt"; every statement keeps the limit that nothing is deployed.

## Evidence

- [REAL-INFRA-001](../records/real/infra/REAL-INFRA-001-gate-run-all-roots.md), [REAL-INFRA-003](../records/real/infra/REAL-INFRA-003-region-migration-verification.md)
- [Statement of applicability](../ISMS/04-controls-and-soa/statement-of-applicability.md) section 1
- [Owner actions](../records/real/isms/REAL-ISMS-001-owner-actions-open.md) O-03 (required checks)
