# ADR-0013: Plan-only CI does not assume the real AWS OIDC role

- **Status:** Proposed
- **Date:** 2026-09-28
- **Deciders:** Ayush (owner)

## Context and problem statement

Every CI plan job logs in to a **real** AWS account through GitHub OIDC, even though nothing real is planned or applied. The role is `arn:aws:iam::982081090103:role/github-actions-oidc-role`. Here is where it and its token permission appear:

| Where | What |
|---|---|
| `.github/workflows/test.yml:16`, `:41` | role ARN as workflow env, and as input to the reusable workflow |
| `.github/actions/plan/action.yml:23-27` | `aws-actions/configure-aws-credentials@v4` (tag-only pin) in **every** plan job |
| `.github/workflows/terraform-workflow.yml:140-145` | the apply job assumes the role, then only echoes a result (`run-apply.sh:24-27`) |
| `.github/workflows/drift-detection.yml:27-31` | the nightly drift job (now disabled, ADR-0008) |
| `test.yml:19-21`, `terraform-workflow.yml:45-47`, `drift-detection.yml:8-10` | `id-token: write` granted workflow-wide, including the `validate-scripts` job |

Run #68 shows that "Configure AWS credentials" succeeded in the plan, apply and regression jobs, with a session token present. **The role is real and assumable from this repository.** And because `test.yml` runs on every push to any branch (`test.yml:3-5`), every push mints a token for it.

What the credentials are used for today:

- **ayka-portal: nothing.** Static mock keys in the provider (`ayka-portal/provider.tf:19-20`) take precedence over environment credentials.
- **control-validation-scenarios: only to satisfy the provider's credential lookup.** Its provider has `skip_*` flags but no keys (`control-validation-scenarios/provider.tf:12-21`). Offline, the plan fails with `No valid credential sources found`. With `AWS_ACCESS_KEY_ID=mock AWS_SECRET_ACCESS_KEY=mock` in the environment it plans the same 6 resources ([research/terraform.md](../research/terraform.md) §6). The real credentials are never needed.

What is *not* known:

- No Terraform in the repository or its history creates the GitHub OIDC provider or this role. The account 982081090103 is not one of the landing-zone accounts (`enterprise_strict.tfvars:5-7`).
- So the role's trust policy (which repositories and branches may assume it) and its permissions are **UNVERIFIED**. Only you can inspect them in AWS.

> **Why this matters to you:** an AWS account ID is not a secret. But an account ID plus an OIDC role whose trust policy doesn't pin the `sub` claim to your repository and branch is a known attack path: someone else's GitHub workflow could assume your role. You don't need to guess whether that is the case here. Just stop depending on the role for work that doesn't need it.

## Decision drivers

- Least privilege: a plan against a mock provider needs **no** cloud identity.
- Both workloads must still plan in CI, and offline on your laptop.
- Keep the fix inside the repository, plus one clear AWS-side checklist for you.
- Don't break the later sandbox path (ADR-0010).

## Considered options

1. Keep the OIDC step as it is.
2. Remove the OIDC step and `id-token: write` from the plan-only workflows. Give **both** workloads mock credentials through the environment of the plan step.
3. Keep OIDC, but restrict the role's trust policy to `repo:Ayush-cloud06/Ayka-Secure-Technologies-GmbH:ref:refs/heads/main` and attach a read-only policy.
4. Remove OIDC and add static mock keys to `control-validation-scenarios/provider.tf`, like ayka-portal.

## Decision outcome

Chosen option: 2. It removes the real identity from CI entirely and keeps both plans working with one mechanism.

In the repository (Phase 1 for the role, Phase 4 for the YAML):

- **Delete the OIDC steps** in:
  - `plan/action.yml:23-27`;
  - the apply job (`terraform-workflow.yml:140-145`);
  - the drift workflow (`drift-detection.yml:27-31`).
