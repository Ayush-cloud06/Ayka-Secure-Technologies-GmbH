# Change management procedure

| Field | Value |
|---|---|
| Document ID | ISMS-OPS-03 |
| Owner | Cloud Platform Engineering |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or pipeline or approval model change |
| Status | Draft. Not approved: no approval record exists (simulated company) |

Ayka Secure Technologies GmbH is a simulated company; this document does not establish a performed activity.

## 1. Scope and current implementation

Apply to infrastructure, policy-as-code, CI tooling, application source and controlled governance documents under [POL-CHG-01](../../policies/change-management-policy.md). The [PR workflow](../../../.github/workflows/test.yml) and [compliance workflow](../../../.github/workflows/terraform-workflow.yml) implement plan/scanner/test execution for the selected workload. The default is `Internal-IT/workloads/ayka-portal`; platform roots are not thereby scanned.

The apply stage is a [simulation](../../../Internal-IT/engineering/ci-cd/scripts/run-apply.sh), not infrastructure execution. PR/check protection and a required reviewer for `manual-apply-approval` are recorded in the 2026-10-05 [risk-register update](../03-risk-management/risk-register.md). Independent approval remains **Partial** because there is one maintainer; do not equate an environment pause with a second person's authorization. Verify current settings at each formal review.

## 2. Prepare and classify

The author records purpose, affected assets/controls, risk/treatment IDs, security/privacy/Region impact, test plan, rollout dependencies and rollback limits in the PR. Compare the requested change with the current [SoA](../04-controls-and-soa/statement-of-applicability.md). For policy/document changes, follow [document control](../00-context-and-governance/document-control-procedure.md) as well.

| Class | Required handling |
|---|---|
| Standard | Ordinary reviewed PR, green required checks, independent reviewer requested |
| Elevated | Identity, SCP, gate logic, mappings, exceptions or MEDIUM finding: CISO review and required elevated approval per policy; do not infer that a path change automatically selects the environment |
| Pre-approved version change | Pin-only update follows policy but still needs checks and review; scanner/rule behavior changes require regression analysis |
| Emergency | Link incident, authorizing decision and urgency; preserve checks and evidence, and arrange independent retrospective review within two business days |

A HIGH decision requires remediation or a separately approved, scoped, expiring exception; it is not an ordinary manual override. The workflow selects `medium-risk-approval` from evaluator output, not from every sensitive path in this table. Human review must cover that gap until automated routing is designed and approved.

## 3. Validate and review

1. Keep the source commit fixed for evidence generation. Run relevant unit/policy tests, Terraform formatting/validation and the offline plan/scanner chain for affected supported workloads. The [local chain](../../../Internal-IT/engineering/ci-cd/scripts/run-local-chain.sh) uses mock credentials and refresh off; it replaces local `output/` and `evidence/`, so retain a needed previous bundle first.
2. Read scanner outputs and the decision together. An execution error, absent output or incomplete scan blocks progression. Treat expected failing regression fixtures separately from the workload result.
3. Inspect the [control mapping](../../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml) and [exceptions](../../../Internal-IT/engineering/policy-as-code/metadata/exceptions.yaml). Record every suppression's rule/resource, reason, owner, expiry and approval. Do not lower a severity to obtain a passing decision.
4. Reviewer checks security impact, scope, tests, safe rollback and evidence for the exact revision. Re-run affected checks after changes; earlier approval does not prove the new revision was reviewed. Follow [CODEOWNERS](../../../.github/CODEOWNERS) for relevant paths.
5. Record any independence conflict. A self-reviewed repository change may exist in this case study, but must be labelled as such and cannot be cited as independent control operation. Future live release requires a separately authorized reviewer.

## 4. Merge, verify and recover

Retain PR, source SHA, run URL, scanner versions, decision, manifest/checksums and review record. The simulated apply verifies required files and the source SHA; it creates no resources. Do not add real cloud credentials or use this procedure to authorize live apply. RISK-002, RISK-005 and RISK-012 in the [treatment plan](../03-risk-management/risk-treatment-plan.md) define prerequisites for that separate transition.

If a repository change regresses behavior, prepare a revert PR and rerun checks. Explain when reverting source cannot undo data/state changes; future live migrations require a tested restore plan. Cloud Platform Engineering verifies the repaired result, and Compliance & Risk Management samples changes under the [audit plan](../09-internal-audit/audit-plan.md). Preserve evidence under the [retention policy](../../policies/records-and-data-retention-policy.md). ISO/IEC 27001:2022 A.8.9, A.8.25, A.8.29 and A.8.32.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
