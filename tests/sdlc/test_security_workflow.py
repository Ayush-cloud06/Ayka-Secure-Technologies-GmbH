"""security-checks.yml must pin every action by SHA; security.txt must be usable (RFC 9116)."""
from datetime import datetime, timezone
from pathlib import Path
import re

import yaml

REPO_ROOT = Path(__file__).resolve().parents[2]
WORKFLOW = REPO_ROOT / ".github/workflows/security-checks.yml"
SECURITY_TXT = REPO_ROOT / ".well-known/security.txt"


def _uses():
    doc = yaml.safe_load(WORKFLOW.read_text(encoding="utf-8"))
    found = []
    for job in doc["jobs"].values():
        for step in job.get("steps", []):
            if "uses" in step:
                found.append(step["uses"])
    return found


def test_workflow_has_actions_and_least_privilege():
    assert _uses(), "no actions found"
    doc = yaml.safe_load(WORKFLOW.read_text(encoding="utf-8"))
    assert doc["permissions"] == {"contents": "read"}


def test_every_action_pinned_to_full_sha():
    for ref in _uses():
        assert re.fullmatch(r"[\w.-]+/[\w./-]+@[0-9a-f]{40}", ref), f"not SHA-pinned: {ref}"


def test_downloaded_binaries_are_checksummed():
    text = WORKFLOW.read_text(encoding="utf-8")
    assert len(re.findall(r"\bwget\b", text)) == len(re.findall(r"sha256sum -c", text))
    for digest in re.findall(r'echo "([0-9a-f]+)\s', text):
        assert len(digest) == 64


def _fields():
    fields = {}
    for line in SECURITY_TXT.read_text(encoding="utf-8").splitlines():
        if line and not line.startswith("#"):
            name, _, value = line.partition(":")
            fields.setdefault(name.strip(), []).append(value.strip())
    return fields


def test_security_txt_has_contact():
    contacts = _fields().get("Contact", [])
    assert contacts
    assert all(re.match(r"(mailto:|https://)", c) for c in contacts)


def test_security_txt_not_expired_and_within_a_year():
    expires = _fields()["Expires"]
    assert len(expires) == 1
    when = datetime.fromisoformat(expires[0].replace("Z", "+00:00"))
    now = datetime.now(timezone.utc)
    assert when > now, "security.txt has expired"
    assert (when - now).days <= 366, "RFC 9116 recommends Expires less than a year ahead"
