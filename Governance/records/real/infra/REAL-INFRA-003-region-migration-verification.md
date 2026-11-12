# REAL-INFRA-003: Verification that the Terraform sources target eu-central-1

> **REAL RECORD.** Performed on the date shown. Scope and limits are stated below.

| Field | Value |
|---|---|
| Record ID | REAL-INFRA-003 |
| Performed | 2026-11-10 |
| Performed by | Repository owner, AI-assisted tool run (`grep`, `terraform plan`, `jq`) |
| Base commit | `bc112b8` plus the uncommitted change that moves the Region |
| Controls | SOC 2 G2 (CC2.3, C1.1); ISO gap G09; RISK-011; [ADR-0003](../../../ADR/0003-target-region.md) |

## 1. What changed

Every `ap-south-1` reference in Terraform, variable files and the region SCP was changed to `eu-central-1`:

- `ayka-portal`: `aws_region` default (now validated to be `eu-central-1`), availability zones `eu-central-1a`/`eu-central-1b`, `envs/dev.tfvars`, and the CloudWatch Logs KMS principal, which now reads `logs.${var.aws_region}.amazonaws.com` instead of a hard-coded Region.
- `control-validation-scenarios`, `aws-organization`, `aws-iam-core`, `aws-identity-center` providers; `landing-zone` variables (validated), `enterprise_strict.tfvars` and the core module default.
- [`restrict-region.json`](../../../../Internal-IT/platform/foundation/aws-organization/modules/scp/restrict-region.json): approved Region `eu-central-1`. The global-service `NotAction` list is now AWS's published example list (42 entries, including `sts:*`, `support:*`, `waf:*`, which the old list lacked). One addition: `events:*` in `us-east-1` only, for the landing zone's forwarding rules ([SCP README](../../../../Internal-IT/platform/foundation/aws-organization/modules/scp/README.md)).

## 2. Proof

Source grep over code and configuration (Terraform, tfvars, JSON, YAML, Python, shell; `.terraform/` and state files excluded):

```
$ grep -rn "ap-south" Internal-IT .github tests --exclude-dir=.terraform \
    --include=*.tf --include=*.tfvars --include=*.json --include=*.yml --include=*.yaml --include=*.py --include=*.sh
(no output, exit 1)
```

Remaining mentions are documentation only, both on purpose: `Internal-IT/platform/domains/identity/docs/identity-source.md` and `scim.md` record that the Identity Center instance configured through the console was created in `ap-south-1` and must be re-created in `eu-central-1`.

Plan of `ayka-portal` with the local chain (mock credentials):

```
$ jq -r '"aws_region=\(.variables.aws_region.value) availability_zones=\(.variables.availability_zones.value|join(","))"' output/tfplan.json
aws_region=eu-central-1 availability_zones=eu-central-1a,eu-central-1b
$ grep -c '"ap-south' output/tfplan.json
0
$ grep -o 'logs\.[a-z0-9-]*\.amazonaws\.com' output/tfplan.json | sort -u
logs.eu-central-1.amazonaws.com
```

The portal still passes the gate after the move (REAL-INFRA-001), and the scenarios plan and regression check behave as before.

## 3. Limits

- This proves what the **source** says. It does not show where any data is processed: nothing is deployed.
- The Identity Center instance, if it still exists, is in `ap-south-1` and cannot be moved. The region SCP would block it once attached.
- Local Terraform state files outside git (for example `remote-state/`) describe resources created earlier; this record does not cover them.
- ADR-0003 also requires an owner-approved residency decision and real processing facts (G09). Those stay open.
