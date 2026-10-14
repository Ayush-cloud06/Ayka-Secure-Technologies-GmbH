# Secure Development Policy

| Field | Value |
|---|---|
| Document ID | POL-SDL-01 |
| Owner | Product & Engineering |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or when the required checks or the pipeline stages change |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Simulated company. The repository holds infrastructure code, policy-as-code and the pipeline. The Ayka Portal application itself is not written: the task definition runs the placeholder image `nginx:stable`.

## 1. Purpose

Makes security part of every step from requirement to release. Insecure infrastructure should fail in the pipeline, not in production, and source code should stay in the hands of the people who need it. Change approval rules are in [POL-CHG-01](change-management-policy.md); this policy covers how code is designed, written, tested and protected.

## 2. Scope

| In scope | Path |
|---|---|
| Terraform | `Internal-IT/` |
| Policy-as-code (Rego, mapping, exceptions) | `Internal-IT/engineering/policy-as-code/` |
| CI scripts and workflows | `Internal-IT/engineering/ci-cd/`, `.github/` |
| Tests | `tests/` |
| Application code | Not written yet |
| Outsourced development | None today; if used, POL-VEN-01 and this policy apply |

## 3. References

| Framework | Requirement |
|---|---|
| ISO/IEC 27001:2022 | A.8.25, A.8.26, A.8.27, A.8.28, A.8.29, A.8.31, A.8.33, A.8.4; A.8.30 (no outsourced development today) |
| SOC 2 | CC8.1, CC7.1, CC5.2, CC6.1, CC6.8 |
| GDPR | Art. 25 (data protection by design), Art. 32 |
| Controls | CM-01 to CM-05, CA-01, CA-02, MO-01, AC-09, AC-14, AC-15, CO-05 in the [control matrix](../SOC2/03-control-matrix.md) |
| Technical documents | [CI/CD architecture](../../Internal-IT/engineering/ci-cd/architecture.md), [policy evaluation flow](../../Internal-IT/engineering/ci-cd/compliance-gates/policy-evaluation-flow.md), [enforcement levels](../../Internal-IT/engineering/ci-cd/compliance-gates/enforcement-levels.md) |
| Related | [POL-CHG-01](change-management-policy.md), [POL-CLD-01](cloud-security-policy.md), [POL-VUL-01](vulnerability-and-patch-management-policy.md), [POL-CRY-01](cryptography-policy.md) |

## 4. Policy statements

### 4.1 Secure development life cycle (A.8.25)

Every change follows these stages. A stage that fails stops the change.

