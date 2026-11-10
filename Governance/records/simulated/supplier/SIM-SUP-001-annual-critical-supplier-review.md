# SIM-SUP-001 Annual review of critical suppliers: AWS, Microsoft, GitHub

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-SUP-001 |
| Authored | 2026-11-10 |
| Scenario date | 2026-07-06 |
| Participants | EMP-016 (Supplier Risk Coordinator, assessor), EMP-004 (Compliance Analyst, privacy and location), EMP-005 (Security Operations, security diligence), EMP-003 (business owner AWS and Entra ID), EMP-013 (business owner GitHub), EMP-002 (CISO, security recommendation), EMP-001 (Managing Director, decision) |
| Procedure exercised | [Supplier performance review ISMS-MON-02](../../../ISMS/08-monitoring-and-measurement/supplier-performance-review.md) sections 2 and 3; [supplier onboarding procedure ISMS-OPS-07](../../../ISMS/06-operational-procedures/supplier-onboarding-procedure.md) sections 2 to 4; [POL-VEN-01](../../../policies/vendor-management-policy.md) |
| Controls | ISO/IEC 27001:2022 Annex A A.5.19, A.5.20, A.5.21, A.5.22, A.5.23; clause 8.1 (externally provided processes); SOC 2 VM-01, VM-02, AC-17; GDPR Art. 28, Art. 44 to 46 |

## 1. Rule for this record

The reviewers record what **they checked**. No statement, report content, certificate or contract term is attributed to the suppliers. Every assurance fact is written as **to verify (see REAL-SUP-001)**. REAL-SUP-001 is a record in the real store, owned by another author; it is referenced here by ID only.

## 2. Population reconciliation (method step 1)

| Supplier ID | Service | Tier | Actual use at review | Business owner |
|---|---|---|---|---|
| SUP-01 | Amazon Web Services | Critical (would host customer data) | IAM Identity Center for workforce sign-in only (SIM-PPL-001). **No workload account.** Workload design has `ap-south-1` defaults in source versus the `eu-central-1` target | EMP-003 |
| SUP-02 | Microsoft Entra ID | Critical (workforce identity) | Lab tenant on the Free plan; staff sign-in in the fiction | EMP-003 |
| SUP-03 | GitHub | Critical (source, CI, change control) | In real use. Personal-account terms, per POL-VEN-01 section 8 | EMP-013 |

Source: [processor register](../../../GDPR/processor-register.md). It has no tier column; tiers above were set by EMP-016 using the onboarding procedure's rule.

## 3. Review results (template fields, section 3)

### 3.1 SUP-01 AWS

| Field | What the reviewer checked | Result |
|---|---|---|
| Source evidence | Whether a current SOC 2 Type II report or ISO/IEC 27001 certificate covers the services in the design (S3, RDS, ECS, KMS, CloudTrail, IAM Identity Center) and `eu-central-1` | to verify (see REAL-SUP-001). No report was downloaded in the fiction |
| Contract/DPA | Whether the AWS DPA applies to the account that runs Identity Center | to verify (see REAL-SUP-001). No contract record is held in the restricted folder |
| CUEC mapping | Customer responsibilities in the design: IAM, encryption keys, logging, backup, Region choice | Mapped to AC-02, AC-13, OP-03, AV-03, AV-04. All are Designed only |
| Location | Region in source | **Gap.** Source defaults to `ap-south-1`. GDPR transfer position cannot be settled (RISK-011, G09) |
| Incidents/availability | Identity Center sign-in failures seen by Ayka | Not measured. No log export kept. Workload: not measurable: no deployed system |
| Exit | RDS, KMS and identity export | Not tested. Workload is design only |

### 3.2 SUP-02 Microsoft Entra ID

