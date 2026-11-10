# SIM-SOC2-006: Joiner traced from the personnel source to a permission set and session duration

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-SOC2-006 |
| Authored | 2026-11-10 (real date) |
| Scenario date | 2026-02-09 (start date and Entra identity). The Identity Center step of the same trace is dated 2026-03-19, as in SIM-PPL-001 |
| Participants | EMP-020 (the joiner, SOC Analyst), EMP-012 (requests access), EMP-005 (line manager, approves), EMP-003 (implements the Terraform change), EMP-011 (checks the identity exists) |
| Procedure exercised | [SOC2-03](../../../SOC2/03-control-matrix.md) rows AC-01 and AC-05 as written; the [identity provisioning workflow](../../../../Internal-IT/platform/domains/identity/docs/identity-provisioning-workflow.md); the Terraform under [`Internal-IT/platform/domains/identity/`](../../../../Internal-IT/platform/domains/identity/) |
| Controls | SOC 2 AC-01, AC-05 (CC6.1, CC6.2); ISO/IEC 27001:2022 A.5.16, A.8.2; related AC-03, AC-04, AC-06 |

## How to read the labels

This record mixes a made-up joiner with real files. Each statement carries one label.

| Label | Meaning |
|---|---|
| **OBS** | A real observation: read from the file in this repository on the Authored date. The quoted text is in the file. Nothing was applied or planned for this record |
| **SCN** | Scenario: what the fictional staff did. Taken from [SIM-PPL-001](../people/SIM-PPL-001-joiner-batch.md) where it says so |
| **INF** | Inference from reading the code. Not observed, not tested |

Placeholders `<tenant-domain>` and `<management-account-id>` replace the real tenant domain and AWS account ID that the files contain. Staff are named by employee ID only.

## 1. Personnel source to Entra ID (AC-01)

| Step | Label | What the trace shows |
|---|---|---|
| 1 Roster entry | SCN | EMP-020 starts on 2026-02-09 as SOC Analyst, line manager EMP-005, department Security Operations, security role Standard User, tier 2 |
| 2 Source file the Terraform reads | OBS | `locals_personnel.tf` reads `personnel = jsondecode(file("${path.module}/personnel.json"))`, the copy inside `entra-id/modules/core/`. It is **not** the roster at `organization/personnel.json`. The two differ in structure: the module copy is an object keyed by employee ID with 24 entries and has no `status`, `end_date` or `changes` field; the roster file is a list that carries them. EMP-020's entry in the module copy has `"department": "Security Operations"`, `"security_role": "Standard User"`, `"privileged": false`, `"tier": "tier2"` |
| 3 Normalisation | OBS | `locals_personnel.tf` lowers and hyphenates names: `department_key = lower(replace(p.department, " ", "-"))`, so `security-operations`; `tier_key = lower(p.tier)`, so `tier2` |
| 4 One identity per person | OBS | `users.tf`: `resource "azuread_user" "users" { for_each = local.normalized_personnel ... user_principal_name = "${lower(each.key)}@<tenant-domain>"`. One user per key, so `emp-020@<tenant-domain>`. `force_password_change = true`. A separate admin account is created in `modules/privileged/admin_accounts.tf` only for entries with `privileged = true`; EMP-020 has none, so there is no second identity |
| 5 Groups | OBS | `groups_departments.tf` names `grp-dept-${each.value}`; `group_roles.tf` names `grp-sec-${each.value}`; `groups_tiers.tf` names `grp-tier-${each.value}`. `memberships.tf` adds the user to all three. EMP-020 lands in `grp-dept-security-operations`, `grp-sec-standard-user`, `grp-tier-tier2`. This matches the groups recorded for EMP-020 in SIM-PPL-001 section 3 |
| 6 Initial password | OBS | `users.tf` sets `password = random_password.initial_user.result`. `passwords.tf` declares **one** `random_password "initial_user"`, so every non-admin user starts with the same generated password (it must be changed at first sign-in) |
| 7 Creation | SCN | EMP-003 applies the change on 2026-02-09. The ticket and approvals are in SIM-PPL-001 |

