#!/bin/bash
set -e
echo "running checkov ..."

mkdir -p output

checkov -d infra-test \
 --quiet \
 --output json > output/checkov-result.json

echo "checkov scan complete