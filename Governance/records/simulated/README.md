# Simulated records

> Everything in this folder is a tabletop walk-through. None of it happened. Ayka Secure Technologies GmbH and its staff are fictional. See [ADR-0006](../../ADR/0006-simulated-operating-records.md).

## Rules

1. One event per file: `<area>/SIM-<AREA>-<nnn>-<slug>.md`.
2. Directly under the title:

   ```
   > **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.
   ```

3. Then a field table with at least: `Record ID`, `Authored` (real date), `Scenario date` (date inside the fiction), `Participants` (employee IDs), `Procedure exercised` (link), `Controls` (Annex A, SOC 2, GDPR or NIS2 references).
4. No signatures. Write "scenario decision by EMP-nnn".
5. No statement, reply or contract is attributed to a real third party. Fictional customers are called "Customer A (fictional)".
6. End with `## Findings` (what the walk-through showed was wrong or missing in the procedure) and `## What this does not show`.

A simulated record can raise a control to **Simulated operation** and no higher.