| Field | What the reviewer checked | Result |
|---|---|---|
| Source evidence | Whether assurance covers Entra ID on the Free plan | to verify (see REAL-SUP-001) |
| Contract/DPA | Which terms apply to the lab tenant | to verify (see REAL-SUP-001) |
| CUEC mapping | MFA, Conditional Access, privileged roles, sign-in logs | **Gap.** The Free plan has no Conditional Access; `enable_conditional_access = false` in source. MFA requirement in POL-AC-01 section 4.2 is not met. Licence decision deferred on 2026-03-02 (SIM-GOV-001 R-04) |
| Location | EU Data Boundary applicability | to verify (see REAL-SUP-001); depends on tenant country, not checked |
| Incidents/availability | Ayka-side sign-in failures | Not measured. No sign-in log export kept |
| Exit | Emergency access if Entra ID is unavailable | Untested (RISK-013); two emergency accounts have no custody record (SIM-ACC-001) |

### 3.3 SUP-03 GitHub

| Field | What the reviewer checked | Result |
|---|---|---|
| Source evidence | Whether assurance covers GitHub Actions and repository hosting on the plan in use | to verify (see REAL-SUP-001) |
| Contract/DPA | Whether a DPA applies to a personal account | to verify (see REAL-SUP-001). The processor register notes that personal accounts fall under the privacy statement, not the DPA. EMP-004 treats this as an open gap |
| CUEC mapping | Branch rules, environment reviewers, token scope, artifact retention, secret scanning | Ruleset requires 0 approvals; environments allow self-review; secret scanning and push protection disabled; artifact retention 90 days. Mapped to CM-01, CM-05, AC-09, AC-14. CM-05 not met |
| Location | Hosting location | United States per the processor register. Transfer mechanism to verify (see REAL-SUP-001) |
| Incidents/availability | Ayka-side pipeline failures | M-02 sample shows no GitHub-caused failure in Q1 and Q2 (scenario value). No provider status claim used |
| Exit | Repository and history export | A full clone exists. Actions logs, environments, rulesets and PR review history are not in a clone. Not tested |

## 4. Recommendation and decision (method step 6)

| Supplier | CISO recommendation (EMP-002) | Scenario decision by EMP-001 | Conditions and due dates |
|---|---|---|---|
| SUP-01 AWS | Continue Identity Center; suspend any workload use until onboarding is complete | Agreed. No workload account may be opened | Onboarding diligence (procedure section 2) complete and Region fixed to `eu-central-1` before any workload account. Owner EMP-003. Trigger: before first workload account |
| SUP-02 Entra ID | Continue with conditions | Agreed | Licence or security-defaults decision at Q3 budget, by 2026-09-30. Owner EMP-001 |
| SUP-03 GitHub | Continue with conditions | Agreed | Decide organization plan with a DPA, or record why personal terms are acceptable, by 2026-09-30. Owner EMP-016 with EMP-004. Enable secret scanning and push protection by 2026-07-31. Owner EMP-002 (GitHub owner role, SIM-PPL-001) |

Next annual review due 2027-07-06. Event triggers: supplier incident, plan change, Region decision.

## Findings

1. **Two owners for one review.** The procedures make "Compliance & Risk Management" the owner. The personnel register names EMP-016 (Finance) as Supplier Risk Coordinator and "Supplier Security Oversight". Neither document says who runs the annual review. Name one role.
2. **No rule for a Critical supplier that is only partly in use.** AWS runs workforce sign-in today and is meant to host customer data later. The review template has one tier and one set of fields per supplier. Add "pre-activation" scope as a review type with its own minimum fields.
3. **"Independent reviewer" field without a rule.** Section 3 asks for an "independent reviewer" but never says independent of whom, or what they check. Nobody filled it here.
4. **Exit test has no minimum.** The onboarding procedure asks for "tested export feasibility when available". For GitHub, a clone looks like an exit but loses review history and environment settings, which are audit evidence. List the data each Critical supplier holds that the exit test must cover.
5. **Processor register lacks the tier column.** POL-VEN-01 section 8 already says so. The review cannot reconcile against it until it exists.

## What this does not show

- No supplier was contacted, no report was read and no contract record was examined. Every "to verify" item is still open.
- Nothing here is a statement by AWS, Microsoft or GitHub.
- The procedures are used as their text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
- The real [supplier performance review log](../../../ISMS/08-monitoring-and-measurement/supplier-performance-review.md) is still empty. That is correct.
