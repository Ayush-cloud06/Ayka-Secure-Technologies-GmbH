#!/bin/bash
# run-local-chain.sh <workload_dir>: run the whole gate locally in the same order as CI.
# Needs terraform, checkov, tfsec, conftest and jq on PATH (versions: see README).
set -uo pipefail
WL="${1:?usage: run-local-chain.sh <workload_dir>}"
cd "$(git rev-parse --show-toplevel)" || exit 1
S=Internal-IT/engineering/ci-cd/scripts
# Plan-only: never use your real AWS login, even by accident (ADR-0013).
mockenv() {
  env -u AWS_SESSION_TOKEN -u AWS_PROFILE AWS_ACCESS_KEY_ID=mock AWS_SECRET_ACCESS_KEY=mock \
    AWS_CONFIG_FILE=/dev/null AWS_SHARED_CREDENTIALS_FILE=/dev/null AWS_EC2_METADATA_DISABLED=true "$@"
}
rm -rf output evidence && mkdir -p output
echo "== 1 validate"
terraform fmt -check -recursive "$WL" || exit 1
terraform -chdir="$WL" init -backend=false -input=false > /dev/null || exit 1
terraform -chdir="$WL" validate -no-color || exit 1
echo "== 2 plan"
mockenv terraform -chdir="$WL" plan -input=false -refresh=false -no-color -out=tfplan.binary | grep -E '^Plan:' || exit 1
terraform -chdir="$WL" show -json tfplan.binary > output/tfplan.json && mv "$WL/tfplan.binary" output/tfplan.binary
echo "== 3 checkov"; bash "$S/run-checkov.sh" > /dev/null 2> output/checkov.stderr.log || exit 1
echo "== 4 tfsec";   WORKLOAD_DIR="$WL" bash "$S/run-tfsec.sh" > /dev/null 2>&1 || { echo "tfsec wrapper failed"; exit 1; }
echo "== 5 opa";     bash "$S/run-policy-check.sh" > /dev/null || exit 1
echo "== 6 decide";  bash "$S/evaluate-results.sh" > output/evaluate.log 2>&1; echo "evaluator exit code: $?"
jq -c '{decision, totals, by_tool: (.by_tool | map_values(.total_findings)), excepted: .decision_basis.excepted_findings}' \
  output/compliance-summary.json 2> /dev/null || tail -3 output/evaluate.log
