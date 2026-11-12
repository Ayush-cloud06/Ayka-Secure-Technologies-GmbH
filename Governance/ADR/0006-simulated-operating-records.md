# ADR-0006: Simulated operating records and the status "Simulated operation"

| Field | Value |
|---|---|
| Status | Recorded |
| Date | 2026-11-10 |
| Deciders | Repository owner. No separate approval record |

## Context

Every framework in this repository stopped at the same wall: the designs exist, but no approval, review, exercise or test had happened, so nothing could be shown working. [ADR-0001](0001-evidence-labels.md) forbids inventing such records and presenting them as fact. A reader still needs to see that each procedure can be followed from start to finish and what its output looks like.

## Drivers

- A procedure nobody has walked through is untested prose.
- A walk-through must never be mistaken for a real event.
- Some things can really be done by one person with a laptop (tool runs, restore tests against an emulator, reading a supplier's published report). Those are real and should be recorded as real.

## Options

1. Keep templates empty until a real company exists.
2. Fill the logs with invented entries.
3. Keep two separate record stores, one real and one simulated, each bannered, with a control status that sits between Designed and Partial.

## Outcome

Option 3.

**Two stores.**

- [`Governance/records/real/`](../records/real/README.md): something was actually done, on the date given, by the repository owner or by a tool run. The record says how to reproduce it.
- [`Governance/records/simulated/`](../records/simulated/README.md): a tabletop walk-through of a procedure using the fictional staff in the [personnel register](../../organization/personnel-register.md).

**Rules for a simulated record.**

- The first lines under the title carry the banner `SIMULATED RECORD`.
- It states `Authored` (the real date the file was written) and `Scenario date` (the date inside the fiction). The two are never merged.
- It names the procedure it exercises and the controls it touches.
- People are employee IDs from the personnel register. Customers are fictional and labelled so. Real third parties (AWS, Microsoft, GitHub, authorities) may be named as the counterpart, but no statement, reply, signature or contract is attributed to them.
- "Signed" and "approved" are written as "scenario decision by EMP-nnn". There are no signatures.
- A believable exercise finds problems. Findings go to the real [improvement register](../ISMS/11-improvement/improvement-register.md) only when they are true of the repository itself; otherwise they stay inside the simulated store.

**New control status: Simulated operation.** A design exists and a bannered simulated record walks it end to end. It is not operating evidence. Order of strength:

`Planned < Designed < Gated design < Simulated operation < Partial < Implemented`

- A row with this status links a file under `records/simulated/`.
- An Implemented row never cites a simulated record.
- Counts of Implemented and Partial do not include it.

## Consequences

`tests/governance/test_simulated_records.py` enforces the banner, the fields and the two citation rules. Positive: every procedure has a worked example, and real evidence is separated from it by directory. Negative: a careless reader may still count Simulated operation as done; the summary tables must print it in its own row.

## Evidence

- [Simulated record rules](../records/simulated/README.md)
- [Real record rules](../records/real/README.md)
