# SIM-CAPA-006 Corrective action: MFA not enforced for privileged access

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-CAPA-006 |
| Authored | 2026-11-10 |
| Scenario date | 2026-10-16 (opened from the audit report). Last update 2026-10-26 |
| Participants | EMP-021 (auditor, reporter), EMP-002 (CISO), EMP-003 (action owner), EMP-001 (licence decision) |
| Procedure exercised | [Corrective action procedure ISMS-OPS-08](../../../ISMS/06-operational-procedures/corrective-action-procedure.md) sections 2 to 5 |
| Controls | ISO/IEC 27001:2022 clause 10.2; Annex A A.8.5, A.5.17, A.8.2; SOC 2 AC-03, MO-03; NIS2 Art. 21(2)(j) (as customer expectation) |

## 1. Confirm and contain

| Field | Content |
|---|---|
| Source and date | Internal audit SIM-AUD-003, NC-02 (minor), 2026-10-16. Working paper WP-02 |
| Requirement | [POL-AC-01](../../../policies/access-control-policy.md) section 4.2 item 1: MFA for every interactive login to Entra ID, AWS and GitHub. OBJ-04 |
| Objective evidence | `enable_conditional_access` defaults to `false` in [`entra-id/variables.tf`](../../../../Internal-IT/platform/domains/identity/entra-id/variables.tf). Licence deferred 2026-03-02 (SIM-GOV-001 R-04). The 2026-09-30 decision date from SIM-SUP-001 passed with no decision |
| Consequence | 4 admin accounts and 6 Tier1 and 2 Tier0 Identity Center memberships (SIM-ACC-001) can sign in with a password alone in the design |
| Validated | Yes, 2026-10-09 |
| Correction | Interim: switch on Entra security defaults (all-user MFA) by 2026-11-06. Owner EMP-003 |

## 2. Cause

- A management resource decision (licence) was deferred to "the Q3 budget" with no owner or date in a tracked list. The supplier review set 2026-09-30, but nobody tracked it (same cause as SIM-CAPA-007).
- The design makes MFA a feature switch that defaults off. Nothing in the gate checks the identity roots.

Similar exposure: GitHub organization MFA requirement not checked in SIM-ACC-001. Added to the Q4 access review.

## 3. Plan

| Element | Content |
|---|---|
| Action and owner | CA-1: licences with Conditional Access for every Tier0 and Tier1 holder. Decision EMP-001 (taken 2026-10-26, SIM-MR-001 A-05). CA-2: `enable_conditional_access = true` in the design and a phishing-resistant method for Tier 0. Owner EMP-003. CA-3: GitHub organization requires two-factor sign-in. Owner EMP-002 (owner role) |
| Due date | Correction 2026-11-06. CA-1 to CA-3 by 2026-12-01 |
| Verification | Sign-in export for 30 days shows an MFA claim on 100 % of privileged sign-ins; test sign-in without MFA refused for each privileged account. Check date **2027-01-15**. Reviewer EMP-005, verified by EMP-021 |
| Risk/doc changes | RISK-003 and RISK-013 notes. SoA A.8.5 status review |

Status on 2026-10-26: **Action in progress.**

## Findings

1. **Resource-deferral is not a recognised state.** The procedure has no way to record "known failure, fix waits for money" between a nonconformity and a risk acceptance. The deferral on 2026-03-02 was neither. Add a step: a deferred requirement is either a time-limited risk acceptance or a nonconformity, never silence.

## What this does not show

- No tenant setting was changed. The real Terraform default is still `false`.
- The procedure is used as its text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
