#!/bin/bash
set -e

cd "$(git rev-parse --show-toplevel)"
echo " Evaluating security results..."
CHECKOV_FILE="output/checkov-result.json"

if [ ! -f "$CHECKOV_FILE" ]; then
  echo " No Checkov results found"
  exit 1
fi

# Count failed checks
FAILED=$(jq '.results.failed_checks | length' $CHECKOV_FILE)

echo "🔍 Failed checks: $FAILED"

# Count HIGH severity (Checkov calls them 'HIGH' in severity field)
HIGH=$(jq '[.results.failed_checks[] | select(.severity=="HIGH")] | length' $CHECKOV_FILE)

echo "High severity issues: $HIGH"

# Decision logic
if [ "$HIGH" -gt 0 ]; then
  echo "Blocking pipeline: HIGH severity issues found"
  exit 1
fi

echo " No blocking issues"