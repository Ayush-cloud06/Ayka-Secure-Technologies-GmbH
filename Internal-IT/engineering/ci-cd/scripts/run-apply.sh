#!/bin/bash
set -e

WORKLOAD_DIR="${WORKLOAD_DIR:-}"

if [[ -z "$WORKLOAD_DIR" ]]; then
  echo "Error: WORKLOAD_DIR is not set."
  exit 1
fi

echo "Verifying plan integrity..."
cd downloaded-evidence

if ! sha256sum -c evidence/artifacts.sha256 --ignore-missing; then
  echo "Error: Checksum verification failed. Tampering detected."
  exit 1
fi
echo "Integrity verified successfully."

echo "Proceeding with apply..."
cd "$GITHUB_WORKSPACE/$WORKLOAD_DIR"
terraform init -input=false
terraform apply -auto-approve "$GITHUB_WORKSPACE/downloaded-evidence/output/tfplan.binary"
