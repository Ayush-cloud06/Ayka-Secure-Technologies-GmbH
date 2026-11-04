# Personnel screening criteria

| Field | Value |
|---|---|
| Document ID | ISMS-01-04 |
| Owner | HR & Administration |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or a change in role tiers, hiring law or a screening incident |
| Status | Draft. Not approved: no approval record exists (simulated company) |

Ayka Secure Technologies GmbH is a simulated company. These are proposed checks for a future hire. Nobody has been screened. The [personnel register](../../../organization/personnel-register.md) is fictional and is not a screening file.

## 1. Purpose and legal boundary

ISO/IEC 27001:2022 A.6.1 asks for verification of personnel proportionate to the information they will handle and the risk of the role. This document is that design. It is not a legal opinion.

German rules on employee data, including BDSG § 26, and the effect of CJEU case C-34/21, are **to verify** before any check is used. The same caveat is in the [legal register](../00-context-and-governance/legal-and-regulatory-register.md) (LR-02) and the [processing record](../../GDPR/record-of-processing-activities.md) (PA-01). A certificate of good conduct (Führungszeugnis) is not the default. It is considered only for Tier 0, only with a written necessity for that role, and only after that legal point is confirmed. Credit records, health data and private social-media review are out of scope for every role.

Collect the minimum. Do not copy identity documents, references or certificates into this public repository. The [retention policy](../../policies/records-and-data-retention-policy.md) requires a purpose and an expiry before personnel records are collected; that schedule is not approved.

## 2. Checks by role

Tiers are the groups in the [identity architecture](../../architecture/identity-architecture.md) and [access control policy](../../policies/access-control-policy.md): Tier 0 security administration, Tier 1 infrastructure operators, Tier 2 developers. The check is required before the access in the middle column, not before a contract is discussed.

| Role group | Before this access | Required checks | Not required |
|---|---|---|---|
| Tier 0 | Identity-provider administration, AWS Organizations administration, break-glass custody | Identity of the person; authenticity of the employment or contractor agreement; two professional references, or one prior-employer confirmation where a second reference is not lawful or not available; CISO writes why any certificate of good conduct is necessary | A certificate as a standard step; private-life investigation |
| Tier 1 | Infrastructure operator permissions, Terraform state, CI secrets | Identity of the person; authenticity of the agreement; one professional reference | Certificate of good conduct |
| Tier 2 and other staff | Repository access and non-privileged company accounts | Identity of the person; authenticity of the agreement and, where the role requires it, the right to work | A background-agency report |
| Contractor with no system account | Confidential information under an NDA only | The contract and the [NDA template](nda-template.md) | An identity-document copy in the screening file |

HR & Administration performs the checks. The receiving function owner confirms the role. The CISO confirms Tier 0 before any privileged account is requested under the [user access procedure](../06-operational-procedures/user-access-procedure.md). A passed screen does not grant access. A failed or refused check stops provisioning; the person is told what was decided and may respond. The [disciplinary process](disciplinary-process.md) is not a substitute for that conversation.

Contractors and employees use the same tier table. A supplier's own screening is additional evidence under the [supplier onboarding procedure](../06-operational-procedures/supplier-onboarding-procedure.md). It does not replace Ayka's check when the person receives an Ayka account.

## 3. Record

One restricted record per person, created only when a real engagement starts:

| Field | Content |
|---|---|
| Person and role | Reference used in the private HR record, not a copy of an identity document |
| Tier and access sought | The row in section 2 |
| Checks performed | Which rows were done, the date, and the role that did them |
| Result | Proceed, proceed with a named limit, or stop |
| Certificate decision | Not requested, or the CISO's necessity note |
| Reviewer | A role other than the person screened. With one maintainer, record that independence was not available (RISK-005) rather than inventing a second reviewer |
| Expiry | Re-screen on move to a higher tier, and when the agreement ends |

The [onboarding procedure](onboarding-and-offboarding-procedure.md) points here from the joiner stage. Do not create a row for the fictional register.

## 4. Status

Designed by this document. SOC 2 control CE-04 is **Designed**: the criteria exist and no joiner has been screened. G01 stays open for the same reason, and because no counsel has confirmed the Tier 0 certificate rule.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
