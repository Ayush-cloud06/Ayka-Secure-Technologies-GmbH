# Vendor and Subservice Organization Management Policy

| Field | Value |
|---|---|
| Document ID | POL-VEN-01 |
| Classification | Internal |
| Owner | Compliance and Risk |
| Approver | CISO |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval |
| Status | Draft. Not approved |

## 1. Purpose

Ayka depends on a few large providers to run the Ayka Portal. Their failures become Ayka's failures, and in Ayka's SOC 2 report their controls are carved out and replaced by Ayka's monitoring of them. This policy says how vendors are selected, tiered, contracted, monitored and exited.

## 2. Scope

Every third party that stores or processes customer data, hosts or changes the system, or provides security-relevant services. Pure office suppliers without access to data or systems are out of scope.

## 3. References

| Framework | Requirement |
|---|---|
| SOC 2 | CC9.2, CC3.2; DC 7 (subservice organizations) |
| ISO/IEC 27001:2022 | A.5.19, A.5.20, A.5.21, A.5.22, A.5.23 |
| GDPR | Art. 28 (processors), Art. 44 to 46 (transfers) |
| Controls | VM-01, VM-02 |
| Related | [Processor and sub-processor register](../../GDPR/processor-register.md) |

## 4. Risk tiers

| Tier | Criteria | Due diligence before contract | Ongoing monitoring |
|---|---|---|---|
| **Critical** | Hosts production or customer data, or can change production; Ayka's SOC 2 carves out its controls | SOC 2 Type II (or ISO/IEC 27001 certificate with SoA, or BSI C5) reviewed; DPA; data location confirmed in the EU; exit plan | Annual report review with CUEC mapping; bridge letter; sub-processor change notices; status page subscription |
| **High** | Processes personal data or confidential data outside production (for example HR system, e-mail) | Security questionnaire or certificate; DPA | Annual questionnaire or certificate check |
| **Standard** | No access to confidential data | Contract terms only | Review at renewal |

## 5. Current critical vendors

| Vendor | Service | Tier | Carved-out controls (CSOCs) | Status (to verify) |
|---|---|---|---|---|
| Amazon Web Services | Hosting, storage, databases, KMS, logging | Critical | Physical security, media destruction, hardware availability, hypervisor isolation | AWS publishes SOC 2 Type II reports through AWS Artifact; not yet retrieved |
| Microsoft (Entra ID) | Workforce identity | Critical | Authentication availability; directory and signing-key protection | Microsoft publishes SOC 2 reports through the Service Trust Portal; not yet retrieved |
| GitHub | Source control, CI, artifacts | Critical | Repository integrity, ruleset and environment enforcement, runner isolation | GitHub publishes SOC reports for its enterprise products; whether one covers the plan in use is to verify |

## 6. Requirements

1. **Before contract.** No vendor gets customer or confidential data before due diligence for its tier is complete and the CISO has signed off. For processors of personal data, a DPA meeting GDPR Art. 28(3) is in place.
2. **Location.** Customer data stays in the EU. A vendor that needs access from outside the EU is recorded with its transfer mechanism and a transfer impact assessment.
3. **Report review.** For critical vendors, Compliance and Risk reviews the SOC 2 Type II report each year using the vendor review template in [SOC2-05](../05-audit-approach-and-evidence.md#72-vendor-review-vm-02). The review checks: the period covered and its gap to today; the opinion (a qualified opinion goes to the CISO); each testing exception and its relevance to Ayka; and each CUEC, which must map to an Ayka control.
4. **Subservice organizations of vendors.** If a critical vendor's report itself carves out a subservice organization relevant to Ayka (for example a colocation provider), that is recorded too.
5. **Changes.** Ayka subscribes to sub-processor change notices. A new sub-processor of a critical vendor is assessed within 30 days and customers are informed per the DPA.
6. **Incidents.** A vendor's security incident affecting Ayka is handled under the [Incident Response Plan](incident-response-plan.md).
7. **Exit.** For each critical vendor, the exit plan names how data is exported, how long migration would take, and how deletion is confirmed. Infrastructure is in Terraform, which keeps an AWS exit realistic for compute and networking but not for managed services such as RDS and KMS.
8. **Concentration.** Using Microsoft for identity and, through GitHub, for change management is a known concentration; it is recorded in the risk register.

## 7. Roles

| Activity | Requesting team | Compliance and Risk | CISO | Managing Director |
|---|---|---|---|---|
| Request a new vendor | R | C | I | |
| Tiering and due diligence | C | R | A | |
| Contract and DPA | C | R | C | A (signs) |
| Annual review | | R | A | I |
| Exit | R | C | A | I |

## 8. Current gaps

No vendor report has been retrieved or reviewed; the register in [Governance/GDPR](../../GDPR/processor-register.md) has no risk tier column; GitHub is the only vendor in real use and is used under a personal account and standard terms.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-06 | First issue |
