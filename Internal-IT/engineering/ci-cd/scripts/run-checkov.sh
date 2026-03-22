#!/bin/bash

echo "running checkov ..."

mkdir -p output

checkov -d . \
 --quiet \
 --output json > output/checkov-result.json

echo "checkov scan complete