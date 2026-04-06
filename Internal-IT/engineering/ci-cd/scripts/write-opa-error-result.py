#!/usr/bin/env python3
import json
import sys
from pathlib import Path


def main():
    if len(sys.argv) != 3:
        print(
            "Usage: write-opa-error-result.py <stderr_log_path> <result_output_path>",
            file=sys.stderr,
        )
        sys.exit(1)

    error_log = Path(sys.argv[1])
    result_output = Path(sys.argv[2])

    stderr_preview = []
    if error_log.exists():
        stderr_preview = (
            error_log.read_text(encoding="utf-8", errors="replace").strip().splitlines()[:20]
        )

    payload = {
        "status": "error",
        "tool": "conftest",
        "message": "OPA policy evaluation failed before producing JSON results.",
        "stderr_log": str(error_log),
        "stderr_preview": stderr_preview,
    }

    result_output.write_text(json.dumps(payload, indent=2), encoding="utf-8")


if __name__ == "__main__":
    main()
