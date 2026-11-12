# REAL-INFRA-002: Database restore test against a local PostgreSQL container

> **REAL RECORD.** Performed on the date shown. Scope and limits are stated below.

| Field | Value |
|---|---|
| Record ID | REAL-INFRA-002 |
| Performed | 2026-11-10 (09:09:28 to 09:09:51 UTC) |
| Performed by | Repository owner, AI-assisted tool run (`restore-test.sh local`) |
| Base commit | `bc112b8` plus the uncommitted change that adds the script |
| Controls | SOC 2 G11 (A1.2, A1.3); ISO A.8.13 (backup), A.5.30 (ICT readiness) |
| Environment | Docker 29.8.2 on WSL2; image `postgres:16.4-alpine` (digest `sha256:5660c2cbfea50c7a9127d17dc4e48543eedd3d7a41a595a2dfa572471e37e64c`), container with no published ports, removed afterwards |

## 1. What was done

[`restore-test.sh`](../../../../Internal-IT/engineering/ci-cd/scripts/restore-test.sh) in `local` mode:

1. started a throw-away PostgreSQL 16.4 container;
2. created database `aykaportal` with deterministic data: 10,000 customers, 30,000 orders;
3. computed an ordered content checksum per table (`md5(string_agg(row::text, '|' ORDER BY id))` plus row count), so dump timestamps and physical row order cannot affect the comparison;
4. backed up with `pg_dump -Fc`;
5. destroyed the source with `DROP DATABASE` and checked it was gone;
6. restored into a new database `aykaportal_restored` with `pg_restore --exit-on-error`;
7. recomputed the checksums and compared them with `diff`.

Reproduce: `bash Internal-IT/engineering/ci-cd/scripts/restore-test.sh local` (needs Docker).

## 2. Output (verbatim, image pull lines removed)

```
[09:09:28Z] 1/7 start postgres:16.4-alpine as restore-test-24439-1794301768 (no published ports)
[09:09:48Z] 2/7 create database aykaportal with 10000 customers and 30000 orders (deterministic data)
[09:09:50Z] 3/7 checksum before backup
customers|10000|ffc00fdab2d444f517e7b93bc0d68fb0
orders|30000|e154caa3cb0e0ba13dfafecd849400e5
[09:09:50Z] 4/7 backup: pg_dump custom format
914160 bytes
7e8d62ba1a861844e909ecbd21db6d095b6c713368ea8272abb3298eaf212f3a  /tmp/aykaportal.dump
[09:09:50Z] 5/7 destroy: DROP DATABASE aykaportal
database aykaportal no longer exists
[09:09:50Z] 6/7 restore into a new database aykaportal_restored
[09:09:51Z] 7/7 checksum after restore and compare
customers|10000|ffc00fdab2d444f517e7b93bc0d68fb0
orders|30000|e154caa3cb0e0ba13dfafecd849400e5
[09:09:51Z] RESTORE VERIFIED: row counts and ordered content checksums match for every table
postgres (PostgreSQL) 16.4
exit=0
```

`docker ps -a` afterwards showed no `restore-test` container.

## 3. Limits

- This is a **logical dump and restore on a local container**. It tests the restore-and-verify procedure and the checksum method. It does **not** test AWS Backup, RDS snapshots, the locked vault, cross-account isolation, IAM, KMS or restore time on AWS.
- The data set is synthetic and small. Restore time (about 1 second) says nothing about a production-size database.
- The script's `aws` mode (restore the latest recovery point from the vault into an isolated instance) has never run: no AWS environment exists, and the mode refuses to start without `RESTORE_TEST_AWS_CONFIRM=yes`.
- SOC 2 G11 asks for a quarterly restore of a real RDS snapshot. That remains open.