| Stage | What happens | Status | Evidence |
|---|---|---|---|
| Requirement | The pull request states what changes, why, its security impact and the risk or ticket it serves | Designed: [POL-CHG-01 §5](change-management-policy.md#5-rules), rule 5; no template | |
| Script validation | `bash -n` on every CI shell script (`validate-scripts`) | Implemented | [`test.yml`](../../.github/workflows/test.yml); [run 37498007502](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/37498007502) |
| Unit and policy tests | `pytest` on evaluator, wrappers, mapping and governance docs; `opa test` on the Rego rules, failing if no test passes (`unit-tests`) | Implemented | same run |
| Terraform validate | `terraform fmt -check`, `terraform validate`, `tflint` (`compliance / validate`) | Implemented | [`validate/action.yml`](../../.github/actions/validate/action.yml) |
| Plan, scan, decide | Plan with mock credentials; Checkov, tfsec, OPA/conftest; evaluator fails closed; evidence bundle with SHA-256 manifest (`compliance / compliance`) | Implemented | CA-01, CA-02; same run |
| Regression | Insecure scenarios must be rejected with the expected controls (`Control Validation Regression`) | Implemented | MO-01; same run |
| MEDIUM approval | `medium-risk-approval` environment when a MEDIUM finding exists | Partial: required reviewer configured, self-review allowed | [Environment settings](https://api.github.com/repos/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/environments), rechecked 2026-10-14; only maintainer can approve |
| Apply | Checksum and commit check, then a simulated apply behind `manual-apply-approval`, only from `main` | Implemented as simulation; never applied | [`run-apply.sh`](../../Internal-IT/engineering/ci-cd/scripts/run-apply.sh); in run 37498007502 the apply waits at the environment |

### 4.2 Security requirements (A.8.26)

1. For infrastructure, the 38 controls in [`control-mapping.yaml`](../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml) are the baseline security requirements. A new requirement is added there, with a rule, a test and a regression scenario. Status: Implemented.
2. Each application feature defines the following before build, recorded in the pull request or design note:
   - authentication;
   - authorisation (tenant isolation);
   - input validation;
   - logging per [STD-LOG-01 §5](logging-and-monitoring-standard.md#5-requirements);
   - data classification per [POL-DATA-01](data-classification-and-confidentiality-policy.md).

   Status: Planned (no application code).
3. A threat model is written for the application and for each major architecture change. The [threat scenarios catalogue](../ISMS/03-risk-management/threat-scenarios-catalog.md) is the input. Status: Planned for the application.

### 4.3 Secure architecture and engineering principles (A.8.27)

| Principle | How it shows today | Status |
|---|---|---|
| Defence in depth | WAF, then a TLS-only ALB, then private ECS tasks, then private Multi-AZ RDS | Gated design ([`compute/`](../../Internal-IT/workloads/ayka-portal/modules/compute/), [`database/`](../../Internal-IT/workloads/ayka-portal/modules/database/)) |
| Least privilege | Tiered permission sets, permission boundaries, no wildcard actions | Designed ([identity architecture](../architecture/identity-architecture.md)); gate controls Implemented for the workload |
| Fail closed | Missing, empty, malformed or errored scanner output stops the run | Implemented (CA-02) |
| No standing credentials in CI | Plan-only CI holds no cloud credentials | Implemented (AC-14) |
| Everything as code | Infrastructure, rules, exceptions and pipeline live in Git | Implemented for the repository |
| Secure defaults | Encryption, public-access blocks, IMDSv2 in module defaults | Gated design |

### 4.4 Secure coding (A.8.28)

1. Secrets, keys and passwords are never committed ([POL-AC-01 §4.2](access-control-policy.md#42-authentication), item 5). Secrets are generated or held in AWS Secrets Manager ([POL-CRY-01](cryptography-policy.md)). Background: Entra bootstrap passwords were hard-coded until 2026-09-28 (RISK-001).
2. Third-party code is pinned:
   - GitHub Actions by commit SHA;
   - downloaded tools by version and SHA-256;
   - Python test dependencies by exact version in [`tests/requirements.txt`](../../tests/requirements.txt).

   Status: Implemented (AC-14; [`toolchain.versions`](../../Internal-IT/engineering/ci-cd/toolchain.versions)).
3. Code uses maintained libraries and supported language versions. Deprecated tools are replaced on a plan ([POL-VUL-01](vulnerability-and-patch-management-policy.md)).
4. Application code follows the OWASP ASVS level 2 requirements relevant to each feature (version to verify at first use). Status: Planned.
5. Static analysis (SAST) and dependency scanning (SCA) run on every pull request once application code exists. Status: Planned.
6. Automated secret scanning runs on every push. Status: Planned.
   - GitHub secret scanning and push protection are disabled (verified via GitHub API on 2026-10-14).
   - The [CI/CD architecture](../../Internal-IT/engineering/ci-cd/architecture.md) lists secrets scanning as not built.

### 4.5 Security testing in development and acceptance (A.8.29)

1. Changes to the evaluator, wrappers or Rego rules come with tests ([POL-CHG-01 §5](change-management-policy.md#5-rules), rule 7). Status: Implemented (`tests/compliance/`, `opa test` in `unit-tests`).
2. A change that could weaken detection must keep the regression scenarios rejected with the expected controls. Status: Implemented (MO-01).
3. Application acceptance includes DAST against a non-production environment. An external penetration test is done before the first production release and yearly after that. Status: Planned.

### 4.6 Branch protection and review

Settings rechecked via the GitHub API on 2026-10-14; [ruleset 24482491](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/rules/24482491) and [environments API](https://api.github.com/repos/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/environments):

| Setting | Required by policy | Configured | Status |
|---|---|---|---|
| Pull request required for `main` | Yes | Yes (ruleset `protect-main`, active) | Implemented |
| Five required checks: `validate-scripts`, `unit-tests`, `compliance / validate`, `compliance / compliance`, `Control Validation Regression` | Yes | Yes | Implemented |
| Force-push and deletion of `main` blocked | Yes | Yes (`non_fast_forward`, `deletion`) | Implemented |
| At least one approving review by someone other than the author | Yes | No: 0 approvals required; single maintainer | Planned (CM-05) |
| Code-owner review for the gate, CI scripts and `.github/` | Yes | No: [`CODEOWNERS`](../../.github/CODEOWNERS) exists, but the ruleset has `require_code_owner_review: false` | Planned |
| Approval environments block self-review | Yes | No: `prevent_self_review: false` on both environments; no deployment branch policy (apply is limited to `main` by the job condition) | Partial |

### 4.7 Separation of development, test and production (A.8.31)

1. Development, test and production run in separate AWS accounts under the Workloads OU ([POL-CLD-01 §4.4](cloud-security-policy.md#44-account-structure)). Each has its own variables file and state.
2. Production is changed only by the pipeline from `main`. Developers (Tier 2) have no write access to production by default ([POL-AC-01 §4.3](access-control-policy.md#43-authorization)).
3. Production data does not flow to non-production environments (section 4.8).
4. Status: Planned. Only [`envs/dev.tfvars`](../../Internal-IT/workloads/ayka-portal/envs/dev.tfvars) exists, and no member accounts are defined. The repository keeps the synthetic regression scenarios (`Internal-IT/workloads/control-validation-scenarios/`) apart from the workload, and they are planned separately.

### 4.8 Test information (A.8.33)

1. Test and development use synthetic data. Status: Implemented for the [configuration regression scenarios](../../Internal-IT/workloads/control-validation-scenarios/) (CO-05); this is not evidence of an operating application test-data control.
2. Production customer data is never copied to a non-production environment ([POL-DATA-01 §5.2](data-classification-and-confidentiality-policy.md#52-protection), item 4). If a defect can only be reproduced with production data:
   - the CISO approves in writing;
   - the data is masked or reduced first;
   - the test runs inside the production account;
   - the copy is deleted after the test, with a record.
3. Test data that resembles personal data is clearly fictional. The [RoPA](../GDPR/record-of-processing-activities.md) records an open decision on the personnel data in the repository (section 4, item 1).

### 4.9 Access to source code (A.8.4)

1. The repository is public (verified via GitHub API on 2026-10-14). This is allowed because its content is classified Public ([POL-DATA-01 §4](data-classification-and-confidentiality-policy.md#4-classification-levels)). Confidential or Restricted information is never committed.
2. Write access is limited to named accounts with MFA. Status: the source snapshot records one collaborator; MFA coverage has not been independently evidenced. One collaborator (the repository owner, role `admin`), verified 2026-10-14. The collaborator list has never been reviewed (AC-09).
3. Repository collaborators are included in the quarterly access review ([POL-AC-01 §4.6](access-control-policy.md#46-access-reviews)).
4. If application code becomes Confidential, it moves to a private repository with the same pipeline and ruleset.

## 5. Roles

| Activity | Product & Engineering | Cloud Platform Engineering | CISO | Security Operations |
|---|---|---|---|---|
| Define security requirements and threat models | R | C | A | C |
| Maintain pipeline, gate rules and tests | C | R | A | |
| Review pull requests | R | R | | |
| Approve MEDIUM-risk releases and exceptions | | C | A | |
| Repository access review | I | C | A | R |

R responsible, A accountable, C consulted, I informed.

## 6. Exceptions

Exceptions to this policy are approved by the CISO in writing with a reason, compensating control and end date of at most 6 months. Gate findings use [`exceptions.yaml`](../../Internal-IT/engineering/policy-as-code/metadata/exceptions.yaml) and the elevated change path.

## 7. Compliance and monitoring

| Check | Frequency | Evidence |
|---|---|---|
| Required checks passed before merge | Every pull request | Ruleset; run history |
| Ruleset and environment settings unchanged | Quarterly, and on change | Export of `protect-main` and environment settings |
| Pull requests reviewed by someone other than the author | Monthly (compensating, per [POL-CHG-01 §10](change-management-policy.md#10-current-gaps)) | Change sample template in [SOC2-05](../SOC2/05-audit-approach-and-evidence.md#74-change-sample-cm-01-to-cm-05) |
| No secrets committed | Every push once scanning exists | Secret scanning alerts |

## 8. Current gaps

| Gap | Status | Evidence | Tracked in |
|---|---|---|---|
| No independent reviewer; 0 approvals required; self-review allowed in environments | Planned | Ruleset and environment settings (GitHub API, 2026-10-14) | CM-05, RISK-005 |
| Code-owner review not required by the ruleset, although POL-CHG-01 §5 rule 4 says it is | Planned | `require_code_owner_review: false` | Open issue for POL-CHG-01 owner |
| Secret scanning and push protection disabled | Planned | GitHub API, 2026-10-14 | |
| No SAST, SCA, DAST or penetration test (no application code) | Planned | [CI/CD architecture](../../Internal-IT/engineering/ci-cd/architecture.md) | OP-02 |
| Only a `dev` environment; no account separation | Planned | [`envs/`](../../Internal-IT/workloads/ayka-portal/envs/) | |
| No pull request template for security impact | Planned | `.github/` has none | |

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
