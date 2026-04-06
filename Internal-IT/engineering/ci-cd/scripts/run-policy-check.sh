#!/bin/bash
set -e

echo "🧠 Running OPA policies via conftest..."

cd "$(git rev-parse --show-toplevel)"

OUTPUT_DIR="$(git rev-parse --show-toplevel)/output"
mkdir -p "$OUTPUT_DIR"

OPA_RESULT_FILE="$OUTPUT_DIR/opa-result.json"
OPA_ERROR_LOG="$OUTPUT_DIR/opa-result.stderr.log"
PLAN_FILE="$OUTPUT_DIR/tfplan.json"
POLICY_DIR="Internal-IT/engineering/policy-as-code/OPA"

set +e
conftest test "$PLAN_FILE" \
  --policy "$POLICY_DIR" \
  --all-namespaces \
  --output json > "$OPA_RESULT_FILE" 2> "$OPA_ERROR_LOG"
conftest_exit_code=$?
set -e

if [ "$conftest_exit_code" -gt 1 ] || [ ! -s "$OPA_RESULT_FILE" ]; then
  python3 Internal-IT/engineering/ci-cd/scripts/write-opa-error-result.py \
    "$OPA_ERROR_LOG" \
    "$OPA_RESULT_FILE"
fi

echo "✅ OPA policy check complete"
