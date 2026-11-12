# Security policy

Ayka Secure Technologies GmbH is a simulated company. This repository is a public case study with a real CI compliance gate. Nobody monitors a company mailbox; the placeholder address in [`.well-known/security.txt`](.well-known/security.txt) does not exist.

## Reporting a vulnerability in this repository

Use **GitHub private vulnerability reporting**: <https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/security/advisories/new>.

- Do not open a public issue or pull request for a vulnerability, and do not post secrets or exploitable details publicly.
- Include the affected path or workflow, steps to reproduce, and the impact you expect.
- If you find a real credential, report it the same way and do not use it.

The repository owner handles reports on a best-effort basis (a hobby-scale, single-maintainer project). Targets, scope and safe harbour are in the [vulnerability disclosure policy](Governance/policies/vulnerability-disclosure-policy.md).

## Supported versions

Only the current `main` branch is maintained.

## Known history

Entra bootstrap passwords were committed in the past and remain in public Git history (risk RISK-001). They were removed from the current tree on 2026-09-28. Reports about those values are already known.
