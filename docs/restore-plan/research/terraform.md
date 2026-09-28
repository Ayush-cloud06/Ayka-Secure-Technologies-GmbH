# A-terraform findings: Terraform roots, dependency graph, secrets, verification, plans

Repo: `<repo>` at `53b0532`. HEAD, `main`, `origin/main` and the checked-out branch `plan/restore-2026` all resolve to `53b0532`.
All tools ran in an export (`git archive HEAD | tar -x -C scratchpad/tree-A`). The repo itself was not touched.
Paths below are relative to `Internal-IT/` unless they start with `.github/` or `./`.
**No secret values appear in this file.** Where a value is sensitive, only `path:line` and the kind are given.

---

## 0. Toolchain and method

| Item | Result |
|---|---|
| terraform | Not preinstalled (`terraform: command not found`). Downloaded **1.7.5** from `releases.hashicorp.com`. SHA256 `3ff056b5…f7a5` matches the official SHA256SUMS. Binary at `scratchpad/bin/terraform`. |
| registry.terraform.io | **Blocked by egress policy.** `terraform init` failed with `Failed to query available provider packages … could not connect to registry.terraform.io: failed to request discovery document: Get "https://registry.terraform.io/.well-known/terraform.json": Forbidden`. The proxy status shows `connect_rejected` 403 for `registry.terraform.io:443` and `checkpoint-api.hashicorp.com:443`. |
| Providers | **DEVIATION, flagged for the lead:** I did not retry the registry or route around it. I downloaded the exact provider zips from `releases.hashicorp.com`, the host that is allowed and that the task named for terraform. All 8 matched the official SHA256SUMS, and the aws 6.x and azurerm zips also matched the `zh:` hashes in the committed lock files. They are served offline with `-plugin-dir=scratchpad/plugin-mirror`. Versions: aws 5.100.0, 6.33.0, 6.35.1, 6.37.0; azurerm 3.117.1; azuread 2.53.1; random 3.8.1; tls 4.2.1. Script: `scratchpad/dl/fetch-providers.sh`. Log: `scratchpad/logs/fetch-providers.log`. |
| tflint | **v0.53.0** from GitHub releases. Checksum OK. Only the bundled terraform ruleset (0.9.1); no AWS ruleset plugin. |
| Ambient creds | The sandbox shell has `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` set, plus `~/.aws/config`. **They were never used.** Every plan and show ran under `env -u AWS_ACCESS_KEY_ID -u AWS_SECRET_ACCESS_KEY -u AWS_SESSION_TOKEN AWS_CONFIG_FILE=/dev/null AWS_SHARED_CREDENTIALS_FILE=/dev/null AWS_EC2_METADATA_DISABLED=true`. No real AWS or Azure call was attempted, and nothing was applied. |
| Logs | `scratchpad/logs/<root>.{fmt,init,validate,plan,tflint}.log` |

---

## 1. Terraform roots under `Internal-IT/` (124 `*.tf` files; none outside `Internal-IT/`)

There are 8 roots. `aws-identity-center` was not in the brief's known list.
"#res" counts `resource` blocks in the root plus its local modules. Blocks inside `/* */` are excluded.

