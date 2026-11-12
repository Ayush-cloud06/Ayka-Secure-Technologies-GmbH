# SIM-INF-002 Customer data deletion at contract end

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-INF-002 |
| Authored | 2026-11-10 |
| Scenario date | 2026-10-19 (pilot ends). Deletion 2026-10-23. Confirmation draft 2026-10-23, never sent |
| Participants | EMP-006 (Product Manager, runs offboarding and the confirmation), EMP-010 (Customer Success Manager, customer contact), EMP-003 (Cloud Platform Engineer, performs and verifies the deletion), EMP-007 (Backend Engineer, tenant queries), EMP-004 (Privacy Lead, deletion record and legal questions), EMP-002 (CISO, approval of method), EMP-001 (approves the outgoing confirmation) |
| Procedure exercised | [Records and data retention policy POL-RET-01](../../../policies/records-and-data-retention-policy.md) sections 2 (customer data, backups, logs rows) and 5 (disposition and verification); [Data classification policy POL-DATA-01](../../../policies/data-classification-and-confidentiality-policy.md) section 5.3 (retention table and the sentence on contract end) and section 6 |
| Controls | ISO/IEC 27001:2022 Annex A A.8.10 (and A.5.33 for what must not be deleted); SOC 2 CO-04; GDPR Art. 5(1)(e), 28(3)(g) |

"Customer B (fictional)" is a fictional pilot customer, the controller. Ayka is the processor. The portal was never deployed. The walk assumes it ran. Every count, time and result below is a scenario value, except the statements marked **Real observation**, which read the Terraform and the tool on the Authored date.

## 1. Rules used

| Rule | Source |
|---|---|
| Customer data: contract term plus 30 days; earlier deletion when required and lawful | POL-RET-01 section 2; POL-DATA-01 section 5.3 |
| On contract end Ayka deletes the data, **confirms deletion in writing within 30 days**, and records the deletion ticket. A customer may ask for an export first | POL-DATA-01 section 5.3 |
| Backups holding deleted customer data may age out for at most a further 35 days, "subject to verified design and contract". Isolate them from normal use. On restore, reapply deletion instructions | POL-RET-01 sections 2 and 5 |
| Cloud Platform Engineering performs authorised deletion and verifies active objects, versions, replicas, snapshots, exports and supplier copies. Keep a minimal deletion record. Do not keep the deleted content as evidence | POL-RET-01 section 5 |
| Deleting a current S3 object can leave prior versions. Deleting a KMS key that serves several records can destroy data still under retention | POL-RET-01 section 5 |
| The Product Manager runs customer offboarding and deletion confirmation | POL-DATA-01 section 6 |

## 2. Steps and results

| Date | Step | Result |
|---|---|---|
| 2026-10-12 | EMP-010 reminds Customer B that the pilot ends on 2026-10-19 and offers an export (POL-DATA-01) | Contact for the confirmation is recorded in the customer file, as [SIM-CAPA-004](../improvement/SIM-CAPA-004-customer-notice-24h-missed-and-evidence-lost.md) action CA-1 requires |
| 2026-10-19 | Pilot ends. Clock: live data deletion due by **2026-11-18** (term plus 30 days). Written confirmation due by the same date | Deletion ticket DEL-2026-001 (scenario number) opened by EMP-006 |
| 2026-10-20 | Inventory of Customer B's data by EMP-007 and EMP-003 (section 3) | 7 locations found. Three were not in the system description's data table (exports, correspondence, backups) |
| 2026-10-21 | Customer B asks for an export of its evidence files and users. Delivered by expiring link on 2026-10-22. Receipt confirmed by Customer B | Export file itself is a copy. It sits in an exports prefix with a 7-day expiry (scenario) |
| 2026-10-22 | Written instruction to delete received from Customer B | Needed before any erase of processor data (Art. 28(3)(a); the design of `dsr_tool.py` requires a stated controller instruction for the same reason) |
| 2026-10-23 10:00 | Deletion executed in the live stores. Method in section 4. Done by EMP-007 (queries) and EMP-003 (storage), the second watching the first | Section 4 |
| 2026-10-23 | EMP-003 verifies and EMP-004 writes the minimal deletion record | Section 5 |
| 2026-10-23 | EMP-006 drafts the written confirmation | Section 6. Draft only |

## 3. Where Customer B's data was (scenario inventory)

