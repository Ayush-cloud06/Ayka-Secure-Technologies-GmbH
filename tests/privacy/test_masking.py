"""Masking functions against STD-MSK-01. Synthetic data only."""

import json
import sys
from pathlib import Path

import pytest

REPO = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(REPO / "Internal-IT/engineering/privacy"))
import masking as m  # noqa: E402

ROWS = [
    {"name": "Alex Example", "email": "alex.example@example.invalid", "ip": "198.51.100.7",
     "role": "viewer", "ticket": "Please call Alex Example (alex.example@example.invalid)",
     "nested": {"contact": {"email": "alex.example@example.invalid"}}, "secret_note": "salary"},
    {"name": "Sam Other", "email": "sam@example.invalid", "ip": "198.51.100.8", "role": "admin",
     "ticket": "ok", "nested": {"contact": {"email": "sam@example.invalid"}}, "secret_note": "x"},
]
POLICY = {
    "name": (m.SYNTHETIC, "name"), "email": (m.SYNTHETIC, "email"), "ip": (m.TOKENISE, "ip"),
    "role": (m.KEEP, "role"), "ticket": (m.KEEP, "text"),
    "nested": (m.KEEP, "nested"), "contact": (m.KEEP, "contact"),
}
IDS = ["Alex Example", "alex.example@example.invalid", "198.51.100.7"]


def run(**kw):
    return m.mask_dataset(ROWS, POLICY, source="fixture", date="2026-11-10", identifiers=IDS, **kw)


def test_known_identifier_does_not_survive_anywhere():
    out = run()
    assert m.survivors(out, IDS) == []


def test_survivors_detects_a_leak():
    leaky = json.loads(json.dumps(ROWS))
    assert m.survivors(leaky, IDS)  # known-bad: unmasked data is caught


def test_unlisted_fields_are_removed_by_default():
    out = run()
    assert all("secret_note" not in r for r in out["rows"])


def test_label_carries_what_the_standard_requires():
    label = run()["label"]
    assert label["source_system"] == "fixture" and label["date"] == "2026-11-10"
    assert label["transformations"]["name"] == "synthetic"
    assert label["fields_still_identifying"] == ["contact", "nested", "role", "ticket"]
    assert label["tokens"] == "token store kept separately"


def test_synthetic_is_consistent_in_a_run_and_not_derived_from_original():
    a = m.Synthesiser()
    assert a.value("email", "x@example.invalid") == a.value("email", "x@example.invalid")
    assert a.value("email", "x@example.invalid") != a.value("email", "y@example.invalid")
    assert "x@" not in a.value("email", "x@example.invalid")


def test_tokens_are_random_stable_and_reversible_only_via_vault():
    v = m.TokenVault()
    t1 = v.token("ip", "198.51.100.7")
    assert t1 == v.token("ip", "198.51.100.7") and "198.51.100.7" not in t1
    assert m.TokenVault().token("ip", "198.51.100.7") != t1  # no deterministic hash of the value
    assert "198.51.100.7" in v.dump()  # the vault is the sensitive part


def test_unknown_action_rejected():
    with pytest.raises(ValueError):
        m.mask_dataset(ROWS, {"name": ("hash", "name")}, source="s", date="d")


def test_scrub_text_is_case_insensitive():
    assert m.scrub_text("hi ALEX@X.invalid", ["alex@x.invalid"]) == "hi [masked]"
