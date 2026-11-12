# Fraud and insider-risk assessment

| Field | Value |
|---|---|
| Document ID | RA-FRD-01 |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Assessment date | 2026-11-10 |
| Next review | Annually, and after any fraud or insider incident, a change of the approval model or a new privileged path |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company with a real repository. Scores below are the assessor's proposal under the [risk criteria](../ISMS/03-risk-management/risk-criteria.md). They are not entered in the [risk register](../ISMS/03-risk-management/risk-register.md); the CISO copies a scenario there when management accepts the assessment. This document answers SOC 2 criterion CC3.3 and control RA-02. It is a design: no fraud review has been carried out.

## 1. Purpose and method

Criterion CC3.3 asks management to consider the potential for fraud, including misuse of assets and management override, in assessing risk. This assessment follows the fraud triangle for each scenario: **incentive or pressure**, **opportunity** (what lets one person do it alone) and **rationalisation** (what the person tells themselves). Opportunity is the part controls can change, so the analysis concentrates on it.

Scope: the Ayka Portal system boundary in the [system description](../SOC2/01-system-description.md), the repository and pipeline, the identity design, and the people processes (hiring, expenses, suppliers). Fraud against customers by outsiders is covered by the threat scenarios catalogue and the incident response plan, not here.

Inputs: the [roles and responsibilities](../../organization/roles-and-responsibilities.md), the [change management policy](change-management-policy.md), the [access control policy](access-control-policy.md), the [break-glass procedure](../../Internal-IT/platform/domains/identity/docs/break-glass-procedure.md), the [code of conduct](code-of-conduct.md), the repository facts recorded in REAL-SOC2-001, and the single-maintainer reality of the repository.

## 2. Scenarios

Likelihood (L) and impact (I) use the 1 to 5 scales of the risk criteria. "Today" means what the repository shows now, not the design.

| ID | Scenario | Opportunity | Controls that apply | Gap today | L x I (proposed) |
|---|---|---|---|---|---|
| FRD-01 | **Self-approved change.** A maintainer merges a change that weakens the gate or hides a finding, approving their own work | The ruleset requires 0 approvals; environments allow self-review | CM-01, CM-02, CA-02, MO-01 (the regression job would catch a weakened rule), RA-04, monthly change review (SOC2-08 section 3) | CM-05 not met. The monthly review is done by the same person, so it detects only what is visible in metadata. REAL-SOC2-001 shows 0 approvals in 17 pull requests | 4 x 4 = 16 Critical |
| FRD-02 | **Exception abuse.** A rule is set aside in `exceptions.yaml` with a thin reason, or an expiry is pushed out repeatedly | One file, one author | RA-04 (reason, owner, expiry), monthly review lists every change to `exceptions.yaml`, CODEOWNERS on the file | CODEOWNERS review is not independent with one maintainer. 13 entries expire together on 2027-03-31 | 3 x 4 = 12 High |
| FRD-03 | **Break-glass misuse.** An administrator uses the emergency role to read data or change settings outside an incident | Break-glass role bypasses normal approvals | AC-08 (MFA trust policy, review within 24 hours), alert ALR-02 in STD-LOG-01 | The alert does not exist yet; the review needs a second person | 3 x 5 = 15 High |
| FRD-04 | **Customer data exfiltration by staff.** An engineer with production access copies customer evidence or exports it to a personal service | Production access is broad for the platform team; DLP is not selected | AC-04 (least privilege design), AC-07 (quarterly review), CO-01, CO-05 (no customer data outside production), acceptable use policy, CloudTrail (Designed) | No deployed logging, no data-egress monitoring, no alert on bulk reads | 3 x 5 = 15 High |
| FRD-05 | **Privilege creep and ghost accounts.** A leaver or mover keeps access, or someone creates an extra identity | Manual removal steps; no HR-to-identity automation | AC-01 (one identity per person), AC-06 (removal within one business day), AC-07 | Nothing applied. Leaver process exists only as a document | 4 x 4 = 16 Critical |
| FRD-06 | **Evidence tampering.** Someone edits or deletes compliance evidence, backdates a record, or re-runs a pipeline until it is green | Evidence is in the same GitHub account that produces it; artifacts expire after 90 days | IC-01 (checksummed bundle), CM-04, code of conduct section 2, the Object Lock bucket design (gap G7) | The checksum travels with the files and proves integrity, not authenticity. The Object Lock archive is not deployed | 3 x 4 = 12 High |
| FRD-07 | **Supplier or payment fraud.** A supplier is chosen or paid because of a personal interest, or an invoice is faked | One person selects and approves a supplier | VM-01, VM-02, conflict-of-interest rule in the code of conduct, supplier onboarding procedure | No payment process is documented. No second approver | 2 x 3 = 6 Medium |
| FRD-08 | **Expense and time fraud.** False expense claims or working time | Manager approval only | Line-manager approval; HR checks | No expense policy exists in this repository. Outside the SOC 2 scope; recorded for completeness | 2 x 2 = 4 Low |
| FRD-09 | **Management override.** Management instructs staff to skip a control, suppress a finding or change a customer commitment | Managing Director holds risk acceptance authority | Speaking-up channels (code of conduct section 4), CISO escalation to the Managing Director, management review minutes, external auditor | With one real person, there is no one to override and no one to refuse. Applies in full once a second person exists | 3 x 4 = 12 High |
| FRD-10 | **Insider sabotage.** A disgruntled administrator deletes backups, the evidence bucket or the Terraform state | Administrator rights on the account | SCPs (deny CloudTrail changes), Object Lock and vault lock in compliance mode (design), MFA, separation of the backup account (design) | Nothing deployed. State is local (RISK-002) | 2 x 5 = 10 Medium |

## 3. Detective checks that follow from the assessment

| Check | What it looks at | Who | Frequency | Where it is recorded |
|---|---|---|---|---|
| Monthly change review | Merged changes, approvals, checks, gate and pipeline files touched, exceptions added | A role independent of the authors where staffing allows; today the repository owner | Monthly | Change review record, first instance REAL-SOC2-001 |
| Exception review | Every entry in `exceptions.yaml`: reason still true, owner, expiry, number expiring on one day | CISO | Quarterly | Management security report (CE-06) |
| Break-glass review | Each use of the emergency role against a ticket or incident | A person other than the user | Per use, within 24 hours | Incident or change record |
| Access review | Leavers, movers, privileged roles, repository collaborators | Manager and CISO | Quarterly | Access review record (AC-07) |
| Supplier conflict check | Whether the person selecting a supplier declared an interest | Compliance & Risk Management | At onboarding | Supplier record |
| Whistleblowing channel test | A test message reaches the owner of the channel | CISO | Annually | Test note |

## 4. Conclusion and limits

With one real person holding every role, preventive separation of duties does not exist for FRD-01, FRD-03, FRD-09 and FRD-10. The assessment therefore relies on detection after the fact and on third-party evidence (GitHub and, later, AWS logs). The proposed top scores (FRD-01, FRD-05) match the open risk of unprotected approval in the register (RISK-005, RISK-004). The assessment is complete as a design; it becomes an operating control only when management approves it, the checks in section 3 run and their records exist.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-11-10 | First draft, written for SOC 2 control RA-02 |
