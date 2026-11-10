# SIM-GOV-002 Authority and community contacts check

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-GOV-002 |
| Authored | 2026-11-10 |
| Scenario date | 2026-04-14 |
| Participants | EMP-002 (CISO, owner of the communication plan), EMP-018 (Governance & Risk Analyst, builds the contact register), EMP-004 (Compliance Analyst, GDPR Lead, privacy authority contact), EMP-005 (Incident Coordinator), EMP-014 (Security Engineer, community and advisory sources) |
| Procedure exercised | [Communication plan ISMS-00-08](../../../ISMS/00-context-and-governance/communication-plan.md) sections 3 (rows IC-E-02, IC-E-03, IC-E-05, IC-E-08, IC-E-09), 4 and 6; [Incident reporting procedure NIS2-03](../../../NIS2/03-incident-reporting-procedure.md) sections 5 to 7; [Threat intelligence procedure ISMS-OPS-09](../../../ISMS/06-operational-procedures/threat-intelligence-procedure.md) section 2 |
| Controls | ISO/IEC 27001:2022 Annex A A.5.5 (raised); A.5.6 (looked at, not raised). SOC 2 IC-03 |

Real authorities are named only as counterparts in contact entries. **No reply, statement, form content, phone number or policy position of any authority is recorded or invented.** No authority was contacted.

## 1. What the plan says

Authorities appear in four rows of the plan:

| Row | Authority | Trigger | Who | Channel |
|---|---|---|---|---|
| IC-E-02 | LfDI Baden-Württemberg (data protection supervisory authority) | Personal-data breach where Ayka is the controller | GDPR Lead, approved by the Managing Director | The authority's online form |
| IC-E-03 | BSI (Federal Office for Information Security) | Significant incident. Not required on the current working assessment of NIS2-01. Voluntary reporting possible | CISO decides | NIS2-03 section 5 and template T-2 |
| IC-E-05 | Police cybercrime unit (Zentrale Ansprechstelle Cybercrime, LKA Baden-Württemberg) | A crime is suspected and the Managing Director agrees | Managing Director | NIS2-03 section 7 |
| IC-E-08 | AWS, Microsoft, GitHub (suppliers, not authorities) | Support or abuse case | Cloud Platform Engineering | Provider portals |

Section 4 states that no security mailbox, on-call number, out-of-band channel or customer contact list exists. The plan "supplies no live contact endpoint".

## 2. The check

The control asks Ayka to keep contact with relevant authorities. The walk asks, for each: who is the contact, how is it reached, who may use it, when was the channel last confirmed, where is it written down.

| Step | Result (scenario) |
|---|---|
| 1. List the authorities Ayka might need. EMP-018 compared the plan with the legal register and the NIS2 procedure | The plan names LfDI, BSI and the police unit. The legal register also names, as owners of rules, the tax and commercial authorities (HGB, AO). These are not security contacts. **Not in the plan:** the emergency numbers for fire and police at the Stuttgart office (site safety), the data protection authority for a customer's own breach (not Ayka's contact), and the employer accident insurer for work-related physical events |
| 2. Create a contact register | EMP-018 made a table with fields: authority, purpose, trigger, internal owner and deputy, channel type, address held where, date confirmed, who confirmed. The register has **no addresses in this repository**. Addresses belong in the restricted store |
| 3. Confirm each channel | EMP-018 and EMP-004 looked up the current official reporting channel of LfDI and BSI on the authorities' own public pages and wrote "channel type, date read". Nothing was submitted and nobody was called. **Result: LfDI and BSI channel types confirmed on 2026-04-14 (scenario). Police unit: EMP-018 could not tell whether a company reports directly to the unit or through a local station. Marked "to verify"** |
| 4. Match the owners to the incident roles | The GDPR Lead role is EMP-004 and the deputy is EMP-021 ([SIM-PPL-006](../people/SIM-PPL-006-role-holder-appointments.md)). The Managing Director approves. The deputy for the Managing Director on a Saturday does not exist. For BSI, EMP-002 decides and no deputy is named |
| 5. Dry run | Not possible. The authority's form cannot be filled in without a breach, and the fields of the real form were not copied. EMP-004 compared the plan's T-4 log fields with Art. 33(3) content instead, on paper. Result (real observation of the template on 2026-11-10): the T-4 log has one "Personal data" column and no separate fields for categories and approximate numbers of data subjects and records. [SIM-INC-006](../incident/SIM-INC-006-t4-incident-and-breach-log.md) fills the log for the later incident |
| 6. Access to the register at night | The register is in the restricted store, behind the same account system that an incident may take down. No offline copy and no out-of-band channel exist (plan section 4). A printed copy was proposed |
| 7. Review date | Set for 2026-10-14 (six months). Nothing triggers a review earlier, for instance when a person leaves a listed role |

Scenario decision by EMP-002: adopt the register as the working list, keep it in the restricted store, print one copy for the CISO. EMP-018 owns the upkeep.

## 3. Community contacts (A.5.6)

The control asks for contact with special interest groups, security forums and professional associations. The plan has **no row** for them. ISMS-OPS-09 section 2 lists sources (tool advisories, AWS bulletins, supplier notices, GitHub advisories) but closes with "no community contact is appointed" and the plan's IC-E-08 says provider advisory subscriptions are "not set up". EMP-014 proposed candidate channels in the meeting: official advisory feeds of the three suppliers, the federal office's public warnings, a regional professional security meetup. Whether such a meetup exists and is open to a company of this size is to verify; no group was contacted, joined or checked.

There is no design to walk: no contact, no owner, no purpose, no review. The row **stays at Designed.**

## Findings

1. **No contact register exists.** The plan names authorities in rows and says no endpoint is supplied. Nothing says where the endpoint is kept, who confirms it or when. Add a register with owner, deputy, channel type and confirmation date. Keep addresses outside the repository.
2. **Missing authorities and emergency contacts.** The plan has no row for site emergencies at the office, for the work accident insurer, or for the Managing Director's deputy when the Managing Director is not reachable.
3. **No deputy named for the approving role.** IC-E-02 needs the Managing Director's approval to notify the data protection authority. No deputy is named, and a breach does not wait for holidays.
4. **The register depends on the system an incident may take down.** The plan accepts no out-of-band channel. A contact list that is reachable only through the compromised identity system is useless in the case it was written for.
5. **No rule for confirming a channel.** The plan does not say how often to confirm a channel is still the right one, nor what counts as confirmation. This walk used "read the public page and record the date". That is a method for the plan, not a statement of it.
6. **Police channel unknown.** NIS2-03 section 7 names the unit but not how a company reaches it. "To verify" cannot be closed without asking.
7. **No community row.** The plan has no row for security community contacts. A.5.6 has no design in the repository, only the sentence "no community contact is appointed" in ISMS-OPS-09.
8. **Plan header is inconsistent with section 6.** Section 4 says `SECURITY.md` does not exist; section 6 says it exists with a placeholder address. (Real observation of the documents, 2026-11-10: the file exists at the repository root and says nobody monitors a company mailbox.)

## What this does not show

- That any authority exists at the address or in the form described. Nothing was contacted. No statement by LfDI, BSI, a police unit, AWS, Microsoft or GitHub is recorded.
- That the channel types are current. The scenario "read" is a placeholder for a real check.
- That Ayka is required to report to any of them. Applicability is decided in the legal register and NIS2-01.
- Any membership of a community group or any advisory subscription. None exists.
