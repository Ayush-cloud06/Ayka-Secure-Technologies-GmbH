# Supplier onboarding procedure

| Field | Value |
|---|---|
| Document ID | ISMS-OPS-07 |
| Owner | Compliance & Risk Management |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or new critical supplier or material service change |
| Status | Draft. Not approved: no approval record exists (simulated company) |

Ayka Secure Technologies GmbH is a simulated company; this document does not establish a performed activity.

## 1. Scope and operating boundary

Apply the [vendor policy](../../policies/vendor-management-policy.md) to providers with access to data, identity, source, CI or infrastructure. Proposed critical suppliers are AWS, Microsoft Entra ID and GitHub. Only GitHub is in real repository use; the [processor register](../../GDPR/processor-register.md) and vendor policy do not prove executed contracts, security-report review or operational AWS/Entra use. This procedure is **Designed**; supplier approvals remain absent.

## 2. Intake and diligence

| Stage | Responsible role | Required evidence and decision |
|---|---|---|
| Request | Requesting function owner | Business purpose, alternatives, service/plan, cost owner, data categories, administrative access, integration, dependency and intended exit |
| Tier | Compliance & Risk Management | Critical if hosting customer/production data or able to change production; High for other personal/confidential data; Standard otherwise; record rationale |
| Security diligence | Compliance & Risk Management with Security Operations | Relevant current assurance report/certificate, scope and service-plan coverage, period/gaps, exceptions, subcontractors and customer responsibilities; unverified items stay open |
| Privacy/location | Compliance & Risk Management | Data/controller-processor roles, actual storage/support/backup locations, transfers, proposed DPA and safeguards; record legal review required, not a presumed conclusion |
| Technical assessment | Cloud Platform Engineering or Product & Engineering | Least privilege, authentication, logging, key ownership, recovery, integration/change risks and tested export feasibility when available |
| Contract decision | Managing Director, with CISO security recommendation | Actual contract/signature record, unresolved risks, conditions, review/renewal date and authorized data scope |

Obtain assurance material through the provider's official channel and store it with appropriate access; verify publication currency, authenticity, service coverage and restrictions. Contract clauses, provider certifications, DPA coverage and transfer mechanisms are **to verify** until the actual documents have been examined. A brand's general certificate does not establish coverage of a personal account or free plan.

## 3. Entry criteria and records

Before sharing confidential/customer data, complete the policy's diligence, CISO sign-off and necessary contract/privacy decisions. A missing report, DPA, data-location answer or exit arrangement is an open gap; CISO escalates to Managing Director rather than marking it approved. No decision in this draft authorizes transfer of real personal data.

Record supplier ID, service/plan, tier/reason, business and technical owner roles, assessed data/locations, contract and DPA references, report scope/period, exception decisions, CUEC-to-Ayka-control mapping, review date and exit steps. Update the [processor register](../../GDPR/processor-register.md), [asset ownership](../02-asset-management/asset-ownership-register.md) and [risk register](../03-risk-management/risk-register.md) where applicable. Store restricted contracts/reports separately under the [retention policy](../../policies/records-and-data-retention-policy.md).

## 4. Activate, monitor and exit

Cloud Platform Engineering grants the approved minimum integration access via the [access procedure](user-access-procedure.md). Confirm service configuration, event/contact route and the ability to revoke access before activation. Compliance & Risk Management schedules the [supplier performance review](../08-monitoring-and-measurement/supplier-performance-review.md): annual for Critical/High, renewal for Standard and event-driven for material changes/incidents.

At exit, inventory data and dependencies; approve export format, destination and migration validation; revoke tokens/accounts; reconcile retained backups, legal holds and deletion confirmation to contract terms. Record inability to independently verify provider deletion. An AWS Terraform design does not prove portability of RDS data, KMS keys or identity integrations. ISO/IEC 27001:2022 A.5.19–A.5.23.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
