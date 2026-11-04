# Architecture decision records

These records state decisions that the repository already follows. They are not management-approval minutes. The [document control procedure](../ISMS/00-context-and-governance/document-control-procedure.md) still requires an approver before an ISMS document is effective.

## Status values

| Status | Meaning |
|---|---|
| Recorded | The repository already behaves this way. The date is when this file was written, not when a manager signed |
| Superseded | A later record in this folder replaces it. Leave the old file in place |

A later change adds a new record. It does not rewrite a Recorded file.

## Index

| No. | Title | Status | Decision |
|---|---|---|---|
| [0001](0001-evidence-labels.md) | Weakest true label on every claim | Recorded | Capability claims use the README yardstick. Control claims use the ISMS and SOC 2 vocabulary. A draft is not Implemented |
| [0002](0002-policy-location.md) | One policy set under Governance/policies | Recorded | Frameworks link to that directory. The ISMS register does not keep a second copy |
| [0003](0003-target-region.md) | Target Region is eu-central-1 | Recorded | The target is documented. Source that still names ap-south-1 is an open gap, not an exception |
| [0004](0004-docs-gate.md) | Governance docs fail CI when links break or files are empty | Recorded | `tests/governance/` is part of the pytest gate |
| [0005](0005-gdpr-roles.md) | Working GDPR roles, not a legal conclusion | Recorded | Controller for repository and designed employment data. Processor for designed customer evidence. Both remain to be confirmed |

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
