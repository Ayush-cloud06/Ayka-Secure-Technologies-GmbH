#!/bin/bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"
echo "Evaluating security results..."

OUTPUT_DIR="output"
CHECKOV_FILE="$OUTPUT_DIR/checkov-result.json"
OPA_FILE="$OUTPUT_DIR/opa-result.json"
TFSEC_FILE="$OUTPUT_DIR/tfsec-result.json"

# Source mode (COMPLIANCE_SCAN_MODE=source) has no plan, so OPA does not run.
# The evaluator rejects any other mode value.
required=("$CHECKOV_FILE" "$TFSEC_FILE")
if [ "${COMPLIANCE_SCAN_MODE:-plan}" != "source" ]; then
  required+=("$OPA_FILE")
fi

for file in "${required[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Required result file missing: $file"
    exit 1
  fi
done

python3 Internal-IT/engineering/ci-cd/scripts/evaluate-results.py
