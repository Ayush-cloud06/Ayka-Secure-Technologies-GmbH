#!/bin/bash
set -euo pipefail

echo "Running tfsec..."

cd "$(git rev-parse --show-toplevel)"

OUTPUT_DIR="${COMPLIANCE_OUTPUT_DIR:-$(git rev-parse --show-toplevel)/output}"
RESULT_FILE="$OUTPUT_DIR/tfsec-result.json"
TARGET_DIR="${WORKLOAD_DIR:?WORKLOAD_DIR must be set by the calling action}"
mkdir -p "$OUTPUT_DIR"
rm -f "$RESULT_FILE" "$OUTPUT_DIR/tfsec-result"

if [ ! -d "$TARGET_DIR" ]; then
  echo "tfsec target directory not found: $TARGET_DIR" >&2
  exit 1
fi

# tfsec exits 1 when it finds problems. Gating happens in evaluate-results.py,
# so a non-zero exit is not an error by itself. The file check below is the guard.
tfsec "$TARGET_DIR" --format json --no-colour --out "$RESULT_FILE" || true

# Fail closed: no fallback file. The result must exist and hold a results list.
if ! jq -e '.results | type == "array"' "$RESULT_FILE" > /dev/null 2>&1; then
  echo "tfsec did not write a valid results list to $RESULT_FILE" >&2
  exit 1
fi

echo "tfsec scan complete: $(jq '.results | length' "$RESULT_FILE") finding(s) in $TARGET_DIR"
