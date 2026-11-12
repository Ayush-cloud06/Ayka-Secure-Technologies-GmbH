#!/bin/bash
# restore-test.sh: restore-and-verify test for the portal database (SOC 2 G11, ISO A.8.13).
#
# Two modes:
#
#   local (default)  Runs end to end on a laptop with Docker. Starts a throw-away
#                    PostgreSQL container, loads a fixed data set, takes a logical
#                    backup (pg_dump), destroys the database, restores it into a new
#                    database, and compares an ordered checksum of every table.
#                    This proves the dump/restore procedure and the verification
#                    step. It does NOT test AWS Backup, RDS snapshots or the vault.
#
#   aws              Restores the latest recovery point of the portal RDS instance
#                    from the AWS Backup vault into a new, isolated instance, waits,
#                    and prints the restored endpoint for the same checksum query.
#                    Needs real credentials and an applied environment, which this
#                    repository does not have (plan-only). It refuses to
#                    run unless RESTORE_TEST_AWS_CONFIRM=yes is set.
#
# Usage:
#   bash restore-test.sh [local]           # needs docker
#   RESTORE_TEST_AWS_CONFIRM=yes VAULT=ayka-portal-dev-vault DB_ID=ayka-portal-dev-db \
#     RESTORE_ROLE_ARN=arn:aws:iam::<acct>:role/ayka-portal-dev-backup bash restore-test.sh aws
#
# Exit code: 0 restore verified, 1 verification failed, 2 usage or environment error.
set -euo pipefail

MODE="${1:-local}"
PG_IMAGE="${PG_IMAGE:-postgres:16.4-alpine}"
CONTAINER="restore-test-$$-$(date +%s)"
ROWS="${ROWS:-10000}"

log() { printf '[%s] %s\n' "$(date -u +%H:%M:%SZ)" "$*"; }

checksum_sql() {
  # Ordered, content-based checksum per table: independent of dump timestamps,
  # physical row order and OIDs.
  cat <<'SQL'
SELECT 'customers', count(*), md5(string_agg(t::text, '|' ORDER BY id)) FROM customers t
UNION ALL
SELECT 'orders', count(*), md5(string_agg(t::text, '|' ORDER BY id)) FROM orders t;
SQL
}

run_local() {
  command -v docker > /dev/null || { echo "docker not found" >&2; exit 2; }
  docker info > /dev/null 2>&1 || { echo "docker daemon not reachable" >&2; exit 2; }
  WORK="$(mktemp -d)"
  trap 'docker rm -f "$CONTAINER" > /dev/null 2>&1 || true; rm -rf "$WORK"' EXIT

  log "1/7 start $PG_IMAGE as $CONTAINER (no published ports)"
  docker run -d --name "$CONTAINER" -e POSTGRES_PASSWORD=restore-test-only "$PG_IMAGE" > /dev/null
  for _ in $(seq 1 60); do
    docker exec "$CONTAINER" pg_isready -U postgres > /dev/null 2>&1 && break
    sleep 1
  done
  docker exec "$CONTAINER" pg_isready -U postgres > /dev/null
  psql() { docker exec -i "$CONTAINER" psql -v ON_ERROR_STOP=1 -U postgres -At "$@"; }

  log "2/7 create database aykaportal with $ROWS customers and $((ROWS * 3)) orders (deterministic data)"
  psql -c "CREATE DATABASE aykaportal" > /dev/null
  psql -d aykaportal > /dev/null <<SQL
CREATE TABLE customers (id int PRIMARY KEY, name text NOT NULL, email text NOT NULL, created date NOT NULL);
CREATE TABLE orders (id int PRIMARY KEY, customer_id int NOT NULL REFERENCES customers(id), amount numeric(12,2) NOT NULL, note text);
INSERT INTO customers SELECT g, 'customer-' || g, 'c' || g || '@example.invalid', date '2026-01-01' + (g % 300)
  FROM generate_series(1, $ROWS) g;
INSERT INTO orders SELECT g, 1 + (g % $ROWS), round(((g * 7919) % 100000) / 100.0, 2), md5(g::text)
  FROM generate_series(1, $((ROWS * 3))) g;
SQL

  log "3/7 checksum before backup"
  checksum_sql | psql -d aykaportal > "$WORK/before.txt"
  cat "$WORK/before.txt"

  log "4/7 backup: pg_dump custom format"
  docker exec "$CONTAINER" pg_dump -U postgres -Fc -d aykaportal -f /tmp/aykaportal.dump
  docker exec "$CONTAINER" sh -c 'ls -l /tmp/aykaportal.dump | awk "{print \$5\" bytes\"}"; sha256sum /tmp/aykaportal.dump'

  log "5/7 destroy: DROP DATABASE aykaportal"
  psql -c "DROP DATABASE aykaportal" > /dev/null
  if psql -lqt | cut -d '|' -f1 | grep -qw aykaportal; then
    echo "database still exists after DROP" >&2; exit 1
  fi
  echo "database aykaportal no longer exists"

  log "6/7 restore into a new database aykaportal_restored"
  psql -c "CREATE DATABASE aykaportal_restored" > /dev/null
  docker exec "$CONTAINER" pg_restore -U postgres -d aykaportal_restored --exit-on-error /tmp/aykaportal.dump

  log "7/7 checksum after restore and compare"
  checksum_sql | psql -d aykaportal_restored > "$WORK/after.txt"
  cat "$WORK/after.txt"
  if diff -u "$WORK/before.txt" "$WORK/after.txt"; then
    log "RESTORE VERIFIED: row counts and ordered content checksums match for every table"
    docker exec "$CONTAINER" postgres --version
  else
    log "RESTORE FAILED: checksums differ"
    exit 1
  fi
}

