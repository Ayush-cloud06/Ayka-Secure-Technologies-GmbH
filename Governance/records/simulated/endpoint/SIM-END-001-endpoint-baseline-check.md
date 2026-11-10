# SIM-END-001 Endpoint baseline check of 24 laptops, with one malware alert

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-END-001 |
| Authored | 2026-11-10 |
| Scenario date | 2026-05-20 (baseline check). Malware alert 2026-05-19 14:10 to 2026-05-20 |
| Participants | EMP-011 (Asset Custodian, runs the check), EMP-003 (second collector), EMP-002 (CISO, decisions), EMP-005 (Incident Coordinator, triage), EMP-020 (SOC Analyst, triage), EMP-009 (user of LT-009), EMP-019 (user whose protection setting was off) |
| Procedure exercised | [User endpoint device policy POL-END-01](../../../policies/user-endpoint-device-policy.md) sections 2, 3, 4, 5 and 6; [Acceptable use policy POL-AUP-01](../../../policies/acceptable-use-policy.md) section 2 (software and services, messages and browsing); [Incident response plan POL-IR-01](../../../policies/incident-response-plan.md) section 7.1 and 7.2 |
| Controls | ISO/IEC 27001:2022 Annex A A.8.1, A.8.7, A.8.19; looked at, not raised: A.8.18, A.8.23. SOC 2 AC-16 |

Device tags (LT-nnn) follow the employee number and are scenario tags. 24 laptops, one per person, none yet managed centrally. EMP-023 is still employed (last day 2026-05-29) and EMP-019 is still in Engineering (moves on 2026-06-01).

## 1. Method

POL-END-01 section 3 lists nine areas with a verification evidence column. Readings "must identify the device, timestamp, expected baseline and pass/fail result". The policy names Cloud Platform Engineering as the verifier (EMP-011 does the work as Asset Custodian; EMP-003 is the deputy).

No device management exists. EMP-011 wrote a read-only check script and had each user run it and send back the output file (scenario). For the 13 remote users the run was started over a screen-sharing call. The script reads: operating system version and support date, firmware update state, disk encryption state, screen-lock timeout, whether the daily account is a local administrator, state of the built-in anti-malware and definition age, list of installed programmes, removable-media policy, and listening network services.

**Scenario assumption stated for A.8.7.** POL-END-01 requires "supported anti-malware/EDR" and names no product. No EDR is selected. This walk assumes the operating system's built-in anti-malware is switched on by default on all 24 laptops, because the policy's "approved product" is open. That is an assumption, not a policy statement.

## 2. Results by area (24 laptops)

| Area | Pass | Fail or not verifiable | Detail |
|---|---:|---:|---|
| Supported software | 22 | 2 | LT-009: system out of support. LT-017: firmware update pending 45 days |
| Encryption | 24 | 0 on state; 5 on key custody | All disks encrypted. 19 recovery keys held by IT Support in the password manager. 5 keys escrowed in each user's own account by the vendor default. A recovery test was never done |
| Identity and privileges | 20 | 4 | Four people use a local administrator account for daily work (EMP-003, EMP-007, EMP-013, EMP-019). MFA for company services cannot be verified: Conditional Access is off |
| Screen and boot | 17 | 7 | Seven have a 15-minute lock, not 5. Five fixed on the spot. Two remote users (EMP-016, EMP-024) not reachable until the next day |
| Protection | 23 | 1 + routing | One laptop (EMP-019) had real-time protection switched off "because it slowed builds". Alert routing: **no central console, so no alert from any laptop reaches anyone** |
| Applications | 21 | 3 | Three have programmes from outside an approved source (a PDF tool, an e-signature tool, a screen recorder). See section 4 |
| Data and backup | 6 of 6 sampled | 0 | EMP-011 searched six laptops for Restricted or customer data: none (scenario). Backup of laptops: none exists, and the policy says "per data owner". Recovery evidence: none |
| Interfaces | 0 | 24 | The block on unapproved removable media is not configured on any laptop. No exposed remote administration was found |
| Loss response | 0 | 24 | Revoke sessions: possible only per account. Isolate or wipe a device remotely: not possible. No tested response record |

Overall: **0 of 24 laptops pass every row.** 3 pass every row that can be read per device (EMP-001, EMP-006, EMP-012 are in that count). 21 fail at least one such row. Rows that fail for all 24 do not depend on the user: central alert routing, removable-media block, remote wipe and the web filter.

## 3. Decisions on the baseline (scenario)

POL-END-01 section 2 says "a failed baseline blocks access to non-public information until corrected or excepted". Applied literally, this would block all 24 people the same day.

Scenario decision by EMP-002 on 2026-05-20:

- Fixable per-device failures (updates, screen lock, local administrator, switched-off protection, recovery-key custody, three programmes) are corrected by 2026-06-03. Owner EMP-011. Access is not blocked in the meantime, except for LT-009 (below).
- The four structural failures (alert routing, removable-media block, remote wipe, loss-response test) are **not 24 exceptions.** They are recorded as open prerequisites of the endpoint workstream G07 and of the device-management choice. No exception record with an expiry was created. This is the same pattern as [SIM-PHY-001](../physical/SIM-PHY-001-office-and-home-workplace-security-assessment.md) section 5.
- LT-009: access to Confidential data blocked until the laptop is replaced. Replaced on 2026-05-25. Disposal in [SIM-PHY-002](../physical/SIM-PHY-002-equipment-and-media-disposal.md).
- Recheck: 2026-06-03 by EMP-003 (verifier is not the person who fixed). Result is not part of this record.

