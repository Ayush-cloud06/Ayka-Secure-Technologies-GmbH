# SIM-PHY-002 Equipment and media disposal

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-PHY-002 |
| Authored | 2026-11-10 |
| Scenario date | 2026-06-17 |
| Participants | EMP-011 (Asset Custodian, performs the work), EMP-003 (second person for verification), EMP-002 (CISO, decisions), EMP-012 (HR, replacement hire), EMP-005 (consulted on evidence), EMP-009 (previous user of LT-009) |
| Procedure exercised | [User endpoint device policy POL-END-01](../../../policies/user-endpoint-device-policy.md) section 4 (use, loss and disposal); [Records and data retention policy POL-RET-01](../../../policies/records-and-data-retention-policy.md) sections 2 (device media row) and 5; [Data classification policy POL-DATA-01](../../../policies/data-classification-and-confidentiality-policy.md) section 5.3 (laptops and storage media row) |
| Controls | ISO/IEC 27001:2022 Annex A A.7.10, A.7.14; SOC 2 AC-18 |

Device tags (LT-nnn, MED-nn) are scenario tags. The [asset ownership register](../../../ISMS/02-asset-management/asset-ownership-register.md) has no row for single laptops, so no tag exists outside this fiction.

## 1. The three items

| Item | What it is | History | Question for the day |
|---|---|---|---|
| LT-023 | EMP-023's laptop, returned on 2026-05-29 ([SIM-PPL-004](../people/SIM-PPL-004-leaver-emp-023.md)) | Factory reset on 2026-06-02 by EMP-011. Marked "reassignable". **No wipe certificate** and no record of the encryption state. It held recruitment files and personnel data (Confidential) | Can it go to the replacement hire starting 2026-07-01? |
| LT-009 | EMP-009's laptop | Failed the baseline on 2026-05-20: operating system out of support ([SIM-END-001](../endpoint/SIM-END-001-endpoint-baseline-check.md)). Replaced on 2026-05-25. Disk encryption was on at the check, recorded by EMP-011 | Retire. What happens to the disk? |
| MED-03 | A USB stick found in a drawer on 2026-05-11 ([SIM-PHY-001](SIM-PHY-001-office-and-home-workplace-security-assessment.md)) | No label, no owner, no register entry, encryption unknown. Kept in the cabinet since | Reuse, destroy or keep? |

## 2. Walk of POL-END-01 section 4

The policy says: before reuse, repair outside company custody or disposal, inventory local data, transfer the business records that are needed, choose a sanitisation method suitable for the media and its encryption state, and verify the result. Keep asset ID, method, performer, date, verification and the destruction or service-provider reference. If reliable sanitisation cannot be verified, keep the media restricted pending destruction through an assessed supplier. "Do not claim that ordinary file deletion sanitises a device."

### LT-023 (reissue)

| Step | Result |
|---|---|
| Inventory of local data | Not possible. The disk was reset on 2026-06-02. What it held before that was never listed. EMP-012's handover note of 2026-05-29 says recruitment files were moved and "personal copies removed" |
| Business records transferred | Yes, before the reset (SIM-PPL-004) |
| Method used on 2026-06-02 | "Factory reset". The tool and the option are not recorded. Whether it erased the disk or only reinstalled the system is unknown |
| Encryption state at return | Not recorded. Device management does not exist, so no console can say |
| Verification | None on 2026-06-02. EMP-011 offered to re-run a reset with a full storage erase now and have EMP-003 confirm that the disk shows no previous partition |
| Policy test | The policy says reliable sanitisation must be verifiable. The first reset cannot be verified after the fact. A second erase would be verifiable for the data that exists now, but says nothing about what a drive may retain on parts it does not address |
| Decision | Scenario decision by EMP-002: **do not reissue LT-023.** It is kept restricted in the locked cabinet pending destruction. The replacement hire gets a new device (ordered on 2026-06-18) |
| Cost of the decision | One new laptop, about three weeks of lead time (scenario value). EMP-011 argued for reissue after a second erase; EMP-002 declined because the original reset left no proof |
| Record | Asset ID LT-023; method (reset, unverified); performer EMP-011; date 2026-06-02; verification none; status "restricted, pending destruction" |

### LT-009 (retirement)

