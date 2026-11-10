# SIM-SDL-002 External developer engagement considered

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-SDL-002 |
| Authored | 2026-11-10 |
| Scenario date | 2026-07-27 |
| Participants | EMP-006 (Product Manager, requester), EMP-016 (Supplier Risk Coordinator), EMP-004 (Compliance Analyst, privacy and contract questions), EMP-002 (CISO, recommendation), EMP-014 (Security Engineer, technical assessment), EMP-001 (Managing Director, contract decision), EMP-012 (HR, screening) |
| Procedure exercised | [Secure development policy POL-SDL-01](../../../policies/secure-development-policy.md) section 2 (outsourced development row) and sections 4.1 to 4.9; [Vendor management policy POL-VEN-01](../../../policies/vendor-management-policy.md) sections 4 and 6; [Supplier onboarding procedure ISMS-OPS-07](../../../ISMS/06-operational-procedures/supplier-onboarding-procedure.md) sections 2 and 3; [Personnel screening criteria](../../../ISMS/01-organization/personnel-screening-criteria.md) |
| Controls | ISO/IEC 27001:2022 Annex A A.8.30 (not raised); looked at: A.5.19, A.5.20, A.5.32. SOC 2 CC9.2 |

"Freelancer F-01 (fictional)" is a fictional self-employed developer, based in Germany. Everything about them is a scenario value. No statement by any real freelancer, platform or agency is recorded.

## 1. Request

EMP-006 asks on 2026-07-27 to engage F-01 for four weeks to build the reports page of the portal, because EMP-008 (the only frontend engineer) is the bottleneck. F-01 would work from their own laptop, in a fork of the public repository, and send pull requests. No customer data and no cloud credentials are needed.

## 2. What the documents say about outsourced development

- POL-SDL-01 section 2: "Outsourced development: None today; if used, POL-VEN-01 and this policy apply." Section 3 lists A.8.30 as "no outsourced development today".
- POL-VEN-01 section 4: three tiers (Critical, High, Standard). Critical means "hosts production or customer data, or can change production". Section 6: no vendor gets customer or confidential data before due diligence and the CISO's sign-off.
- ISMS-OPS-07 section 2: intake fields (purpose, data categories, administrative access, integration, exit), tier, diligence, privacy and location, technical assessment, contract decision.
- Screening criteria: a contractor with a system account follows the same tier table as an employee. A "contractor with no system account" needs a contract and an NDA only.

The walk looks for the oversight requirements for software supplied by a third party: what Ayka demands of the code, how it checks, what it keeps.

## 3. Walk of the oversight requirements

| Oversight element (what the control needs) | Where the written design says it | Walk result |
|---|---|---|
| Tier of the supplier | POL-VEN-01 section 4 | F-01 would write code that reaches the `main` branch only through Ayka's pipeline and review. "Can change production" would put them at Critical, which implies a SOC 2 report. That is nonsense for a freelancer. "High" fits personal data only. **No tier fits** |
| Security requirements for the work | POL-SDL-01 4.2 and 4.4 apply to "every change" | Applies to F-01's code as to anyone's. No clause says how F-01 learns the rules or confirms them |
| Contract terms on secure development | Nothing | **No template.** No clause on coding rules, vulnerability fixing, confidentiality of what F-01 sees, return or deletion of material, or breach notice |
| Ownership and licence of the work | Legal register section 5: "Review origin, rights and licence compatibility before merge" | The repository is public under Apache 2.0. A freelancer keeps copyright unless the contract assigns or licenses it (to verify with counsel). The repository has no contributor licence statement and no sign-off rule. **Open** |
| Screening | Screening criteria | F-01 has no system account (fork only), so "contractor with no system account": contract and NDA. The pull request would carry F-01's name and e-mail in public history. NDA template v1.0 would be signed |
| Access | ISMS-OPS-07 section 4 (minimum integration access) | No repository write. Fork and pull request. Required checks run on a fork's pull request without secrets (the pipeline holds no cloud credentials). Environment approvals are not reachable |
| Code review of external code | POL-SDL-01 4.6 and POL-CHG-01 | Review by an Ayka engineer other than the one who requested the work. The ruleset requires 0 approvals, so this is an agreement, not a control |
| Acceptance criteria and evidence of testing | POL-SDL-01 4.5 | Unit tests and the required checks. No criteria written for external work. F-01's own test evidence is not required anywhere |
| Dependency and licence disclosure | Legal register section 5 | New libraries must be listed. No rule asks the supplier to list them |
| Right to inspect the supplier's practices | Nothing | None. For a self-employed person on their own laptop the only possible check is the output |
| Supplier's own device and environment | POL-END-01 applies to Ayka-managed devices | **Not covered.** F-01's laptop is outside the endpoint baseline. The policy allows no personal device for Confidential data; F-01 would see only public code |
| Exit | ISMS-OPS-07 section 4 | Nothing to export. An end-of-engagement note and an NDA reminder would be needed; no rule asks for them |

