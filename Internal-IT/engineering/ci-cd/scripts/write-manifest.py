#!/usr/bin/env python3
"""Write evidence/manifest.json: what produced this evidence bundle (issue #15).

The bundle has to explain itself outside GitHub: which commit, which run,
which tool versions, and which exact policy, mapping and exception files
made the decision. checksum-evidence.sh then hashes the manifest with the
rest of the bundle.
"""
import hashlib
import json
import os
from datetime import datetime, timezone
from pathlib import Path
import subprocess
import sys

POLICY_INPUTS = [
    "Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml",
    "Internal-IT/engineering/policy-as-code/metadata/exceptions.yaml",
    "Internal-IT/engineering/ci-cd/scripts/evaluate-results.py",
]
POLICY_DIR = Path("Internal-IT/engineering/policy-as-code/OPA/terraform")
TOOL_COMMANDS = {
    "conftest": ["conftest", "--version"],
    "tfsec": ["tfsec", "--version"],
    "checkov": ["checkov", "--version"],
    "python": [sys.executable, "--version"],
}


def sha256(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def run(cmd):
    try:
        out = subprocess.run(cmd, capture_output=True, text=True, timeout=60).stdout
    except (OSError, subprocess.SubprocessError):
        return None
    lines = [line.strip() for line in out.splitlines() if line.strip()]
    if cmd[0] == "tfsec":
        lines = lines[-1:]  # tfsec prints a banner before the version
    return ", ".join(lines) or None


def read_json(path):
    try:
        return json.loads(Path(path).read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return {}


def main(output_dir="output", evidence_dir="evidence"):
    output_dir, evidence_dir = Path(output_dir), Path(evidence_dir)
    plan = read_json(output_dir / "tfplan.json")
    checkov = read_json(output_dir / "checkov-result.json")
    summary = read_json(output_dir / "compliance-summary.json")

    inputs = {p: sha256(p) for p in POLICY_INPUTS if Path(p).is_file()}
    inputs.update({str(p): sha256(p) for p in sorted(POLICY_DIR.glob("*.rego"))})

    tools = {name: run(cmd) for name, cmd in TOOL_COMMANDS.items()}
    tools["terraform"] = plan.get("terraform_version")
    if isinstance(checkov, dict) and isinstance(checkov.get("summary"), dict):
        tools["checkov"] = checkov["summary"].get("checkov_version") or tools["checkov"]

    manifest = {
        "manifest_version": "1.0",
        "generated_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "source": {
            "repository": os.environ.get("GITHUB_REPOSITORY"),
            "commit": os.environ.get("GITHUB_SHA") or run(["git", "rev-parse", "HEAD"]),
            "ref": os.environ.get("GITHUB_REF"),
            "workload_dir": os.environ.get("WORKLOAD_DIR"),
            # A local run from an edited checkout is not evidence for the commit above.
            "uncommitted_changes": None if os.environ.get("GITHUB_ACTIONS") == "true"
            else bool(run(["git", "status", "--porcelain", "--untracked-files=no"])),
        },
        "run": {
            "id": os.environ.get("GITHUB_RUN_ID"),
            "attempt": os.environ.get("GITHUB_RUN_ATTEMPT"),
            "workflow": os.environ.get("GITHUB_WORKFLOW"),
            "local": os.environ.get("GITHUB_ACTIONS") != "true",
        },
        "decision": summary.get("decision"),
        "summary_schema_version": summary.get("schema_version"),
        "tools": tools,
        "policy_inputs_sha256": inputs,
    }
    evidence_dir.mkdir(parents=True, exist_ok=True)
    (evidence_dir / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({k: manifest[k] for k in ("source", "decision", "tools")}, indent=2))


if __name__ == "__main__":
    main(*sys.argv[1:3])
