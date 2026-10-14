# Remote work policy

| Field | Value |
|---|---|
| Document ID | POL-REM-01 |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or a change in working locations, access methods or relevant incident |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company. These are proposed requirements; a written policy is not evidence that its controls operate.

## 1. Purpose and scope

Protect company information when work occurs outside controlled premises (ISO/IEC 27001:2022 A.6.7, A.7.9 and A.8.1). Covers home working, travel, customer sites and temporary locations. Remote work is a proposed operating model; no evidence of a managed workforce exists.

## 2. Before access is allowed

HR & Administration records role, approved location/country, working arrangement and emergency contact in a private system. Cloud Platform Engineering verifies the [endpoint baseline](user-endpoint-device-policy.md), named account, MFA, least privilege and a working reporting route. The CISO assesses travel or access outside the approved jurisdiction; Compliance & Risk Management assesses data-access and transfer implications. Approval to work remotely does not itself approve a new data location.

Company-managed equipment is the default. Personal devices may not handle Confidential or Restricted data until a separately assessed arrangement provides equivalent isolation, support, data removal and privacy safeguards. No such arrangement is approved today.

## 3. Working rules

| Risk | Requirement |
|---|---|
| Household or visitor access | Separate work account; no shared sessions; lock on leaving the desk; secure storage when unattended; prevent others viewing meetings, screens or papers |
| Local network | Use maintained router software and a strong router administrator password; avoid open Wi-Fi. Use an approved encrypted remote access method for private services; do not expose SSH, RDP or administrative consoles to the public internet |
| Public places and travel | Keep devices in hand luggage; avoid sensitive calls and visible customer records; never leave equipment unattended in vehicles; use privacy screens where needed |
| Transfers and printing | Use approved company channels. No personal storage or home printing of Confidential/Restricted information without owner approval and secure disposal arrangements |
| Privileged work | Use dedicated administrative identity, MFA and a trusted device under [access control](access-control-policy.md). Break-glass is for documented emergencies, not convenience |
| Availability | Maintain a contact method independent of the affected work account and a safe alternate working location. Recovery targets follow [BCP/DR](business-continuity-and-disaster-recovery-plan.md); internet/power failures are not evidence that these targets can be met |
| Loss or compromise | Report immediately through [incident response](incident-response-plan.md); preserve evidence, disconnect a suspected device when safe and follow Security Operations' instructions |

A VPN is not currently configured or selected. Browser access to approved provider endpoints must use TLS; a VPN does not replace endpoint controls, MFA or per-service authorisation.

## 4. Ending or changing the arrangement

A changed country, device, role or network access method triggers reassessment before access continues. On leaving, Cloud Platform Engineering revokes sessions and credentials and arranges return or verified removal of company data under [onboarding/offboarding](../ISMS/01-organization/onboarding-and-offboarding-procedure.md). HR & Administration records return; the CISO approves and tracks unresolved losses.

## 5. Review and status

Review authorisations and device compliance quarterly, and after loss, compromise or a material change. Exceptions require CISO approval, reason, compensating controls and a maximum 90-day expiry. Employee monitoring and workspace assessments must be proportionate and assessed for privacy and employee-representation obligations before use; intrusive access to a home is not authorised here.

Status: Designed through this policy; operational verification is Planned. MFA is switched off in the [identity design](access-control-policy.md), device management is absent, no remote-work approvals exist and out-of-band incident communication is not established ([communication plan](../ISMS/00-context-and-governance/communication-plan.md)). These are prerequisites, not completed controls.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
