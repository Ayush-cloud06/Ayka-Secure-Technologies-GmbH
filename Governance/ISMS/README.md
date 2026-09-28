# Information Security Management System (ISMS)

> Simulated ISO/IEC 27001:2022 case study. This table is the single list of ISMS documents: the ones that exist and the ones that are only planned.
> A `Planned` row is an intention, not a document. When you write one, create the file in the matching folder, link it here and change the status.
> Status: `Draft` = file exists, not approved (no real approver exists) · `Covered elsewhere` = content lives in another file · `Planned` = not written.

| Area | Planned document | Status | Why it would exist | Evidence it would need |
|---|---|---|---|---|
| 00 Context and governance | [Scope](00-context-and-governance/scope.md) | Draft | Clause 4.3: what the ISMS covers | Label the approval line as simulated (Phase 5) |
| 00 Context and governance | [Information security policy](00-context-and-governance/information-security-policy.md) | Draft | Clause 5.2, A.5.1: top-level policy | Label the approval line as simulated (Phase 5) |
| 00 Context and governance | Context of the organization | Planned | Clause 4.1: issues that shape the ISMS | Dated list of issues; can build on `organization/business-model.md` |
| 00 Context and governance | Interested parties | Planned | Clause 4.2: who has requirements on the ISMS | List of parties and their requirements, with a review date |
| 00 Context and governance | Legal and regulatory requirements | Planned | Clause 4.2, A.5.31 | Register of laws and contracts (e.g. GDPR) with an owner |
| 00 Context and governance | ISMS objectives | Planned | Clause 6.2: measurable objectives | Each objective names a data source, e.g. CI run history |
| 00 Context and governance | Management commitment statement | Planned | Clause 5.1 | A real dated decision by a real person; don't write one for the simulated company |
| 00 Context and governance | Document control procedure | Planned | Clause 7.5.2, 7.5.3 | Git history, pull requests and branch protection (after Phase 4) |
| 00 Context and governance | Document register | Planned | Clause 7.5 | This table can be the register; add owner and review-date columns |
| 00 Context and governance | Record retention policy | Planned | A.5.33 | Retention that is actually configured, e.g. GitHub artifact retention |
| 01 Organization | [Org chart](../../organization/org-structure.md) | Covered elsewhere | Clause 5.3 | Already written in `organization/` |
| 01 Organization | [Roles and responsibilities](../../organization/roles-and-responsibilities.md) | Covered elsewhere | Clause 5.3, A.5.2 | Already written in `organization/` (fix the SIEM claim in Phase 5) |
| 01 Organization | [Personnel register](../../organization/personnel-register.md) | Covered elsewhere | A.6.1, joiner and leaver tracking | Already written in `organization/` (fictional people) |
| 01 Organization | NDA template | Planned | A.6.6 | Template text only |
| 01 Organization | Signed NDA index | Planned | A.6.6 | Only real signed agreements; stays Planned in a simulation |
| 01 Organization | Competence matrix | Planned | Clause 7.2 | Roles against required skills, with a dated assessment |
| 01 Organization | [Training and awareness programme](../../organization/training-and-awareness.md) | Covered elsewhere | Clause 7.3, A.6.3 | Already written in `organization/`; no training records exist |
| 01 Organization | Disciplinary process | Planned | A.6.4 | Process text; no records in a simulation |
| 01 Organization | Onboarding and offboarding procedure | Planned | A.5.16, A.5.18, A.6.5 | Link the identity provisioning workflow and the Entra ID Terraform |
| 02 Asset management | Asset inventory | Planned | A.5.9 | Generated from the plan JSON resource list, not typed by hand |
| 02 Asset management | Asset classification policy | Planned | A.5.12 | A classification tag that Terraform actually sets |
| 02 Asset management | Asset ownership register | Planned | A.5.9 | Owner tags or a CODEOWNERS file |
| 02 Asset management | Acceptable use policy | Planned | A.5.10 | Policy text; acknowledgements would be records |
| 02 Asset management | Remote work policy | Planned | A.6.7 | Policy text |
| 02 Asset management | Mobile device policy | Planned | A.8.1 | Policy text; device management records |
| 02 Asset management | Asset return checklist | Planned | A.5.11 | Offboarding records |
| 03 Risk management | [Risk management methodology](03-risk-management/risk-management-methodology.md) | Draft | Clause 6.1.2 | Replace `AUDIT/` links with CI run links with CI run links |
| 03 Risk management | [Risk criteria](03-risk-management/risk-criteria.md) | Draft | Clause 6.1.2 a | In your preferred style already |
| 03 Risk management | [Risk register](03-risk-management/risk-register.md) | Draft | Clause 6.1.2, 8.2 | RISK-001 corrected in Phase 1; other links in Phase 5 |
| 03 Risk management | [Risk treatment plan](03-risk-management/risk-treatment-plan.md) | Draft | Clause 6.1.3, 8.3 | TRT-003/006 status fixed in Phase 5 |
| 03 Risk management | [Risk acceptance log](03-risk-management/risk-acceptance-log.md) | Draft | Clause 6.1.3 f | No approver exists yet, and the log says so |
| 03 Risk management | [Threat scenarios catalogue](03-risk-management/threat-scenarios-catalog.md) | Draft | Clause 6.1.2 c | Scenarios already point at real repo conditions |
| 03 Risk management | [2026 Q1 risk assessment](03-risk-management/risk-assessment-results/2026-q1-risk-assessment.md) | Draft | Clause 8.2 | Marked as a retrospective reconstruction |
| 03 Risk management | [2026 Q2 risk review](03-risk-management/risk-assessment-results/2026-q2-risk-review.md) | Draft | Clause 8.2 | Its drift reading matches the workflow history |
| 04 Controls and SoA | [IAM to ISO 27001 mapping](04-controls-and-soa/iam-iso27001-mapping.md) | Draft | A.5.15 to A.5.18, A.8.2 to A.8.5 | Has broken `Internal-IT/iam/` paths and shifted A.5 labels; fix before relying on it |
| 04 Controls and SoA | Statement of Applicability | Planned | Clause 6.1.3 d | Every Annex A control: applicable or not, and why; link applicable ones to `control-mapping.yaml` |
| 04 Controls and SoA | [Control mapping to Internal-IT](../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml) | Covered elsewhere | Clause 6.1.3 | The real mapping: 38 controls with ISO 27001 refs, read by the evaluator |
| 04 Controls and SoA | Control gap analysis | Planned | Clause 6.1.3 | Difference between the SoA and the controls the gate enforces |
| 04 Controls and SoA | Access control evidence index | Planned | A.5.15 | CI run links for the IAM controls |
| 04 Controls and SoA | Privileged access justification | Planned | A.8.2 | One line per privileged role: reason and approver |
| 04 Controls and SoA | Justification for exclusions | Planned | Clause 6.1.3 d | Can be a column in the SoA instead of a file |
| 05 Operational policies | Incident response policy | Planned | A.5.24 | Policy text |
| 05 Operational policies | Access control policy | Planned | A.5.15 | Controls `IAM_WILDCARD_POLICY`, `IAM_USER_PROHIBITED` in CI runs |
| 05 Operational policies | Password policy | Planned | A.5.17 | Entra ID settings; no passwords in code (Phase 1) |
| 05 Operational policies | MFA policy | Planned | A.8.5 | Control `IAM_USER_MFA_MISSING`; Conditional Access module |
| 05 Operational policies | Privileged access policy | Planned | A.8.2 | Tier 0 groups in Terraform; break-glass procedure |
| 05 Operational policies | Logging and monitoring policy | Planned | A.8.15, A.8.16 | Controls `S3_LOGGING_DISABLED`, `VPC_FLOW_LOGS_MISSING` |
| 05 Operational policies | Cloud security policy | Planned | A.5.23 | The compliance gate itself: CI run links |
| 05 Operational policies | Secure development policy | Planned | A.8.25 | Pipeline stages and branch protection |
| 05 Operational policies | Change management policy | Planned | A.8.32 | Pull requests plus the gate decision per run |
| 05 Operational policies | Backup policy | Planned | A.8.13 | Control `S3_VERSIONING_DISABLED`; restore tests would be records |
| 05 Operational policies | Encryption policy | Planned | A.8.24 | Controls `S3_ENCRYPTION_MISSING`, `EC2_ROOT_VOLUME_UNENCRYPTED` |
| 05 Operational policies | Vulnerability management policy | Planned | A.8.8 | Scanner results in CI artifacts |
| 05 Operational policies | Patch management policy | Planned | A.8.8 | Pinned tool versions and update commits |
| 05 Operational policies | Supplier security policy | Planned | A.5.19 | Supplier list with assessments |
| 05 Operational policies | Data protection policy | Planned | A.5.34 | GDPR records of processing (none yet) |
| 05 Operational policies | Data retention policy | Planned | A.5.33, A.8.10 | Configured retention settings |
| 05 Operational policies | Clean desk and clear screen policy | Planned | A.7.7 | Policy text |
| 06 Operational procedures | User access procedure | Planned | A.5.16, A.5.18 | Link the identity provisioning workflow doc |
| 06 Operational procedures | Access review procedure | Planned | A.5.18 | Dated review records |
| 06 Operational procedures | Incident response procedure | Planned | A.5.26 | Exercise or incident records |
| 06 Operational procedures | Backup and restore procedure | Planned | A.8.13 | Restore test results |
| 06 Operational procedures | Change management procedure | Planned | A.8.32 | PR and CI run URLs |
| 06 Operational procedures | Vulnerability scanning procedure | Planned | A.8.8 | CI scan artifacts |
| 06 Operational procedures | Patch deployment procedure | Planned | A.8.8 | Update commits and CI runs |
| 06 Operational procedures | Supplier onboarding procedure | Planned | A.5.19, A.5.20 | Supplier assessments |
| 06 Operational procedures | Data breach notification procedure | Planned | A.5.26, GDPR Art. 33 | Exercise records |
| 06 Operational procedures | Business continuity procedure | Planned | A.5.29, A.5.30 | Test records |
| 06 Operational procedures | Disaster recovery procedure | Planned | A.5.30 | Recovery test records |
| 06 Operational procedures | Corrective action procedure | Planned | Clause 10.2 | Corrective action log entries |
| 07 Technical evidence | Control evidence index | Planned | Clause 7.5, 9.1 | CI run URL and artifact name per control |
| 07 Technical evidence | Internal-IT mapping | Planned | Clause 6.1.3 | Which folder implements which control |
| 07 Technical evidence | Terraform module mapping | Planned | Clause 6.1.3 | Which module implements which control |
| 07 Technical evidence | Penetration test report | Planned | A.8.8 | Only from a real test; never simulated |
| 07 Technical evidence | IAM role list, Identity Center groups, IAM plan extract | Planned | A.5.15, A.8.2 | Generated by a CI job from the plan JSON, never typed by hand |
| 07 Technical evidence | Architecture diagrams | Planned | Clause 7.5 | Mermaid diagrams in Markdown instead of PNG files |
| 07 Technical evidence | Logging evidence, access review logs, backup test results | Planned | A.8.15, A.5.18, A.8.13 | Real exports only |
| 07 Technical evidence | Vulnerability scan reports | Covered elsewhere | A.8.8 | The `compliance-evidence` artifact of each CI run |
| 08 Monitoring and measurement | KPIs and metrics | Planned | Clause 9.1 | Numbers computed from CI history |
| 08 Monitoring and measurement | Security metrics dashboard | Planned | Clause 9.1 | Same data as KPIs |
| 08 Monitoring and measurement | Q1 and Q2 monitoring results | Planned | Clause 9.1 | Real measurements only; don't backdate |
| 08 Monitoring and measurement | Supplier performance review | Planned | A.5.22 | Review records |
| 09 Internal audit | Audit programme | Planned | Clause 9.2.2 | Programme text |
| 09 Internal audit | Audit plan 2026 | Planned | Clause 9.2 | Plan with dates |
| 09 Internal audit | Audit findings log | Planned | Clause 9.2 | Findings from a real audit |
| 09 Internal audit | Audit checklists and reports | Planned | Clause 9.2 | Real audit records |
| 10 Management review | Management review agenda | Planned | Clause 9.3.2 | Agenda text |
| 10 Management review | Management review minutes Q1 and Q2 | Planned | Clause 9.3.3 | Real meetings only; don't write minutes after the fact |
| 10 Management review | Management review action items | Planned | Clause 9.3.3 | Actions from real meetings |
| 11 Improvement | Nonconformity log | Planned | Clause 10.2 | Entries with dates |
| 11 Improvement | Corrective action log | Planned | Clause 10.2 | Entries with dates |
| 11 Improvement | Improvement register | Planned | Clause 10.1 | Entries with dates; the restore plan itself is a candidate |
| 11 Improvement | Lessons learned log | Planned | A.5.27 | Entries with dates |

This index replaces 79 one-line placeholder files and `tree.md` (removed 2026-09-28). Git history keeps every removed path: `git show baseline-2026-10:<path>`.