run_aws() {
  if [ "${RESTORE_TEST_AWS_CONFIRM:-}" != "yes" ]; then
    echo "Refusing: aws mode restores into a real account. Set RESTORE_TEST_AWS_CONFIRM=yes to run it." >&2
    exit 2
  fi
  : "${VAULT:?set VAULT}" "${DB_ID:?set DB_ID}" "${RESTORE_ROLE_ARN:?set RESTORE_ROLE_ARN}"
  TARGET="${DB_ID}-restore-test-$(date +%Y%m%d%H%M)"
  log "latest recovery point of $DB_ID in $VAULT"
  DB_ARN="$(aws rds describe-db-instances --db-instance-identifier "$DB_ID" --query 'DBInstances[0].DBInstanceArn' --output text)"
  RP="$(aws backup list-recovery-points-by-backup-vault --backup-vault-name "$VAULT" --by-resource-arn "$DB_ARN" \
        --query 'sort_by(RecoveryPoints,&CreationDate)[-1].RecoveryPointArn' --output text)"
  [ -n "$RP" ] && [ "$RP" != "None" ] || { echo "no recovery point found" >&2; exit 1; }
  log "restore $RP into $TARGET (not publicly accessible)"
  JOB="$(aws backup start-restore-job --recovery-point-arn "$RP" --iam-role-arn "$RESTORE_ROLE_ARN" \
        --metadata "DBInstanceIdentifier=$TARGET,PubliclyAccessible=false,MultiAZ=false" \
        --query RestoreJobId --output text)"
  log "restore job $JOB; waiting"
  while :; do
    STATUS="$(aws backup describe-restore-job --restore-job-id "$JOB" --query Status --output text)"
    case "$STATUS" in COMPLETED) break ;; ABORTED|FAILED) echo "restore job $STATUS" >&2; exit 1 ;; esac
    sleep 60
  done
  aws rds wait db-instance-available --db-instance-identifier "$TARGET"
  log "restored: $(aws rds describe-db-instances --db-instance-identifier "$TARGET" --query 'DBInstances[0].Endpoint.Address' --output text)"
  echo "Next: run the checksum query from this script against source and restore, record both, then delete $TARGET."
}

case "$MODE" in
  local) run_local ;;
  aws) run_aws ;;
  *) echo "usage: restore-test.sh [local|aws]" >&2; exit 2 ;;
esac
