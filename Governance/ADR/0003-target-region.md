# ADR-0003: Target Region is eu-central-1

| Field | Value |
|---|---|
| Status | Recorded |
| Date | 2026-10-14 |
| Deciders | Written target in the cloud security policy, the GDPR index and the risk register. No residency approval and no source migration |

## Context

The case study aims at customers in the EU. Several Terraform roots and the Region-restriction service control policy name `ap-south-1`.

## Drivers

- A document that says "data stays in the EU" would be false while the source names Mumbai.
- Moving every root is a code change with plan impact. It is not done by editing a policy.
- The mismatch is already RISK-011.

## Options

1. Treat `ap-south-1` as the Region of record because it is what the files say.
2. State `eu-central-1` as the target and keep the conflicting source visible as a gap.
3. Change the Terraform in the same change as the policy, and call the residency question closed.

## Outcome

Option 2. The target Region for personal data and for the workload design is `eu-central-1` (Frankfurt). Until the source matches, or a named exception is approved, no EU-location claim is made. Option 3 is rejected because a string change would not show where a future account processes data, and it is a separate engineering change.

## Consequences

Transfer text, the SoA and the cloud policy repeat the conflict instead of resolving it. Positive: the target is stable. Negative: readers who see only `dev.tfvars` will think the decision went the other way. The [data-flow assessment](../GDPR/data-flow-and-transfer-assessment.md) is the map that holds both facts.

## Evidence

- [Cloud security policy](../policies/cloud-security-policy.md)
- [GDPR index](../GDPR/README.md)
- RISK-011 in the [risk register](../ISMS/03-risk-management/risk-register.md)
- [`restrict-region.json`](../../Internal-IT/platform/foundation/aws-organization/modules/scp/restrict-region.json)

## Links

- [ADR-0005](0005-gdpr-roles.md)
