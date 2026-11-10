# SOC 2 Programme

| Field | Value |
|---|---|
| Document ID | SOC2-00 |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.2 |
| Effective | 2026-11-10 |
| Next review | 2027-04-06, or when the SOC 2 scope changes |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company and `ayka-portal` has never been deployed. Nothing here is a SOC 2 report or a claim that a service auditor has examined anything. These documents are what Ayka would hold **before** engaging a CPA firm: the system description, the control set and an honest readiness position.

## Completion position

Counted from the 65 rows of the [control matrix](03-control-matrix.md) 1.4 (status on 2026-11-10); the matrix summary and `test_soc2_matrix.py` keep the numbers in step.

| Position | Matrix status | Controls |
|---|---|---:|
| Real evidence | Implemented (13) and Partial (10) | 23 |
| Simulated walk-through | Simulated operation | 14 |
| Gated design | Gated design | 11 |
| Design only | Designed | 16 |
| Open | Planned | 0 |
| Carved out to AWS | Carved out | 1 |
| **Total** | | **65** |

Simulated walk-throughs are not operating evidence. Real evidence here means a CI run, a test or a configured setting; for a Type I the readiness pack still expects only 13 of the 65 controls to pass, because nothing is deployed.

## 1. What SOC 2 is, and why Ayka would do it

A SOC 2 report is an attestation report issued by a licensed CPA firm under the AICPA attestation standards (SSAE 18 / AT-C 205). The auditor gives an opinion on management's **system description** (measured against the AICPA *Description Criteria*, DC 200) and on whether the controls meet the **Trust Services Criteria** (TSP 100, 2017, revised points of focus 2022).

- **Type I**: description and control design are fair and suitable **as of one date**.
- **Type II**: the same, plus controls **operated effectively over a period**, usually 6 to 12 months. Customers and procurement teams ask for this one.

For a Stuttgart company selling to German automotive suppliers, ISO/IEC 27001 and TISAX carry more weight than SOC 2, and BSI C5 is the reference for cloud services sold to German public-sector and regulated customers. SOC 2 is worth the cost only when customers in North America, or EU customers with US parents, put it in their security questionnaires. Ayka's decision is therefore:

1. ISO/IEC 27001 first (see the [ISMS index](../ISMS/README.md)).
2. Design one control set that answers both frameworks, so SOC 2 adds evidence and an auditor, not a second ISMS.
3. Start a SOC 2 Type I once `ayka-portal` runs in production in an EU Region and the blockers in the [readiness assessment](04-readiness-assessment.md) are closed; follow with a Type II over a 6-month first period.

## 2. Scope chosen

| Trust Services Category | In scope | Reason |
|---|---|---|
| Security (Common Criteria CC1 to CC9) | Yes | Mandatory in every SOC 2 |
| Availability (A1) | Yes | Customers depend on the portal being reachable before audits; the design already has Multi-AZ, backups and autoscaling |
| Confidentiality (C1) | Yes | Customers upload audit evidence, policies and risk data that they classify as confidential |
| Processing Integrity (PI1) | No | The portal stores and presents customer evidence; it does not compute results customers rely on for financial or operational decisions |
| Privacy (P1 to P8) | No | GDPR is the governing privacy regime and is documented in [Governance/GDPR](../GDPR/README.md). For EU customers the GDPR documents, not the SOC 2 Privacy criteria, answer privacy questions |

The system boundary is defined in the [system description](01-system-description.md), section 3.

## 3. Documents

