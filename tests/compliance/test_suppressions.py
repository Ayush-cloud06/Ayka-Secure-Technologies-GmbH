"""One place to set a finding aside: exceptions.yaml (issue #18).

Checkov scans the plan JSON, where inline `checkov:skip` comments are
ignored, and an inline skip has no owner or expiry anyway. So inline
suppressions are not allowed, and every exception stays reviewable.
"""
from collections import Counter
from datetime import date, timedelta
from pathlib import Path
import re
import unittest

import yaml

REPO_ROOT = Path(__file__).resolve().parents[2]
EXCEPTIONS = REPO_ROOT / "Internal-IT/engineering/policy-as-code/metadata/exceptions.yaml"
INLINE = re.compile(r"(checkov:skip|tfsec:ignore|trivy:ignore|#\s*nosec)", re.IGNORECASE)
MAX_LIFETIME = timedelta(days=400)


class SuppressionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.exceptions = yaml.safe_load(EXCEPTIONS.read_text(encoding="utf-8"))["exceptions"]

    def test_no_inline_scanner_suppressions(self):
        hits = [
            f"{path.relative_to(REPO_ROOT)}:{n}: {line.strip()}"
            for path in sorted((REPO_ROOT / "Internal-IT").rglob("*.tf"))
            for n, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1)
            if INLINE.search(line)
        ]
        self.assertEqual(hits, [], "move these to exceptions.yaml with a reason, owner and expiry")

    def test_each_exception_is_unique(self):
        keys = Counter((e["policy_id"], e["resource"]) for e in self.exceptions)
        self.assertEqual([k for k, n in keys.items() if n > 1], [])

    def test_exceptions_expire_within_a_review_cycle(self):
        limit = date.today() + MAX_LIFETIME
        too_long = [(e["policy_id"], e["resource"], str(e["expires"]))
                    for e in self.exceptions if date.fromisoformat(str(e["expires"])) > limit]
        self.assertEqual(too_long, [])


if __name__ == "__main__":
    unittest.main()
