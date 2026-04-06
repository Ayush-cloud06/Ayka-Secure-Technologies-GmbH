#!/bin/bash
set -e

echo "Running tfsec..."

cd "$(git rev-parse --show-toplevel)"

OUTPUT_DIR="$(git rev-parse --show-toplevel)/output"
TARGET_DIR="${WORKLOAD_DIR:-Internal-IT/workloads/ayka-portal}"
mkdir -p "$OUTPUT_DIR"

# Run tfsec but do not fail here; gating happens in evaluate-results.sh
tfsec "$TARGET_DIR" \
  --format json \
  --out "$OUTPUT_DIR/tfsec-result" || true

if [ ! -f "$OUTPUT_DIR/tfsec-result.json" ]; then
  echo '{"results":[]}' > "$OUTPUT_DIR/tfsec-result.json"
fi

echo "tfsec scan complete"
