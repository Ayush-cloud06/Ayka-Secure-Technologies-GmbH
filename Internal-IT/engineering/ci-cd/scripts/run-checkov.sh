#!/bin/bash
set -e

echo "🔍 Running Checkov..."

cd "$(git rev-parse --show-toplevel)"
echo "📍 Current directory: $(pwd)"

OUTPUT_DIR="$(git rev-parse --show-toplevel)/output"
mkdir -p "$OUTPUT_DIR"
MODE="${COMPLIANCE_SCAN_MODE:-plan}"

# Run checkov but DO NOT fail pipeline: the evaluator decides, and it rejects
# a result file that shows nothing was scanned.
case "$MODE" in
  plan)
    checkov \
      -f "$OUTPUT_DIR/tfplan.json" \
      --framework terraform_plan \
      -o json > "$OUTPUT_DIR/checkov-result.json" || true
    ;;
  source)
    # Roots that cannot be planned offline: scan the Terraform source instead.
    TARGET_DIR="${WORKLOAD_DIR:?WORKLOAD_DIR must be set for a source scan}"
    checkov \
      -d "$TARGET_DIR" \
      --framework terraform \
      --download-external-modules false \
      --skip-path '\.terraform' \
      -o json > "$OUTPUT_DIR/checkov-result.json" || true
    ;;
  *)
    echo "Unknown COMPLIANCE_SCAN_MODE: $MODE" >&2
    exit 1
    ;;
esac

echo "✅ Checkov scan complete ($MODE)"