| ID | Document | Purpose | Status |
|---|---|---|---|
| SOC2-01 | [System description](01-system-description.md) | Management's description of the Ayka Portal system, structured on DC 200 | Draft |
| SOC2-02 | [Trust Services Criteria mapping](02-trust-services-criteria-mapping.md) | Every in-scope criterion (CC1.1 to CC9.2, A1.1 to A1.3, C1.1 to C1.2) mapped to Ayka controls, with the ISO/IEC 27001:2022 crosswalk | Draft |
| SOC2-03 | [Control matrix](03-control-matrix.md) | The controls themselves: owner, frequency, type, evidence, test approach and status | Draft |
| SOC2-04 | [Readiness assessment](04-readiness-assessment.md) | Gaps against Type I and Type II, ranked, with the remediation plan | Draft |
| SOC2-05 | [Audit approach and evidence management](05-audit-approach-and-evidence.md) | How an examination would run: auditor selection, period, PBC list, sampling, evidence retention; record templates | Draft |
| SOC2-06 | [Type I readiness pack](06-type1-readiness-pack.md) | Population, sample, test and expected result for all 65 controls; draft management assertion; CSOCs and CUECs | Draft |
| SOC2-07 | [Observation period log](07-observation-period-log.md) | Evidence trail of the automated change controls from 2026-11-10 | Draft |
| SOC2-08 | [Control designs](08-control-designs.md) | Designs for the 19 controls that were Planned; the compensating monthly change review | Draft |
| POL-COC-01 | [Code of conduct](../policies/code-of-conduct.md) | CC1.1 (CE-02) | Draft |
| RA-FRD-01 | [Fraud and insider-risk assessment](../policies/fraud-and-insider-risk-assessment.md) | CC3.3 (RA-02) | Draft |
| POL-AC-01 | [Logical Access Control Policy](../policies/access-control-policy.md) | CC6.1 to CC6.3 | Draft |
| POL-CHG-01 | [Change Management Policy](../policies/change-management-policy.md) | CC8.1, CC7.1 | Draft |
| POL-IR-01 | [Incident Response Plan](../policies/incident-response-plan.md) | CC7.3 to CC7.5 | Draft |
| STD-LOG-01 | [Logging and Monitoring Standard](../policies/logging-and-monitoring-standard.md) | CC7.2, CC4.1 | Draft |
| POL-VEN-01 | [Vendor and Subservice Organization Management Policy](../policies/vendor-management-policy.md) | CC9.2, CC3.2 | Draft |
| POL-BCDR-01 | [Business Continuity and Disaster Recovery Plan](../policies/business-continuity-and-disaster-recovery-plan.md) | A1.2, A1.3, CC9.1 | Draft |
| POL-DATA-01 | [Data Classification and Confidentiality Policy](../policies/data-classification-and-confidentiality-policy.md) | C1.1, C1.2, CC6.5, CC6.7 | Draft |

The policies are company policies, not SOC 2-only documents, and live in [`Governance/policies/`](../policies/). Each lists the ISO/IEC 27001:2022 Annex A controls it also satisfies; the [ISMS index](../ISMS/README.md) (section 05 Operational policies) links to the same files.

## 4. Status vocabulary

Every control carries the weakest status that is true today. The same words are used across the ISMS documents.

| Status | Meaning |
|---|---|
| **Implemented** | Operates today, and a CI run, a test or a configured setting shows it |
| **Partial** | Part of the control operates; the rest is a named gap |
| **Gated design** | Terraform in a root the compliance gate plans and scans with all three tools (`ayka-portal` on every change; the platform roots `aws-organization`, `landing-zone`, `evidence-archive` and `aws-iam-core` through the `Platform Gate` job, which has not run on GitHub and is not a required check; local run [REAL-INFRA-001](../records/real/infra/REAL-INFRA-001-gate-run-all-roots.md)), but that has never been deployed |
| **Designed** | Written down, or written as Terraform that is not planned and scanned by all three tools (`aws-identity-center` and `remote-state` are scanned in source mode without OPA, `entra-id` by no scanner), and not deployed |
| **Simulated operation** | A design exists and a bannered tabletop record under `records/simulated/` walks it end to end. Not operating evidence ([ADR-0006](../ADR/0006-simulated-operating-records.md)). Order of strength: Planned, Designed, Gated design, Simulated operation, Partial, Implemented. The row must link the record. An Implemented row never cites one, and counts of Implemented and Partial exclude it |
| **Planned** | Not designed yet. No control is Planned since 2026-11-10 |

A SOC 2 auditor would accept only **Implemented** as "in place" for a Type I (the [readiness pack](06-type1-readiness-pack.md) applies this), and only Implemented controls with records across the period for a Type II.

## 5. Relationship to the compliance gate

The gate's [`control-mapping.yaml`](../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml) maps each of its 38 scanner rules to ISO/IEC 27001 Annex A and, since 2026-11-10, to SOC 2 criteria (a `soc2` list next to `iso27001`; the compliance report prints the criteria a run touches). On 2026-10-06 it carried no SOC 2 criteria. A criterion in the mapping is supported by a plan check, not met by it: SOC 2 criteria are met by operating controls. The [control matrix](03-control-matrix.md) names which gate controls support which control. The repository README still lists "SOC 2 mappings" as not claimed for the gate (README.md, outside this folder); that line is stale.

## 6. Rules for these documents

- Documents (policies, the description, the matrix) are written now. **Records** are never presented as something they are not: real ones go in [`records/real/`](../records/real/README.md), tabletop walk-throughs in [`records/simulated/`](../records/simulated/README.md) ([ADR-0006](../ADR/0006-simulated-operating-records.md)). Section 7 of [SOC2-05](05-audit-approach-and-evidence.md) holds the templates.
- No control is described as operating unless the repository shows it.
- Facts about third parties' SOC 2 reports and contracts are marked **to verify** until checked against the provider's current documents.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-06 | First issue |
| 1.1 | 2026-11-10 | Add Simulated operation to the status vocabulary. Add SOC2-06 to 08, the code of conduct and the fraud assessment. Rewrite sections 5 and 6 |
| 1.2 | 2026-11-10 | Add the completion position. Gated design now includes platform roots planned and scanned in plan mode; Designed excludes them. Section 5 states that the mapping carries SOC 2 criteria |
