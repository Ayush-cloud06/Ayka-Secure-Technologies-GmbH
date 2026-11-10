#!/bin/bash
# run-local-chain.sh <workload_dir> [plan|source]: run the whole gate locally in the same order as CI.
# Needs the pinned tools (bootstrap-tools.sh installs them into .tools/) and jq.
# Mode "source" is for roots that cannot be planned offline (Azure, Identity Center lookups):
# Checkov and tfsec scan the source, OPA does not run, and the summary says so.
# Exit code follows the decision: 0 pass, 1 fail, 2 approval_required, 3 tool or input error.
set -uo pipefail
WL="${1:?usage: run-local-chain.sh <workload_dir> [plan|source]}"
WL="${WL%/}"
MODE="${2:-${COMPLIANCE_SCAN_MODE:-plan}}"
case "$MODE" in plan|source) ;; *) echo "mode must be plan or source, not '$MODE'"; exit 3 ;; esac
export COMPLIANCE_SCAN_MODE="$MODE" WORKLOAD_DIR="$WL"
cd "$(git rev-parse --show-toplevel)" || exit 1
S=Internal-IT/engineering/ci-cd/scripts
# Prefer the pinned tools from bootstrap-tools.sh, then refuse to run on drift.
[ -d .tools/bin ] && export PATH="$PWD/.tools/bin:$PATH"
bash "$S/check-tool-versions.sh" || exit 3
# Plan-only: never use your real AWS login, even by accident (ADR-0013).
# TF_VAR_mock_credentials is read by the platform roots (no assume_role, no AWS call);
# roots that do not declare the variable ignore it.
mockenv() {
  env -u AWS_SESSION_TOKEN -u AWS_PROFILE AWS_ACCESS_KEY_ID=mock AWS_SECRET_ACCESS_KEY=mock \
    AWS_CONFIG_FILE=/dev/null AWS_SHARED_CREDENTIALS_FILE=/dev/null AWS_EC2_METADATA_DISABLED=true \
    TF_VAR_mock_credentials=true "$@"
}
if [ -d output ] || [ -d evidence ]; then
  echo "Removing results of the previous run: output/ evidence/"
fi
rm -rf output evidence && mkdir -p output
echo "== 1 validate"
terraform fmt -check -recursive "$WL" || exit 3
terraform -chdir="$WL" init -backend=false -input=false > /dev/null || exit 3
terraform -chdir="$WL" validate -no-color || exit 3
if [ "$MODE" = plan ]; then
  echo "== 2 plan"
  # Plan a clean copy, as CI sees it: no .terraform/, no local terraform.tfstate and no
  # untracked *.tfvars (they may hold real account IDs or real state). A root with a
  # remote backend is planned against a throw-away local state, never the real one.
  WORK="$(mktemp -d)"
  trap 'rm -rf "$WORK"' EXIT
  PLAN_DIR="$WORK/root"; mkdir -p "$PLAN_DIR"
  tar -C "$WL" --exclude=.terraform --exclude='terraform.tfstate*' --exclude='*.tfvars' \
    --exclude='*.tfvars.json' --exclude='*_override.tf' --exclude='tfplan.binary' -cf - . | tar -C "$PLAN_DIR" -xf -
  printf 'terraform {\n  backend "local" {\n    path = "%s/plan-only.tfstate"\n  }\n}\n' "$WORK" > "$PLAN_DIR/ci_backend_override.tf"
  export TF_PLUGIN_CACHE_DIR="${TF_PLUGIN_CACHE_DIR:-$PWD/.tools/tf-plugin-cache}"; mkdir -p "$TF_PLUGIN_CACHE_DIR"
  terraform -chdir="$PLAN_DIR" init -input=false > "$WORK/init.log" 2>&1 || { tail -20 "$WORK/init.log"; exit 3; }
  mockenv terraform -chdir="$PLAN_DIR" plan -input=false -refresh=false -lock=false -no-color -out=tfplan.binary | grep -E '^Plan:' || exit 3
  terraform -chdir="$PLAN_DIR" show -json tfplan.binary > output/tfplan.json && mv "$PLAN_DIR/tfplan.binary" output/tfplan.binary
else
  echo "== 2 plan skipped (source scan)"
fi
echo "== 3 checkov"; bash "$S/run-checkov.sh" > /dev/null 2> output/checkov.stderr.log || exit 3
echo "== 4 tfsec";   bash "$S/run-tfsec.sh" > /dev/null 2>&1 || { echo "tfsec wrapper failed"; exit 3; }
echo "== 5 opa";     bash "$S/run-policy-check.sh" > /dev/null || exit 3
echo "== 6 decide"
bash "$S/evaluate-results.sh" > output/evaluate.log 2>&1 || true
echo "== 7 report and evidence (as in CI, also for a fail decision)"
if [ -f output/compliance-summary.json ]; then
  python3 "$S/generate-report.py" > /dev/null
  bash "$S/export-evidence.sh" > /dev/null
  python3 "$S/write-manifest.py" > /dev/null
  bash "$S/checksum-evidence.sh" > /dev/null
fi
if ! decision=$(jq -er '.decision' output/compliance-summary.json 2> /dev/null); then
  echo "No compliance summary; evaluator output:"; tail -5 output/evaluate.log
  exit 3
fi
jq -c '{decision, scan_mode, totals, by_tool: (.by_tool | map_values(.total_findings)), excepted: .decision_basis.excepted_findings, tools_not_run}' \
  output/compliance-summary.json
echo "Report: output/compliance-report.md   Evidence: evidence/"
case "$decision" in
  pass) exit 0 ;;
  fail) exit 1 ;;
  approval_required) exit 2 ;;
  *) exit 3 ;;
esac