Result for AC-01: the Terraform does create one identity per roster entry and no shared account. That is what the control says. It is not the same as "a person joined": the roster row has to be copied into the module's own JSON file by hand, and the leaver is not represented (section 4).

## 2. Entra ID to Identity Center

| Step | Label | What the trace shows |
|---|---|---|
| 8 Runbook | OBS | The [workflow](../../../../Internal-IT/platform/domains/identity/docs/identity-provisioning-workflow.md) step 1 says to create the user in the Entra console with a UPN of the form `firstname.lastname@aykasecure.com`. Terraform (step 4 above) already created `emp-020@<tenant-domain>`. The two descriptions of how a user comes into existence disagree, and the UPN formats differ |
| 9 App assignment and sync | OBS | The same step 1.3 says to assign the user to the `AWS IAM Identity Center` enterprise application by hand; step 2 waits for the SCIM cycle (every 40 minutes). Nothing in the Terraform assigns the user to that app: `aws_enterprise_app.tf` only reads the existing service principal with a data source. The [identity boundary decision](../../../../Internal-IT/platform/domains/identity/docs/identity-boundary-decision.md) says groups cannot be assigned to the app on the Free licence |
| 10 Scenario | SCN | EMP-011 assigns the user to the app on 2026-03-19 and confirms the user appears in Identity Center |
| 11 Group membership | OBS | Identity Center groups are created by Terraform in `groups.tf` from `local.tier_groups = ["Tier0", "Tier1", "Tier2"]`. They are **not** the Entra groups of step 5 (names differ). `memberships.tf` is a hand-written list of user names per tier. `emp-020@<tenant-domain>` appears in the `Tier2` list. `data "aws_identitystore_user" "users"` looks each name up in the identity store; `aws_identitystore_group_membership "memberships"` adds it to the Identity Center group |
| 12 Race | OBS | The workflow's troubleshooting section says an apply before SCIM has pushed the user fails with `ResourceNotFoundException` |
| 13 Change | SCN | EMP-003 adds the line in a pull request; the five required checks pass; request by EMP-012, approval by EMP-005 (ticket JNR-2026-020), grant date 2026-03-19. The pull request needs no second approver (ruleset requires 0 approvals, SIM-PPL-001 and the SoD TOM) |

Result: the tier of the person lives in **two** places. The Entra `grp-tier-tier2` comes from the module JSON and nothing reads it in AWS. The Identity Center `Tier2` comes from a typed list. A mistake or a delay in one does not show in the other.

## 3. Permission set, role and session duration (AC-05)

| Step | Label | What the trace shows |
|---|---|---|
| 14 Assignment | OBS | `assignments.tf`: `aws_ssoadmin_account_assignment "tier2_workload"` gives group `Tier2` the permission set `Tier2-Workload` on `target_id = var.management_account_id` (value `<management-account-id>` in `terraform.tfvars`). All three tiers (`Tier0`, `Tier1`, `Tier2`) are assigned to this one account. No workload account is assigned |
| 15 Session length of the set | OBS | `permission-sets.tf`: `Tier2-Workload` has `session_duration = "PT8H"`. This is the "8 hours for others" half of AC-05. EMP-020 meets it |
| 16 What the set allows | OBS | Its inline policy allows `sts:AssumeRole` on `arn:aws:iam::*:role/WorkloadOperatorRole` and nothing else |
| 17 The role | OBS | `aws-iam-core/cross-account-roles.tf`: `WorkloadOperatorRole` has `max_session_duration = 3600` and a permissions boundary. Its trust policy (`identity_center_assume_role`) names only the principal `{ type = "Service", identifiers = ["sso.amazonaws.com"] }` |
| 18 Whether the chain works | INF | A person who has signed in through Identity Center holds a role session, which is an AWS principal, not the SSO service. A trust policy that lists only the service principal would then refuse the call. The effective chain has never been run (RISK-003). Not tested here |
| 19 The administrator half of AC-05 | OBS | The control says 1 hour for the platform administrator set. `permission-sets.tf`: `Platform-Admin` has `session_duration = "PT8H"`. The only one-hour set is `Restricted-Admin` in `session-controls.tf` (`session_duration = "PT1H"`), and `assignments.tf` assigns no group to it and gives it no policy. **The code contradicts the control as written** |

