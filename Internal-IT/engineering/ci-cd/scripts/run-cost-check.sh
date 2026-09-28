#!/bin/bash
set -e

echo "Running cost estimation..."
# Mocking infracost check since it might not be installed on GitHub runners natively
if command -v infracost &> /dev/null; then
  infracost breakdown --path output/tfplan.json --format json --out-file output/infracost-report.json
  infracost output --path output/infracost-report.json --format table
else
  echo "SIMULATED: infracost is not installed, so no cost estimate was produced."
  echo "This step does not gate anything."
fi
