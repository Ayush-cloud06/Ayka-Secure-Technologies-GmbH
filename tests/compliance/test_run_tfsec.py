import os
import subprocess
import tempfile
import unittest
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
SCRIPT = REPO_ROOT / "Internal-IT/engineering/ci-cd/scripts/run-tfsec.sh"


class RunTfsecWrapperTests(unittest.TestCase):
    """The wrapper must never invent an empty result (ADR-0011)."""

    def run_wrapper(self, fake_tfsec_body, workload_dir="Internal-IT/workloads/ayka-portal"):
        with tempfile.TemporaryDirectory() as tmp:
            tmp = Path(tmp)
            bin_dir = tmp / "bin"
            bin_dir.mkdir()
            fake = bin_dir / "tfsec"
            fake.write_text("#!/bin/bash\n" + fake_tfsec_body + "\n")
            fake.chmod(0o755)
            out = tmp / "output"
            env = os.environ.copy()
            env["PATH"] = f"{bin_dir}:{env['PATH']}"
            env["COMPLIANCE_OUTPUT_DIR"] = str(out)
            env.pop("WORKLOAD_DIR", None)
            if workload_dir:
                env["WORKLOAD_DIR"] = workload_dir
            result = subprocess.run(["bash", str(SCRIPT)], cwd=REPO_ROOT, env=env,
                                    capture_output=True, text=True)
            written = (out / "tfsec-result.json").read_text() if (out / "tfsec-result.json").exists() else None
            return result, written

    def test_tfsec_writes_nothing_fails_closed(self):
        result, written = self.run_wrapper("exit 1")
        self.assertEqual(result.returncode, 1, result.stdout + result.stderr)
        self.assertIsNone(written, "the wrapper must not create a fallback file")

    def test_findings_are_kept(self):
        # Parse --out like the real tfsec and write one finding there.
        body = 'while [ $# -gt 0 ]; do [ "$1" = "--out" ] && out="$2"; shift; done\n' \
               'echo \'{"results":[{"rule_id":"AVD-AWS-0107","severity":"HIGH"}]}\' > "$out"; exit 1'
        result, written = self.run_wrapper(body)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("AVD-AWS-0107", written)

    def test_missing_workload_dir_fails_closed(self):
        result, written = self.run_wrapper("exit 0", workload_dir=None)
        self.assertNotEqual(result.returncode, 0)
        self.assertIsNone(written)


if __name__ == "__main__":
    unittest.main()
