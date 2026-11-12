# Real records

Records of things that were actually done: a tool run, a setting checked, a published supplier document read, a decision the repository owner really took. See [ADR-0006](../../ADR/0006-simulated-operating-records.md).

## Rules

1. One event per file: `<area>/REAL-<AREA>-<nnn>-<slug>.md`.
2. Directly under the title:

   ```
   > **REAL RECORD.** Performed on the date shown. Scope and limits are stated below.
   ```

3. Field table with at least: `Record ID`, `Performed` (date), `Performed by` (the repository owner, or the tool and command), `Controls`.
4. State how to reproduce it (command, URL, commit) and paste or link the output.
5. State the limit: a test against an emulator or a plan is not a test of a deployed system.

Anything that needs the repository owner's own hand (a GitHub setting, an acknowledgement, a tenant check) is listed as **open** until the owner does it. Nobody writes it on their behalf.
