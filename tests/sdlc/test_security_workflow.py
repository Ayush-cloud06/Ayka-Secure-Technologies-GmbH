"""Hardening rules for everything under .github/, and a usable security.txt (RFC 9116).

Every workflow and composite action is checked, not one file: a rule that holds
for security-checks.yml only says nothing about the gate itself.
"""
from datetime import datetime, timezone
from pathlib import Path
import re

import pytest
import yaml

REPO_ROOT = Path(__file__).resolve().parents[2]
GITHUB = REPO_ROOT / ".github"
WORKFLOWS = sorted((GITHUB / "workflows").glob("*.yml"))
ACTIONS = sorted((GITHUB / "actions").glob("*/action.yml"))
SECURITY_TXT = REPO_ROOT / ".well-known/security.txt"
REQUIREMENTS = REPO_ROOT / "tests/requirements.txt"

name = lambda p: str(p.relative_to(GITHUB))  # noqa: E731


def load(path):
    return yaml.safe_load(path.read_text(encoding="utf-8"))


def steps(path):
    """Every step of a workflow (all jobs) or of a composite action."""
    doc = load(path)
    if "runs" in doc:
        return doc["runs"]["steps"]
    return [step for job in doc["jobs"].values() for step in job.get("steps", [])]


def external_uses(path):
    doc = load(path)
    found = [step["uses"] for step in steps(path) if "uses" in step]
    found += [job["uses"] for job in doc.get("jobs", {}).values() if "uses" in job]
    return [ref for ref in found if not ref.startswith("./")]


def test_files_were_found():
    assert len(WORKFLOWS) >= 4 and len(ACTIONS) >= 7
    assert any(external_uses(path) for path in WORKFLOWS + ACTIONS)


@pytest.mark.parametrize("path", WORKFLOWS, ids=name)
def test_workflow_token_is_read_only(path):
    doc = load(path)
    assert doc["permissions"] == {"contents": "read"}
    for job_id, job in doc["jobs"].items():
        assert "permissions" not in job, f"{job_id} widens the token"


@pytest.mark.parametrize("path", WORKFLOWS + ACTIONS, ids=name)
def test_every_action_pinned_to_full_sha(path):
    for ref in external_uses(path):
        assert re.fullmatch(r"[\w.-]+/[\w./-]+@[0-9a-f]{40}", ref), f"not SHA-pinned: {ref}"


@pytest.mark.parametrize("path", WORKFLOWS + ACTIONS, ids=name)
def test_checkout_does_not_keep_the_token(path):
    for step in steps(path):
        if step.get("uses", "").startswith("actions/checkout@"):
            assert step.get("with", {}).get("persist-credentials") is False, step.get("name")


@pytest.mark.parametrize("path", WORKFLOWS + ACTIONS, ids=name)
def test_no_expression_is_pasted_into_a_script(path):
    """A value reaches a script through `env:`, so it can never be run as code."""
    for step in steps(path):
        assert "${{" not in step.get("run", ""), f"use env: in step {step.get('name')!r}"


@pytest.mark.parametrize("path", WORKFLOWS + ACTIONS, ids=name)
def test_downloaded_binaries_are_checksummed(path):
    text = path.read_text(encoding="utf-8")
    assert len(re.findall(r"\bwget\b", text)) == len(re.findall(r"sha256sum -c", text))
    for digest in re.findall(r'echo "([0-9a-f]+)\s', text):
        assert len(digest) == 64


@pytest.mark.parametrize("path", WORKFLOWS, ids=name)
def test_every_job_has_a_timeout(path):
    for job_id, job in load(path)["jobs"].items():
        if "uses" in job:  # a job that calls a reusable workflow cannot set one
            continue
        assert isinstance(job.get("timeout-minutes"), int), f"{job_id} has no timeout-minutes"


@pytest.mark.parametrize("path", WORKFLOWS + ACTIONS, ids=name)
def test_uploaded_artifacts_state_their_retention(path):
    for step in steps(path):
        if step.get("uses", "").startswith("actions/upload-artifact@"):
            assert step.get("with", {}).get("retention-days") == 90, step.get("name")


@pytest.mark.parametrize(
    "workflow, summary",
    [("test.yml", "gate-summary"), ("security-checks.yml", "security-summary")],
)
def test_summary_job_waits_for_every_other_job(workflow, summary):
    """The ruleset can require one name per workflow only if that job covers all of them."""
    jobs = load(GITHUB / "workflows" / workflow)["jobs"]
    assert set(jobs[summary]["needs"]) == set(jobs) - {summary}
    assert jobs[summary]["if"] == "always()"


def test_simulated_apply_needs_a_manual_dispatch():
    """On a push nobody answers the approval prompt; after 30 days the run ends red."""
    condition = load(GITHUB / "workflows/terraform-workflow.yml")["jobs"]["apply"]["if"]
    assert "github.event_name == 'workflow_dispatch'" in condition
    assert "github.ref == 'refs/heads/main'" in condition


def test_python_dependencies_are_pinned_in_one_place():
    """Dependabot bumps tests/requirements.txt; a second pin in .github/ would be missed."""
    pinned = re.findall(r"^([A-Za-z0-9_.-]+)==", REQUIREMENTS.read_text(encoding="utf-8"), re.M)
    assert pinned
    ci = "\n".join(p.read_text(encoding="utf-8") for p in WORKFLOWS + ACTIONS)
    for package in pinned:
        assert not re.search(rf"\b{re.escape(package)}==", ci, re.I), f"{package} is pinned again in .github/"


def test_security_checks_run_on_a_schedule():
    triggers = load(GITHUB / "workflows/security-checks.yml")[True]  # YAML reads the key `on` as True
    assert triggers["schedule"], "a new advisory must not wait for the next push"


def _fields():
    fields = {}
    for line in SECURITY_TXT.read_text(encoding="utf-8").splitlines():
        if line and not line.startswith("#"):
            name_, _, value = line.partition(":")
            fields.setdefault(name_.strip(), []).append(value.strip())
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
