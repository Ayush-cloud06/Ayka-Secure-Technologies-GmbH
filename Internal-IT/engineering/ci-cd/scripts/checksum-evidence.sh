#!/bin/bash
# Hash every file in the evidence bundle: plan, raw scanner results, summary,
# report, logs and manifest. A fail run is evidence too.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
mkdir -p evidence
mapfile -t files < <(find output evidence -type f ! -name artifacts.sha256 2> /dev/null | LC_ALL=C sort)
if [ "${#files[@]}" -eq 0 ]; then
  echo "::warning::Nothing to checksum"
  exit 0
fi
sha256sum "${files[@]}" > evidence/artifacts.sha256
cat evidence/artifacts.sha256