| Root (path) | Purpose | Providers (constraint → locked) | Backend | #res blocks (→ instances) | #module calls | Vars / outputs (root) | Health |
|---|---|---|---|---|---|---|---|
| `platform/foundation/aws-organization` | Creates the AWS Org (`organization.tf:1-3`), 3 OUs (`modules/ou-structure/ous.tf:5-17`), 3 SCPs (`modules/scp/scp.tf:1-21`) and 3 attachments to the **Workloads OU only** (`modules/scp/attachment.tf:5-18`) | aws, **no `terraform{}` block and no version constraint** (`provider.tf:1-3`) → 6.33.0 | **local** (none) | 10 (→10) | 2 (`main.tf:1,6`) | 0 / 2 (`outputs.tf`) | fmt/init/validate OK; tflint: 2 warnings (required_providers, required_version) |
| `platform/foundation/landing-zone` | Per-account baseline for security, dev and prod via 3 aliased providers that assume `OrganizationAccountAccessRole` (`provider.tf:10-35`, `locals.tf:2-4`). Contents: CloudTrail, S3 account PAB, IAM roles, SNS alerts, "SIEM" Firehose, VPC quota, break-glass role, budgets | aws `>= 5.0` (`provider.tf:5`) → 6.35.1 | **local** | 22 per account (→ **66** with all features for 3 accounts) | 12 (3 root `main.tf:1,17,33`; 5 in `account_landing_zone/main.tf:11-45`; 4 in `core/main.tf:2-20`) | 8 / 1 (`main.tf:49`) | fmt/init/validate OK; tflint: required_version, plus unused vars `account_landing_zone/variables.tf:1` (`environment`), `core/variables.tf:7`, `siem/variables.tf:6` |
| `platform/foundation/remote-state` | State storage bootstrap. **AWS:** S3 bucket `ayka-terraform-state`, versioning, AES256 SSE and DynamoDB `terraform-locks` in eu-central-1 (`bootstrap.tf:1-40`). **Azure:** RG, storage account `stplatformtfstate066` and container `entra-id` in westeurope (`main.tf:1-23`) | azurerm `~> 3.100` → 3.117.1; aws **unconstrained** (`bootstrap.tf:1`) → 6.37.0 | **local** (expected for a bootstrap) | 7 (→7) | 0 | 0 (`variables.tf` is 0 bytes) / 0 | fmt/init/validate OK; tflint: missing aws constraint. Storage account `public_network_access_enabled = true` (`main.tf:16`); S3 state bucket has no public-access block |
| `platform/domains/identity/aws-iam-core` | IAM roles (BreakGlassRole, SecurityAuditRole, PlatformOperationsRole, WorkloadOperatorRole), 9 customer policies including 5 ABAC ones, and a permission boundary | aws `~> 5.0` → 5.100.0 | **local** | 21 (→21) | 0 | 2 required, no defaults (`variables.tf:1-9`) / 0 | fmt/init/validate OK; tflint: required_version. 3 ABAC policies are **never attached**: `abac-custom-policies.tf:32,64,95` |
| `platform/domains/identity/aws-identity-center` | Identity Store groups Tier0-2, 26 memberships (users looked up by Entra UPN), 4 permission sets, 3 inline policies, 3 account assignments, ABAC access-control attributes | aws `~> 5.0` → 5.100.0 | **s3** `ayka-terraform-state` / `aws-identity-center/terraform.tfstate` / eu-central-1 / DynamoDB `terraform-locks` (`backend.tf:1-9`) | 13 (→ ~40: 3 groups + 26 memberships + 4 PS + 3 inline + 3 assignments + 1 ABAC) | 0 | 1 (`variables.tf:1`) / 1 (`sso-settings.tf:3`) | fmt/init(-backend=false)/validate OK; tflint: required_version. `restricted_session` PS (`session-controls.tf:32`) is never assigned |
| `platform/domains/identity/entra-id` | Entra ID users from the HR JSON (24 people in `modules/core/personnel.json`), department, role and tier groups, 3 kinds of memberships, 4 admin accounts, 1 break-glass user, and Conditional Access (off by default) | azuread `~> 2.47` → **no lock file committed** (`entra-id/.gitignore:10` ignores it); I used 2.53.1 | **azurerm** RG `rg-platform-terraform-state`, SA `stplatformtfstate066`, container `entra-id`, key `identity.tfstate`, subscription ID hardcoded (`provider.tf:11-17`) | 14 active (+3 commented out in `aws_enterprise_app.tf:32-63`) (→ ~137 estimated from personnel.json: 24 users, 4 admins, 1 break-glass, 27 groups, 81 memberships; CA count=0) | 4 (`main.tf:1,5,18,28`); `module "output"` points at a module whose only file is whitespace | 2 (`variables.tf:1,6`) / 0 active | fmt/init/validate OK (init warns about an incomplete lock). tflint: unused `data.azuread_service_principal.aws_sso` (`aws_enterprise_app.tf:10`), untyped vars (`modules/privileged/variables.tf:1-3`, `modules/security/conditional_access/variables.tf:1,5`), unused `local.non_privileged_personnel` (`modules/core/locals_personnel.tf:17`) |
| `workloads/ayka-portal` | Portal workload in 5 modules: networking (VPC, subnets, NAT, flow logs), security (SGs, IAM), storage (S3, SNS), database (RDS Postgres, Secrets Manager), compute (ALB+WAF, ECS Fargate, EC2, ACM with a self-signed cert). Root holds the KMS key and alias | aws `~> 5.0` → 5.100.0; random `~> 3.6` → 3.8.1; tls `~> 4.0` (module) → 4.2.1 | **local** | 81 (→ **87 planned**) | 5 (`main.tf:1,13,22,30,45`) | 28 root vars (all defaulted) / 10 outputs | fmt/init/validate/tflint(--recursive) all clean; **plan OK: 87 to add** |
| `workloads/control-validation-scenarios` | Deliberately insecure fixtures: EC2 without IMDSv2, SSH open to the world, unencrypted S3 with versioning off, public-read ACL. The NACL scenario is **empty** | aws `~> 5.0` → 5.100.0 | **local** | 6 (→ **6 planned**) | 5, count-gated by `var.enabled_scenarios` (`main.tf:1-24`) | 1 (`variables.tf:1-23`) / 0 | fmt/init/validate/tflint clean; **plan OK: 6 to add**, but only with env creds (see §6) |

Other facts about these roots:

