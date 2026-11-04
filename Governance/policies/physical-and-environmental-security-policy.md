# Physical and environmental security policy

| Field | Value |
|---|---|
| Document ID | POL-PHY-01 |
| Owner | HR & Administration |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or a new work location, facility supplier or equipment-maintenance arrangement |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company. These are proposed requirements. Naming a cloud provider does not prove that its facilities were assessed.

## 1. Purpose and scope

Set Ayka's duties for physical perimeters, entry, offices, physical monitoring, environmental threats, secure areas, supporting utilities, cabling and equipment maintenance (ISO/IEC 27001:2022 A.7.1 to A.7.6 and A.7.11 to A.7.13).

Clear desks (A.7.7), endpoint placement and off-site devices (A.7.8, A.7.9), storage media (A.7.10) and disposal (A.7.14) stay in the [clean desk policy](clean-desk-and-clear-screen-policy.md), the [remote work policy](remote-work-policy.md), the [endpoint policy](user-endpoint-device-policy.md) and the [retention policy](records-and-data-retention-policy.md). This policy does not repeat them.

The [system description](../SOC2/01-system-description.md) says Ayka operates no data centre and that the named Stuttgart office holds no production systems or customer data. No floor plan, badge system, visitor log, utility contract or maintenance contract is in this repository. Remote work is the people model in [POL-REM-01](remote-work-policy.md). Production hosting is a supplier duty until an assurance report is reviewed.

ISO 27001 keeps these controls applicable. A SOC 2 carve-out describes who would operate a facility. It does not remove Ayka's duty to obtain and read that provider's report. No report has been retrieved (VM-02 in the [control matrix](../SOC2/03-control-matrix.md)).

## 2. Who protects what

| Place | Ayka's duty | Someone else's duty | Evidence that would count |
|---|---|---|---|
| A person's home, travel location or a customer site | Apply remote-work and endpoint rules before non-public information is handled | The building owner controls the premises. Ayka does not inherit that control by visiting | Location approval, endpoint baseline, incident record if the device leaves the person's custody |
| Any future Ayka office | Assess the site before production data or administration is allowed there. Until then, do not claim office controls | The landlord, for the parts of the building Ayka does not control | A dated site note: perimeter, entry, visitors, locking, environmental risks and what was not inspected |
| AWS, Microsoft and GitHub facilities | Choose the supplier, record the expectation, and review the current assurance report and its exceptions | The supplier operates the facility | The report, its period, its scope and the review record under [POL-VEN-01](vendor-management-policy.md). A logo or a marketing page does not count |

Cloud Platform Engineering owns the supplier-facility expectation for AWS. HR & Administration owns work locations. Compliance & Risk Management records whether the assurance report was actually read.

## 3. Ayka workplaces

- Do not store production systems or customer data in a home or in the named office. The system description already states that limit for Stuttgart. This policy does not add a physical control that was not observed.
- Non-public work uses a company endpoint that meets [POL-END-01](user-endpoint-device-policy.md), a locked session, and the [clean desk policy](clean-desk-and-clear-screen-policy.md).
- Visitors, household members and coworkers do not use the company session. Lost devices follow the endpoint policy.
- Ayka designates no secure area of its own. If one is later required, the CISO writes who may enter, how entry is recorded and how the rule is checked before the area is used.
- Physical monitoring of people, including cameras, is out of scope until a works-council and legal check under [LR-11](../ISMS/00-context-and-governance/legal-and-regulatory-register.md) says it is allowed. No camera requirement is created here.

## 4. Supplier facilities

For AWS, Microsoft and GitHub, Ayka expects the supplier to provide a perimeter, controlled entry, protection of the equipment rooms, detection of unauthorised physical access, and protection against fire, water and loss of power, to the extent those threats affect the service Ayka buys. Those expectations are complementary controls in the [system description](../SOC2/01-system-description.md). They are unverified.

Before production use, the review records:

1. The report name, period and locations it covers, compared with the Region Ayka actually uses.
2. Exceptions that affect physical or environmental controls, and whether Ayka accepts them.
3. The gap if the report does not cover the service in the [processor register](../GDPR/processor-register.md).

The target Region is `eu-central-1`. Source still names `ap-south-1` (RISK-011). A report for the wrong Region does not close the review.

## 5. Utilities, cabling and maintenance

| Topic | Rule | What exists today |
|---|---|---|
| Supporting utilities (A.7.11) | Power and connectivity for a future office must be part of the site note. Cloud dependence on the provider's power and network is accepted only through the section 4 review. Home power and home internet failures are incidents to work around under [POL-BCDR-01](business-continuity-and-disaster-recovery-plan.md), not proof that recovery objectives are met | No office utility contract. No tested failover. Recovery targets are proposed and unvalidated |
| Cabling (A.7.12) | Ayka does not operate a data-centre cable plant. In a future office, network and power cables that leave a locked room are in the site note. At home, unused remote-administration ports stay closed under the endpoint and remote-work policies | No cable plant. No inspection record |
| Equipment maintenance (A.7.13) | Maintenance that can expose data is authorised, time-bounded and done by a named party. Media that leaves Ayka's custody is sanitised first, or the whole device stays controlled, under the endpoint policy. Supplier staff who need logical access follow the [supplier onboarding procedure](../ISMS/06-operational-procedures/supplier-onboarding-procedure.md) | No maintenance contract and no service record |

## 6. Status

Designed by this policy. G04 stays open: no work location has been assessed, and no supplier assurance report is on file. Do not describe Ayka as having a reception, a badge system, a generator or a secure room.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
