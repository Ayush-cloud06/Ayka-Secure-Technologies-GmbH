# Control gap analysis

| Field | Value |
|---|---|
| Document ID | ISMS-GAP-01 |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or scope, risk, supplier or architecture change |
| Status | Draft. Not approved: no approval record exists (simulated company) |

Ayka Secure Technologies GmbH is simulated. This analysis describes repository evidence and proposed treatments as of 2026-10-14; it does not record completed control operation.

## 1. What the gate can establish

The [SoA](statement-of-applicability.md) selects 93 Annex A controls. The [gate metadata](../../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml) contains 38 internal control IDs referencing 16 distinct Annex A IDs. The other 77 IDs have no explicit gate metadata mapping. This is a traceability count, not a measure of compliance: code checks cannot evaluate employee agreements, actual incident handling, supplier contracts or management decisions.

The [workflow](../../../.github/workflows/terraform-workflow.yml) validates and scans the `ayka-portal` workload plan and source, evaluates findings and writes evidence. See the [S3 control chain](control-chain-s3-encryption.md) for a dated test/run example. A finding can be absent because a resource is absent, excluded, unrecognized or outside scanner scope. A pass therefore does not establish every mapped control. Review resource coverage, scanner completion, exceptions and decision details in the evidence bundle.

`Internal-IT/platform/` is outside the workload compliance gate. The [identity mapping](iam-iso27001-mapping.md) is source design, not validated federation. Workload plans use mock credentials and refresh disabled; apply is simulated. No runtime logs, restore exercise or effective-permissions verification is established by these artifacts. The [risk register](../03-risk-management/risk-register.md) records these limits as RISK-003, RISK-006, RISK-007, RISK-008 and RISK-012.

## 2. Explicit metadata coverage and limits

The IDs below reproduce repository metadata relationships, including coarse relationships that need owner review. They do not assert that all relationships are equally strong. In particular, public-access/ACL checks are not cryptographic proof; unused security groups are not access-review or logging evidence; rule descriptions are not operating procedures; Terraform IAM-user findings do not verify a real MFA challenge.

| Annex A ID | Gate control IDs | Evidence limitation |
|---|---|---|
| A.5.9 | `EC2_MISSING_TAGS` | EC2 tags do not inventory every asset or assign a real custodian. |
| A.5.15 | `SECURITY_GROUP_UNUSED` | Unused-group hygiene is not an access control system. |
| A.5.17 | `IAM_USER_PROHIBITED`, `SECRETS_MANAGER_ROTATION_DISABLED` | User prohibition and rotation configuration do not prove credential custody or actual rotation. |
| A.5.30 | `S3_VERSIONING_DISABLED`, `EC2_PROD_UNDERSIZED_INSTANCE`, `EC2_PROD_SPOT_USAGE`, `S3_REPLICATION_DISABLED` | Sizing, versioning and replication do not establish tested recovery readiness. |
| A.5.37 | `EC2_SECURITY_GROUP_RULE_DESCRIPTION` | Security-group descriptions do not document complete operating procedures. |
| A.8.2 | `IAM_WILDCARD_POLICY`, `IAM_INLINE_POLICY_USAGE`, `IAM_USER_PROHIBITED`, `SECRETS_MANAGER_ROTATION_DISABLED` | Policy pattern checks do not establish least privilege or approval. |
| A.8.3 | `IAM_WILDCARD_POLICY` | Wildcard detection does not calculate effective access or ABAC. |
| A.8.5 | `IAM_USER_MFA_MISSING` | Any IAM user is flagged because plan data cannot prove MFA; federated MFA remains untested. |
| A.8.9 | `EC2_MISSING_IMDSV2` | IMDSv2 configuration is one configuration requirement, not live drift control. |
| A.8.12 | `S3_PUBLIC_ACCESS`, `S3_ACLS_DISABLED` | Public S3 and ACL settings cover only selected leakage paths. |
| A.8.13 | `S3_VERSIONING_DISABLED`, `S3_REPLICATION_DISABLED`, `S3_LIFECYCLE_DISABLED` | Versioning, replication and lifecycle configuration do not prove recoverable backups. |
| A.8.15 | `S3_LOGGING_DISABLED`, `VPC_FLOW_LOGS_MISSING`, `CLOUDWATCH_LOG_GROUP_KMS_ENCRYPTION`, `SECURITY_GROUP_UNUSED`, `S3_NOTIFICATIONS_DISABLED`, `WAF_LOGGING_DISABLED` | Log configuration does not prove delivery, completeness or retained event integrity. |
| A.8.16 | `S3_LOGGING_DISABLED`, `VPC_FLOW_LOGS_MISSING`, `CLOUDWATCH_LOG_GROUP_KMS_ENCRYPTION`, `S3_NOTIFICATIONS_DISABLED`, `WAF_LOGGING_DISABLED` | Log settings and notifications do not establish detection, triage or response. |
| A.8.20 | `EC2_OPEN_SSH`, `EC2_MISSING_IMDSV2`, `EC2_HTTP_OPEN`, `EC2_PUBLIC_EGRESS`, `ALB_WAF_PROTECTION_REQUIRED`, `ALB_TLS_ENFORCEMENT`, `VPC_DEFAULT_PROHIBITED`, `ROUTE_TABLE_PUBLIC_IGW`, `NETWORK_ACL_UNRESTRICTED_INGRESS`, `WAF_LOG4J_PROTECTION` | Network patterns do not prove effective connectivity or application-layer protection. |
| A.8.21 | `EC2_OPEN_SSH`, `EC2_PUBLIC_EGRESS`, `ALB_WAF_PROTECTION_REQUIRED`, `ALB_TLS_ENFORCEMENT`, `ROUTE_TABLE_PUBLIC_IGW`, `NETWORK_ACL_UNRESTRICTED_INGRESS`, `WAF_LOG4J_PROTECTION` | Network settings do not establish supplier service obligations or availability. |
| A.8.24 | `S3_PUBLIC_ACCESS`, `S3_ENCRYPTION_MISSING`, `EC2_ROOT_VOLUME_UNENCRYPTED`, `S3_KMS_ENCRYPTION_REQUIRED`, `ALB_TLS_ENFORCEMENT`, `CLOUDWATCH_LOG_GROUP_KMS_ENCRYPTION`, `SECRETS_MANAGER_CMK_ENCRYPTION`, `SNS_TOPIC_KMS_ENCRYPTION`, `S3_ACLS_DISABLED`, `KMS_KEY_POLICY_DEFINED`, `RDS_PERFORMANCE_INSIGHTS_ENCRYPTION`, `RDS_ENCRYPTION_IN_TRANSIT` | Encryption configuration and indirect exposure checks do not prove key operations or every encrypted path. |

