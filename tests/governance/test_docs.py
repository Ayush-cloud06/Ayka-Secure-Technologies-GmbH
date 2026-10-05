import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).parent))
from docs_check import broken_links, is_stub  # noqa: E402

REPO = Path(__file__).resolve().parents[2]
GOVERNANCE = REPO / "Governance"
# tree.md is a local planning file, never committed
DOCS = sorted(p for p in GOVERNANCE.rglob("*.md") if p.name != "tree.md")


def test_helper_finds_broken_link(tmp_path):
    (tmp_path / "exists.md").write_text("# Exists\n\nBody.\n")
    doc = tmp_path / "doc.md"
    doc.write_text(
        "# Doc\n\n[ok](exists.md) [ok-anchor](exists.md#x) [web](https://example.com)\n"
        "[bad](missing.md)\n```\n[ignored](in-code-block.md)\n```\n"
    )
    assert broken_links(doc) == ["missing.md"]


def test_helper_flags_stub(tmp_path):
    stub = tmp_path / "stub.md"
    stub.write_text("# Title only\n\n## Section\n")
    real = tmp_path / "real.md"
    real.write_text("# Title\n\nSome text.\n")
    assert is_stub(stub)
    assert not is_stub(real)


@pytest.mark.parametrize("doc", DOCS, ids=lambda p: str(p.relative_to(REPO)))
def test_governance_links_resolve(doc):
    assert broken_links(doc) == []


@pytest.mark.parametrize("doc", DOCS, ids=lambda p: str(p.relative_to(REPO)))
def test_governance_doc_not_stub(doc):
    assert not is_stub(doc)
