#!/bin/bash
# bootstrap-tools.sh: install the pinned toolchain into .tools/ (linux amd64).
# Every download is checked against the SHA-256 in toolchain.versions; Checkov goes
# into its own virtualenv. Nothing is installed system-wide.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
# shellcheck source=../toolchain.versions
source Internal-IT/engineering/ci-cd/toolchain.versions
BIN="$PWD/.tools/bin"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$BIN"

fetch() { # fetch <url> <sha256> <file>
  echo "  $(basename "$1")"
  curl -fsSL --retry 3 -o "$TMP/$3" "$1"
  echo "$2  $TMP/$3" | sha256sum -c --quiet -
}

echo "Installing pinned tools into .tools/"
fetch "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
  "$TERRAFORM_SHA256" terraform.zip
unzip -qo "$TMP/terraform.zip" terraform -d "$BIN"

fetch "https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip" \
  "$TFLINT_SHA256" tflint.zip
unzip -qo "$TMP/tflint.zip" tflint -d "$BIN"

fetch "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" \
  "$CONFTEST_SHA256" conftest.tar.gz
tar xzf "$TMP/conftest.tar.gz" -C "$BIN" conftest

fetch "https://github.com/open-policy-agent/opa/releases/download/v${OPA_VERSION}/opa_linux_amd64_static" \
  "$OPA_SHA256" opa
install -m 0755 "$TMP/opa" "$BIN/opa"

fetch "https://github.com/aquasecurity/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64" \
  "$TFSEC_SHA256" tfsec
install -m 0755 "$TMP/tfsec" "$BIN/tfsec"

echo "  checkov ${CHECKOV_VERSION} (virtualenv)"
python3 -m venv .tools/venv
.tools/venv/bin/pip install -q "checkov==${CHECKOV_VERSION}" -r tests/requirements.txt
ln -sf ../venv/bin/checkov "$BIN/checkov"

echo "Done. Use them with:  export PATH=\"$BIN:\$PATH\""
PATH="$BIN:$PATH" bash Internal-IT/engineering/ci-cd/scripts/check-tool-versions.sh