| Step | Result |
|---|---|
| Inventory of local data | EMP-009 confirmed on 2026-05-25 that his files are in the approved cloud storage. A search for local copies of customer proposals found 11 files (Confidential). Copied to the approved location. Originals removed |
| Encryption state | On, recorded 2026-05-20. EMP-011 had the recovery key from the escrow location noted in SIM-END-001 |
| Method | Cryptographic erase: destroy the disk key, re-initialise the disk, install a clean system |
| Verification | EMP-003 booted the device and checked that no readable partition or old user profile existed. No forensic tool was used. Recorded as "no previous data accessible by normal tools" |
| Certificate | **No template exists** (SOC 2 AC-18 says a wipe certificate template exists; none is in the repository). EMP-011 wrote one in a text file: asset ID, method, performer, verifier, date, result. Held in the restricted IT folder |
| Disposal | Released to a local refurbisher. The refurbisher is not on any supplier list. The policy requires an "assessed" supplier. POL-VEN-01 puts suppliers without access to data or systems out of scope; after a verified erase, EMP-002 treated the device as holding no data (scenario decision) |

### MED-03 (found USB stick)

| Step | Result |
|---|---|
| Owner | Unknown. EMP-011 asked in the staff chat on 2026-05-12 and 2026-06-10. No answer |
| Contents | Not opened. Opening an unknown stick on a company laptop is itself a risk (POL-END-01 section 3: block unapproved removable media). EMP-011 did not mount it |
| Encryption | Unknown |
| Sanitisation | Cannot be verified for an unknown device |
| Decision | Scenario decision by EMP-002: restricted. **Destruction was not possible: no assessed destruction supplier exists.** EMP-011 will not destroy it himself (the policy says assessed supplier). It stays in the cabinet with a label, a register line and a date |
| Media register | None existed. EMP-011 created a list with MED-01 to MED-03 (two other sticks found in a drawer, both now labelled and returned to their owners) |

## 3. Outcome on the scenario date

| Item | Result | Status |
|---|---|---|
| LT-023 | Not reissued. Held restricted. No certificate possible | Open: waits for an assessed destruction supplier |
| LT-009 | Sanitised, verified by a second person, certificate written. Released to a refurbisher | Closed, with the supplier issue |
| MED-03 | Held restricted. No owner found | Open |
| Replacement for LT-023 | New laptop ordered. Baseline check due on delivery | Open |

Decision on the supplier: EMP-016 (Supplier Risk Coordinator) was asked on 2026-06-17 to find an assessed destruction service. No assessment criteria exist in POL-VEN-01 for a service of this type (see Finding 4). No supplier is chosen.

## Findings

1. **Sanitisation cannot be verified after the fact.** POL-END-01 requires verification but names no method that works on a device that was already reset. A device that left custody without a certificate becomes an unrecoverable item. The policy should say that a missing certificate means "treat as not sanitised".
2. **No wipe certificate template.** POL-END-01 section 6 says a wipe-certificate template exists (SOC 2 AC-18 Designed). None is in the repository. The same gap was seen in [SIM-PPL-004](../people/SIM-PPL-004-leaver-emp-023.md) finding 8.
3. **The reset method is not defined.** "Factory reset" is not a sanitisation method. The policy must state which methods are acceptable for which media and encryption state, even if the list is short (crypto erase for encrypted laptop disks, destroy for unknown media).
4. **"Assessed supplier" has no criteria.** The policy needs a destruction supplier. POL-VEN-01 has tiers for hosting and processing but no tier or criteria for a destruction or refurbishing service. Today the policy can only end in "keep restricted".
5. **No media register.** POL-RET-01 and POL-END-01 speak of tracking media, but no register exists and no owner is named. MED-03 was found by chance.
6. **Unknown found media has no rule.** The policy does not say how to treat an unlabelled device found on premises (do not connect, report, hold). EMP-011 improvised.
7. **Encryption state is not captured at return.** The offboarding checklist records a device as returned in "good condition" but not whether disk encryption was on. That fact decides the sanitisation method.
8. **Reuse of a verified-erased device has no approval rule.** The policy does not say who may release a device for reuse, nor whether a lower-sensitivity role may reuse a device from a higher-sensitivity role.

## What this does not show

- No laptop, USB stick, disk or refurbisher exists. Tags, counts and dates are scenario values.
- No erase tool was run and no certificate was written. The certificate fields in section 2 are the ones the walk needed, not an approved template.
- That a cryptographic erase is a sufficient method for a given disk. The standards that describe sanitisation were not consulted and no statement of any standard is claimed.
- Whether personal data of the leaver on the laptop needed a deletion record under GDPR.
- Loss, theft or remote wipe of a device. Not exercised.
