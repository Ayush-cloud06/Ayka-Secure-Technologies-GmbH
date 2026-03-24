#!/bin/bash
set -e

cd "$(git rev-parse --show-toplevel)"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BASE_DIR="evidence/raw/$TIMESTAMP"

OUTPUT_DIR="$(git rev-parse --show-toplevel)/output"
mkdir -p "$OUTPUT_DIR"

echo " Copying files..."
cp output/*.json "$BASE_DIR/" || true

ls -la "$BASE_DIR"

echo " Evidence stored"