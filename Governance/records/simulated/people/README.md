# Simulated people-process records

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

Walk-throughs of joiner, training, confidentiality, leaver, mover and role-appointment steps for the 24 fictional staff of Ayka Secure Technologies GmbH. Rules for every file are in the [simulated records README](../README.md). The machine-readable staff list is [`organization/personnel.json`](../../../../organization/personnel.json).

Related records held elsewhere, cited by ID only: SIM-GOV-001 (management commitment and policy approval, 2026-03-02), SIM-ACC-001 (Q2 access review, 2026-06-22), SIM-GDPR records (DPO decision).

| ID | Title | Scenario date | Controls |
|---|---|---|---|
| [SIM-PPL-001](SIM-PPL-001-joiner-batch.md) | Joiner batch for the 24 founding staff | 2026-01-01 to 2026-04-29 | A.6.1, A.6.2, A.6.6, A.5.10, A.5.15, A.5.16, A.5.18, A.8.2; SOC 2 CE-02, CE-04, CO-03, AC-01, AC-06 |
| [SIM-PPL-002](SIM-PPL-002-nda-index.md) | Confidentiality agreement index | 2026-01-01 to 2026-04-02 | A.6.6, A.6.2, A.5.14; SOC 2 CO-03 |
| [SIM-PPL-003](SIM-PPL-003-training-completion.md) | Training completion: awareness for 24, role-based for Tier 0 and Tier 1 | 2026-03-04 to 2026-04-28 | clause 7.2, 7.3, A.6.3; SOC 2 CE-05 |
| [SIM-PPL-004](SIM-PPL-004-leaver-emp-023.md) | Leaver: EMP-023, last day 2026-05-29, one late GitHub removal | 2026-04-28 to 2026-06-22 | A.6.5, A.5.11, A.5.18, A.8.2, A.7.10; SOC 2 AC-06, AC-18 |
| [SIM-PPL-005](SIM-PPL-005-mover-emp-019.md) | Mover: EMP-019 to Security Operations | 2026-05-12 to 2026-06-19 | A.5.15, A.5.18, A.8.2, A.6.3; SOC 2 AC-06, AC-07, CE-05 |
| [SIM-PPL-006](SIM-PPL-006-role-holder-appointments.md) | Role-holder appointments and gap owners G01 to G10 | 2026-03-02 to 2026-03-04 | clause 5.3, A.5.2, A.5.3, A.5.24; SOC 2 CE-03 |
| [SIM-PPL-007](SIM-PPL-007-disciplinary-case.md) | Disciplinary case after incident INC-2026-001 | 2026-08-27 | A.6.4 |

## Dependency

SOC 2 control CE-02 needs a code of conduct. None exists. SIM-PPL-001 shows the acknowledgement column empty for all 24. Once a code of conduct is written, CE-02 can be walked again.
