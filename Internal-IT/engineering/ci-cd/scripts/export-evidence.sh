#!/bin/bash
set -e

cd "$(git rev-parse --show-toplevel)"

OUTPUT_DIR="$(git rev-parse --show-toplevel)/output"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BASE_DIR="$(pwd)/evidence/raw/$TIMESTAMP"
mkdir -p "$BASE_DIR"
echo "📦 Exporting evidence to $BASE_DIR"
cp "$OUTPUT_DIR"/*.json "$BASE_DIR/" 2>/dev/null || echo "No JSON files found"



# 🔥 THIS WAS MISSING
mkdir -p "$BASE_DIR"

echo "📁 Output contents:"
ls -la "$OUTPUT_DIR" || echo "No output directory"

echo "📦 Copying files..."
cp "$OUTPUT_DIR"/*.json "$BASE_DIR/" 2>/dev/null || echo "No JSON files found"

echo "📁 Evidence contents:"
ls -la "$BASE_DIR"

echo "✅ Evidence stored"