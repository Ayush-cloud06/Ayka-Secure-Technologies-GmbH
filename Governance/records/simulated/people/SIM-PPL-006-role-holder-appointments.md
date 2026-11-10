# SIM-PPL-006: Role-holder appointments and gap owners

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-PPL-006 |
| Authored | 2026-11-10 (real date) |
| Scenario date | 2026-03-02 to 2026-03-04 |
| Participants | EMP-001 (appoints), EMP-002, EMP-003, EMP-004, EMP-005, EMP-006, EMP-009, EMP-011, EMP-012, EMP-013, EMP-014, EMP-016, EMP-018, EMP-020, EMP-021 |
| Procedure exercised | [Roles and responsibilities](../../../../organization/roles-and-responsibilities.md); [Personnel register](../../../../organization/personnel-register.md) sections 3 and 4; [Incident response plan](../../../policies/incident-response-plan.md) roles table; [Control gap analysis](../../../ISMS/04-controls-and-soa/control-gap-analysis.md) section 3 |
| Controls | ISO 27001:2022 clause 5.3, A.5.2, A.5.3, A.5.24, A.6.3; SOC 2 CE-03, CE-01; GDPR Art. 24, Art. 38(6) (conflicts, if a DPO is appointed) |

## Scenario summary

With the management commitment of 2026-03-02 (SIM-GOV-001), EMP-001 appointed role holders on 2026-03-02 and 2026-03-03. The appointments are scenario decisions by EMP-001. Each holder confirmed by e-mail on 2026-03-04 (scenario text). No signed appointment letters exist. The table lists role, holder, deputy, effective date and a note on where the role comes from.

## 1. Role holders

| Role | Holder | Deputy | Effective | Note |
|---|---|---|---|---|
| ISMS Owner / CISO | EMP-002 | None named | 2026-03-02 | Policy owner. Starts 2026-01-01; formal appointment on policy approval |
| Risk Acceptance Authority / Managing Director | EMP-001 | None named | 2026-03-02 | Register section 4 |
| ISMS document control and policy management | EMP-018 | EMP-002 | 2026-03-03 | Runs the document control procedure |
| Risk analyst (risk register upkeep) | EMP-018 | EMP-002 | 2026-03-03 | Same person as document control |
| Incident Commander | EMP-002 | EMP-005 | 2026-03-03 | As written in the incident response plan, section on roles |
| Incident coordinator / incident handler | EMP-005 | EMP-020 | 2026-03-03 | Register: Incident Coordinator. Deputy chosen from his own team |
| Technical Lead (incident) | EMP-003 | EMP-013 | 2026-03-03 | Plan says "Cloud Platform Engineer on call"; there is no rota |
| Communications Lead (incident) | EMP-001 | EMP-009 | 2026-03-03 | Plan names "Head of Sales and Customer Success" as deputy; no such post. EMP-009 is the Sales Manager |
| Privacy Lead / GDPR Lead | EMP-004 | EMP-021 | 2026-03-03 | Plan names the GDPR Lead; register assigns EMP-004 |
| Data protection contact (internal point for data-subject requests) | EMP-004 | EMP-021 | 2026-03-03 | Not a DPO appointment. See below |
| Internal auditor | EMP-021 | EMP-004 (see Findings) | 2026-03-03 | Register also lists EMP-004 |
| Vulnerability Manager | EMP-014 | EMP-017 | 2026-03-03 | Register security role |
| Asset Custodian | EMP-011 | EMP-003 | 2026-03-03 | Register security role |
| Supplier Risk Coordinator | EMP-016 | EMP-004 | 2026-03-03 | Register section 4 supplier oversight |
| Training Coordinator | EMP-012 | EMP-023 | 2026-03-03 | Deputy EMP-023 ended with the leaver record SIM-PPL-004; no replacement named |
| Business Risk Contributor | EMP-006 | EMP-009 | 2026-03-03 | Register security role |

### Data protection contact and the DPO question

EMP-004 is appointed internal contact for data-subject requests. This is a working contact, not a data protection officer. Whether Ayka must appoint a DPO, and who, is decided and recorded elsewhere in the SIM-GDPR records and in the [DPO decision register](../../../GDPR/dpo-and-legal-basis.md). This record makes no decision on that. No published contact exists today.

