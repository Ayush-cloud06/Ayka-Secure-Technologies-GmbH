# ADR-0002: One policy set under Governance/policies

| Field | Value |
|---|---|
| Status | Recorded |
| Date | 2026-10-14 |
| Deciders | Repository layout already used by the ISMS register. No separate approval record |

## Context

ISO 27001, SOC 2 and NIS2 were accumulating separate copies of the same rules. The ISMS tree has no `05-operational-policies` directory.

## Drivers

- One requirement must have one owner and one review date.
- Framework mappings should link to the requirement, not fork it.
- Empty placeholder files had already been removed rather than filled twice.

## Options

1. A full policy copy under `Governance/ISMS/05-operational-policies/`.
2. Policies only inside `Governance/SOC2/policies/`.
3. One set in `Governance/policies/`, with the ISMS register marking those rows "Covered elsewhere".

## Outcome

Option 3. New shared requirements go in `Governance/policies/` and gain a row in the [policy register](../policies/README.md) and the [ISMS register](../ISMS/README.md). Procedures that say how a role carries a policy out stay under `Governance/ISMS/06-operational-procedures/`. GDPR records stay under `Governance/GDPR/`.

## Consequences

A control can look undocumented if a reader opens only the ISMS folders. The register is the index that prevents that. Positive: access control, logging and supplier rules are not edited in two places.

## Evidence

- [Policy register](../policies/README.md)
- [ISMS register](../ISMS/README.md), area 05

## Links

- [ADR-0001](0001-evidence-labels.md)