## 4. Result (scenario)

- EMP-016 and EMP-004 find no tier, no contract template, no licence rule and no acceptance criteria.
- EMP-014 points out the main risk is not data, since F-01 sees only the public repository, but **code that enters a Tier 0 or Tier 1 change path or the identity Terraform**. A malicious or careless pull request is stopped only by review and the five checks.
- Scenario decision by EMP-001 on 2026-07-27, with the CISO's recommendation (EMP-002): **no engagement now.** The need is met by moving two tasks from EMP-008 to EMP-007. Reconsider after the missing items below are written. Nothing was signed, paid or started.
- Draft requirement list written during the walk (not in force; for the owner of POL-SDL-01): tier "Standard-development" for suppliers with no data and no repository write; contract clauses (rules, licence grant or assignment, confidentiality, return, notice); contributor sign-off rule; second Ayka reviewer required for any external pull request; dependency disclosure; acceptance criteria per task.

## 5. Why A.8.30 stays Designed

The control is oversight of outsourced development. The written design is one line that points to two policies, and neither contains a requirement that applies specifically to code produced by a third party. The walk produced the requirements by itself. A design that exists only as a pointer cannot be walked. The row stays at Designed, with the remaining work stated, and is not raised. One may argue it should be Planned, since no specific design exists.

## Findings

1. **A.8.30 has no design of its own.** POL-SDL-01 says "if used, POL-VEN-01 and this policy apply". Neither document contains an oversight requirement for external code. Write them.
2. **No vendor tier fits a developer supplier.** POL-VEN-01 section 4's tiers are written for hosting and data processing. A freelancer with no data and no repository write cannot be tiered without distorting the tier.
3. **No contract template or required clauses.** POL-VEN-01 section 6 mentions DPA for personal data. Nothing covers development contracts, even in outline.
4. **Licence and ownership of contributions undefined.** The repository is Apache 2.0, public, and the legal register says to check rights before merge. Neither says how a contributor grants rights (contract grant, contributor licence, sign-off). Counsel must advise (to verify).
5. **External pull requests need a stronger review rule.** POL-CHG-01 does not distinguish external from internal authors. With 0 required approvals, a freelancer's change can be merged by the same person who asked for it.
6. **Supplier devices are outside POL-END-01.** The endpoint baseline covers Ayka devices. A contractor's own laptop has no stated rule, even where only public material is handled.
7. **The screening table does not say how to treat "pull request only" contributors.** "Contractor with no system account" could apply. An external contributor with fork access only is a case no row covers.
8. **No acceptance criteria for externally produced work.** POL-SDL-01 4.5 covers tests for Ayka changes. Nothing says whether supplier-supplied tests count or who runs acceptance.

## What this does not show

- No freelancer exists. No contract, NDA, price or statement exists. No code was written, reviewed or merged.
- The view on copyright is not a legal opinion. It is a question for counsel.
- Whether a real agency or marketplace would fit the requirements. None was assessed.
- A supplier with access to customer data or to production. Not exercised.
