#!/bin/bash
set -e

echo "🧠 Running OPA policies via conftest..."

cd "$(git rev-parse --show-toplevel)"

mkdir -p output

conftest test Internal-IT/engineering/infra-test \
  --policy policy-as-code/OPA \
  --output json > output/opa-result.json || true

echo "✅ OPA policy check complete"