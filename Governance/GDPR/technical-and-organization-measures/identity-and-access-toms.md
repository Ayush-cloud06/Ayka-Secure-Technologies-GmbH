# Technical and Organizational Measures (TOMs): Identity & Access

- **Organization:** Ayka Secure Technologies GmbH (simulated case study)
- **Framework:** GDPR Art. 25 (data protection by design), Art. 32 (security of processing)
- **System scope:** Microsoft Entra ID, AWS IAM Identity Center, AWS IAM
- **Version:** 2.0 (replaces the 2026-03-15 version, which described design as if it were deployed)
- **Last updated:** 2026-10-05
- **Status:** Draft. Not approved: no approval record exists.

## 1. How to read this document

Each measure carries the weakest true label, using the yardstick in the [repository README](../../../README.md#2-yardstick-capability-status):

- **Implemented**: runs in CI, and a run or test shows it working.
- **Simulated**: runs, but its effect is faked on purpose and labelled.
- **Planned (design-only)**: written as Terraform or text that validates locally but is not deployed and not scanned by the compliance gate.

None of the identity Terraform under `Internal-IT/platform/domains/identity/` has been applied. No tenant, AWS account or personal-data processing system exists. A "Planned" measure therefore protects no personal data today.

## 2. Authentication

| Measure | Status | Evidence | Gap |
|---|---|---|---|
| One identity provider (Entra ID) federating into AWS IAM Identity Center | Planned (design-only) | [`entra-id/aws_enterprise_app.tf`](../../../Internal-IT/platform/domains/identity/entra-id/aws_enterprise_app.tf), [`aws-identity-center/`](../../../Internal-IT/platform/domains/identity/aws-identity-center/) | Not deployed; SAML/SCIM wiring is described in [`scim.md`](../../../Internal-IT/platform/domains/identity/docs/scim.md) as manual console steps |
| MFA required for Tier 0 group members on all cloud apps | Planned (design-only) | [`ca-tier0-mfa.tf`](../../../Internal-IT/platform/domains/identity/entra-id/modules/security/conditional_access/ca-tier0-mfa.tf) (`built_in_controls = ["mfa"]`) | Only Tier 0, not all users. Generic MFA, not phishing-resistant (no authentication-strength policy). Off by default: `enable_conditional_access` defaults to `false` in [`entra-id/variables.tf`](../../../Internal-IT/platform/domains/identity/entra-id/variables.tf). Conditional Access needs Entra ID P1; the lab tenant is on the Free plan ([`identity-boundary-decision.md`](../../../Internal-IT/platform/domains/identity/docs/identity-boundary-decision.md)) |
| Legacy authentication blocked for all users | Planned (design-only) | [`ca-block-legacy-auth.tf`](../../../Internal-IT/platform/domains/identity/entra-id/modules/security/conditional_access/ca-block-legacy-auth.tf) | Same toggle; off by default |
| No AWS IAM users in scanned workloads | Implemented (mapped, not exercised) | Control `IAM_USER_PROHIBITED` in [`control-mapping.yaml`](../../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml); the gate scans every PR | Gated workloads only, not the identity roots. No negative scenario in [`expected-controls.txt`](../../../Internal-IT/workloads/control-validation-scenarios/expected-controls.txt) triggers it, so it has never been seen to fire |
| Sign-in risk evaluation (Identity Protection) | Not designed | None in source | Requires Entra ID P2; no policy written |
| Session limits: 8 h standard, 1 h high-privilege | Planned (design-only) | [`permission-sets.tf`](../../../Internal-IT/platform/domains/identity/aws-identity-center/permission-sets.tf), [`session-controls.tf`](../../../Internal-IT/platform/domains/identity/aws-identity-center/session-controls.tf) | Not deployed |

## 3. Authorization

| Measure | Status | Evidence | Gap |
|---|---|---|---|
| Attribute-based access: principal `Department` tag must match resource `Department` tag | Planned (design-only) | `ABACDepartmentIsolation` in [`abac-custom-policies.tf`](../../../Internal-IT/platform/domains/identity/aws-iam-core/abac-custom-policies.tf) | Effective permissions never simulated (RISK-003, TRT-003). The `Department` session tag depends on an attribute mapping that is not verified end to end |
| Resource creation denied without `Department`, `Environment`, `Owner` tags | Planned (design-only) | `ABACMandatoryTags` in the same file | Not deployed |
| Permissions boundary for workload roles | Planned (design-only) | [`permissions-boundaries.tf`](../../../Internal-IT/platform/domains/identity/aws-iam-core/permissions-boundaries.tf) | Not deployed; not tested |
| No wildcard or inline IAM policies in scanned workloads | Implemented (mapped, not exercised) | Controls `IAM_WILDCARD_POLICY`, `IAM_INLINE_POLICY_USAGE` in [`control-mapping.yaml`](../../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml) | Gated workloads only; no negative scenario triggers them. The ABAC policy itself uses service wildcards (`ec2:*`, `s3:*`) and is not scanned |
| Access changes go through version-controlled Terraform | Implemented for the repository | Git history; CODEOWNERS on [`.github/CODEOWNERS`](../../../.github/CODEOWNERS) | Branch protection is not configured (README D7, RISK-005), so review is not enforced |

## 4. Identity lifecycle (joiner, mover, leaver)

| Measure | Status | Evidence | Gap |
|---|---|---|---|
| Users, departments and tier groups generated from one personnel file | Planned (design-only) | [`personnel.json`](../../../Internal-IT/platform/domains/identity/entra-id/modules/core/personnel.json), [`users.tf`](../../../Internal-IT/platform/domains/identity/entra-id/modules/core/users.tf) | The file is itself personal data (see [Section 6](#6-personal-data-held-in-the-repository)) |
| Automatic deprovisioning from Entra ID to AWS via SCIM | Planned (text only) | [`scim.md`](../../../Internal-IT/platform/domains/identity/docs/scim.md), [`identity-provisioning-workflow.md`](../../../Internal-IT/platform/domains/identity/docs/identity-provisioning-workflow.md) | No HR system integration, no SCIM configuration in Terraform, no leaver test (RISK-004, TRT-004) |
| Just-in-time production access via Entra PIM | Not designed | None in source | No PIM resources exist; PIM needs Entra ID P2 |

## 5. Emergency access

| Measure | Status | Evidence | Gap |
|---|---|---|---|
| Break-glass procedure SOP-IAM-001 | Planned (text only) | [`break-glass-procedure.md`](../../../Internal-IT/platform/domains/identity/docs/break-glass-procedure.md), [`break-glass-role.tf`](../../../Internal-IT/platform/domains/identity/aws-iam-core/break-glass-role.tf) | Never exercised; competing emergency paths exist (RISK-013, TRT-013). Entra break-glass account is managed manually, outside Terraform, since 2026-09-28 |

## 6. Personal data held in the repository

`personnel.json` lists names, roles, departments, managers and start dates for the case-study staff. At least one entry is a real person (the repository owner). This is processing of employee personal data by the repository itself, and is recorded in the Record of Processing Activities (planned, slice G-04).

## 7. Region

The target Region for all personal data is **`eu-central-1` (Frankfurt)**. The identity and workload Terraform currently uses `ap-south-1`, for example [`scim.md`](../../../Internal-IT/platform/domains/identity/docs/scim.md) and [`ayka-portal/envs/dev.tfvars`](../../../Internal-IT/workloads/ayka-portal/envs/dev.tfvars). Until that is migrated, any statement that personal data stays in the EU is unsupported (RISK-011, TRT-011).

## 8. Evidence that can actually be produced today

- The compliance gate's CI runs and their `compliance-evidence` artifact, for the Implemented rows ([first honest-green run](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/36444940223)).
- The Terraform source linked above, for the Planned rows: it shows design, not operation.

Not available: Conditional Access exports, sign-in logs, SCIM provisioning logs, Terraform state of a real deployment. These would require a deployed tenant and account.
