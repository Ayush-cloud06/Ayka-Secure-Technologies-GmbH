# Change Management Policy

| Field | Value |
|---|---|
| Document ID | POL-CHG-01 |
| Classification | Internal |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval |
| Status | Draft. Not approved |

## 1. Purpose

Every change to the production system is authorised, tested, approved and traceable, and no single person can put a change into production unseen. Most of this policy is already enforced by the repository's pipeline; this document states the rules the pipeline implements and the ones it cannot.

## 2. Scope

Changes to: infrastructure (Terraform under `Internal-IT/`), the pipeline (`.github/`, `Internal-IT/engineering/ci-cd/`), the policy-as-code rules, mapping and exceptions (`Internal-IT/engineering/policy-as-code/`), the application, and the governance documents in `Governance/`. Customer content changes made by customers are out of scope.

## 3. References

| Framework | Requirement |
|---|---|
| SOC 2 | CC8.1, CC7.1, CC5.1, CC5.2 |
| ISO/IEC 27001:2022 | A.8.9, A.8.25, A.8.29, A.8.32, A.5.3 |
| Controls | CM-01 to CM-06, CA-01, CA-02, MO-01, AC-09, AC-14 |
| Technical documents | [Policy evaluation flow](../../../Internal-IT/engineering/ci-cd/compliance-gates/policy-evaluation-flow.md), [enforcement levels](../../../Internal-IT/engineering/ci-cd/compliance-gates/enforcement-levels.md), [CI/CD architecture](../../../Internal-IT/engineering/ci-cd/architecture.md) |

## 4. Change types

| Type | Definition | Approval |
|---|---|---|
| Standard | Any change through a pull request whose gate decision is `pass` | One reviewer other than the author |
| Elevated | A change whose gate decision is `approval_required` (any MEDIUM finding), or that touches identity, the gate itself or an SCP | Reviewer other than the author, plus approval in the `medium-risk-approval` environment by the CISO or a delegate |
| Emergency | A change needed to restore service or contain an incident that cannot wait for normal review | See section 6 |
| Pre-approved | Dependency or tool version bumps that only change pins in `toolchain.versions` and the workflow, with all checks green | One reviewer; may be merged without the elevated path |

A gate decision of `fail` (any HIGH finding) cannot be approved. The finding must be fixed, or accepted through an exception (section 7).

## 5. Rules

1. **Everything through a pull request.** Direct pushes, force-pushes and branch deletion on `main` are blocked by the ruleset `protect-main`.
2. **Required checks.** A pull request merges only when the five required checks pass: script validation (`validate-scripts`), unit and policy tests (`unit-tests`), Terraform validate, the plan with scans and decision (the two jobs of the compliance workflow), and the control-validation regression.
3. **Severity decides the path.** The control's severity in [`control-mapping.yaml`](../../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml) applies, not the scanner's. Unmapped findings count as at least MEDIUM. Lowering a severity to get a green build is not allowed; it is an exception (section 7).
4. **Segregation of duties.** The author of a change does not approve it in the pull request or in an approval environment. `CODEOWNERS` review is required for the gate, the CI scripts and `.github/`.
5. **Traceability.** Each pull request states what changes and why, links the risk or ticket it serves, and its evidence bundle is kept per [SOC2-05](../05-audit-approach-and-evidence.md#6-evidence-sources-and-retention).
6. **Integrity to apply.** The apply job verifies the evidence checksums and that the bundle belongs to the commit being applied. Nothing is applied from a workstation.
7. **Testing.** Changes to the evaluator, wrappers or Rego rules come with tests. Changes that could weaken detection must keep the regression scenarios failing with the expected controls.
8. **Rollback.** Every infrastructure change is reversible by reverting the pull request, unless the description states why not (for example, a data migration) and how recovery would work.
9. **Configuration is code.** Manual changes in the AWS console are not allowed outside break-glass. Any drift found is either codified through a pull request or reverted.

## 6. Emergency changes

1. The Incident Commander (see the [Incident Response Plan](incident-response-plan.md)) declares the emergency in the incident record.
2. The change still goes through a pull request and all scans run. Only the wait for a second reviewer may be skipped; the CISO or Managing Director may approve by phone and the approval is noted in the pull request.
3. A HIGH finding still blocks. If a HIGH-rated configuration is the only way to restore service, the CISO records a time-limited exception of at most 7 days.
4. Within 2 business days a reviewer other than the author reviews the merged change, and the review is linked from the incident record.

## 7. Exceptions

A finding that will not be fixed is recorded in [`exceptions.yaml`](../../../Internal-IT/engineering/policy-as-code/metadata/exceptions.yaml) with the exact rule, the resource, the reason, an owner and an expiry date of no more than 12 months. The entry is itself a change to the gate and follows the elevated path. Expired entries stop matching automatically.

## 8. Roles

| Activity | Author | Reviewer | Code owner | CISO |
|---|---|---|---|---|
| Open pull request with description and tests | R | | | |
| Review and approve | | R | R for gate paths | |
| Approve elevated change | | | | A |
| Approve emergency change and retrospective review | | R | | A |
| Approve exceptions | C | | R | A |

## 9. Compliance and monitoring

Each quarter, Compliance and Risk compares the list of merged pull requests with approvals to confirm that no author approved their own change and that every emergency change has a retrospective review. Findings go to the quarterly management report.

## 10. Current gaps

The repository has one maintainer, so the ruleset requires 0 approvals and the approval environments allow self-review (CM-05 Planned). Until a second maintainer exists, the compensating control is a monthly review of all merged changes by the Managing Director, recorded on the change sample template in SOC2-05.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-06 | First issue |
