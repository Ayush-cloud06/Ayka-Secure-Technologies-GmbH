# User endpoint device policy

| Field | Value |
|---|---|
| Document ID | POL-END-01 |
| Owner | Cloud Platform Engineering |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or a supported-platform change, device loss or baseline failure |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company. These are proposed requirements; a written policy is not evidence that its controls operate.

## 1. Purpose and scope

Set a baseline for laptops, desktops, tablets and phones that access company information (ISO/IEC 27001:2022 A.8.1, A.8.7, A.8.19, A.7.9, A.7.10 and A.7.14). Requirements include removable media and device return. A device-management service has not been selected; this document is a Designed baseline, not an enrolled-device report.

## 2. Inventory and issue

Before issue, record asset ID, serial number, model, owner role, assigned custodian, classification, OS/support expiry, management status and return date in a private asset register. Never put serial numbers tied to real people or recovery keys in this public repository. The [asset inventory](../ISMS/02-asset-management/asset-inventory.md) records infrastructure design; it does not prove staff devices exist.

Cloud Platform Engineering verifies section 3 and records the result. HR & Administration records acceptance under [onboarding/offboarding](../ISMS/01-organization/onboarding-and-offboarding-procedure.md). A failed baseline blocks access to non-public information until corrected or excepted.

## 3. Minimum baseline

| Area | Required configuration | Verification evidence |
|---|---|---|
| Supported software | Supported OS and firmware; automatic updates; remediation deadlines from [vulnerability policy](vulnerability-and-patch-management-policy.md) | Version, support status and update report |
| Encryption | Full-disk encryption; recovery material stored separately with restricted, logged access; encrypted removable media only when approved | Management configuration and recovery test record; no key value in evidence |
| Identity and privileges | Named user; standard account for daily work; separate approved administration; MFA for company services | Account/privilege report and identity configuration |
| Screen and boot | Automatic lock after at most 5 minutes, authentication on wake; secure boot where supported | Baseline check |
| Protection | Supported anti-malware/EDR, host firewall, tamper controls, current definitions and alert routing | Health and alert-delivery report |
| Applications | Approved installation source and licence; remove unused applications; restrict macros and untrusted executable content | Software inventory and exception list |
| Data and backup | No Restricted local copies; minimise Confidential local storage; synchronise authorised work to approved storage; backup/recovery per data owner | Data-location review and recovery evidence |
| Interfaces | Block unapproved removable media; disable unused services; no exposed remote administration | Configuration report |
| Loss response | Ability to revoke sessions and isolate or wipe company data after approval, with an evidence-preservation decision | Tested response record |

Readings must identify the device, timestamp, expected baseline and pass/fail result. A selected vendor or installed agent is not a compliant-device measurement.

## 4. Use, loss and disposal

Users follow [acceptable use](acceptable-use-policy.md), [remote work](remote-work-policy.md) and [clean desk](clean-desk-and-clear-screen-policy.md). Report loss or compromise immediately; Security Operations assesses isolation, credential/session revocation, evidence preservation and remote wipe. A missing device is not assumed wiped because a command was queued.

Before reuse, repair outside company custody or disposal, Cloud Platform Engineering inventories local data, transfers required business records, selects a sanitisation method suitable for the media and encryption state, and verifies the outcome. Retain asset ID, method, performer, date, verification and destruction/service-provider reference. If reliable sanitisation cannot be verified, keep the media restricted pending destruction through an assessed supplier. Do not claim that ordinary file deletion sanitises a device.

## 5. Review, exceptions and gaps

Cloud Platform Engineering reviews baseline compliance monthly and after material changes; Security Operations follows missing or unhealthy devices. CISO exceptions name scope, owner, compensating protection and an expiry of at most 90 days. Lost devices, overdue patches and unsupported systems go to the [risk register](../ISMS/03-risk-management/risk-register.md).

Status: Designed by this policy. Device management, EDR, remote isolation/wipe, recovery-key storage, baseline checks, media-disposal records and device inventory are Planned (AC-16 and AC-18 in the [control matrix](../SOC2/03-control-matrix.md)). No device test or disposal has occurred.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
