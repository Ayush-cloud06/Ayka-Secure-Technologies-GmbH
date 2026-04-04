#!/bin/bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"
echo "Evaluating security results..."

OUTPUT_DIR="output"
CHECKOV_FILE="$OUTPUT_DIR/checkov-result.json"
OPA_FILE="$OUTPUT_DIR/opa-result.json"
TFSEC_FILE="$OUTPUT_DIR/tfsec-result.json"
SUMMARY_FILE="$OUTPUT_DIR/compliance-summary.json"

for file in "$CHECKOV_FILE" "$OPA_FILE" "$TFSEC_FILE"; do
  if [ ! -f "$file" ]; then
    echo "Required result file missing: $file"
    exit 1
  fi
done

python3 Internal-IT/engineering/ci-cd/scripts/evaluate-results.py
