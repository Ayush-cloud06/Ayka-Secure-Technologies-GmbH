# Segregation of Duties (SoD)

- **Organization:** Ayka Secure Technologies GmbH (simulated case study)
- **Framework:** GDPR Art. 32(1)(b), Art. 25; ISO/IEC 27001:2022 A.5.3 (segregation of duties), A.8.2 (privileged access rights)
- **System scope:** Change pipeline (GitHub), AWS and Entra ID identity design
- **Version:** 2.0 (replaces the 2026-03-15 version, which described design as if it were deployed)
- **Last updated:** 2026-10-05
- **Status:** Draft. Not approved: no approval record exists.

Labels follow the [repository README yardstick](../../../README.md#2-yardstick-capability-status): Implemented, Simulated, Planned (design-only), Not designed.

## 1. Objective

No single person should be able to change infrastructure, read personal data and alter the records of what they did, without a second person or an automated control noticing.

The simulated company has fictional staff with separate roles ([`organization/personnel-register.md`](../../../organization/personnel-register.md)), but the repository has one real maintainer, who writes, reviews and merges every change. Real segregation is therefore impossible today; this document defines the intended split and records which parts the repository can already enforce.

## 2. Change pipeline

This is the only area with working controls.

| Measure | Status | Evidence | Gap |
|---|---|---|---|
| Every Terraform change is scanned (Checkov, tfsec, OPA) and a fail-closed evaluator decides pass, approval or fail | Implemented | [`test.yml`](../../../.github/workflows/test.yml), [`terraform-workflow.yml`](../../../.github/workflows/terraform-workflow.yml), [first honest-green run](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/36444940223) | Scans the two workloads only, not `Internal-IT/platform/` |
| A finding can only be set aside with a written reason, owner and expiry | Implemented | [`exceptions.yaml`](../../../Internal-IT/engineering/policy-as-code/metadata/exceptions.yaml) | Same person writes and approves exceptions |
| Changes to the gate (mapping, exceptions, evaluator, workflows) need the code owner's review | Partly implemented | [`.github/CODEOWNERS`](../../../.github/CODEOWNERS) | CODEOWNERS only blocks merges when branch protection requires it; branch protection is not configured (README D7, RISK-005) |
| Peer review of every pull request before merge | Not configured | None | Needs a GitHub ruleset and a second person (TRT-005) |
| MEDIUM findings wait for a human approval before apply | Simulated | `medium-risk-approval` and `manual-apply-approval` environments in [`terraform-workflow.yml`](../../../.github/workflows/terraform-workflow.yml) | The environments have no required reviewers, so the job does not actually wait. The apply itself is simulated |

## 3. Privilege tiers (design)

All rows are **Planned (design-only)**: the Terraform under [`Internal-IT/platform/domains/identity/`](../../../Internal-IT/platform/domains/identity/) has never been applied.

| Tier | Intended holders | Permission set (source) | Intended access to personal data |
|---|---|---|---|
| Tier 0 | Cloud platform administrators | `Platform-Admin` in [`permission-sets.tf`](../../../Internal-IT/platform/domains/identity/aws-identity-center/permission-sets.tf) | None by intent. Not technically prevented: the permission set may assume `BreakGlassRole` (`AdministratorAccess`, [`break-glass-role.tf`](../../../Internal-IT/platform/domains/identity/aws-iam-core/break-glass-role.tf)) in any account, and no SCP restricts data access ([`scp/`](../../../Internal-IT/platform/foundation/aws-organization/modules/scp/)) |
| Tier 1 | Security operations | `Tier1-Ops` | Read access to security logs only |
| Tier 2 | Workload operators and developers | `Tier2-Workload` | Limited by the `Department` ABAC tag ([`abac-custom-policies.tf`](../../../Internal-IT/platform/domains/identity/aws-iam-core/abac-custom-policies.tf)) |

Known design gaps: effective permissions of these tiers have never been simulated (RISK-003, TRT-003), and Entra and Identity Center disagree on who owns group membership ([`identity-boundary-decision.md`](../../../Internal-IT/platform/domains/identity/docs/identity-boundary-decision.md), RISK-004).

## 4. Production access

| Measure | Status | Gap |
|---|---|---|
| No standing developer access to production data | Not designed | No production account or data exists; no assignment rule separates environments |
| Just-in-time access via Entra PIM with approver | Not designed | No PIM resources; PIM needs Entra ID P2, the lab tenant is Free |

## 5. Emergency access

Break-glass use bypasses SoD by design. The procedure is [SOP-IAM-001](../../../Internal-IT/platform/domains/identity/docs/break-glass-procedure.md), with the AWS role in [`break-glass-role.tf`](../../../Internal-IT/platform/domains/identity/aws-iam-core/break-glass-role.tf). Status: **Planned (text only)**. It has never been exercised, and no alert on its use exists in source (RISK-013, TRT-013).

## 6. What would make SoD real

In order:

1. A second person with merge rights, and branch protection that requires their review and the gate's status checks (TRT-005).
2. Required reviewers on the two approval environments, excluding the author.
3. Exceptions approved by someone other than the author.
4. A deployed identity design with simulated effective permissions per tier (TRT-003) before any personal data is stored.