The gate can also provide limited process evidence for source access, vulnerability review, security testing and changes (A.8.4, A.8.8, A.8.29, A.8.32), and CI evidence handling (A.5.28). These are workflow relationships, not additional mappings claimed by the metadata.

## 3. Treatment workstreams

These are proposed workstreams, not accepted residual risks. Priority P0 blocks live use; P1 is required before claiming an operating ISMS; P2 is risk-based refinement after the baseline exists. The [risk treatment plan](../03-risk-management/risk-treatment-plan.md) remains the treatment authority: add concrete dates and assignees there when resources and decisions are real. The SoA names every affected control and missing deliverable.

| Gap | Priority / risk links | Owner | Required work | Closure evidence / dependency |
|---|---|---|---|---|
| G01 | P1; RISK-005, RISK-010 | CISO | Approve governance; assign real owners; define screening; conduct training, reviews and incident exercises; provide independent oversight | Approved documents and dated operating samples; independent reviewer appointed. Templates alone do not close this gap |
| G02 | P0; RISK-001, RISK-003, RISK-004, RISK-013 | Cloud Platform Engineering | Reconcile identity authority, trust, ABAC, boundaries and privileged roles; investigate exposed historical credentials with owner; validate ordinary and emergency access | Owner-led credential investigation, approved role scopes, positive and negative effective-access tests, MFA and lifecycle evidence. See [privileged access](privileged-access-justification.md) |
| G03 | P0; RISK-002, RISK-006, RISK-008, RISK-009, RISK-012 | Cloud Platform Engineering | Establish state custody and bootstrap order; resolve findings; design runtime monitoring, trusted time, backup and resilience; validate only after authorized setup | Reviewed bootstrap/state design; scoped deployment authorization; runtime delivery, restore, connectivity and alert evidence. No source-only closure |
| G04 | P1; RISK-010 | HR & Administration | Assess actual work locations and supplier physical controls; define maintenance, utilities and facility safeguards | Site risk assessment and proportionate checks; verified supplier assurance. No blanket cloud-provider exemption |
| G05 | P1; RISK-010, RISK-011 | Compliance & Risk Management | Verify contracts, cloud shared responsibilities, suppliers, subcontractors, exit and external development conditions | Reviewed terms, assurance reports with scope/period, processing locations and dated supplier assessment; certifications and contracts remain to verify |
| G06 | P1; RISK-005, RISK-009, RISK-010 | Product & Engineering | Apply SDLC and security requirements; broaden beyond IaC scanning; appoint independent review where required; review metadata semantics | Threat and abuse cases, dependency/licence checks, security acceptance and change records; product tests when product exists |
| G07 | P1; RISK-010 | Cloud Platform Engineering | Inventory actual endpoints; implement remote, malware, filtering, installation and media safeguards | Configuration samples, accountable custodians, alert exercises, acknowledgements and disposal records |
| G08 | P1; RISK-007, RISK-010 | Compliance & Risk Management | Extend inventory beyond plan assets; protect evidence and records independently of the generating workflow | Provenance, verified checksums, approved retention and access controls, independent retrieval/review and complete asset ownership |
| G09 | P0 before real personal data; RISK-011 | Compliance & Risk Management | Resolve target `eu-central-1` versus `ap-south-1` roots; verify actual processing and transfers; approve retention, masking and deletion needs | Owner-approved residency decision, corrected sources or justified exception, real processing facts and reviewed obligations; data handling tests before personal data use |
| G10 | P1; RISK-009, RISK-010 | Security Operations | Define relevant intelligence sources, community contacts, assessment cadence and feedback into risk and change management | Approved intelligence process and dated assessments; subscriptions alone are insufficient |

## 4. Status corrections and review

The [risk register](../03-risk-management/risk-register.md) records GitHub API verification on 2026-10-14: active ruleset `protect-main` (ID 24482491) requires a pull request and five checks, but zero approving reviews. Both `manual-apply-approval` and `medium-risk-approval` require the maintainer as reviewer and allow self-review (`prevent_self_review=false`). These settings provide limited change gating, not independent separation of duties. RISK-005 remains Treating; no production approval or independent second review is evidenced.

Review gaps when evidence changes, after incidents and at least annually after approval. Keep the [SoA](statement-of-applicability.md), [risk register](../03-risk-management/risk-register.md), [evidence index](../07-technical-evidence/control-evidence-index.md) and [improvement register](../11-improvement/improvement-register.md) consistent. CISO proposes closure; the responsible owner supplies evidence and management records any residual acceptance. The current documentation completion does not close these operating gaps.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
