#!/bin/bash
set -e

echo "🔍 Running Checkov..."

cd "$(git rev-parse --show-toplevel)"
echo " Current directory: $(pwd)"

mkdir -p output

checkov -d Internal-IT/engineering/infra-test \
  --quiet \
  --output json > output/checkov-result.json

echo " Checkov scan complete"