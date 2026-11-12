# SIM-GDPR-001: DPO designation decision, minutes

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-GDPR-001 |
| Authored | 2026-11-10 (real date) |
| Scenario date | 2026-03-09 |
| Participants | EMP-001 (Managing Director, decides), EMP-002 (CISO), EMP-004 (GDPR Lead, prepared the file), EMP-012 (HR & Administration, confirmed headcount facts) |
| Procedure exercised | [DPO decision and legal-basis register](../../../GDPR/dpo-and-legal-basis.md) (GDPR-11) section 1, version 1.0, then as revised in version 1.1 |
| Controls | GDPR Art. 37, 38, 39; BDSG § 38 (read in [REAL-PRIV-002](../../real/privacy/REAL-PRIV-002-bdsg-38-reading.md)); ISO/IEC 27001:2022 A.5.34; legal register LR-02 |

## Agenda and minutes (scenario)

1. **Headcount.** EMP-012 confirms 24 full-time staff, all started between 2026-01-01 and 2026-02-13. EMP-004 shows the counting table (12 office roles, 5 security roles, 3 platform administrators, 4 developers on synthetic data). Narrow reading 17, adopted reading 20, widest 24.
2. **Art. 37(1)(b), (c).** Core activity is the compliance SaaS. Not regular large-scale monitoring and no special categories. Not met.
3. **§ 38(1) sentence 1.** Threshold 20 persons constantly engaged in automated processing. Met on the adopted reading, not on the narrow one. The room does not settle "constantly" for developers and records the uncertainty.
4. **§ 38(1) sentence 2.** EMP-004 explains that security logging (PA-03) is likely to need a DPIA ([screening](../../../GDPR/dpia-screening.md)). If it does, a DPO is mandatory at any headcount once the processing starts.
5. **Independence (Art. 38(6)).** No internal role is free of conflict. EMP-004 maintains the processing record; EMP-002 owns security processing; EMP-001 sets purposes. External officer preferred (Art. 37(6)).
6. **Decision.** Scenario decision by EMP-001: designate an external DPO; EMP-004 to prepare a short list and a service contract; EMP-002 to confirm budget. Notification to the authority and publication of the contact (Art. 37(7)) after the contract. No provider is named. Review when headcount changes by 3 or more.

## Findings

Defects in GDPR-11 version 1.0 that the walk-through found:

1. The document said "no threshold number is adopted". Without the number (20, from the official text) and a counting method no decision could be taken. Closed in version 1.1 with the count table.
2. No method for "ständig beschäftigen". Which roles count was argued from scratch. Closed in version 1.1; the reading is still the author's.
3. No conflict-of-interest check (Art. 38(6)). Closed in version 1.1.
4. No link between the DPIA outcome and § 38(1) sentence 2. Closed in version 1.1.
5. No owner or step for Art. 37(7) notification and publication. Version 1.1 names the duty. Still no owner assigned.
6. No review trigger tied to headcount. Added in the minutes only; not yet in the document.
7. The scenario date precedes the written DPIA by months; at the meeting the DPIA limb was an expectation, not a fact. The document needs a re-confirmation step when the DPIA concludes.

## What this does not show

- That a DPO is appointed, exists or was selected. None is.
- That counsel agrees with the headcount reading.
- That the meeting took place. No signature or approval is recorded; "decides" means scenario decision by EMP-001.
