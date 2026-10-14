# Acceptable use policy

| Field | Value |
|---|---|
| Document ID | POL-AUP-01 |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or a material misuse event or new class of company tool |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company. These are proposed requirements; a written policy is not evidence that its controls operate.

## 1. Purpose and scope

Define permitted use of company information, identities, endpoints, networks and services by staff and contractors (ISO/IEC 27001:2022 A.5.10, A.6.3 and A.8.19). The rules apply both in the office and remotely. The [onboarding procedure](../ISMS/01-organization/onboarding-and-offboarding-procedure.md) supplies the acknowledgement record; no acknowledgement exists today.

## 2. Permitted use and responsibilities

Use assigned assets for authorised work within the access granted. Protect information under [classification](data-classification-and-confidentiality-policy.md); use named identities and [authentication rules](access-control-policy.md). Staff must ask the information owner before sharing non-public material with a new recipient or service.

| Area | Rule |
|---|---|
| Accounts and credentials | Do not share accounts, passwords, tokens or MFA prompts. Verify unexpected authentication requests; use approved password storage. Privileged accounts are used only for authorised administration |
| Software and services | Install only reviewed, licensed software through the authorised change/install process. CISO approval is required for a new service handling non-public data; supplier assessment remains mandatory |
| Data movement | No customer evidence, credentials or real HR records in public Git, public issues, personal e-mail, unapproved cloud drives or unapproved automated processing tools |
| Network use | No unauthorised scanning, interception, bypass of access controls or connection of unapproved devices. Testing requires written scope and asset-owner authorisation |
| Messages and browsing | Check recipients and links; report suspected phishing. Do not download or execute untrusted attachments, macros or scripts. No unlawful, harassing or discriminatory use |
| Personal use | Limited incidental use only if it creates no cost, security exposure, prohibited content or interference with work. Company controls still apply; avoid storing private material on company assets |
| Publication and licences | Obtain owner approval before publication; check confidentiality, third-party rights and contract restrictions. A public repository exposes its contents regardless of an Internal label |
| Equipment | Prevent access by household members and visitors; do not disable protection or connect unknown removable media. Follow [endpoint](user-endpoint-device-policy.md), [remote-work](remote-work-policy.md) and [clear-screen](clean-desk-and-clear-screen-policy.md) requirements |

## 3. Reporting and fair handling

Report lost devices, misdirected data, suspicious prompts and suspected misuse immediately to Security Operations or the CISO through the [communication plan](../ISMS/00-context-and-governance/communication-plan.md). Preserve relevant information and do not investigate other people's accounts yourself. A missing monitored reporting channel is an open gap.

Monitoring must have a defined security purpose, proportionate scope, access restrictions, retention and staff notice. Covert or unrestricted monitoring is not authorised by this policy. Compliance & Risk Management and HR & Administration assess privacy and any employee-representation requirements before a monitoring system starts.

Good-faith reporting is encouraged; accidental errors prompt containment and learning. Alleged misconduct follows the [disciplinary process](../ISMS/01-organization/disciplinary-process.md), with fact-finding and an opportunity to respond. This policy does not impose an automatic penalty.

## 4. Exceptions, review and status

CISO exceptions record purpose, scope, compensating measures and an expiry of at most 90 days; they cannot waive legal or contract duties. HR & Administration issues this policy before access and at material changes; the CISO reviews acknowledgements annually.

Status: Designed, evidenced by this policy and the [training programme](../../organization/training-and-awareness.md). No acceptance records, managed endpoint fleet, monitoring programme or completed training exists. Public Git and CI are real; those systems do not demonstrate staff adherence.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
