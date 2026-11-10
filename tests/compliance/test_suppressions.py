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
        keys = Counter((e["policy_id"], e["resource"], e.get("workload")) for e in self.exceptions)
        self.assertEqual([k for k, n in keys.items() if n > 1], [])

    def test_every_exception_is_scoped_to_an_existing_workload(self):
        """The same address can exist in several roots; an unscoped entry would apply to all."""
        bad = [(e["policy_id"], e["resource"], e.get("workload")) for e in self.exceptions
               if not e.get("workload") or not (REPO_ROOT / e["workload"]).is_dir()]
        self.assertEqual(bad, [])

    def test_expiry_dates_are_staggered(self):
        """SOC 2 readiness observation: one shared expiry would return every finding on one day."""
        dates = Counter(str(e["expires"]) for e in self.exceptions)
        self.assertGreaterEqual(len(dates), 6)
        self.assertLessEqual(max(dates.values()), len(self.exceptions) // 4)

    def test_exceptions_expire_within_a_review_cycle(self):
        limit = date.today() + MAX_LIFETIME
        too_long = [(e["policy_id"], e["resource"], str(e["expires"]))
                    for e in self.exceptions if date.fromisoformat(str(e["expires"])) > limit]
        self.assertEqual(too_long, [])


if __name__ == "__main__":
    unittest.main()
