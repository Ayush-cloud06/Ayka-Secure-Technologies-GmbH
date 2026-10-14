# Supplier performance review

| Field | Value |
|---|---|
| Document ID | ISMS-MON-02 |
| Owner | Compliance & Risk Management |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or supplier incident, assurance gap or service change |
| Status | Draft. Not approved: no approval record exists (simulated company) |

Ayka Secure Technologies GmbH is a simulated company; this document does not establish a performed activity.

## 1. Purpose and population

Review suppliers under [POL-VEN-01](../../policies/vendor-management-policy.md) and the [onboarding procedure](../06-operational-procedures/supplier-onboarding-procedure.md). Critical/High suppliers are reviewed annually; Standard suppliers at renewal; material security incidents, report qualifications, sub-processor changes, location changes and exit obstacles trigger an additional review. The [processor register](../../GDPR/processor-register.md) supplies candidate services; it is not evidence of an assessment.

AWS hosting, Microsoft Entra ID and GitHub source/CI are proposed Critical services. Only GitHub is in real repository use, under personal-account terms according to the vendor policy. Applicable assurance coverage and contractual commitments are **to verify** for each actual service plan. No provider SLA, certification or contract conclusion is asserted here.

## 2. Review method

1. Reconcile actual services, owner, account/plan, data and dependencies against the previous review and register. Confirm the review period and who can access assurance material.
2. Obtain the provider's current relevant report/certificate and any period-gap evidence through an official source. Inspect scope, report period, opinion, exclusions, relevant exceptions and carved-out subservices. Record missing materials as a gap.
3. Map each applicable customer responsibility to an Ayka control and evidence. Provider assurance does not replace Ayka's access, configuration, logging or restore checks.
4. Compare observed incidents, availability, support responsiveness and recovery evidence against the actual contract; separate provider status claims from Ayka measurements. Record unavailable measurement data rather than scoring it favourably.
5. Reassess data locations, transfers, subprocessors, DPA coverage, concentration and exit/export/deletion capability. Coordinate legal/privacy review where facts or terms changed. For sub-processor notices, use the policy's 30-day assessment target.
6. Recommend continue, continue with conditions, suspend new use or exit. CISO records the security recommendation; Managing Director decides material contractual/resource/risk matters. Assign due dates and link actions; no review is complete with an unsigned decision presented as approved.

## 3. Review record template

| Field group | Required content |
|---|---|
| Identity and scope | Review ID/date, supplier/service/plan, tier, business owner role, assessor, independent reviewer, period and data/systems |
| Source evidence | Contract/DPA references, report type/version/period/source, retrieval date, restricted location and coverage gaps |
| Evaluation | Relevant exceptions, CUEC mapping, incidents/availability evidence, subservice and location changes, transfer/privacy decision, concentration and exit test status |
| Decision | Recommendation, actual approval/date, conditions, residual-risk link, next review due and event triggers |
| Follow-up | Action ID, owner role, due date, verification and closure evidence |

Keep restricted reports/contracts under the [retention policy](../../policies/records-and-data-retention-policy.md). Public records contain sanitized references only. Use the [SOC2 vendor review template](../../SOC2/05-audit-approach-and-evidence.md) where it contains equivalent fields.

## 4. Review log

No entries yet. No supplier assurance report or completed supplier review has been evidenced, and this template must not be used to manufacture a review date or favourable result.

| Review ID | Supplier/service | Period / actual review date | Owner role | Evidence reference | Decision / approver | Actions / next due |
|---|---|---|---|---|---|---|

Before real supplier activation, complete onboarding diligence; assign the first annual review from that actual approval date. Report overdue reviews in [M-07](kpis-and-metrics.md) and material gaps to [management review](../10-management-review/management-review-agenda.md). ISO/IEC 27001:2022 A.5.19–A.5.23 and clause 9.1.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
