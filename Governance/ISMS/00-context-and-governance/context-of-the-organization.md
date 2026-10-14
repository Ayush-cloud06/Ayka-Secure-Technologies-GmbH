# Context of the organization

| Field | Value |
|---|---|
| Document ID | ISMS-00-03 |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, at each management review, or on a trigger in section 6 |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company. Nothing is deployed; the compliance gate runs for real in CI on Terraform plans only ([README, scope](../../../README.md#2-scope-a-plan-analysis-gate)). The issues below describe the company as designed and the repository as it is.

## 1. Purpose

ISO/IEC 27001:2022 clause 4.1 asks for the external and internal issues that affect Ayka's ability to achieve the intended outcomes of its ISMS. ISO/IEC 27001:2022/Amd 1:2024 adds that Ayka must decide whether climate change is a relevant issue. This document lists those issues, says what each one does to the ISMS, and points to where it is handled: a risk in the [risk register](../03-risk-management/risk-register.md), a policy, or an objective in [ISMS objectives](isms-objectives.md).

Intended outcomes of the ISMS (from the [information security policy](information-security-policy.md), section 1): customer trust, meeting legal and contractual obligations, protecting reputation, operational resilience.

## 2. Business in one paragraph

Stuttgart GmbH, founded January 2026 ([NIS2-01 §2.2 and §4](../../NIS2/01-applicability-assessment.md#22-facts-about-ayka)), 24 staff in the [personnel register](../../../organization/personnel-register.md) (fictional people). Sells a compliance SaaS (GDPR readiness, ISO 27001 evidence automation, automotive extension) plus onboarding, audit preparation and advisory services to EU SMEs and automotive Tier-2/3 suppliers ([business model](../../../organization/business-model.md)). The SaaS (`ayka-portal`) is designed for AWS and has never been deployed. No customers exist.

## 3. External issues

All issues recorded 2026-10-14 (first issue of this document). Where the evidence behind an issue is older, its date is given in the evidence column.

| ID | Issue | Evidence (date) | Effect on the ISMS | Handled in |
|---|---|---|---|---|
| EXT-01 | EU and German data protection law: Ayka is controller for staff data and processor for customer data | [GDPR README](../../GDPR/README.md) (2026-10-05) | Privacy requirements shape access, logging, retention and supplier controls; a breach requires a role-specific notification assessment under the linked procedure | [Legal register](legal-and-regulatory-register.md) LR-01, LR-02; RISK-011 |
| EXT-02 | The current NIS2 working assessment places the simulated company outside direct scope; supplier-security duties may arise through contracts (legal conclusion to verify) | [NIS2-01](../../NIS2/01-applicability-assessment.md#1-result) (2026-10-06) | Proposed customer terms include 24-hour incident notice, audit rights and evidence; the ISMS must be able to produce that evidence | [NIS2-05](../../NIS2/05-supply-chain-security.md); legal register LR-03, CR-02; [communication plan](communication-plan.md) |
| EXT-03 | Automotive supply chain expects TISAX labels and VDA ISA questionnaires | [NIS2-05 A.1](../../NIS2/05-supply-chain-security.md#a1-what-customers-will-ask) (2026-10-06) | Control set and evidence must also answer VDA ISA; TISAX may be a sales precondition | Legal register CR-02; [interested parties](interested-parties.md) |
| EXT-04 | Market demand for ISO/IEC 27001 certification among Ayka's target customers, and Ayka sells ISO 27001 support itself | [Business model](../../../organization/business-model.md) sections 2 and 4 | Ayka's own ISMS is part of the product's credibility; an overstated claim damages the business directly | [Scope](scope.md); RISK-008; objective OBJ-01 |
| EXT-05 | Dependence on three providers: AWS (hosting, planned), Microsoft (Entra ID, planned), GitHub (source and CI, real) | [Processor register](../../GDPR/processor-register.md) (2026-10-05) | Their outages and compromises become Ayka's; their terms and attestations have to be tracked | [POL-VEN-01](../../policies/vendor-management-policy.md); [NIS2-05 B.3](../../NIS2/05-supply-chain-security.md#b3-what-is-missing); legal register CR-03 to CR-05 |
| EXT-06 | Threats to SaaS and CI supply chains: credential theft, compromised GitHub Actions or dependencies, misconfigured cloud storage | [Threat scenarios catalogue](../03-risk-management/threat-scenarios-catalog.md); RISK-001 (credentials in public history since 2026-03-22) | Change path and identity are the main attack surface; detection is missing | RISK-001, RISK-003, RISK-005, RISK-009; [POL-CHG-01](../../policies/change-management-policy.md) |
| EXT-07 | The repository is public on GitHub: every committed file is published worldwide | GitHub API `visibility: public`, read 2026-10-14 | Nothing Internal, Confidential or Restricted may be committed; Git history keeps mistakes visible | [POL-DATA-01](../../policies/data-classification-and-confidentiality-policy.md#4-classification-levels); [document control](document-control-procedure.md) section 9; RISK-001 |
| EXT-08 | New regulation affecting software and automated processing, including the EU AI Act; applicability to each use is to verify | [Legal register](legal-and-regulatory-register.md) LR-10 | Assess tool use and staff competence before adopting affected services; review legal changes | Legal register LR-10; [competence matrix](../01-organization/competence-matrix.md) |
| EXT-09 | Security tooling changes upstream: tfsec being folded into Trivy; Rego pinned to pre-1.0 syntax; Terraform licence change (to verify) | [README, known limitations](../../../README.md#6-known-limitations) | Gate tools need planned upgrades; licence terms of tools must be checked | Legal register LR-08; [toolchain pins](../../../Internal-IT/engineering/ci-cd/toolchain.versions) |
| EXT-10 | Climate change | See section 5 | Low; covered by existing availability measures | Section 5 |

## 4. Internal issues

| ID | Issue | Evidence (date) | Effect on the ISMS | Handled in |
|---|---|---|---|---|
| INT-01 | Simulated company, plan-only infrastructure: no running service, no customers, no operating records | [README, scope](../../../README.md#2-scope-a-plan-analysis-gate) | Most controls can be at best Gated design or Designed; a pass means "the plan meets the mapped controls", not "the system runs securely" | RISK-008, RISK-010; [status vocabulary](../../SOC2/README.md#4-status-vocabulary) |
| INT-02 | One real maintainer holds every role: no independent second reviewer or approver | [Ruleset 24482491](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/rules/24482491) requires 0 approvals (GitHub API, rechecked 2026-10-14); [POL-CHG-01](../../policies/change-management-policy.md) records the single-maintainer constraint | Segregation of duties and independent audit are absent; no policy approval is recorded | RISK-005; objective OBJ-03 |
| INT-03 | Startup size: 24 staff, roles consolidated | [Org structure §3](../../../organization/org-structure.md#3-role-consolidation-startup-model) | Several ISMS roles are part-time hats; some functions (Sales, Finance) have no defined ISMS role | [Roles and responsibilities](../../../organization/roles-and-responsibilities.md); [competence matrix](../01-organization/competence-matrix.md) |
| INT-04 | The compliance gate is Ayka's strongest operating control: 38 mapped controls, fail-closed evaluator, regression scenarios that must fail | [Run 37498007502](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/37498007502) (2026-10-06): the five gate jobs passed; the simulated apply job waits on `manual-apply-approval` | The ISMS can measure itself from CI history; objectives build on it | Objectives OBJ-01, OBJ-02; [control-mapping.yaml](../../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml) |
| INT-05 | AWS Organization, landing zone and identity are design-only and not gated | [README, capability status](../../../README.md#4-capability-status) | Identity and account controls cannot be shown to operate; unsafe apply order possible | RISK-003, RISK-004, RISK-012, RISK-013 |
| INT-06 | Target Region `eu-central-1`; Terraform names `ap-south-1` in about 10 roots and the region SCP | [GDPR README, Region](../../GDPR/README.md#region) | No "data stays in the EU" claim is supported | RISK-011; objective OBJ-09 |
| INT-07 | CI evidence bundles kept 90 days (GitHub setting, maximum for this repository) | GitHub API `actions/permissions/artifact-and-log-retention`: 90 days, read 2026-10-14 | Evidence for a 12-month audit period cannot be retained in CI | RISK-007; objective OBJ-08 |
| INT-08 | No detection or alerting exists (no SIEM, GuardDuty or alert routing) | [NIS2-02](../../NIS2/02-risk-management-measures.md) No. 2 (2026-10-06) | Incident awareness depends on luck; notification commitments cannot be met reliably | RISK-006; [POL-IR-01](../../policies/incident-response-plan.md#12-current-gaps); [STD-LOG-01](../../policies/logging-and-monitoring-standard.md) |
| INT-09 | MFA is not required: Conditional Access is switched off because the lab tenant runs Entra ID Free | [NIS2-02](../../NIS2/02-risk-management-measures.md) No. 10 (2026-10-06) | Policy objective "MFA for all privileged access" is not met | [POL-AC-01 §4.2](../../policies/access-control-policy.md#42-authentication); objective OBJ-04 |
| INT-10 | Documented requirements can be mistaken for operating controls | [Risk register](../03-risk-management/risk-register.md) RISK-008 and [capability status](../../../README.md#4-capability-status) | Every status needs scope and evidence; draft documents cannot substitute for operation | RISK-008; [document control](document-control-procedure.md) section 6 |

## 5. Climate change (Amd 1:2024)

**Draft assessment: relevant, with an indirect availability effect. Existing availability treatments are proposed; management has not accepted this assessment.** Reasoning:

| Question | Answer |
|---|---|
| Does Ayka operate facilities exposed to climate hazards? | No data centre. One Stuttgart office; staff can work remotely ([POL-BCDR-01 §2](../../policies/business-continuity-and-disaster-recovery-plan.md#2-scope)) |
| Could climate events (heat, flooding, storms, power-grid stress) affect availability? | Yes, through the hosting Region. The platform design is single-Region on AWS; physical and environmental protection is inherited from AWS (to verify through AWS's attestations). A Region outage already exceeds the RTO for any cause ([POL-BCDR-01 §5](../../policies/business-continuity-and-disaster-recovery-plan.md#5-resilience-in-the-design), known weaknesses) |
| Is the effect covered? | Addressed in design by the Region-outage scenario and the planned second-EU-Region copy in POL-BCDR-01, and by the AWS concentration gap in [NIS2-05 B.3](../../NIS2/05-supply-chain-security.md#b3-what-is-missing). Climate does not change the treatment, only the likelihood of one cause |
| Do interested parties have climate-related requirements on the ISMS? | None known. Customer sustainability questionnaires are possible, but they are not information security requirements; see [interested parties](interested-parties.md) section 4 |

Revisit if Ayka selects a second Region, operates its own facilities, or a customer contract sets climate-related resilience terms.

## 6. Review triggers

Review this document, in addition to the annual review, when:

- the first customer contract is signed, or the service starts operating;
- the NIS2 applicability assessment changes its result ([NIS2-01 §7](../../NIS2/01-applicability-assessment.md#7-when-this-assessment-must-be-repeated));
- a provider in EXT-05 is added, replaced or changes its terms materially;
- a second maintainer joins (INT-02) or the headcount or role structure changes (INT-03);
- the Region is migrated (INT-06);
- a significant incident occurs.

Each review adds a line to the revision history. Issues that change go into the risk register through the [risk management methodology](../03-risk-management/risk-management-methodology.md). No review has taken place yet.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