| # | Location | Content | In the system description's data table? |
|---|---|---|---|
| 1 | Database rows keyed by tenant | 42 users (name, work e-mail, role), 310 evidence records (metadata), audit log rows | Yes |
| 2 | S3 evidence bucket, prefix for the tenant | 310 objects, 1.2 GB, plus prior versions | Yes |
| 3 | Export files (prefix with expiry) | One export made on 2026-10-22 | **No** |
| 4 | Application logs (CloudWatch, 365 days) | User identifiers and IP addresses of the 42 users | Yes, but classified **Internal** in the table (Real observation, [system description](../../../SOC2/01-system-description.md) section 3.6) although they hold identifiers |
| 5 | S3 server access logs | Object keys, which include evidence file names | Yes, classified Internal |
| 6 | Customer Success mailbox and the contract file | Correspondence, the pilot agreement, the contact record | No. These are business records, not tenant data |
| 7 | Backups (RDS automated, AWS Backup vault, S3 noncurrent versions) | Copies of rows 1 and 2 | **No** (no backup row in the table) |

Onboarding material received from Customer B is held in the restricted folder introduced by [SIM-CAPA-003](../improvement/SIM-CAPA-003-real-customer-data-used-as-test-fixture.md) action CA-2 and is deleted on the date set by that route (scenario).

## 4. How the deletion was done, and the tool

**What `dsr_tool.py` is, and is not (Real observation).** [`Internal-IT/engineering/privacy/dsr_tool.py`](../../../../Internal-IT/engineering/privacy/dsr_tool.py) finds, exports and erases the records of **one data subject** in a SQLite database. It matches strong identifiers (e-mail, user id, employee id, username). A name alone is only a weak match and is never erased. It covers five tables: `personnel`, `repo_metadata`, `security_logs`, `training_records`, `portal_users`. Processor rows (`portal_users`, activity PP-01) are erased only when the caller states a controller instruction. Its audit log holds no identifier and no values. It states in every report that backups, Git history and provider logs are not searched. It has been exercised on fixture data only ([REAL-PRIV-001](../../real/privacy/REAL-PRIV-001-dsr-tool-test-run.md)). **It has not been run on any real data and it was not run here.**

**Design used in the walk (described, not executed).**

- Row-level: for each of Customer B's 42 identifiers, the tool would run `erase` with `--controller-instruction` and a request id, once per person. 42 runs. The tool knows nothing about tenants, evidence records or audit-log rows keyed by tenant. Those are not in its schema. EMP-007 therefore wrote tenant queries by hand: delete from the three tenant tables where `tenant_id` equals the value, with a row count before and after. The queries were reviewed by EMP-003 before running.
- Objects: EMP-003 listed all object versions and delete markers under the tenant prefix and deleted each version by version id, not only the current objects (POL-RET-01 section 5 warns about prior versions). The export prefix object was deleted with them.
- No KMS key was deleted. One key serves the whole workload ([POL-CRY-01](../../../policies/cryptography-policy.md) 4.4 item 2), so deleting it would destroy other tenants' data.

## 5. Verification and the deletion record

| Check (POL-RET-01 section 5) | Result |
|---|---|
| Active rows | Row count for the tenant: 0 in all three tables |
| Active objects and versions | 0 current objects, 0 versions, 0 delete markers under the prefix |
| Replicas | None configured: cross-Region replication is not part of the design (Real observation: the gate flags its absence with `S3_REPLICATION_DISABLED`) |
| Snapshots | No manual snapshot was taken for the tenant. The final snapshot setting (`skip_final_snapshot = false` in `modules/database/main.tf`) applies when the instance is deleted, not now |
| Exports | One export deleted |
| Supplier copies | None known. Not checkable: no processor records of AWS-held copies exist |
| Logs (rows 4 and 5) | **Not deleted.** Application logs expire after 365 days and access logs after 365 days. They hold user identifiers and file names. A decision is needed (finding 4) |
| Mailbox and contract file (row 6) | Not deleted: business correspondence has its own retention (POL-RET-01 section 2: normally 6 years for letters, category to confirm) |
| Backups (row 7) | Not deleted and cannot be: see below |

**Backups (Real observation of the design, scenario dates).**