## 2. Gap owners G01 to G10

The [control gap analysis](../../../ISMS/04-controls-and-soa/control-gap-analysis.md) names a function per gap. This table maps each function to one accountable employee and one supporting employee. Scenario decisions by EMP-002 on 2026-03-04, accepted by EMP-001.

| Gap | Owner function (gap analysis) | Accountable | Support | Subject |
|---|---|---|---|---|
| G01 | CISO | EMP-002 | EMP-012 | Governance, screening, training, independent oversight |
| G02 | Cloud Platform Engineering | EMP-003 | EMP-013 | Identity, trust and privileged roles |
| G03 | Cloud Platform Engineering | EMP-013 | EMP-003 | State custody, bootstrap, monitoring, backup |
| G04 | HR & Administration | EMP-012 | EMP-011 | Physical and environmental |
| G05 | Compliance & Risk Management | EMP-004 | EMP-016 | Suppliers and contracts |
| G06 | Product & Engineering | EMP-006 | EMP-003 | Secure development |
| G07 | Cloud Platform Engineering | EMP-011 | EMP-003 | Endpoints and media. Owner changed to IT Support (Finding 6) |
| G08 | Compliance & Risk Management | EMP-018 | EMP-004 | Inventory and records |
| G09 | Compliance & Risk Management | EMP-004 | EMP-018 | Data residency and masking |
| G10 | Security Operations | EMP-005 | EMP-014 | Threat intelligence |

Load per person: EMP-004 holds two gaps; every other owner holds one. EMP-002 is accountable for G01 and consulted on the rest.

## Findings

1. **Internal auditor is named twice.** Register section 4 says EMP-004 is accountable for internal audit. The register table gives "Internal Auditor" to both EMP-004 and EMP-021. EMP-021 reports to EMP-004. This record names EMP-021 as the auditor. He audits a function led by his own manager, who is also GDPR Lead, Privacy Lead and data protection contact. The [competence matrix](../../../ISMS/01-organization/competence-matrix.md) requires a separately competent reviewer. None is available (RISK-005).
2. **Roles named in the incident plan that nobody holds.** The plan's Communications Lead deputy is "Head of Sales and Customer Success". The org structure also has "Head of Product" and "Head of Sales & Customer Success". The register has neither post. EMP-009 and EMP-006 were chosen to stand in.
3. **"On call" with no rota.** The Technical Lead is "Cloud Platform Engineer on call". Only EMP-003 has that title. There is no on-call schedule document. EMP-013 was named deputy though his title is DevOps Engineer.
4. **No appointment procedure.** The register says role changes need formal documentation. Nothing defines an appointment form, acceptance, deputy rule, or what happens when a holder leaves. SIM-PPL-004 shows it: EMP-023 was the deputy training coordinator and no one replaced him.
5. **Gap owners are functions, not people.** The gap analysis says "Cloud Platform Engineering" and "Compliance & Risk Management". The org structure has no head of either. A function cannot be held to account. The mapping here is the first time a person is named.
6. **G07 owner does not match the work.** The gap analysis gives endpoints to Cloud Platform Engineering. The asset ownership register gives endpoint devices to HR & Administration with Security Operations as custodian. The register gives EMP-011 (IT) the Asset Custodian role. SOC 2 AC-16 gives devices to IT Support. Four documents, three owners. This record chose EMP-011.
7. **The CISO owns the gap about her own oversight.** G01 asks for independent oversight, and the owner is the CISO. Closure evidence says "independent reviewer appointed". Nobody is named for it, so G01 cannot be closed by anything in this record.
8. **Product & Engineering has no single head.** EMP-006 (Product Manager) reports to EMP-001. The engineers report to EMP-003, who reports to EMP-002. The gap analysis has one owner function. G06 was assigned to EMP-006 with EMP-003 as support.
9. **Concentration.** EMP-004 holds Privacy Lead, GDPR Lead, data protection contact, G05, G09, a Tier 1 role and the line management of the internal auditor. Her capacity was not assessed.

## What this does not show

- Any acceptance, signature or appointment letter.
- A DPO decision. It lives in the SIM-GDPR records.
- That any holder can do the role. Competence is covered in SIM-PPL-003 only for six people.
- An annual review of appointments. The first is due after 2027-03-02.