Result for AC-05: the standard-user half is met in source; the administrator half is not. Under the Type I rule of SOC2-06 section 2 a control whose Terraform contradicts it fails. AC-05 stays Designed.

## 4. What the trace shows about the other end of the lifecycle

| Observation | Label | Detail |
|---|---|---|
| Leaver still listed | OBS | `memberships.tf` still lists `emp-023@<tenant-domain>` in `Tier2`, and the module JSON still has an EMP-023 entry. SIM-PPL-004 records that a pull request removed the line on 2026-06-01. The repository does not show it: this record is a reading of the file as it is on the Authored date, and the fiction's pull request does not exist |
| Mover not reflected | OBS | The module JSON has EMP-019 in Engineering. SIM-PPL-005 moved EMP-019 to Security Operations on 2026-06-01, and the module file has no field for a change |
| Manual disable and Terraform | INF | `users.tf` sets no `account_enabled`. The provider's default is true (to verify), so a plan after a manual disable in the console would likely show the user re-enabled |
| Attribute for ABAC | OBS | `session-controls.tf` maps Identity Center attributes `AccessTier` (from `enterprise.extension.attribute1`) and `CostCenter`. `users.tf` sets neither. The policy `ABACDepartmentIsolation` keys on `aws:PrincipalTag/Department`, which is not in the mapping. The TOM notes the mapping is "not verified end to end" |
| Admin accounts in Tier 0 | OBS | `admin_accounts.tf` puts `admin-emp-002`, `admin-emp-003`, `admin-emp-013` and `admin-emp-014` in Entra `grp-tier-tier0`. `memberships.tf` has only `admin-emp-002` in Identity Center `Tier0`. Entra "tier 0" and Identity Center "Tier0" are not the same set |

## Findings

Defects in the AC-01 and AC-05 designs and the code behind them:

1. **AC-05 is contradicted by the Terraform.** `Platform-Admin` is 8 hours; the 1 hour set is never assigned. Either the control text changes or `Platform-Admin` becomes `PT1H` and `Restricted-Admin` is deleted.
2. **AC-01 names "the personnel source" but the Terraform reads a copy.** Two JSON files with different structures exist. A joiner or leaver added to one is invisible in the other. One source with a build step or a check that the two agree is needed.
3. **The runbook and the Terraform describe two different joiner paths** (console user creation with a company UPN versus Terraform user creation with `emp-nnn`), and the runbook cites a path that does not exist (`Internal-IT/iam/entra-id/modules/core/personnel.json`).
4. **Tier is kept twice** (Entra tier groups from JSON, Identity Center tier lists typed by hand), so "tier" is not one fact. This is RISK-004 in code.
5. **The app assignment is a manual console step** that no record captures. AC-01 does not cover it.
6. **No leaver or mover field in the Terraform source.** The module copy cannot say a person left or moved.
7. **One shared initial password** for every ordinary user. It is forced to change, but the value sits in state.
8. **All tiers are assigned to the management account.** A Tier 2 operator's permission set points at the account that should hold no workload.
9. **The ABAC attribute mapping does not contain the attribute the policy needs.** The `Department` tag would be empty.
10. **The SoD and identity TOMs say "8 h standard, 1 h high-privilege" as a design**; the code does not match for the high-privilege half. The TOM does not note it.

## What this does not show

- That anyone joined, that a ticket, approval or application exists, or that EMP-020 holds any account. All people and dates are scenario values.
- That the Terraform works. It was read, not planned or applied for this record, and has never been applied to any tenant or account.
- That statements marked INF are true. They are readings and are labelled so.
- Every OBS line rests on the files on the Authored date (2026-11-10), not on the files as they were on 2026-02-09. The fiction's later changes (SIM-PPL-004, SIM-PPL-005) are not in the repository.
- A tabletop is not an instance for a SOC 2 test. AC-01 and AC-05 would still fail or be untestable in a Type I (SOC2-06).
