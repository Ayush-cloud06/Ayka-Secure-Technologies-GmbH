# SIM-AUD-002 Completed audit checklists and sampling working papers

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-AUD-002 |
| Authored | 2026-11-10 |
| Scenario date | 2026-10-09 (last working paper). Fieldwork 2026-10-05 to 2026-10-09 |
| Participants | EMP-021 (auditor); owner responses from EMP-002, EMP-003, EMP-004, EMP-005, EMP-013, EMP-016 |
| Procedure exercised | [Internal audit checklists ISMS-AUD-03](../../../ISMS/09-internal-audit/audit-checklists.md) sections 1 to 4; [audit plan template ISMS-AUD-02](../../../ISMS/09-internal-audit/audit-plan.md) section 4 |
| Controls | ISO/IEC 27001:2022 clauses 9.2.2, 4 to 10; Annex A as per row; SOC 2 MO-02 |

Engagement SIM-AUD-001. Results use only the allowed words: Not tested, Conforming within tested scope, Potential nonconformity, Observation, Not applicable. "Potential nonconformity" became a confirmed nonconformity in SIM-AUD-003 after owner validation on 2026-10-09.

## 1. Management-system checklist

| ID | Evidence examined | Population / sample | Result | Link |
|---|---|---|---|---|
| C-01 | [Context](../../../ISMS/00-context-and-governance/context-of-the-organization.md), [interested parties](../../../ISMS/00-context-and-governance/interested-parties.md) | Both documents | Conforming within tested scope. Simulation boundary stated | — |
| C-02 | [Scope](../../../ISMS/00-context-and-governance/scope.md) against asset inventory and SIM-SUP-001 | Whole scope | Conforming within tested scope. Customer A (fictional) onboarding data is in scope through PP-01 | — |
| C-03 | SIM-GOV-001; document headers | 6 documents | Observation: decisions exist, headers still say "Draft. Not approved" | SIM-AUD-003 O-03 |
| C-04 | Risk register, SIM-RISK-001, SoA | 13 risks; RISK-007 (3 x 4 = 12) and RISK-008 (2 x 4 = 8) reperformed and agree | Potential nonconformity: acceptance review and expiry dates passed, risk review 203 days old | SIM-AUD-003 NC-03 |
| C-05 | [ISMS objectives](../../../ISMS/00-context-and-governance/isms-objectives.md), SIM-MON-001, SIM-MON-002 | OBJ-03, OBJ-04, OBJ-09, OBJ-10 | Observation: OBJ-03, OBJ-09, OBJ-10 missed with no action plan change | SIM-AUD-003 O-02 |
| C-06 | Training and communication | — | Not tested. Training records are in the people area (other author); not in this engagement's evidence set | — |
| C-07 | [Document control procedure](../../../ISMS/00-context-and-governance/document-control-procedure.md) on POL-IR-01 | 1 document traced | Observation: approval not reflected in the header (same as C-03) | SIM-AUD-003 O-03 |
| C-08 | SIM-CHG-001, change procedure | 1 change | Conforming within tested scope for that change. Settings change outside the procedure noted | SIM-CHG-001 finding 1 |
| C-09 | Recompute M-03, M-04, OBJ-10 | 3 measures | Conforming within tested scope: recomputed values agree (0 %, 144/144 with 1 overdue removal, 114 days). Limit: auditor's own department owns the KPI document | — |
| C-10 | SIM-AUD-001 | This engagement | Not applicable: an auditor cannot test his own audit. Left for the next cycle or an external reviewer | — |
| C-11 | Management review | 0 reviews held before cutoff | Not tested. First review is scheduled for 2026-10-26 | — |
| C-12 | SIM-CAPA-001 to SIM-CAPA-004 | 4 of 4 | Potential nonconformity: two effectiveness checks missed, one action overdue | SIM-AUD-003 NC-03 |

## 2. Control checklist

