#!/bin/bash
# Hash every file the apply job will rely on. A fail run is evidence too.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
mkdir -p evidence
files=""
for f in output/tfplan.json output/tfplan.binary output/compliance-summary.json; do
  [ -f "$f" ] && files="$files $f"
done
if [ -z "$files" ]; then
  echo "::warning::Nothing to checksum"
  exit 0
fi
# shellcheck disable=SC2086
sha256sum $files > evidence/artifacts.sha256
cat evidence/artifacts.sha256