- **Committed lock files.** Lock files are committed for every root except entra-id. There is **provider major-version skew**: the foundation roots lock aws 6.x (6.33.0, 6.35.1, 6.37.0), while identity and workloads lock 5.100.0.
- **No `terraform_remote_state` anywhere.** Cross-root data sources are limited to `data.aws_organizations_organization.current` (`aws-organization/main.tf:11`), which reads the org itself.
- **Tracked tfvars are not auto-loaded.** Neither `landing-zone/enterprise_strict.tfvars` nor `ayka-portal/envs/dev.tfvars` is named `terraform.tfvars` or `*.auto.tfvars`.
  - CI never passes `-var-file`.
  - `dev.tfvars` values all equal the defaults in `variables.tf`.
  - landing-zone requires `security_account_id`, `dev_account_id` and `prod_account_id` without defaults (`variables.tf:1-14`), so it cannot plan without the tfvars.

---

## 2. Dependency graph (REAL = code reference; INTENDED-ONLY = docs or claims with no code link)

No root reads another root's state. The only real cross-root links are **string or name conventions** (bucket names, role names, UPN patterns).

| # | Edge | Status | Evidence |
|---|---|---|---|
| E1 | remote-state (AWS S3/DynamoDB) → aws-identity-center backend | **REAL, by hardcoded name** | `remote-state/bootstrap.tf:6` (`ayka-terraform-state`), `:32` (`terraform-locks`), `:2` (eu-central-1) = `aws-identity-center/backend.tf:3-6` |
| E2 | remote-state (Azure SA/container) → entra-id backend | **REAL, by hardcoded name** | `remote-state/main.tf:2,7,20` = `entra-id/provider.tf:12-14` |
| E3 | remote-state → aws-organization, landing-zone, aws-iam-core, ayka-portal, scenarios | **INTENDED-ONLY** | These 5 roots have no backend block, so they use local state. The claim of state for all domains appears at `platform/structure.md:30` and `CONTROL-PLANE.md:18` ("separate Terraform states"). |
| E4 | aws-organization → landing-zone | **INTENDED-ONLY** | landing-zone takes account IDs from tfvars (`enterprise_strict.tfvars:5-7`) and assumes `OrganizationAccountAccessRole` (`locals.tf:2-4`). aws-organization creates **no accounts** (its own README, lines 10-12; no `aws_organizations_account` anywhere) and has no outputs consumed elsewhere. |
| E5 | aws-organization internal: org → OUs → SCP attachments | **REAL, with a bug** | `main.tf:3` passes `module.ou-structure.Workloads_ou_id` to the SCP module. The OU root comes from `data.aws_organizations_organization.current` (`main.tf:8,11`), **not** from the `aws_organizations_organization.ayka` resource (`organization.tf:1`). That gives no ordering on a fresh payer. If the org already exists, the resource tries to create a second one. |
| E6 | landing-zone → aws-iam-core / aws-identity-center | **INTENDED-ONLY** | aws-iam-core takes `security_account_id` and `management_account_id` as bare vars (`variables.tf:1-9`), with no tfvars and no state link. **Overlap:** the landing-zone break-glass role `emergency-break-glass-role` (`landing-zone/modules/break_glass/main.tf:2`) and the aws-iam-core `BreakGlassRole` (`break-glass-role.tf:4`) have different trust (security-account root vs management-account root). |
| E7 | aws-identity-center → aws-iam-core roles | **REAL by role name, functionally BROKEN** | The permission sets' inline policies allow `sts:AssumeRole` on `arn:aws:iam::*:role/BreakGlassRole` (`permission-sets.tf:15`), `PlatformOperationsRole` and `SecurityAuditRole` (`:41-42`), and `WorkloadOperatorRole` (`:68`). These names are defined in `aws-iam-core/break-glass-role.tf:4` and `cross-account-roles.tf:4,25,48`. But PlatformOperationsRole and WorkloadOperatorRole trust the **service** principal `sso.amazonaws.com` (`trust-policies.tf:2-11`, used at `cross-account-roles.tf:27,50`), not the `AWSReservedSSO_*` role principals, so the role chain cannot work. All 3 assignments target only `var.management_account_id` (`assignments.tf:10,23,36`). |
| E8 | entra-id → aws-identity-center (users) | **REAL by UPN convention, via manual SCIM** | IC does lookups with `data.aws_identitystore_user` on UserName `emp-0NN@<personal-tenant>.onmicrosoft.com` (`memberships.tf:6-37,43-54`). That matches the Entra UPN pattern in `entra-id/modules/core/users.tf:5` and `modules/privileged/admin_accounts.tf:5`. The SCIM sync itself is **not in code**: console steps only in `domains/identity/docs/scim.md:17-23`. Group models differ: IC `Tier0..2` (`groups.tf:3`) vs Entra `grp-tier-tier0..` (`groups_tiers.tf:5`). Drift: IC Tier1 contains emp-001 and emp-002, who are tier0 in personnel.json. Only 1 of the 4 privileged admin accounts (`admin-emp-002`) is in an IC group. |
| E9 | entra-id enterprise app / SAML federation → IC | **INTENDED-ONLY** | Commented out (`aws_enterprise_app.tf:15-83`). Only an unused `data.azuread_service_principal` lookup remains (`:10-12`). |
| E10 | ABAC chain: IC attributes → aws-iam-core ABAC policies | **INTENDED-ONLY, keys do not match** | IC maps `AccessTier` and `CostCenter` (`session-controls.tf:15-27`). The policies test `aws:PrincipalTag/Department` and `…/Environment` (`abac-custom-policies.tf:22,116`) and require request tags Department, Environment and Owner (`abac-mandatory-tagging.tf:27,49,71`). |
| E11 | identity / landing-zone → ayka-portal | **INTENDED-ONLY** | ayka-portal uses static mock creds (`provider.tf:19-20`), has no `assume_role`, and uses placeholder account `123456789012` (`kms.tf:19`). default_tags are Environment, Workload, ManagedBy and Project (`provider.tf:26-32`), with **no Department tag**, so it would violate the aws-iam-core mandatory-tag policy. Region ap-south-1 is consistent with the SCP (`aws-organization/modules/scp/restrict-region.json:18`). |
| E12 | CI → ayka-portal / scenarios | **REAL** | `.github/workflows/test.yml:13-14,39,56-62` and `.github/workflows/drift-detection.yml:17`. The OIDC role `arn:aws:iam::982081090103:role/github-actions-oidc-role` (`test.yml:16,41`, `drift-detection.yml:31`) is **overridden for ayka-portal**: static provider creds (`provider.tf:19-20`) take precedence over env or OIDC creds. The OIDC creds only matter for scenarios, whose provider has no creds. |
| E13 | GitHub OIDC provider/role in code | **NOT IN CODE** | No Terraform creates `aws_iam_openid_connect_provider` or the `github-actions-oidc-role`. There are zero hits for `token.actions.githubusercontent.com`, `AssumeRoleWithWebIdentity` or `aws_iam_openid_connect_provider` in the tree, and `git log --all -S` finds nothing. The trust-policy `sub` condition and attached permissions are therefore **UNVERIFIABLE from the repo**. Account `982081090103` is **not** one of the landing-zone accounts (`enterprise_strict.tfvars:5-7`). |
| E14 | landing-zone SIEM → a SIEM | **INTENDED-ONLY** | `modules/siem/main.tf:16-27` is a Firehose with **no source**, writing to the **CloudTrail bucket** (`account_landing_zone/main.tf:22`). `modules/siem/elastic-siem.md` is only a directory-tree sketch. |

