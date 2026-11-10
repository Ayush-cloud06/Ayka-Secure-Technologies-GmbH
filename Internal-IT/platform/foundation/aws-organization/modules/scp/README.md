# Service Control Policies

Defines SCP guardrails applied at the OU level.

Policies include:
- Deny root usage
- Prevent disabling CloudTrail
- Region restrictions

SCPs operate at the governance layer and apply to entire OUs.

## Region restriction (`restrict-region.json`)

- Approved Region: `eu-central-1` only ([ADR-0003](../../../../../../Governance/ADR/0003-target-region.md)).
- The `NotAction` list is copied unchanged from AWS's published example
  [`Deny-access-to-AWS-based-on-the-requested-AWS-region.json`](https://github.com/aws-samples/service-control-policy-examples/blob/main/Region-controls/Deny-access-to-AWS-based-on-the-requested-AWS-region.json)
  (retrieved 2026-11-10). AWS says the list "might not include all of the latest global AWS services or operations"; review it when a new global service is adopted.
- One deliberate addition: in `us-east-1` only, `events:*` is also allowed (second statement). The landing zone's forwarding rules for global-service events (IAM, root sign-in, global STS) must live there, because CloudTrail delivers those events to EventBridge only in `us-east-1`. Every other Region keeps the AWS list unchanged.
- The AWS example also exempts a named privileged role (`ArnNotLike aws:PrincipalARN`). No such role is defined here yet, so the exemption is left out.

Caveats (design facts, not tested against a live organization):
- Global services such as IAM, Organizations, CloudFront and Route 53 are served from `us-east-1`; they stay usable through the `NotAction` exemptions above.
- IAM Identity Center has one home Region. It must be created in `eu-central-1`; an instance in another Region would be blocked by this SCP and cannot be moved, only re-created.
- Regional detection services (GuardDuty, Security Hub, AWS Config) run only in `eu-central-1`. Activity in other Regions is denied by this SCP rather than detected.
- SCPs never apply to the management account or to service-linked roles.
