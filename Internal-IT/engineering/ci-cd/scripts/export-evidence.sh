#!/bin/bash
set -e
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BASE_DIR="../../Internal-IT/assurance/evidence/raw/$TIMESTAMP"

echo "Exporting evidence to $BASE_DIR"

mkdir -p $BASE_DIR

cp output/*.json $BASE_DIR/

echo "Evidence stored"

# chmod +x ci-cd/scripts/*.sh   -> Make script executable