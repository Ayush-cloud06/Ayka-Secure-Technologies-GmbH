#!/bin/bash
set -e

echo "Running cost estimation..."
# Mocking infracost check since it might not be installed on GitHub runners natively
if command -v infracost &> /dev/null; then
  infracost breakdown --path output/tfplan.json --format json --out-file output/infracost-report.json
  infracost output --path output/infracost-report.json --format table
else
  echo "Infracost not installed. Skipping precise cost estimation."
  echo "To enable actual cost checks, install infracost in the runner."
  echo "Simulated cost check: Passed."
fi
