"""A decision record cited anywhere in the repository must exist in Governance/ADR/.

Code comments once cited five records that were never written. A reader who
follows such a citation finds nothing, so the build fails instead.
"""
import re
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
ADR_DIR = REPO / "Governance/ADR"
ROOTS = [".github", "Governance", "Internal-IT", "organization", "tests", "docs", "README.md", "SECURITY.md"]
SUFFIXES = {".md", ".py", ".sh", ".yml", ".yaml", ".rego", ".tf", ".toml", ".txt", ".versions"}
SKIP_DIRS = {".terraform", "__pycache__"}
CITATION = re.compile(r"\bADR-(\d{4})\b")


def text_files():
    for root in ROOTS:
        base = REPO / root
        candidates = [base] if base.is_file() else base.rglob("*")
        for path in candidates:
            if path.is_file() and path.suffix in SUFFIXES and not SKIP_DIRS & set(path.parts):
                yield path


def test_every_cited_adr_exists():
    recorded = {p.name[:4] for p in ADR_DIR.glob("[0-9][0-9][0-9][0-9]-*.md")}
    assert recorded, "no decision records found"
    missing = sorted(
        f"{path.relative_to(REPO)}: ADR-{number}"
        for path in text_files()
        for number in set(CITATION.findall(path.read_text(encoding="utf-8", errors="ignore")))
        if number not in recorded
    )
    assert not missing, "cited but not recorded: " + "; ".join(missing)


def test_every_adr_is_in_the_index():
    index = (ADR_DIR / "README.md").read_text(encoding="utf-8")
    for record in sorted(ADR_DIR.glob("[0-9][0-9][0-9][0-9]-*.md")):
        assert f"]({record.name})" in index, f"{record.name} is missing from the ADR index"