Summary chain (all INTENDED-ONLY, with no state wiring):

- `aws-organization ⇢ landing-zone ⇢ {aws-iam-core, aws-identity-center, entra-id} ⇢ ayka-portal`
- `remote-state →(REAL, names) aws-identity-center, entra-id`

---

## 3. Empty `.tf` files (0 bytes or whitespace only): 8

| Path | Size |
|---|---|
| `platform/domains/identity/entra-id/modules/output/compliance.tf` | 1 byte (newline); it is the whole of `module "output"` (`entra-id/main.tf:28-30`) |
| `platform/domains/identity/entra-id/modules/privileged/governance_authorities.tf` | 0 |
| `platform/foundation/remote-state/variables.tf` | 0 |
| `workloads/control-validation-scenarios/shared/variables.tf` | 0 |
| `workloads/control-validation-scenarios/ec2/open-ssh-security-group/variables.tf` | 0 |
| `workloads/control-validation-scenarios/vpc/permissive-network-acl/main.tf` | 0: **the NACL scenario creates nothing** |
| `workloads/control-validation-scenarios/vpc/permissive-network-acl/variables.tf` | 0 |
| `workloads/control-validation-scenarios/s3/public-bucket/variables.tf` | 0 |

These are also 0 bytes, but they are not `.tf` files: the 5 scenario `README.md` files (`ec2/no-imdsv2`, `ec2/open-ssh-security-group`, `s3/missing-encryption`, `s3/public-bucket`, `vpc/permissive-network-acl`), plus `platform/README.md` and `platform/architecture.md`.

---

## 4. How ayka-portal plans offline ("plan-only, mock provider")

**The provider block** (`workloads/ayka-portal/provider.tf:17-34`):

- Static `access_key` at `:19` and `secret_key` at `:20`. Both are 15-character placeholders containing "mock"; neither is AKIA format.
- `skip_credentials_validation = true` (`:21`), `skip_metadata_api_check = true` (`:22`), `skip_region_validation = true` (`:23`), `skip_requesting_account_id = true` (`:24`).
- There are no custom `endpoints`.

