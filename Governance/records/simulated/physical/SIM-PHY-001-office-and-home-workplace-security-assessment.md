# SIM-PHY-001 Office and home workplace security assessment

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-PHY-001 |
| Authored | 2026-11-10 |
| Scenario date | 2026-05-11 (Stuttgart office) and 2026-05-12 (home sample, by video call) |
| Participants | EMP-011 (assessor, Asset Custodian), EMP-012 (co-assessor, HR & Administration, owner of work locations); EMP-002 (CISO, decisions); EMP-003 (Tier 0, one home in the sample); EMP-007, EMP-009, EMP-022 (homes in the sample) |
| Procedure exercised | [Physical and environmental security policy POL-PHY-01](../../../policies/physical-and-environmental-security-policy.md) sections 2, 3 and 5; [Clean desk and clear screen policy POL-DESK-01](../../../policies/clean-desk-and-clear-screen-policy.md) sections 2 and 3; [Remote work policy POL-REM-01](../../../policies/remote-work-policy.md) sections 2 to 5 |
| Controls | ISO/IEC 27001:2022 Annex A A.7.1, A.7.2, A.7.3, A.7.7, A.7.8, A.7.9, A.7.11, A.7.12, A.7.13, A.6.7. Looked at but not raised: A.7.4, A.7.5, A.7.6 (section 6). SOC 2 CC6.4 (physical access) |

All facts about the office, the homes and the people in it are scenario values. Nothing was inspected. The policies are used as their text stands on the Authored date and are treated as in force at the scenario date.

## 1. Frame

- POL-PHY-01 section 2 says an Ayka office is assessed before production data or administration is allowed there, and the result is a dated site note. POL-DESK-01 section 3 asks HR & Administration for a quarterly workplace check "once premises and staff exist". POL-REM-01 section 5 asks for a quarterly review of remote-work authorisations.
- Scenario: the Stuttgart office is one rented floor in a shared commercial building. Of the 24 staff, 11 work there two or three days a week (hybrid) and 13 work from home. The system description says the office holds no production systems or customer data. That limit is the premise of the whole assessment.
- Method chosen by EMP-011 and EMP-012 on 2026-05-11: office walk-round with a checklist built from POL-PHY-01 section 2, the "what is not inspected" field filled last. Homes: a self-declaration checklist built from POL-REM-01 section 3, then an optional video call. The policy says intrusive access to a home is not authorised, so no one was asked to show their home.

## 2. Office site note (2026-05-11)

| Item | Observed (scenario) | Policy rule | Result |
|---|---|---|---|
| Perimeter (A.7.1) | The street door and lift lobby belong to the landlord. Ayka controls only its own door on the floor | POL-PHY-01 section 2: the landlord controls what Ayka does not | Recorded. Ayka's perimeter is one door. No landlord document was requested (section 7, item 3) |
| Entry (A.7.2) | Office door has a key lock. 14 keys exist. No key register. Nobody knows whether the landlord holds a master key | Entry rules written, "no local control" in the SoA | **Exception X-1**: key holders cannot be listed |
| Visitors (A.7.2) | Visitors ring and are admitted by whoever is in. No visitor book. No escort rule in practice | POL-DESK-01 table: escort visitors "under local access arrangements" | **Exception X-2**: no arrangement exists |
| Office protection (A.7.3) | Windows on the first floor, lockable. One lockable cabinet for paper (HR files). Meeting room has a whiteboard | Office limit stated in the policy | Recorded. The cabinet is the only locked storage for 11 hybrid staff (X-3) |
| Supporting utilities (A.7.11) | Mains power from the building. No UPS. Internet through one ISP line and a single router. No second line | POL-PHY-01 section 5: utilities are part of the site note | Recorded. A power or line failure sends staff home. Work from home is the fallback and was not tested |
| Cabling (A.7.12) | Network cables run through a patch cupboard shared with another tenant. The cupboard is not locked by Ayka | Section 5: cables that leave a locked room go in the site note | **Exception X-4**: cables leave the locked room and nobody can say who has the cupboard key |
| Environmental (looked at for A.7.5) | Smoke detector in the corridor, one extinguisher, no water-sensitive equipment on the floor | Environmental duty sits mainly with the provider | Recorded, not used to raise A.7.5 (section 6) |
| Not inspected | Landlord's fire plan and alarm tests, building access logs, cleaning contractor vetting, the neighbouring tenant's access to the cupboard | "Record what was not inspected" | Listed |

Production check: no server, no NAS, no customer data on paper or on a shared drive. EMP-011 checked the three laptops in the meeting room cabinet and the printer's stored jobs: empty (scenario). The premise holds on the day.

