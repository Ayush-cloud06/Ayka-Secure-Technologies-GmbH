#!/bin/bash
# Negative test: the insecure scenarios MUST be blocked, by the expected controls and tools.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

SUMMARY="${COMPLIANCE_SUMMARY_FILE:-output/compliance-summary.json}"
EXPECTED="${EXPECTED_CONTROLS_FILE:-Internal-IT/workloads/control-validation-scenarios/expected-controls.txt}"

if [ ! -f "$SUMMARY" ]; then
  echo "::error::No compliance summary at $SUMMARY"
  exit 1
fi

decision="$(jq -r '.decision' "$SUMMARY")"
echo "Regression decision: $decision"
if [ "$decision" != "fail" ]; then
  echo "::error::Negative test broken: the insecure scenarios were not blocked (decision=$decision)"
  exit 1
fi

missing=0
while read -r control tools _; do
  case "$control" in ''|'#'*) continue ;; esac
  for tool in ${tools//,/ }; do
    if ! jq -e --arg c "$control" --arg t "$tool" \
        '(.by_control[$c].tools // []) | index($t) != null' "$SUMMARY" > /dev/null; then
      echo "::error::$control was not reported by $tool"
      missing=$((missing + 1))
    fi
  done
done < "$EXPECTED"

if [ "$missing" -gt 0 ]; then
  echo "Negative test broken: $missing expected control/tool pair(s) missing."
  exit 1
fi
echo "Negative test verified: every expected control was reported by every expected tool."
