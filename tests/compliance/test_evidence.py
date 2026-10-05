"""Evidence bundle: manifest content and the integrity check before apply (issue #15)."""
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

REPO_ROOT = Path(__file__).resolve().parents[2]
SCRIPTS = REPO_ROOT / "Internal-IT/engineering/ci-cd/scripts"
COMMIT = "a" * 40


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


class EvidenceBundleTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.bundle = Path(self.tmp.name)
        files = {
            "output/tfplan.json": '{"terraform_version": "1.7.5"}',
            "output/tfplan.binary": "binary-plan",
            "output/compliance-summary.json": '{"decision": "pass"}',
            "output/compliance-report.md": "# Compliance Report",
            "output/checkov-result.json": "{}",
            "evidence/manifest.json": json.dumps({"source": {"commit": COMMIT}}),
        }
        for name, content in files.items():
            path = self.bundle / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(content, encoding="utf-8")
        self.write_checksums(files)

    def tearDown(self):
        self.tmp.cleanup()

    def write_checksums(self, names):
        lines = [f"{sha(self.bundle / n)}  {n}" for n in sorted(names)]
        (self.bundle / "evidence/artifacts.sha256").write_text("\n".join(lines) + "\n", encoding="utf-8")

    def apply(self, **env):
        full_env = {k: v for k, v in os.environ.items() if k != "GITHUB_SHA"}
        full_env.update({"WORKLOAD_DIR": "wl", "EVIDENCE_DIR": str(self.bundle)}, **env)
        return subprocess.run(["bash", str(SCRIPTS / "run-apply.sh")], env=full_env,
                              capture_output=True, text=True)

    def test_untouched_bundle_verifies(self):
        result = self.apply(GITHUB_SHA=COMMIT)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("SIMULATED APPLY", result.stdout)

    def test_tampered_report_fails(self):
        (self.bundle / "output/compliance-report.md").write_text("# edited", encoding="utf-8")
        self.assertEqual(self.apply().returncode, 1)

    def test_tampered_raw_scanner_result_fails(self):
        (self.bundle / "output/checkov-result.json").write_text('{"x": 1}', encoding="utf-8")
        self.assertEqual(self.apply().returncode, 1)

    def test_required_file_missing_from_checksums_fails(self):
        self.write_checksums(["output/tfplan.json", "output/tfplan.binary", "output/compliance-summary.json"])
        result = self.apply()
        self.assertEqual(result.returncode, 1)
        self.assertIn("evidence/manifest.json is not covered", result.stdout)

    def test_evidence_from_another_commit_fails(self):
        result = self.apply(GITHUB_SHA="b" * 40)
        self.assertEqual(result.returncode, 1)
        self.assertIn("not " + "b" * 40, result.stdout)


class ManifestTests(unittest.TestCase):
    def test_manifest_records_commit_tools_and_policy_hashes(self):
        with tempfile.TemporaryDirectory() as tmp:
            out, ev = Path(tmp) / "output", Path(tmp) / "evidence"
            out.mkdir()
            (out / "tfplan.json").write_text('{"terraform_version": "1.7.5"}', encoding="utf-8")
            (out / "checkov-result.json").write_text('{"summary": {"checkov_version": "3.3.20"}}', encoding="utf-8")
            (out / "compliance-summary.json").write_text('{"decision": "fail", "schema_version": "2.0"}', encoding="utf-8")
            env = dict(os.environ, GITHUB_SHA=COMMIT, WORKLOAD_DIR="wl", GITHUB_ACTIONS="true")
            subprocess.run(["python3", str(SCRIPTS / "write-manifest.py"), str(out), str(ev)],
                           cwd=REPO_ROOT, env=env, check=True, capture_output=True)
            manifest = json.loads((ev / "manifest.json").read_text(encoding="utf-8"))

        self.assertEqual(manifest["source"]["commit"], COMMIT)
        self.assertEqual(manifest["source"]["workload_dir"], "wl")
        self.assertEqual(manifest["decision"], "fail")
        self.assertEqual(manifest["tools"]["terraform"], "1.7.5")
        self.assertEqual(manifest["tools"]["checkov"], "3.3.20")
        mapping = "Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml"
        self.assertEqual(manifest["policy_inputs_sha256"][mapping], sha(REPO_ROOT / mapping))
        self.assertTrue(any(p.endswith(".rego") for p in manifest["policy_inputs_sha256"]))


if __name__ == "__main__":
    unittest.main()