- **Delete the `aws_role_arn` inputs** and `AWS_ROLE_ARN` (`test.yml:16,41`).
- **Drop `id-token: write`** from all three workflows.
- **Set mock credentials in the plan step's `env:`** for both workloads: `AWS_ACCESS_KEY_ID: mock`, `AWS_SECRET_ACCESS_KEY: mock`, `AWS_EC2_METADATA_DISABLED: "true"`.
  - Option 4 is an acceptable fallback if you prefer the provider file to be self-contained.
  - Optional: then remove the static keys from `ayka-portal/provider.tf:19-20` too. Credentials set in the provider block are copied into the plan JSON ([research/terraform.md](../research/terraform.md) §4) and so into the evidence bundle. Environment credentials are not.

In AWS (you, outside the repository):

1. Inspect the role:
   - `aws iam get-role --role-name github-actions-oidc-role --query Role.AssumeRolePolicyDocument`: is `token.actions.githubusercontent.com:sub` pinned with `StringEquals` to this repository?
   - `aws iam list-attached-role-policies …` and `list-role-policies …`: what can it do?
2. Check CloudTrail for `AssumeRoleWithWebIdentity` on this role, to see who has used it.
3. If nothing else needs it, **delete the role** (and the OIDC provider, if unused). If you keep it for ADR-0010, restrict it as in option 3 and scope it to a GitHub environment with required reviewers.

## Consequences

### Positive

- CI holds no real cloud identity. A compromised workflow or a stray branch push can't touch AWS.
- Plans behave the same in CI and offline, which makes local reproduction simple.
- It matches TRT-008: "prohibit real credentials and apply" (`risk-treatment-plan.md:27`).

### Negative

- Removing the role closes the door on a quick real apply. ADR-0010 re-introduces a narrowly scoped role later, and it must be designed then.
- The AWS-side check is manual work in an account this repository doesn't describe.
- If the role *is* over-permissive, you may find it was assumable by others. Then treat it as an incident: check CloudTrail, and rotate or delete.
- Mock credentials in YAML may trigger naive secret scanners. Use obviously fake values (`mock`) and a comment.

## Pros and cons of the options

### 1. Keep OIDC

- Good: no change.
- Bad: a real identity for fake work, and every push on any branch mints a token.

### 2. Remove OIDC, mock env credentials

- Good: least privilege and one mechanism for both workloads. Mock credentials stay out of the plan JSON.
- Bad: the later sandbox needs a new role design.

### 3. Restrict the trust policy

- Good: keeps a ready path to real AWS.
- Bad: still a real identity in plan-only CI. It depends on AWS-side configuration the repository can't show.

### 4. Static mock keys in the scenarios provider

- Good: self-contained provider files.
- Bad: the keys land in the plan JSON and the evidence bundle.

## Evidence

- `.github/workflows/test.yml:3-5,16,19-21,41`, `.github/actions/plan/action.yml:23-27`, `.github/workflows/terraform-workflow.yml:45-47,140-145`, `.github/workflows/drift-detection.yml:8-10,27-31`
- Run #68 job logs: "Configure AWS credentials" succeeded in plan, apply and regression, with `AWS_SESSION_TOKEN` set ([research/facts-lead.md](../research/facts-lead.md)) — <https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/32621618951>
- `Internal-IT/workloads/ayka-portal/provider.tf:19-20` and `Internal-IT/workloads/control-validation-scenarios/provider.tf:12-21`
- [research/terraform.md](../research/terraform.md) §2 E12–E13 (role not in code; provider credentials override env) and §6 (scenarios plan: fails without credentials, passes with mock env credentials)
- `Internal-IT/platform/foundation/landing-zone/enterprise_strict.tfvars:5-7`: the three landing-zone account IDs, none of which is 982081090103.

## Links

- Related: [ADR-0007](0007-entra-bootstrap-secrets.md), [ADR-0008](0008-drift-manual-only.md), [ADR-0010](0010-mock-plan-only-then-sandbox.md), [ADR-0015](0015-pin-tool-versions.md)
- Phase playbooks: [phase 1 – secrets](../05-phase-playbooks/phase-1-secrets.md), [phase 4](../05-phase-playbooks/phase-4-pipeline-green.md)
