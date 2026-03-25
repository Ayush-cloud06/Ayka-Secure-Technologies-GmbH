#!/bin/bash
set -e

echo "🔍 Running Checkov..."

cd "$(git rev-parse --show-toplevel)"
echo "📍 Current directory: $(pwd)"

OUTPUT_DIR="$(git rev-parse --show-toplevel)/output"
mkdir -p "$OUTPUT_DIR"

# Run checkov but DO NOT fail pipeline
checkov -d Internal-IT/engineering/infra-test \
  --quiet \
  --output json > output/checkov-result.json || true

echo "✅ Checkov scan complete"