| ID | Evidence examined | Population / sample | Result | Link |
|---|---|---|---|---|
| A-01 | Asset inventory, ownership register | Register only | Conforming within tested scope. Owner tag on 1 of 88 plan resources noted, already known | — |
| A-02 | SIM-ACC-001, POL-AC-01 sections 4.2 and 4.6, [`entra-id/variables.tf`](../../../../Internal-IT/platform/domains/identity/entra-id/variables.tf) | 144 rows; 13 examined (1 exception row, 2 investigate, 10 retained) plus the 2 leaver/mover events | Potential nonconformity: MFA not enforced for privileged access (`enable_conditional_access = false`). Q3 review not held. The 10 retained rows agree with the register | SIM-AUD-003 NC-02, NC-03 |
| A-03 | SIM-SUP-001 | 3 suppliers, 3 dated conditions | Potential nonconformity: GitHub secret scanning condition (due 2026-07-31) not met; secret scanning and push protection still disabled per the [threat intelligence procedure](../../../ISMS/06-operational-procedures/threat-intelligence-procedure.md) section 2 | SIM-AUD-003 NC-03 |
| A-04 | SIM-INC-001 to SIM-INC-006, SIM-IMP-001 | 1 incident, all records | Observation: no detection; found by chance after about 42 h. The 24 h miss is already a corrective action (SIM-CAPA-004). BSI-decision step: **not tested** (auditor's own role, SIM-AUD-001 limit 2) | SIM-AUD-003 O-01 |
| A-05 | SIM-BCP-001, BC/DR plan | 1 tabletop, 4 scenarios | Conforming within tested scope: tabletop held as the plan requires; it records that targets are not met for S-C and S-D. No restore measured | — |
| A-06 | [Processor register](../../../GDPR/processor-register.md), SIM-INC-001 section 3 | 3 suppliers, 1 breach | Observation (part of O-02): Region in source is `ap-south-1`. RoPA review [SIM-GDPR-002](../privacy/SIM-GDPR-002-ropa-annual-review.md) **not tested**: the auditor took part in it (SIM-AUD-001 limit 5) | SIM-AUD-003 O-02 |
| A-07 | SIM-ACC-001 leaver and mover | 2 events | Conforming within tested scope for corrections. Effectiveness not shown (see NC-03) | — |
| A-08 | Physical policy | — | Not tested. No site visit in scope | — |
| A-09 | [`exceptions.yaml`](../../../../Internal-IT/engineering/policy-as-code/metadata/exceptions.yaml), SIM-TI-001 | 14 exceptions | Conforming within tested scope: every exception has reason, owner and expiry; none expired at cutoff (scenario value) | — |
| A-10 | Logging standard, POL-IR-01 section 12 | — | Observation (part of O-01): no alerting | SIM-AUD-003 O-01 |
| A-11 | [S3 control chain](../../../ISMS/04-controls-and-soa/control-chain-s3-encryption.md) | 1 control chain | Conforming within tested scope, plan level only | — |
| A-12 | OBJ-03 measurement (22 merged PRs), [POL-CHG-01](../../../policies/change-management-policy.md) section 10, [document control procedure](../../../ISMS/00-context-and-governance/document-control-procedure.md) section 2 settings row, [CODEOWNERS](../../../../.github/CODEOWNERS) | 22 PRs; 7 monthly reviews due | Potential nonconformity: 0 of 22 approved by a second person; 0 of 7 monthly MD reviews recorded; ruleset requires 0 approvals; environments allow self-review | SIM-AUD-003 NC-01 |

## 3. Working papers for the potential nonconformities

| Paper | Requirement | Population and selection | Observation | Owner response (2026-10-09) |
|---|---|---|---|---|
| WP-01 | POL-CHG-01 section 10: monthly MD review of all merged changes; OBJ-03 target 100 % | 22 merged PRs (all, from the existing 2026-10-14 snapshot); monthly reviews March to September (7, all) | 0/22 approved by someone other than the author. 0/7 monthly reviews recorded. The only CODEOWNER and the only required environment reviewer is one owner-role account (held by EMP-002 per SIM-PPL-001), which can approve its own runs. The compensating reviewer, EMP-001, has no GitHub access (SIM-PPL-001) and was given no list of merged changes | EMP-002: agrees with the facts. EMP-001: agrees. Cause given: the review was never scheduled and its input never defined. EMP-021 recorded that as the cause, not a defence |
| WP-02 | POL-AC-01 section 4.2 item 1: MFA for every interactive login, including Entra ID; OBJ-04 | Design default and licence decision | `enable_conditional_access` defaults to `false`. Licence deferred on 2026-03-02 to Q3; no Q3 decision recorded by cutoff | EMP-003: agrees. EMP-001: decision still open |
| WP-03 | Risk review at planned intervals (methodology section 4.7, quarterly); High exception review within 90 days (criteria section 6); Medium acceptance expiry; quarterly access review (POL-AC-01 section 4.6); corrective action timing (corrective action procedure section 3) | 6 dated commitments | Risk review due 2026-06-12: not held (203 days since 2026-03-16 at 2026-10-05). RISK-007 exception review due 2026-06-12: not held. RISK-008 acceptance expired 2026-09-16: no review, still shown as accepted. Q3 access review due by 2026-09-30: not held, so the SIM-CAPA-001 and SIM-CAPA-002 effectiveness checks did not happen. SIM-SUP-001 secret-scanning condition due 2026-07-31: not met. SIM-CAPA-004 document alignment due 2026-09-30: open | EMP-002: agrees. "No one owns the calendar; each document has its own dates." |

## 4. Limitations

- GitHub, Entra ID and AWS were not re-queried. Dated observations already in the repository were used and named.
- The 22 pull requests are the real repository's population at the 2026-10-14 snapshot, placed into the fiction as Ayka's changes. SIM-CHG-001 is outside that population.
- Single auditor; no review of these papers by a second person.

## Findings

1. **Checklist rows are too broad to sample.** A-02 covers eight controls and four populations. One "result" cell cannot say which part failed. Split rows by control or require a result per sub-test.
2. **No "Not tested: auditor conflict" result.** The allowed results do not include a conflict case. A-04 (part) and C-10 had to be forced into "Not tested" and "Not applicable". Add a result for "not tested: independence".
3. **Owner response has no deadline.** Section 4 lists "owner response" as a field but gives no time limit. Here all responses came on the last day.

## What this does not show

- No checklist was executed. The real [audit checklists](../../../ISMS/09-internal-audit/audit-checklists.md) are still "Not tested", which is correct.
- The checklists are used as their text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
- Facts marked as from the repository (the 22 PRs, the ruleset, the Terraform default, the disabled secret scanning, the Region) are true of the repository. Their use as Ayka evidence is fiction.
