# ADR-0004: Governance documents are part of the test gate

| Field | Value |
|---|---|
| Status | Recorded |
| Date | 2026-10-14 |
| Deciders | Tests already in `tests/governance/`. No separate approval record |

## Context

Governance documents link to each other and to source paths. Empty files and broken links had made the tree look finished when it was not.

## Drivers

- A link to a missing procedure is a false control reference.
- A title-only file reads as a document that exists.
- The SoA's 93 rows and its summary counts have to match, including the gate IDs cited on each row.

## Options

1. Review documents by hand.
2. Fail `pytest` when a Governance Markdown file, other than the local planning file `tree.md`, has a broken relative link or no body, and fail when the SoA counts or gate IDs drift.

## Outcome

Option 2. `tests/governance/test_docs.py` checks links and rejects stubs. `tests/governance/test_soa.py` checks the Annex A set, the status summary and the bidirectional control-mapping citations. Both run with the rest of `tests/` in CI.

The tests do not check that a sentence is true. A document can pass with a false claim if the links resolve.

## Consequences

Renaming a file requires updating every link in the same change. Positive: the register cannot point at a deleted policy. Negative: anchor mistakes are not caught, and prose can still overclaim.

## Evidence

- [`tests/governance/test_docs.py`](../../tests/governance/test_docs.py)
- [`tests/governance/test_soa.py`](../../tests/governance/test_soa.py)
- [`tests/governance/docs_check.py`](../../tests/governance/docs_check.py)

## Links

- [ADR-0001](0001-evidence-labels.md)
