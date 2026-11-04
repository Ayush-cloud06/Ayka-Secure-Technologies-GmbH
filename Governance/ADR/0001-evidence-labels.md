# ADR-0001: Weakest true label on every claim

| Field | Value |
|---|---|
| Status | Recorded |
| Date | 2026-10-14 |
| Deciders | Repository practice already in the README, the SoA and the SOC 2 matrix. No separate approval record |

## Context

The same repository holds a plan-analysis gate that runs, a simulated company, and Terraform that has not been applied. Readers were previously shown designs as if they were operating controls.

## Drivers

- A recruiter or an auditor must be able to tell a CI check from a policy draft.
- Two vocabularies already exist and are not the same list.
- Inventing approvals, minutes or test results would make the repository false.

## Options

1. One word, "compliant", for anything written down.
2. The README yardstick only: Implemented, Simulated, Planned.
3. Keep the README yardstick for capabilities, and the ISMS/SOC 2 vocabulary for controls. Use the weakest label the evidence supports.

## Outcome

Option 3.

- Capabilities in the [README](../../README.md) use Implemented, Simulated and Planned.
- Annex A and SOC 2 controls use Implemented, Partial, Gated design, Designed and Planned, as defined in the [Statement of Applicability](../ISMS/04-controls-and-soa/statement-of-applicability.md).
- Designed means a document or ungated Terraform exists. It does not mean the control operates.
- Planned means the control-specific design is still missing. After the 2026-10-14 design batch, no Annex A row is Planned. The operating gaps are unchanged.
- GDPR measure tables may say "Implemented (plan check only)" when they point at a gate ID. The parenthesis is mandatory.

## Consequences

Writers update the SoA summary counts in the same change as a status. The pytest in [ADR-0004](0004-docs-gate.md) does not understand prose, so a wrong count has to be caught by `tests/governance/test_soa.py`.

Positive: a draft cannot be mistaken for a running control without ignoring the label. Negative: two lists must be kept apart, or a gate check gets described as a certified control.

## Evidence

- [README yardstick](../../README.md)
- [SoA status rules](../ISMS/04-controls-and-soa/statement-of-applicability.md)
- [SOC 2 status vocabulary](../SOC2/README.md)

