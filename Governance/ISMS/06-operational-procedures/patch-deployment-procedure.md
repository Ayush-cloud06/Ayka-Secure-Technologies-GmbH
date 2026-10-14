# Patch deployment procedure

| Field | Value |
|---|---|
| Document ID | ISMS-OPS-05 |
| Owner | Cloud Platform Engineering |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or patch failure or material vulnerability |
| Status | Draft. Not approved: no approval record exists (simulated company) |

Ayka Secure Technologies GmbH is a simulated company; this document does not establish a performed activity.

## 1. Scope and boundary

This procedure covers Terraform providers, scanner/CI tools, application dependencies and future workload/endpoint patches under the [vulnerability and patch policy](../../policies/vulnerability-and-patch-management-policy.md). Today only source/pin changes and plan-only checks can be evidenced; no operating workload or endpoint patch programme exists. [Tool pins](../../../Internal-IT/engineering/ci-cd/toolchain.versions) and [workflow pins](../../../.github/workflows/test.yml) provide a repository inventory starting point, not a complete software bill of materials.

## 2. Plan a patch

Product & Engineering owns application dependencies; Cloud Platform Engineering owns infrastructure and CI components; Security Operations validates priority and exposure. Each patch ticket contains affected assets, installed/intended versions, advisory source and verification date, vulnerability/finding IDs, scope, remediation deadline from policy, release compatibility, expected benefit, tests, change window and rollback approach. Verify supplier advisories against their primary publication when preparing a real change; this document supplies no current vulnerability claim.

Distinguish replacing a scanner binary from proving that all existing findings are resolved. Compare rule additions/removals and output formats; do not silently discard findings because a tool upgrade changes identifiers. If no safe patch is available, CISO reviews time-limited containment with expiry and reassessment; risk acceptance follows the [risk treatment plan](../03-risk-management/risk-treatment-plan.md).

## 3. Implement and validate

1. Obtain the release through the supplier's documented channel; verify checksum/signature when provided, license impact and supported version. Record provenance, not a copied binary or token, in the PR.
2. Update intended pins and lock files consistently. Follow the [change procedure](change-management-procedure.md); sensitive gate/tool behavior changes use elevated review even when initiated as a version update.
3. Test in an isolated environment. For current repository tooling, run evaluator/wrapper tests, policy tests and expected regression cases; compare before/after scan populations, decision severity and evidence integrity. For future service patches, require compatibility, security and business smoke tests plus approved backup/recovery prerequisites.
4. Stop on incomplete scans, failing tests, undocumented rule loss, identity failures or unrecoverable state transitions. Capture the failure and restore the previously approved version through a reviewed change where safe.
5. After merge, identify the exact SHA/run and verify the changed version actually used. Future runtime rollout additionally requires actual version/configuration readback, a monitored observation interval defined in the ticket and owner acceptance. Do not describe a pin update as a live patch.

## 4. Emergency and closure

For active exploitation, CISO invokes the [incident plan](../../policies/incident-response-plan.md) and emergency change path. Preserve tests and scoped evidence; retrospective review is due within two business days. Rollback that reintroduces a vulnerability requires documented containment and CISO decision; irreversible migrations require a tested recovery alternative before release.

Close the finding only after [rescanning](vulnerability-scanning-procedure.md) confirms remediation for the same scope and the reviewer records effectiveness. Preserve ticket, approval, before/after versions, PR, tests, run URL, rollback or incident links and verification under the [retention policy](../../policies/records-and-data-retention-policy.md). Report missed targets via [metrics](../08-monitoring-and-measurement/kpis-and-metrics.md). ISO/IEC 27001:2022 A.8.8, A.8.19 and A.8.32.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
