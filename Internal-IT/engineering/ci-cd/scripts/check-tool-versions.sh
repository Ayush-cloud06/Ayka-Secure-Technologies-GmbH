#!/bin/bash
# check-tool-versions.sh: fail when a tool on PATH is not the pinned version.
# A local result only means something if it was produced by the same tools as CI.
# Set ALLOW_TOOL_DRIFT=1 to downgrade the failure to a warning.
set -uo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 1
# shellcheck source=../toolchain.versions
source Internal-IT/engineering/ci-cd/toolchain.versions

drift=0
check() { # check <name> <expected> <command...>
  local name="$1" expected="$2"; shift 2
  local actual
  actual="$("$@" 2>&1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
  if [ "$actual" = "$expected" ]; then
    printf '  ok     %-9s %s\n' "$name" "$actual"
  else
    printf '  DRIFT  %-9s %s (pinned %s)\n' "$name" "${actual:-missing}" "$expected"
    drift=1
  fi
}

echo "Toolchain check (pins: Internal-IT/engineering/ci-cd/toolchain.versions)"
check terraform "$TERRAFORM_VERSION" terraform version
check conftest  "$CONFTEST_VERSION"  conftest --version
check opa       "$OPA_VERSION"       opa version
check tfsec     "$TFSEC_VERSION"     sh -c 'tfsec --version | tail -1'
check checkov   "$CHECKOV_VERSION"   checkov --version

if [ "$drift" -ne 0 ]; then
  if [ "${ALLOW_TOOL_DRIFT:-0}" = "1" ]; then
    echo "WARNING: tool versions differ from CI; results may differ (ALLOW_TOOL_DRIFT=1)."
    exit 0
  fi
  echo "Tool versions differ from CI. Run Internal-IT/engineering/ci-cd/scripts/bootstrap-tools.sh, or set ALLOW_TOOL_DRIFT=1."
  exit 1
fi