**Why it runs with no network.** The only data sources are `aws_iam_policy_document`, which is computed locally. Combined with `-refresh=false` and local, empty state, plan needs no network. **Verified:** it planned with every ambient AWS variable unset.

**History of the mock creds:**

- The static creds were introduced in **`83004ae` (2026-04-04, "workload ayka-poratal")**, found with `git log -S'access_key' -- …/provider.tf`.
- Commit **`243c3b1` "mock creds for pipeline" (2026-04-16) does NOT touch Terraform.** It adds `role-session-name` to `.github/workflows/terraform-workflow.yml` and **replaces the real `terraform apply`** in `engineering/ci-cd/scripts/run-apply.sh:22-27` with `echo "Apply complete! Resources: 14 added, 0 changed, 0 destroyed."`.
- **The real plan is 87 to add.** Both "14" and "applied" are fabricated.

**Side effects:**

- The mock key and secret are embedded in the plan JSON at `configuration.provider_config.aws.expressions.{access_key,secret_key}.constant_value`. CI's evidence bundle hashes and ships `tfplan.json`, so real static creds would leak the same way.
- Nightly drift runs `terraform plan -detailed-exitcode` against local, empty state (`drift-detection.yml:36-37`). It therefore always shows 87 creates and exits 2, so the "drift" job always fails. This matches D-codex's 61/61 failures and `Governance/ISMS/03-risk-management/risk-assessment-results/2026-q2-risk-review.md:21` ("planned 87 creates against fresh/local state").

**Hardcoded AWS account IDs.** These are not secrets, but they are real-looking:

| Account ID | Where | Meaning |
|---|---|---|
| `982081090103` | `.github/workflows/test.yml:16,41`, `.github/workflows/drift-detection.yml:31` | CI OIDC role. Real, per the lead's CI run #68. |
| `<landing-zone-account-id>` | `platform/foundation/landing-zone/enterprise_strict.tfvars:5` | security account |
| `<landing-zone-account-id>` | same file, `:6` | dev account |
| `<landing-zone-account-id>` | same file, `:7` | prod account |
| `123456789012` | `workloads/ayka-portal/kms.tf:19` | AWS documentation placeholder |

Other identifiers:

- Azure subscription ID in `entra-id/provider.tf:16`.
- Personal Entra tenant domain `<personal-tenant>.onmicrosoft.com` in `entra-id/modules/core/users.tf:5`, `modules/privileged/{break_glass.tf:2, admin_accounts.tf:5}` and `aws-identity-center/memberships.tf:6-37`.
- Placeholder AMIs: `ami-1234567890abcdef0` (`ayka-portal/variables.tf:103`, `envs/dev.tfvars:12`) and `ami-12345678` (`control-validation-scenarios/ec2/no-imdsv2/main.tf:2`).

---

## 5. Secrets (values NOT reproduced)

Search scope: grep over `*.tf *.tfvars *.yml *.yaml *.sh *.py *.json *.rego *.md` for literal assignments of `password|passwd|secret_key|access_key|private_key|client_secret|api_key|token|AWS_*`. **Exactly 5 literal hits**; all are listed here.

| path:line | Kind | First commit introducing it | Notes |
|---|---|---|---|
| `platform/domains/identity/entra-id/modules/core/users.tf:16` | Hardcoded Entra user password (initial password shared by all 24 `azuread_user.users`) | `89db3df` 2026-03-22 "gitignore cleanup" | `force_password_change = true` (`:17`). Value is 16 chars. |
| `platform/domains/identity/entra-id/modules/privileged/break_glass.tf:6` | Hardcoded **break-glass** account password | `89db3df` 2026-03-22 | `force_password_change = false` (`:7`) and `disable_password_expiration = true` (`:8`): **if applied, the committed value is the live long-lived credential of a Tier0 member** (`:11-14`). Value is 24 chars. |
| `platform/domains/identity/entra-id/modules/privileged/admin_accounts.tf:9` | Hardcoded initial password for the 4 privileged admin accounts | `89db3df` 2026-03-22 | `force_password_change = true` (`:10`). Value is 17 chars. |
| `workloads/ayka-portal/provider.tf:19` | Static AWS `access_key` (mock placeholder) | `83004ae` 2026-04-04 | 15 chars, contains "mock", not AKIA format |
| `workloads/ayka-portal/provider.tf:20` | Static AWS `secret_key` (mock placeholder) | `83004ae` 2026-04-04 | same as above |

History and extra checks:

- Repo history has **3 root commits** (`89db3df`, `7a2f667`, `fcbb603`). Each one "adds" the three entra-id files.
- A per-commit SHA-256 of the `password =` line is **identical** at `89db3df`, `7a2f667`, `fcbb603` and HEAD. The values have **never changed** since first commit.
- The three values are distinct (different hashes and lengths).
- The line numbers claimed in the brief are **confirmed exactly**: `users.tf:16`, `break_glass.tf:6`, `admin_accounts.tf:9`.
- These are generated at apply time and stored in state, not literals:
  - `tls_private_key.alb` (`ayka-portal/modules/compute/alb.tf:1-4`): RSA key stored in plaintext **local** state.
  - `random_password.db` (`modules/database/main.tf:1-4`).
