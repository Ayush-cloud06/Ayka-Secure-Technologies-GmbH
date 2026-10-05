"""Checks for the Governance/ Markdown documents.

Two rules, both from the restore plan:
- every relative link points at a file or folder that exists;
- no Markdown file is empty or only a title.
"""

import re
from pathlib import Path

# [text](target) — ignores images' leading "!" on purpose (same rule applies)
LINK = re.compile(r"\[[^\]]*\]\(([^)\s]+)\)")
EXTERNAL = ("http://", "https://", "mailto:", "#")


def broken_links(md_file: Path) -> list[str]:
    """Return relative link targets in md_file that do not exist on disk."""
    text = md_file.read_text(encoding="utf-8")
    # Code blocks often hold example links; don't check them
    text = re.sub(r"```.*?```", "", text, flags=re.S)
    broken = []
    for target in LINK.findall(text):
        if target.startswith(EXTERNAL):
            continue
        path = target.split("#", 1)[0]
        if path and not (md_file.parent / path).exists():
            broken.append(target)
    return broken


def is_stub(md_file: Path) -> bool:
    """True when the file has no content beyond headings and blank lines."""
    lines = [l.strip() for l in md_file.read_text(encoding="utf-8").splitlines()]
    return not [l for l in lines if l and not l.startswith("#")]
