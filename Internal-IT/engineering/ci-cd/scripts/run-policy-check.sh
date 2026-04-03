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
  python3 - <<'PY' > "$OPA_RESULT_FILE"
import json
from pathlib import Path

error_log = Path("output/opa-result.stderr.log")

payload = {
    "status": "error",
    "tool": "conftest",
    "message": "OPA policy evaluation failed before producing JSON results.",
    "stderr_log": str(error_log),
    "stderr_preview": error_log.read_text(encoding="utf-8", errors="replace").strip().splitlines()[:20],
}

print(json.dumps(payload, indent=2))
PY
fi

echo "✅ OPA policy check complete"
