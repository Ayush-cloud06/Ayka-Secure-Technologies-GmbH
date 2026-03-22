#!/bin/bash
set -e
echo "Running OPA policies via conftest ..."
mkdir -p output

conftest test infra-test \
 --policy ../policy-as-code/OPA \
 --output json > output/opa-result.json

echo "OPA policy check complete"