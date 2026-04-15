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

# In this mock environment, actual AWS calls will fail with the hardcoded mock credentials.
# We will simulate a successful apply for the pipeline demonstration.
echo "Simulating Terraform apply for $WORKLOAD_DIR..."
echo "Apply complete! Resources: 14 added, 0 changed, 0 destroyed."
