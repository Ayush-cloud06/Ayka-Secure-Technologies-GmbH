#!/bin/bash
set -euo pipefail

WORKLOAD_DIR="${WORKLOAD_DIR:-}"

if [[ -z "$WORKLOAD_DIR" ]]; then
  echo "Error: WORKLOAD_DIR is not set."
  exit 1
fi

echo "Verifying evidence integrity..."
cd "${EVIDENCE_DIR:-downloaded-evidence}"

# These must be in the checksum list, so nobody can drop them from the bundle.
for required in output/tfplan.json output/tfplan.binary output/compliance-summary.json evidence/manifest.json; do
  if ! grep -q "  $required\$" evidence/artifacts.sha256; then
    echo "Error: $required is not covered by evidence/artifacts.sha256."
    exit 1
  fi
done

if ! sha256sum --quiet -c evidence/artifacts.sha256; then
  echo "Error: integrity check failed; these files differ from the ones that were scanned."
  exit 1
fi

# The evidence must come from the commit being applied.
manifest_commit="$(jq -r '.source.commit // empty' evidence/manifest.json)"
if [[ -n "${GITHUB_SHA:-}" && "$manifest_commit" != "$GITHUB_SHA" ]]; then
  echo "Error: evidence was produced for commit '$manifest_commit', not $GITHUB_SHA."
  exit 1
fi
echo "Integrity verified: $(wc -l < evidence/artifacts.sha256) files, commit ${manifest_commit:-unknown}."

# This project never applies to a real account (plan-only, mock provider).
# Say so plainly instead of printing a fake Terraform summary.
echo "SIMULATED APPLY for $WORKLOAD_DIR: the verified plan was NOT applied and no resources were created."
