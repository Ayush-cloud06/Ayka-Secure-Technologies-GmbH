#!/bin/bash
set -e

WORKLOAD_DIR="${WORKLOAD_DIR:-}"

if [[ -z "$WORKLOAD_DIR" ]]; then
  echo "Error: WORKLOAD_DIR is not set."
  exit 1
fi

echo "Verifying plan integrity..."
cd downloaded-evidence

if ! sha256sum -c evidence/artifacts.sha256; then
  echo "Error: integrity check failed; these files differ from the ones that were scanned."
  exit 1
fi
echo "Integrity verified successfully."

# This project never applies to a real account yet (plan-only, mock provider).
# Say so plainly instead of printing a fake Terraform summary.
echo "SIMULATED APPLY for $WORKLOAD_DIR: the verified plan was NOT applied and no resources were created."
