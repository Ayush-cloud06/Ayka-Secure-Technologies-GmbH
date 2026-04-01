#!/bin/bash
set -e

echo "🔍 Running Checkov..."

cd "$(git rev-parse --show-toplevel)"
echo "📍 Current directory: $(pwd)"

OUTPUT_DIR="$(git rev-parse --show-toplevel)/output"
mkdir -p "$OUTPUT_DIR"

# Run checkov but DO NOT fail pipeline
checkov \
  -f "$OUTPUT_DIR/tfplan.json" \
  --framework terraform_plan \
  -o json > "$OUTPUT_DIR/checkov-result.json" || true

echo "✅ Checkov scan complete"