## 3. Clear desk and equipment placement (2026-05-11, A.7.7 and A.7.8)

Walk of 8 desks and the meeting room at 17:45 (after most people left).

| Check | Result |
|---|---|
| Screens locked | 7 of 8 locked. One laptop open and unattended with a chat window visible (EMP-007's desk: he was in a call in the next room) |
| Papers | 2 desks with printed architecture diagrams (Internal). One desk with a handwritten page containing a password reset code (**X-5**). The code was expired. Contents not copied here |
| Media | One unlabelled USB stick in a drawer. Handled in [SIM-PHY-002](SIM-PHY-002-equipment-and-media-disposal.md) |
| Meeting room | Whiteboard shows a customer name and a pilot start date. Not erased after the meeting |
| Waste | No secure destruction bin. Paper goes to ordinary recycling (**X-6**) |
| Equipment location | Laptops sit on desks next to windows facing the corridor. No privacy filters. Docking stations are not locked down |

Automatic screen lock (a technical setting) was not checked here. POL-DESK-01 gives that to Cloud Platform Engineering. It is part of [SIM-END-001](../endpoint/SIM-END-001-endpoint-baseline-check.md).

## 4. Maintenance event on paper (2026-05-12, A.7.13)

Scenario: the ISP technician comes on 2026-05-12 to replace the router after a line fault. This tests POL-PHY-01 section 5, which says maintenance that can expose data is authorised, time-bound and done by a named party.

| Step | What happened |
|---|---|
| Authorisation | EMP-011 asked EMP-012 by chat. EMP-012 said yes. Nothing was written down. There is no authorisation form |
| Named party | The visit was booked by the landlord's agent. The technician's name was not known beforehand |
| Time bound | Window "between 09:00 and 12:00". Real arrival 11:20, leave 11:50 |
| Supervision | EMP-012 stayed in the room. The patch cupboard was opened by the technician with the shared key |
| Data exposure | No Ayka media left the office. The old router went back to the ISP. It holds a Wi-Fi password (scenario) that was **not** changed afterwards (**X-7**) |
| Record | EMP-011 wrote a three-line note afterwards |

The rule was followed in spirit, not in form. The policy does not say what record is required, and it is silent on network equipment that carries credentials.

## 5. Home sample and remote-work approvals (2026-05-12, A.6.7, A.7.8, A.7.9, A.7.7)

POL-REM-01 section 2 lists what must be true before remote access is allowed: role, location and country recorded by HR; endpoint baseline verified; named account; MFA; least privilege; a working reporting route.

**Approval records.** EMP-012 searched for the HR record of each of the 13 full-remote staff. Location and working arrangement were on file for 9. For 4 (EMP-009, EMP-016, EMP-022, EMP-024) only an address from the contract existed, with no approved working location or emergency contact (**X-8**). All 13 work in Germany (scenario).

**Sample.** Four homes were chosen by EMP-012: EMP-003 (Tier 0), EMP-007 (Tier 2, repository write), EMP-009 (customer data in sales mail), EMP-022 (marketing). Each filled in a one-page declaration based on section 3 and offered an optional video call. EMP-003 and EMP-009 accepted the call. The video call showed a desk and a door, nothing more.

| Section 3 risk | Result for the four |
|---|---|
| Household or visitor access | Separate room: 2 of 4. EMP-009 works at a shared table. EMP-022 shares the room with a partner and has no lockable storage (**X-9**) |
| Local network | Router firmware current: declared by 3, not known by 1. Router administrator password changed from default: declared by 3. Nobody can check it. Open Wi-Fi never used: 4 of 4 declared |
| Remote administration ports | "Unused remote-administration ports stay closed": nobody could say what a port is on their router. Home remote-admin on the router is unknown for all 4 |
| Transfers and printing | EMP-009 prints customer proposals at home on a personal printer (Confidential). No secure disposal arrangement (**X-10**) |
| Privileged work | EMP-003 uses a dedicated admin identity for Tier 0 and the same laptop for daily work. Section 3 requires a trusted device. Whether this laptop is trusted depends on the baseline in SIM-END-001 |
| Availability | Independent contact method: 3 of 4 have a private phone number on file. EMP-007's is missing. Safe alternate location: none named by anyone |
| Loss or compromise | All four know to "tell someone". None knows a mailbox or number, because none exists |

**Prerequisites that fail for everyone.** MFA is not enforced (Entra Conditional Access is off), device management does not exist, and there is no reporting channel. POL-REM-01 section 5 says so in its own status line. With those three unmet, no one of the 24 can pass section 2 as written.

Scenario decision by EMP-002 on 2026-05-12: remote work continues. The three prerequisites are recorded as gaps owned by the endpoint workstream (G07) and the identity workstream (G02). **No exception was raised.** POL-REM-01 section 5 allows an exception with a reason, compensating controls and an expiry of at most 90 days. Nobody asked for one and the gap is open ended (see SIM-CAPA-006, where the same silence was found by audit).

## 6. What was looked at and not raised

| Control | Why the walk does not support a higher status |
|---|---|
| A.7.4 Physical monitoring | POL-PHY-01 section 3 creates no monitoring requirement and defers cameras to a works-council and legal check (LR-11). There is nothing to walk. The provider's detection is reported in a report that was never read (SIM-SUP-001 records the AWS facts as to verify) |
| A.7.5 Environmental threats | The office line in section 2 is one field of a site note. The policy gives the real duty to the provider review in section 4. That review has not been walked: SIM-SUP-001 did not read any physical or environmental section |
| A.7.6 Secure areas | Ayka designates none. A control for an area that does not exist cannot be walked |

## 7. Results and decisions (scenario)

| Ref | Item | Decision | Owner | Due |
|---|---|---|---|---|
| X-1, X-2 | Key list, visitor arrangement | Create a key list and a visitor book. Ask the landlord who holds a master key | EMP-012 | 2026-05-29 |
| X-3 | One lockable cabinet | Buy two more lockable pedestals for hybrid desks | EMP-012 | 2026-06-12 |
| X-4 | Cables in a shared cupboard | Ask the landlord for a locked cupboard or a lock for Ayka's part | EMP-011 | 2026-06-12 |
| X-5, X-6 | Expired reset code on paper; no destruction bin | Remind staff. Order a secure destruction bin. Treat the paper as an exposure of an expired code: no incident | EMP-012 | 2026-05-29 |
| X-7 | Router credentials | Change the Wi-Fi password and the router administrator password | EMP-011 | 2026-05-13 |
| X-8 | 4 missing location records | Collect and record them | EMP-012 | 2026-05-29 |
| X-9, X-10 | Shared room; home printing | EMP-022: privacy screen and lockable box supplied. EMP-009: stop home printing. Use the office | EMP-012 | 2026-06-05 |
| Item 3 | Landlord documents (fire plan, alarm tests, access logs) | Requested. No answer is recorded in this simulation | EMP-012 | Open |
| Gaps | MFA, device management, reporting route | Already tracked. Not re-opened | EMP-002 | Open |

Status on the scenario date: the office site note and the home sample are done. X-8 and the landlord request are open.

## Findings

1. **POL-PHY-01 gives no template for the site note.** Section 2 names the fields in prose. EMP-011 and EMP-012 had to invent a table. Provide a table with a "not inspected" column.
2. **No check for who holds keys.** Entry for a small tenant is a key lock. The policy asks for "entry" without saying that a key list and a master-key answer are the minimum.
3. **Visitor and cleaner handling depends on "local access arrangements".** POL-DESK-01 section 2 says escort visitors "under local access arrangements". The policy does not create one. Where none exists, the rule cannot be followed.
4. **Maintenance has no record rule.** POL-PHY-01 section 5 requires authorisation but no written form, no name check on arrival, and says nothing on network equipment that holds credentials. A returned router with a stored Wi-Fi password is a gap in the rule.
5. **Home assessment has no method.** POL-REM-01 gives risks but no way to assess them without entering a home. A self-declaration cannot be checked. Say that this is accepted, or provide a lighter check (for example a photo of the router label with the administrator password hidden).
6. **Section 2 of POL-REM-01 cannot be met by any employee today.** MFA, device management and a reporting route are preconditions, and the same document says none exists. The policy does not say whether remote work may continue meanwhile, nor who may waive a precondition. The CISO decided to continue without an exception.
7. **Quarterly workplace check has no first date.** POL-DESK-01 says "quarterly once premises and staff exist". Both exist from 2026-01. Nothing triggered the first check; this one was set up by HR.
8. **No secure disposal requirement is operable.** POL-DESK-01 says use secure destruction storage or an assessed disposal service. Neither exists, and nobody owns buying it.
9. **The home sample rule is missing.** The policy asks for reviews of authorisations but gives no sample size or method. EMP-012 chose four homes by role risk.

## What this does not show

- No office, building or home exists. The landlord, the ISP technician and the neighbour tenant are scenario placeholders. No statement by any of them is recorded.
- No inspection, key count or video call took place. Counts and times are scenario values.
- Nothing about AWS, Microsoft or GitHub facilities. A.7.4 to A.7.6 stay at Designed for that reason.
- No equipment baseline reading. See SIM-END-001.
- Whether works-council or privacy rules allow a workplace check of this kind (LR-11 is conditional and unverified).
