# REAL-PRIV-001: DSR tool and masking test run

> **REAL RECORD.** Performed on the date shown. Scope and limits are stated below.

| Field | Value |
|---|---|
| Record ID | REAL-PRIV-001 |
| Performed | 2026-11-10 |
| Performed by | Repository owner, AI-assisted tool run (Claude Code) |
| Controls | GDPR Art. 12, 15, 17, 25, 32; ISO/IEC 27001:2022 A.8.11, A.5.34; [data subject rights procedure](../../../GDPR/data-subject-rights-procedure.md); [STD-MSK-01](../../../policies/data-masking-standard.md) section 4 |
| Code | [`dsr_tool.py`](../../../../Internal-IT/engineering/privacy/dsr_tool.py), [`masking.py`](../../../../Internal-IT/engineering/privacy/masking.py) |
| Tests | [`test_dsr_tool.py`](../../../../tests/privacy/test_dsr_tool.py), [`test_masking.py`](../../../../tests/privacy/test_masking.py) |
| Baseline commit | 509f4b2 plus uncommitted working-tree files (the files above were new when run) |

## What was run

```text
.venv/bin/python -m pytest -v tests/privacy
```

Python 3.10.12, pytest 9.1.1. Result: **19 passed in 0.90s** (11 in `test_dsr_tool.py`, 8 in `test_masking.py`).

## What the tests show

Known-good:

- The tool finds one subject's rows in six tables modelled on PA-01 to PA-04 and PP-01.
- Erasure deletes or anonymises those rows, redacts the identifier in free text, and re-checks that no unheld strong match remains.
- Export and dry run change nothing.
- Masking drops unlisted fields by default, labels the output, and a known identifier does not survive in the output, nested fields included.

Known-bad (the tool must refuse or leave alone):

- A row with `legal_hold = 1` is kept and reported, while the subject's other rows are erased.
- A name-only match (a namesake) is reported as weak and is not erased.
- A near-miss email is not touched.
- PP-01 rows are not erased without a stated controller instruction.
- The audit log contains the request ID, table, row ID, outcome and counts, and none of the identifiers or column values.
- A subject with no strong identifier is refused.
- The leak checker flags unmasked data.

## Limits

- Fixture data only. Every record is synthetic (`example.invalid` addresses). Nothing was read from `personnel.json`, which STD-MSK-01 forbids as a source.
- Not a deployed system. It was run against a temporary SQLite database. It says nothing about RDS, S3, CloudTrail or any `ayka-portal` component, none of which exist.
- Backups, Git history and provider-side logs are not searched. The tool says so in every report. A real Git history cannot be erased by this tool.
- `PRAGMA secure_delete=ON` is set and tested as a setting. Overwriting of freed SQLite pages was not inspected at file level.
- The masking tool is a function library, not an approved product. STD-MSK-01 still shows no approved selection.
- Tests are not wired as a required status check; `.github/workflows/test.yml` runs `pytest tests/`, which includes them, but no branch rule was verified here.

## Reproduce

From the repository root: `.venv/bin/python -m pytest -v tests/privacy`. Manual use: `python Internal-IT/engineering/privacy/dsr_tool.py find --db <sqlite file> --email <address>`.