- RDS automated backups: `backup_retention_period = 7` (`modules/database/main.tf`). The last backup holding the tenant's rows: 2026-10-23 02:00 UTC. Expires 2026-10-30.
- AWS Backup: daily at 02:00 UTC, `retention_days` default 35, vault lock with `min_retention_days` equal to the retention (`modules/backup/main.tf`). Once the lock's 3 days have passed it becomes immutable (compliance mode). **Nobody, not even root, can remove the 2026-10-23 recovery point early.** It expires on **2026-11-27**.
- S3 noncurrent versions: 30 days (`modules/storage/main.tf`). Versions were deleted by hand, but the AWS Backup recovery point still holds the bucket as it was.
- Maximum further 35 days after deletion: 2026-10-23 plus 35 days is 2026-11-27. The proposed maximum is met on paper. It depends on nothing having been added to the vault by hand and on no restore in the window.
- **If a restore happened before 2026-11-27**, the deleted tenant would come back with it. The design has no replayable deletion list (see [SIM-BCP-001](../continuity/SIM-BCP-001-restore-and-dr-tabletop.md) finding 3). EMP-004 recorded the deletion ticket as a plain description.

**Minimal deletion record (DEL-2026-001):** category customer data; scope Customer B tenant, rows 1 to 3; authority written instruction of 2026-10-22; method as section 4; performer EMP-007 and EMP-003; date 2026-10-23; result live stores empty; remaining copies and expiry: RDS backups until 2026-10-30, AWS Backup recovery point until 2026-11-27, logs until their expiry, business correspondence per its own schedule. No content kept.

## 6. Written confirmation (draft, never sent)

- Due by 2026-11-18 (POL-DATA-01: within 30 days). EMP-006 drafted it on 2026-10-23.
- Content: what was deleted and when; what remains and until when (backups until 2026-11-27, logs to a date, business records); that Ayka cannot confirm deletion of AWS-held copies beyond its own settings; an offer to confirm again after 2026-11-27.
- Approval: EMP-001 (the confirmation makes a statement about residual copies). Scenario decision by EMP-001: send after EMP-004 has answered the logs question. **Not sent.** The draft is held. In this fiction the 2026-11-18 date has not yet been reached on the Authored date.
- A statement "all data deleted" cannot be made before 2026-11-27. The policy asks for one confirmation within 30 days, which falls before the backups end. A second confirmation is needed and no document says so.

## Findings

1. **No tenant deletion routine.** POL-RET-01 says the capability is "Designed requirement; no tenant deletion implementation". The walk had to invent hand-written queries. `dsr_tool.py` handles one person at a time and has no tenant, evidence or audit-log table. The two designs do not meet.
2. **One confirmation cannot be true.** POL-DATA-01 asks for a written confirmation within 30 days of contract end. The backups it allows run to 35 days after deletion. Add a two-step confirmation: live stores within 30 days, final after the last backup expires.
3. **The data table misses copies and mislabels logs.** The system description's data table does not list exports, correspondence or backups, and classifies application and access logs as Internal although they hold user identifiers and file names. Make the data table the deletion inventory and extend it.
4. **Logs are personal data with no deletion rule at contract end.** POL-RET-01 keeps logs 365 days for security. GDPR Art. 28(3)(g) asks a processor to delete or return personal data at the end of services unless law requires storage. Whether security logs fall under the controller's instruction is a legal question. This record does not answer it (to verify).
5. **Business records versus deletion.** The contract file and correspondence follow the 6-year rule. POL-DATA-01 5.3 says "delete the customer's data" and does not separate tenant data from business records.
6. **Vault Lock and deletion collide.** The design makes recovery points undeletable for 35 days. That is right for ransomware and wrong for an erasure demand. The retention policy says the 35-day maximum is "subject to verified design and contract". Put it in the customer contract text.
7. **Restore reapply rule has no list.** POL-RET-01 section 5: "on restore, reapply deletion instructions". Instructions are not stored in a replayable form (SIM-BCP-001 finding 3, IMP-2026-011).
8. **KMS key deletion is a trap.** The policy warns about it. With one key per workload there is no per-tenant key to destroy, so crypto-erase per tenant is not available. State that tenant deletion is row and object level only.
9. **Who runs the deletion is ambiguous.** POL-RET-01 gives it to Cloud Platform Engineering. POL-DATA-01 gives offboarding to the Product Manager and the tool design to Engineering. EMP-006, EMP-003 and EMP-007 shared it.
10. **No customer record of the instruction.** An instruction received by e-mail is the legal basis for erasing processor data. The tool design requires one. No place is named to keep it.

## What this does not show

- No customer, tenant, database, bucket, backup or log exists. Counts and dates are scenario values. Nothing was deleted.
- No run of `dsr_tool.py` on real data. Only its design and its fixture-tested behaviour are described.
- That AWS Backup, S3 or RDS behave as the Terraform intends. The Terraform has never been applied and its behaviour is read, not tested.
- Any statement by Customer B or by AWS. The written instruction of 2026-10-22 is a scenario input.
- A legal opinion on logs, business records or the controller's rights.
