#!/bin/bash
set -e

echo "Starting export script..."

ROOT="$(git rev-parse --show-toplevel)"
echo "Root: $ROOT"

cd "$ROOT"

OUTPUT_DIR="$ROOT/output"
EVIDENCE_ROOT="$ROOT/evidence"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BASE_DIR="$EVIDENCE_ROOT/raw/$TIMESTAMP"

echo "Creating evidence directory..."
mkdir -p "$BASE_DIR"

echo "Checking output folder:"
ls -la "$OUTPUT_DIR" || echo "output folder missing"

echo "Copying files..."

if compgen -G "$OUTPUT_DIR/*.json" > /dev/null; then
  cp "$OUTPUT_DIR"/*.json "$BASE_DIR/"
else
  echo "No JSON files found in output"
fi

echo "Final evidence contents:"
ls -la "$BASE_DIR"

echo "Export script finished"