- Tracked tfvars (lead's question): **no secrets.**
  - `landing-zone/enterprise_strict.tfvars` holds region, an alert email, 3 account IDs, quota and budget numbers, and feature flags.
  - `ayka-portal/envs/dev.tfvars` holds region, env, name prefix, CIDRs, bucket suffix, image, port, placeholder AMI, `db_name` and `db_username` (a username, no password).
- Committed `control-validation-scenarios/tfplan.binary`:
  - Added in `0756e0a` (2026-04-03) and still tracked, even though `.gitignore:36` (`*.binary`) was added later in `3d9a0aa` (2026-04-13).
  - It decodes (tf 1.7.5) to the **same 6 creates** as today.
  - Its embedded config snapshot differs from HEAD only by `required_version` (`provider.tf:2`).
  - It contains no credentials: 0 matches for key, secret, password or token in its `provider.tf`. Its embedded tfstate is empty (144 bytes).

---

## 6. Verification results (terraform 1.7.5, in `scratchpad/tree-A/Internal-IT/<root>`)

Commands per root (CI equivalents are in `.github/actions/validate/action.yml` and `.github/actions/plan/action.yml:37-49`):

```
terraform fmt -check -recursive <root>                                  # run from Internal-IT/
terraform init -backend=false -input=false -plugin-dir=$SP/plugin-mirror # plain init fails: registry 403
terraform validate
tflint --chdir=<root> --call-module-type=all ; tflint --recursive        # tflint 0.53.0, terraform ruleset only
# plans:
env -u AWS_ACCESS_KEY_ID -u AWS_SECRET_ACCESS_KEY -u AWS_SESSION_TOKEN AWS_CONFIG_FILE=/dev/null \
    AWS_SHARED_CREDENTIALS_FILE=/dev/null AWS_EC2_METADATA_DISABLED=true \
    terraform plan -input=false -refresh=false -out=tfplan.binary && terraform show -json tfplan.binary
```

| Root | fmt | init | validate | plan | Notes |
|---|---|---|---|---|---|
| aws-organization | PASS | PASS (aws 6.33.0) | PASS | not attempted | Needs the live Organizations API (`data.aws_organizations_organization`, `main.tf:11`); no skip flags |
| landing-zone | PASS | PASS (aws 6.35.1) | PASS | not attempted | `assume_role` into 3 accounts (`provider.tf:14-34`) and required account-ID vars |
| remote-state | PASS | PASS (azurerm 3.117.1 + aws 6.37.0) | PASS | not attempted | Needs Azure auth and AWS STS |
| aws-iam-core | PASS | PASS (aws 5.100.0) | PASS | not attempted | Provider has no skip flags, so credential validation would call STS. 2 required vars |
| aws-identity-center | PASS | PASS (-backend=false; aws 5.100.0) | PASS | not attempted | s3 backend, plus `data.aws_ssoadmin_instances` and 25 `aws_identitystore_user` lookups need live AWS |
| entra-id | PASS | PASS (azuread 2.53.1; "Incomplete lock file" warning because no lock is committed) | PASS | not attempted | azurerm backend, azuread tenant auth and a data lookup need Azure |
| **ayka-portal** | PASS | PASS (aws 5.100.0, random 3.8.1, tls 4.2.1) | PASS | **PASS: `Plan: 87 to add, 0 to change, 0 to destroy.`** | Fully offline with no env creds at all |
| **control-validation-scenarios** | PASS | PASS (aws 5.100.0) | PASS | **PASS: `Plan: 6 to add`**, only with `AWS_ACCESS_KEY_ID=mock AWS_SECRET_ACCESS_KEY=mock` | With no creds it fails: `Error: No valid credential sources found … on provider.tf line 12` (`scratchpad/logs/scenarios.plan.nocreds.log`). The provider (`provider.tf:12-21`) has skip flags but no static creds, so CI depends on the OIDC env creds. |

tflint, recursive over `Internal-IT` (terraform ruleset): 46 warnings, 0 errors.

- `terraform_required_version`: 20
- `terraform_required_providers`: 16
- `terraform_typed_variables`: 5 (entra-id)
- `terraform_unused_declarations`: 5 (landing-zone 3, entra-id 2)
- ayka-portal and scenarios: **0 issues**, including with `--recursive` as CI runs it.

---

## 7. Planned resources by type (plan JSON)

**`scratchpad/plans/ayka-portal.tfplan.json`** (format 1.2, tf 1.7.5; binary alongside):

- 89 `resource_changes`: 87 `create` plus 2 `read`. The reads are deferred `aws_iam_policy_document` data sources in storage and networking.
- **87 managed** resources by module: root 2, networking 25, security 18, storage 16, compute 17, database 9.

| Type | Count |
|---|---|
| aws_route_table_association | 6 |
| aws_subnet | 6 |
| aws_iam_role | 5 |
| aws_vpc_security_group_egress_rule | 5 |
| aws_security_group | 4 |
| aws_vpc_security_group_ingress_rule | 4 |
| aws_cloudwatch_log_group | 3 |
| aws_iam_role_policy_attachment | 3 |
| aws_route_table | 3 |
| aws_s3_bucket, _lifecycle_configuration, _notification, _public_access_block, _server_side_encryption_configuration, _versioning | 2 each (12) |
| 1 each (34 types) | aws_acm_certificate, aws_appautoscaling_policy, aws_appautoscaling_target, aws_db_instance, aws_db_parameter_group, aws_db_subnet_group, aws_default_security_group, aws_ecs_cluster, aws_ecs_service, aws_ecs_task_definition, aws_eip, aws_flow_log, aws_iam_instance_profile, aws_iam_policy, aws_instance, aws_internet_gateway, aws_kms_alias, aws_kms_key, aws_lb, aws_lb_listener, aws_lb_target_group, aws_nat_gateway, aws_s3_bucket_logging, aws_s3_bucket_ownership_controls, aws_secretsmanager_secret, aws_secretsmanager_secret_version, aws_sns_topic, aws_sns_topic_policy, aws_vpc, aws_wafv2_web_acl, aws_wafv2_web_acl_association, aws_wafv2_web_acl_logging_configuration, random_id, random_password, tls_private_key, tls_self_signed_cert |

**`scratchpad/plans/scenarios.tfplan.json`** has 6 creates:

- `module.ec2_imdsv2[0].aws_instance.bad_instance`
- `module.ec2_openssh[0].aws_security_group.open_ssh`
- `module.s3_encryption[0].aws_s3_bucket.unencrypted_bucket`
- `module.s3_encryption[0].aws_s3_bucket_versioning.disabled_versioning`
- `module.s3_public[0].aws_s3_bucket.public_bucket`
- `module.s3_public[0].aws_s3_bucket_acl.public_read`

By type: aws_instance 1, aws_security_group 1, aws_s3_bucket 2, aws_s3_bucket_versioning 1, aws_s3_bucket_acl 1. The **vpc_permissive_network_acl scenario yields 0**, and there is **no IAM scenario**, although the README says "bad IAM" (`control-validation-scenarios/README.md:5`).

The decoded committed plan is at `scratchpad/plans/scenarios.committed-tfplan.json` and has the same 6 creates.

---

## 8. README claims vs code

| Claim (source) | Status | Evidence |
|---|---|---|
| Terragrunt (`README.md:67`) | **NOT IMPLEMENTED** | No `terragrunt.hcl` or `*.hcl` other than lock files; only mention is README:67 |
| SCPs (`README.md:18`) | **IMPLEMENTED, partial** | 3 SCPs (`aws-organization/modules/scp/scp.tf:1-21`), attached to the Workloads OU only (`attachment.tf:5-18`) |
| "Delegated administration" (`README.md:18`) | **NOT IMPLEMENTED** | No `aws_organizations_delegated_administrator` |
| "Dedicated security and logging accounts" (`README.md:52`) | **NOT IMPLEMENTED in aws-organization** | No `aws_organizations_account`; accounts exist only as tfvars IDs |
| CloudTrail (`README.md:21`) | **IMPLEMENTED per account, not org trail** | `landing-zone/modules/core/logging/cloudtrail.tf:1-18` (multi-region, log validation) plus bucket (`trail_bucket.tf`). **No bucket policy for cloudtrail.amazonaws.com**, so apply would likely fail (UNVERIFIED, reasoning only). SCP denies tampering (`deny-disable-cloudtrail.json:8-10`). |
| SIEM integration (`README.md:24`) | **STUB** | Firehose with no source, writing to the CloudTrail bucket (`siem/main.tf:16-27`). Elastic exists only as a tree sketch (`siem/elastic-siem.md`). |
| Identity Center (`README.md:48`) | **IMPLEMENTED** (`aws-identity-center/*`) | Requires a pre-enabled instance (`sso-settings.tf:7-8`) |
| SCIM (`README.md:48`) | **DOCUMENTED ONLY** | `domains/identity/docs/scim.md:17-23` (manual console) |
| ABAC (`README.md:20,48`) | **PARTIAL, not wired** | Policies in `aws-iam-core/abac-*.tf`; 3 of 5 are unattached; IC attribute keys do not match (see E10) |
| Conditional Access / MFA | **IMPLEMENTED but disabled** | `entra-id/variables.tf:6-10` default false; `main.tf:15-17` mentions a licensing limit |
| GuardDuty, SecurityHub, Config, Macie (`platform/deployments/platform-rollout.md:19`, `platform/structure.md` detection/response domains) | **NOT IMPLEMENTED** | Named only in deny lists and IAM actions. `platform/domains/{detection,response,network}` and `foundation/Platform_Compliance.md`, all listed in `structure.md`, **do not exist** |
| Remote state for domains (`CONTROL-PLANE.md:18`) | **PARTIAL** | Only aws-identity-center and entra-id have backends; see E3 |

---

## 9. Surprising findings

1. **The apply is faked, and the resource count is wrong.** `engineering/ci-cd/scripts/run-apply.sh:24-27` echoes "Apply complete! Resources: 14 added". This was introduced by `243c3b1`, the commit titled "mock creds for pipeline". The real ayka-portal plan is **87 to add**, and nothing has ever been applied.
2. **The CI OIDC role is irrelevant for ayka-portal.** The static provider creds (`ayka-portal/provider.tf:19-20`) override the env creds, so CI's `configure-aws-credentials` (OIDC, account 982081090103) has no effect on the main workload. The OIDC role and provider are **not defined in any Terraform** (E13), and account 982081090103 is not among the landing-zone accounts.
3. **Drift detection can never pass.** ayka-portal has **no backend** (local state), so the nightly plan always shows 87 creates and exits 2 (`drift-detection.yml:36-45`).
4. **The break-glass password is live-if-applied.** `entra-id/modules/privileged/break_glass.tf:6` pairs the committed password with no forced change and no expiry (`:7-8`), and the user is added to tier0 (`:11-14`). It has been unchanged since the first commit (`89db3df`).
5. **Checkov skip comments are probably ineffective.** Several `# checkov:skip=` comments sit **outside** resource blocks: `ayka-portal/modules/security/main.tf:28,35,42,49` (CKV2_AWS_5) and `modules/storage/main.tf:21` (CKV_AWS_144; the in-block duplicate for `this` is at `:82`). Checkov only honours skips inside the block, so they probably do nothing. UNVERIFIED; B-pipeline should confirm with checkov.
6. **There are four "Identity/Break-glass" designs that conflict.** landing-zone's `emergency-break-glass-role` trusts the security-account root (`landing-zone/main.tf:14,30,46`). aws-iam-core's `BreakGlassRole` trusts the management-account root (`trust-policies.tf:39`). The IC Tier0 permission set can only assume `BreakGlassRole` (`permission-sets.tf:8-24`). The IC roles trusting `sso.amazonaws.com` cannot be chained (E7).
7. **aws-organization contradicts itself.** It uses both the resource `aws_organizations_organization.ayka` (`organization.tf:1`) and the data source for the same org (`main.tf:11`). It has no `terraform{}` block. The OU names in the docs (Sandbox; `structure.md`) differ from the code (Security, Infrastructure, Workloads).
8. **Provider major versions are split** (aws 6.x for foundation, 5.100.0 for identity and workloads). **Regions are split:** ap-south-1 everywhere, but the state bucket and IC backend are in eu-central-1 and Azure is in westeurope. entra-id has no lock file because it is gitignored in `entra-id/.gitignore:10`.
9. **The regression fixture is weaker than documented.** The NACL scenario is an empty file, there is no IAM scenario, and a stale plan binary is committed despite the `.gitignore`.
10. **ayka-portal would not actually apply.** Reasoning only, UNVERIFIED:
    - The ALB access-logs bucket uses SSE-KMS (`storage/main.tf:35-44`), which ALB log delivery does not support.
    - That bucket has no policy for ELB delivery.
    - The KMS key policy trusts the placeholder account `123456789012` (`kms.tf:19`).
    - The AMI is a placeholder.
    - The KMS logs principal is hardcoded to ap-south-1 (`kms.tf:53`).
    - The self-signed cert's private key lands in local state.
11. **The plan JSON embeds provider credentials** as `constant_value` (mock here). Any real static creds would flow into the checksummed evidence bundle.
12. **Personal data is in IaC.** The personal Entra tenant domain appears in 4 files, and personnel.json holds 24 named people, including the author's own name. This is PII-adjacent, not a secret.
13. **Two more doc/code contradictions** (both corroborate C-inventory's handoff):
    - `aws-organization/README.md:10-13` says the layer does NOT create OUs or attach SCPs, but `main.tf:1-9` calls both modules and attaches 3 SCPs.
    - `entra-id/modules/output/` is matched by the root `.gitignore:39` (`output/`). Its single whitespace file is still tracked, and `entra-id/main.tf:28-30` depends on it, so the module block must go first if the dir is removed.

_Export provenance: `git archive HEAD` taken while HEAD = `53b0532` (verified: HEAD, main, origin/main and plan/restore-2026 all = 53b0532 at the time of research). C-inventory reports a later local switch to `plan/restore-2026`@b3169ec (docs only); that is not reflected here._
