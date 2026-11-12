# SIM-BCP-001 Backup restore and disaster recovery tabletop

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-BCP-001 |
| Authored | 2026-11-10 |
| Scenario date | 2026-09-15 |
| Participants | EMP-002 (Incident Commander, facilitator), EMP-003 (Technical Lead), EMP-013 (DevOps, state and pipeline), EMP-007 (Product & Engineering, functional checks), EMP-015 (QA, smoke test), EMP-005 (Security Operations, access checks), EMP-006 (Product Manager, service owner view), EMP-018 (scribe) |
| Procedure exercised | [Backup and restore procedure ISMS-OPS-06](../../../ISMS/06-operational-procedures/backup-and-restore-procedure.md) sections 3 and 4; [BC/DR plan POL-BCDR-01](../../../policies/business-continuity-and-disaster-recovery-plan.md) sections 4, 6, 7 and 8 |
| Controls | ISO/IEC 27001:2022 Annex A A.5.29, A.5.30, A.8.13, A.8.14; SOC 2 RM-01, AV-02, AV-03, AV-04, AC-08; RISK-002, RISK-012, RISK-013 |

A tabletop proves decisions and gaps, not restore time or data integrity (procedure section 4). Measured RTO and RPO are therefore **not measurable: no deployed system**. A separate restore test against an emulator may exist in the real store as REAL-INFRA-002 (other author); it is referenced by ID only and its results are not used here.

## 1. Scenarios

| ID | Scenario | Target from POL-BCDR-01 section 4 |
|---|---|---|
| S-A | A bad database migration on Tuesday 02:00 corrupts the customer table. Found at 07:30 | Portal and database: RTO 8 h, RPO 24 h |
| S-B | Accidental deletion of one evidence object in S3 | Evidence files: RTO 8 h, zero-loss aspiration |
| S-C | Region outage of the workload Region | RTO 8 h; plan says "exceeds RTO today" |
| S-D | Entra ID unavailable during S-A | Break-glass within 1 h |

## 2. Walk-through of S-A against the restore sequence

| Step (procedure section 3) | What the team said they would do | Problem found |
|---|---|---|
| 1. Open ticket, scenario, last good point, RTO/RPO, authorizing role | EMP-002 opens a recovery ticket at 07:40 | "Authorizing role" is not defined. EMP-002 took it as IC |
| 2. Preserve evidence, read-only inventory, select account, Region, key, recovery point | Point-in-time restore to 01:55 | **Which Region?** Source defaults to `ap-south-1`; the procedure says `eu-central-1`. The team could not say where the backups would be |
| 3. Restore to isolated target | New RDS instance in an isolated environment | No isolated account exists or is designed. EMP-003 proposed a new VPC in the same account; that is not isolated from an account compromise |
| 4. Verify encryption, consistency, records, app behaviour | EMP-007 and EMP-015 run smoke tests; EMP-005 checks access | No smoke test suite for the portal exists |
| 5. Reapply authorized deletions since the recovery point | Replay deletion requests made between 01:55 and 07:30 | **No deletion log exists to replay.** The retention policy requires it; nothing produces it |
| 6. Measure RTO/RPO | Design estimate only | Estimate: 5 h 30 min to validated use (inside 8 h) and 5 min data age at restore point (inside 24 h). Estimate, not a measurement |
| 7. Cutover authorization, cleanup | EMP-006 as service owner and EMP-002 | Cleanup of the old instance: no rule for how long to keep it as evidence |

## 3. Other scenarios

- **S-B:** S3 versioning keeps noncurrent versions 30 days. Restore of one object is quick in design. Checksum comparison needs the original checksum, which only the evidence manifest has. Zero loss cannot be claimed (plan section 4 already says so).
- **S-C:** Agreed with the plan: no copy outside the Region, so RTO is not met. Decision proposal for management review: fund cross-Region copy or change the stated RTO for Region loss.
- **S-D:** Break-glass path is untested (RISK-013). The two emergency accounts have no custody record (SIM-ACC-001). Team could not show how a person would get to them within 1 hour. **Target not met in the walk-through.**

## 4. Result against targets

| Scenario | Target | Tabletop result |
|---|---|---|
| S-A | RTO 8 h, RPO 24 h | Plausible by estimate; not measurable: no deployed system. Blocked in practice by Region ambiguity and missing isolated target |
| S-B | Zero-loss aspiration | Not supportable |
| S-C | RTO 8 h | Not met by design |
| S-D | 1 h | Not met; path not usable as written |

## 5. Actions proposed

| Action | Owner | Due |
|---|---|---|
| Decide recovery Region and isolated restore account before any deployment | EMP-003 | Before first deployment (gate) |
| Design a deletion log so step 5 can be done | EMP-007 | 2026-12-15 |
| Custody record and test plan for emergency accounts | EMP-002 | 2026-11-30 |
| Portal smoke test suite for restore checks | EMP-015 | Before first deployment (gate) |
| Management decision on Region-loss RTO | EMP-001 | Management review 2026-10-26 |

## Findings

1. **"Authorizing role" is not named.** Step 1 asks for it; nothing defines it. Name the IC for incidents and the service owner for tests.
2. **Isolated target is assumed, not designed.** Step 3 says restore to an isolated target. The architecture has one account and no isolated space.
3. **Step 5 needs a record that no procedure creates.** The deletion replay depends on a log of deletion requests. Neither the retention policy nor the data subject request process (see SIM-DSR-001, other author) says it must be kept in a replayable form.
4. **Region stated in two ways.** The procedure says `eu-central-1`; the source says `ap-south-1`. The tabletop could not pick a recovery Region. Same root as RISK-011.
5. **BC/DR roles depend on an on-call rota that does not exist.** POL-BCDR-01 section 7 uses the IR plan's Technical Lead, "Cloud Platform Engineer on call". No rota exists (POL-IR-01 section 12).
6. **No tabletop record format.** Section 4 points to the SOC 2 restore template, which has fields for measured RTO/RPO only. A tabletop has nothing to measure. Add a tabletop format: scenario, decision points, gaps, actions.

## What this does not show

- No backup, restore or failover was performed. No database or bucket exists.
- The 5 h 30 min figure is a design estimate made in the fiction.
- The procedure and plan are used as their text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
- Nothing from REAL-INFRA-002 is used or implied.