## 4. Malware alert (2026-05-19, A.8.7) and software installation (A.8.19)

| Time (UTC+2) | Event |
|---|---|
| 14:05 | EMP-009 downloads an "e-signature tool" installer from a search result and runs it |
| 14:10 | The built-in anti-malware quarantines a file and shows a notice. EMP-009 sees it. Nothing is sent to anybody |
| 14:25 | EMP-009 posts in the general chat: "my laptop says it removed a threat". There is no security mailbox and no on-call number (POL-IR-01 section 7.1 names both) |
| 14:40 | EMP-020 reads the chat and tells EMP-005 |
| 14:55 | EMP-005 opens a ticket and starts triage under POL-IR-01 section 7.2. Classification question: event or incident? |
| 15:10 | EMP-020 asks EMP-009 to disconnect Wi-Fi. Remote isolation is not possible (section 2). EMP-011 joins a call, exports the quarantine entry (name, path, detection time, file hash) and the installer's download address from the browser history. EMP-005 limits what is read to the download page and time window: a proportionality choice, since the policy on monitoring says scope must be proportionate (POL-AUP-01 section 3) |
| 15:40 | Full scan: clean. The quarantined file is still in quarantine. No sign that the installer ran past its first stage (scenario) |
| 16:10 | Precaution: EMP-013 revokes EMP-009's sessions and sets a password reset, because an information-stealing programme cannot be ruled out without a managed console |
| 16:30 | Decision by EMP-005: **event, not an incident.** No evidence of execution or data loss. Reason recorded. EMP-009 is told that the tool was not allowed (POL-AUP-01: install only reviewed, licensed software through the authorised process) |

Software installation findings from the baseline: three programmes outside an approved source. Nobody can name the "authorised change/install process". POL-AUP-01 and POL-END-01 both refer to it and neither defines it. The two other programmes (PDF tool and screen recorder) were removed by their users on 2026-05-21. EMP-009's laptop is replaced anyway.

## 5. Looked at and not raised

| Control | Why the walk does not support a higher status |
|---|---|
| A.8.23 Web access filtering | POL-END-01 section 5: no product, no agent, no resolver and no exception register. All 24 fail the first rule of the section. The policy adds that a failing device does not get an exception here. A device cannot be checked for a filter that does not exist. The row stays Designed |
| A.8.18 Privileged utilities | The walk found four daily local administrators, which is a privilege question (A.8.2). No document defines which utilities are privileged, who may use them or how use is logged, so there was nothing to check use against. POL-AC-01 and POL-AUP-01 do not use the word |

## Findings

1. **A failed-baseline rule that blocks everyone.** POL-END-01 section 2 blocks access on any failed row. When a row fails for all devices (no central console exists), the rule is unworkable. Split rows into "per-device" and "needs the management service", and say what happens while the service is missing.
2. **No definition of the install process.** POL-AUP-01 section 2 and POL-END-01 section 3 point to an "authorised change/install process" and "approved installation source". No such process or list exists.
3. **Alerts have nowhere to go.** POL-END-01 section 3 asks for alert routing, and section 6 admits it does not operate. A built-in alert on one laptop is seen only by its user. The detection depended on EMP-009 posting in a chat.
4. **No rule for the first hour.** POL-IR-01 section 7.1 assumes a mailbox or number. The user posted in a chat. The triage record has no field for "event, not incident" ([SIM-INC-006](../incident/SIM-INC-006-t4-incident-and-breach-log.md) finding 4 found the same for the log).
5. **Remote isolation is promised and not available.** POL-END-01 section 4 asks Security Operations to assess isolation and remote wipe. Without management, the only isolation is to ask the user. State the manual alternative.
6. **Recovery-key custody is unspecified.** The policy says keys are stored "separately, with restricted, logged access", but not where. Five were in the users' own accounts by default.
7. **The check itself has no frequency anchor.** Section 6 asks for a monthly review. The first run is whenever someone starts. This check was triggered by the walk, not by the policy.
8. **Evidence is not specified.** The policy lists a "verification evidence" column per area but does not say who keeps the readings or for how long. Readings with device identity belong in a private store (section 2 forbids serial numbers tied to people in the repository).
9. **Four daily local administrators are not an exception.** The policy says a standard account is required for daily work and separate administration is approved. Nothing says whether a developer's need for local administration is allowed.

## What this does not show

- No laptop exists. Every reading, count and timestamp is a scenario value. The script was not written.
- That the built-in protection of any real operating system is switched on by default or detects what is described. The assumption is stated only to let the walk run.
- Any EDR, device-management service or web-filter product. None is selected.
- That a laptop fix on 2026-06-03 worked. The recheck is not recorded.
- A real malware sample, a real installer or a real information stealer. The file and the tool names are scenario placeholders.
