#!/bin/bash
# run-local-chain.sh <workload_dir>: run the whole gate locally in the same order as CI.
# Needs terraform, checkov, tfsec, conftest and jq on PATH (versions: see README).
# Exit code follows the decision: 0 pass, 1 fail, 2 approval_required, 3 tool or input error.
set -uo pipefail
WL="${1:?usage: run-local-chain.sh <workload_dir>}"
cd "$(git rev-parse --show-toplevel)" || exit 1
S=Internal-IT/engineering/ci-cd/scripts
# Plan-only: never use your real AWS login, even by accident (ADR-0013).
mockenv() {
  env -u AWS_SESSION_TOKEN -u AWS_PROFILE AWS_ACCESS_KEY_ID=mock AWS_SECRET_ACCESS_KEY=mock \
    AWS_CONFIG_FILE=/dev/null AWS_SHARED_CREDENTIALS_FILE=/dev/null AWS_EC2_METADATA_DISABLED=true "$@"
}
if [ -d output ] || [ -d evidence ]; then
  echo "Removing results of the previous run: output/ evidence/"
fi
rm -rf output evidence && mkdir -p output
echo "== 1 validate"
terraform fmt -check -recursive "$WL" || exit 3
terraform -chdir="$WL" init -backend=false -input=false > /dev/null || exit 3
terraform -chdir="$WL" validate -no-color || exit 3
echo "== 2 plan"
mockenv terraform -chdir="$WL" plan -input=false -refresh=false -no-color -out=tfplan.binary | grep -E '^Plan:' || exit 3
terraform -chdir="$WL" show -json tfplan.binary > output/tfplan.json && mv "$WL/tfplan.binary" output/tfplan.binary
echo "== 3 checkov"; bash "$S/run-checkov.sh" > /dev/null 2> output/checkov.stderr.log || exit 3
echo "== 4 tfsec";   WORKLOAD_DIR="$WL" bash "$S/run-tfsec.sh" > /dev/null 2>&1 || { echo "tfsec wrapper failed"; exit 3; }
echo "== 5 opa";     bash "$S/run-policy-check.sh" > /dev/null || exit 3
echo "== 6 decide"
bash "$S/evaluate-results.sh" > output/evaluate.log 2>&1 || true
echo "== 7 report and evidence (as in CI, also for a fail decision)"
if [ -f output/compliance-summary.json ]; then
  python3 "$S/generate-report.py" > /dev/null
  bash "$S/export-evidence.sh" > /dev/null
  WORKLOAD_DIR="$WL" python3 "$S/write-manifest.py" > /dev/null
  bash "$S/checksum-evidence.sh" > /dev/null
fi
if ! decision=$(jq -er '.decision' output/compliance-summary.json 2> /dev/null); then
  echo "No compliance summary; evaluator output:"; tail -5 output/evaluate.log
  exit 3
fi
jq -c '{decision, totals, by_tool: (.by_tool | map_values(.total_findings)), excepted: .decision_basis.excepted_findings}' \
  output/compliance-summary.json
echo "Report: output/compliance-report.md   Evidence: evidence/"
case "$decision" in
  pass) exit 0 ;;
  fail) exit 1 ;;
  approval_required) exit 2 ;;
  *) exit 3 ;;
esac
