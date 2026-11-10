# Customer Security Addendum (template)

| Field | Value |
|---|---|
| Document ID | NIS2-06 |
| Organization | Ayka Secure Technologies GmbH (simulated case study) |
| Owner | CISO |
| Contributors | Compliance Officer, Sales Manager, Customer Success Manager |
| Version | 1.0 |
| Date | 2026-11-10 |
| Status | Draft. Not approved. Not reviewed by counsel. Not offered to any customer (there are none) |
| Classification | Internal; the clause text in section 3 is meant to be shared under NDA |

## 1. What this is

A contract addendum of the kind an in-scope customer (a *wichtige* or *besonders wichtige Einrichtung* under NIS2) will ask a SaaS supplier to sign. It is built from the requests listed in [NIS2-05](05-supply-chain-security.md) A.1. Each clause is mapped to the NIS2 / BSIG provision the customer is answering to, to the Ayka document that backs it, and to an honest status.

Ayka itself is not in scope ([NIS2-08](08-applicability-reassessment-2026-11.md)). The customer is. Art. 21(2)(d) NIS2 and §30(2) no. 4 BSIG oblige the customer to manage supply-chain security, and Art. 21(3) tells it to weigh its suppliers' practices. The clauses are the customer's way of doing that. A clause that Ayka signs and cannot keep is a breach of contract, so section 2 says which ones it can sign today.

Status words follow the [README yardstick](../../README.md) and [ADR-0006](../ADR/0006-simulated-operating-records.md): Implemented, Partial, Gated design, Designed, Planned. "Simulated" in a status means a walk-through exists, not that the control operates.

## 2. Can Ayka sign it today?

| Clause | Sign as drafted? | Why |
|---|---|---|
| C-1, C-5, C-7, C-9 (process commitments) | Yes, once the Managing Director approves | They describe a process that is written. Their operation is untested in reality |
| C-2 to C-4 (24 h, 72 h, one month) | **Only with the carve-out in C-2.3** | Detection is Gated design (Terraform plan only, never applied). Awareness today depends on luck |
| C-8 (audit) | Yes in the limited form drafted | Ayka offers evidence on request and a remote audit, not on-site audits |
| C-10 (data location) | **No** until the workload Terraform and the Region-restriction policy are applied in `eu-central-1` | Region moved in code on 2026-11-10 (see section 5); never deployed |
| C-12, C-13 (continuity, exit) | Only as "target", not as warranty | No restore has been run against a real system |
| C-15 (certification) | Only the "none" statement | No certificate exists |

## 3. Clauses

Square brackets are fields to fill per customer. Quotation of NIS2 or BSIG wording is avoided on purpose: the clauses cite the provisions and say what the supplier does.

### C-1 Security contacts and cooperation

1. Each party names a security contact reachable at all times for incidents: `[Customer contact]` and `[Ayka security contact: role mailbox and number]`.
2. Each party tells the other of a change of contact within five working days.

| Maps to | Backing document | Status |
|---|---|---|
| Art. 23(1) NIS2 (customer must notify and needs facts); §32 BSIG | [NIS2-03](03-incident-reporting-procedure.md) section 2 (roles). Role holders in the [personnel register](../../organization/personnel-register.md) | Designed. A 24-hour contact rota does not exist |

### C-2 Incident notification: early warning within 24 hours

1. Ayka notifies the customer **without undue delay and in any event within 24 hours of becoming aware** of a significant incident affecting the customer's data or the contracted service.
2. The notice states, as far as known: what happened; services and data affected; whether unlawful or malicious action is suspected; whether other customers or other Member States may be affected; what the customer should do now; the time of the next update. (Content follows template T-1 in NIS2-03.)
3. **Awareness** means the point at which, after an initial assessment started without delay, Ayka has reasonable certainty that an incident has occurred. Ayka's detection measures are described in Annex 1 `[list the measures live on signing date]`. Ayka is not in breach for an incident it could not have detected with those measures.
4. "Significant" uses the thresholds in Annex 2 (taken from NIS2-03 section 4).

| Maps to | Backing document | Status |
|---|---|---|
| Art. 23(4)(a) NIS2 (24-hour early warning, which the customer must itself give); §32 BSIG; Art. 21(2)(b) | [NIS2-03](03-incident-reporting-procedure.md) sections 3 to 5 and template T-1; [incident response plan](../policies/incident-response-plan.md) | Designed (procedure). Detection: Gated design, GuardDuty, Security Hub, Config and EventBridge-to-SNS Terraform added 2026-11-10, see `Internal-IT/` roots in the gate; never applied. Walked through once in simulated record SIM-INC-001 (scenario 2026-08-12). Not Partial or Implemented |

Warning for Sales: do not accept 12-hour clauses. The 24-hour clock in this clause runs from Ayka's awareness; the customer's own 24 hours run from the customer's awareness of the incident at Ayka, which the customer may date from Ayka's notice.

### C-3 Incident notification: update within 72 hours

Within **72 hours of becoming aware**, Ayka sends an update: initial assessment of severity and impact, indicators of compromise where available, and any change to the first notice.

| Maps to | Backing document | Status |
|---|---|---|
| Art. 23(4)(b); §32 BSIG | NIS2-03 section 5; template T-1 | Designed (+ simulated record SIM-INC-001 with the 72-hour draft SIM-INC-00x, added 2026-11-10) |

### C-4 Final report within one month

Not later than **one month after the 72-hour update**, Ayka sends a final report: detailed description with severity and impact; type of threat or root cause; mitigation applied and ongoing; cross-border impact. If the incident is still ongoing, Ayka sends a progress report and the final report one month after handling ends.

| Maps to | Backing document | Status |
|---|---|---|
| Art. 23(4)(d); §32 BSIG | NIS2-03 template T-3 | Designed (+ simulated record SIM-INC-001, one-month draft SIM-INC-00x) |

### C-5 Cooperation in the customer's own reporting

Ayka supplies, within the deadlines of C-2 to C-4, the facts the customer needs for its own reports to the BSI (early warning, notification, final report) and for GDPR Art. 33 where Ayka is the customer's processor.

| Maps to | Backing document | Status |
|---|---|---|
| Art. 23(1), (4); Art. 21(2)(b), (d); §30(2) no. 4 and §32 BSIG; GDPR Art. 33(2) | NIS2-03 sections 5 and 6; [NIS2-05](05-supply-chain-security.md) A.2 | Designed |

### C-6 Security measures

Ayka maintains technical and organisational measures covering the ten areas of Art. 21(2) NIS2 and describes them in Annex 1, which it updates on material change. Ayka reports a material degradation of those measures to the customer's security contact.

| Maps to | Backing document | Status |
|---|---|---|
| Art. 21(2)(a) to (j); §30(2) BSIG; Art. 21(3) | [NIS2-02](02-risk-management-measures.md) (status per measure) | Partial overall. Per measure, see NIS2-02 section 3. Annex 1 must copy those statuses, not summarise them upward |

### C-7 Sub-suppliers

1. Annex 3 lists the sub-processors and critical sub-suppliers with access to customer data or able to change the service, with service and location.
2. Ayka gives **30 days' notice** of a new or replaced entry and the customer may object on reasonable security or data-protection grounds. If the objection is not resolved, the customer may terminate the affected service.
3. Ayka assesses critical sub-suppliers at least annually using their independent assurance reports and passes on relevant exceptions on request.

| Maps to | Backing document | Status |
|---|---|---|
| Art. 21(2)(d), 21(3); §30(2) no. 4 BSIG; GDPR Art. 28(2), (4) | [Processor register](../GDPR/processor-register.md); [vendor management policy](../policies/vendor-management-policy.md) (POL-VEN-01); [supplier review log](../ISMS/08-monitoring-and-measurement/supplier-performance-review.md); [REAL-SUP-001](../records/real/supplier/REAL-SUP-001-supplier-attestations.md) | Designed (register and policy: draft). Public assurance pages of AWS, Microsoft and GitHub read on 2026-11-10; no report obtained. One simulated review SIM-SUP-001 (scenario 2026-07-06) was added 2026-11-10. 30-day notice process: no subscriptions exist |

### C-8 Audit and evidence

1. Once a year, and after a significant incident, the customer may request evidence: policies, the list of sub-processors, the CI compliance evidence for a given change, and summaries of the latest internal audit and management review.
2. The customer may carry out a remote audit on 30 days' notice, limited to Ayka's information security management system and the contracted service. A further audit in the same year is at the customer's cost. On-site audits only after a significant incident or a regulator's demand.
3. Ayka does not disclose other customers' data, source code of its own, or reports it holds only under another supplier's NDA.

| Maps to | Backing document | Status |
|---|---|---|
| Art. 21(2)(f), 21(3); §30(2) no. 6 and no. 4 BSIG | [README](../../README.md) compliance gate and evidence bundle; [NIS2-05](05-supply-chain-security.md) A.3; simulated records SIM-AUD-001 (internal audit) and SIM-MR-001 (management review, scenario 2026-10-26), added 2026-11-10 | Partial for the gate evidence (real, checksummed, infrastructure code only). Audit and review: Designed + simulated records. No real audit has happened |

### C-9 Vulnerability handling

1. Ayka fixes or mitigates **critical** vulnerabilities in the contracted service within **7 days** of a fix being available and **high** within **30 days**.
2. Ayka tells the customer of a vulnerability that has been exploited against, or exposed, the customer's data.
3. Ayka runs a coordinated disclosure channel for external reporters.

| Maps to | Backing document | Status |
|---|---|---|
| Art. 21(2)(e); Art. 21(3) ("vulnerabilities specific to each direct supplier"); §30(2) no. 5 BSIG | [Vulnerability and patch policy](../policies/vulnerability-and-patch-management-policy.md) (targets: critical 7 days, high 30 days, "proposed service targets, not measured performance"); `SECURITY.md`, `.well-known/security.txt` and `Governance/policies/vulnerability-disclosure-policy.md`, added 2026-11-10; CI checks (gitleaks, actionlint, shellcheck, Bandit, pip-audit, SBOM) in `.github/workflows/security-checks.yml`, added 2026-11-10 | Partial for infrastructure-code scanning (gate). Application dependency and code scanning: Designed, first workflow runs not verified in this document. No application exists to patch. Disclosure channel: Designed (files in a public repository; no company domain serves `security.txt`). Penetration test: Planned |

### C-10 Data location

Customer data is stored and processed in `eu-central-1` (Frankfurt). Remote access from outside the EU for support is limited to `[list]` under the transfer mechanism named in Annex 3.

| Maps to | Backing document | Status |
|---|---|---|
| Art. 21(2)(d); GDPR Art. 28, 44 to 46 | [ADR-0003](../ADR/0003-target-region.md); [processor register](../GDPR/processor-register.md); [data-flow and transfer assessment](../GDPR/data-flow-and-transfer-assessment.md) | Gated design. Region moved to `eu-central-1` in the Terraform on 2026-11-10 by parallel work; plan-only, never applied. No EU-location claim may be made to a customer until a real deployment exists |

### C-11 Access control and authentication

Ayka enforces multi-factor authentication for all staff access to systems that process customer data, and restricts administrative access to named roles with periodic review.

| Maps to | Backing document | Status |
|---|---|---|
| Art. 21(2)(i), (j); §30(2) no. 9 and no. 10 BSIG | [Access control policy](../policies/access-control-policy.md); identity Terraform in `Internal-IT/platform/domains/identity/` | Designed. **MFA enforcement is switched off**: the Conditional Access policy exists but `enable_conditional_access` defaults to `false` (Entra ID Free licence has no Conditional Access). Do not sign this clause until Security Defaults or Entra ID P1 is in effect |

### C-12 Business continuity and backup

Ayka maintains backups of customer data separate from the production account and tests restore at least annually. Recovery objectives `[RTO / RPO from Annex]`.

| Maps to | Backing document | Status |
|---|---|---|
| Art. 21(2)(c); §30(2) no. 3 BSIG | [BC/DR plan](../policies/business-continuity-and-disaster-recovery-plan.md); [backup and restore procedure](../ISMS/06-operational-procedures/backup-and-restore-procedure.md); AWS Backup with vault lock in Terraform, added 2026-11-10 | Gated design (Terraform, plan-only) + simulated record SIM-BCP-001 (restore tabletop). No restore has been run against a real system |

### C-13 Exit

At termination, Ayka makes customer data available for export in `[format]` for 30 days, then deletes it within 30 days and confirms in writing. Ayka documents an exit path for each critical sub-supplier.

| Maps to | Backing document | Status |
|---|---|---|
| Art. 21(2)(d); IR 2024/2690 Annex section 5 (as described in NIS2-05 B.3); GDPR Art. 28(3)(g) | [NIS2-05](05-supply-chain-security.md) A.2 "Exit"; [records retention policy](../policies/records-and-data-retention-policy.md) | Designed. No export function exists in a running service; no per-supplier exit note exists |

### C-14 Personnel and training

Ayka screens staff with access to customer data, binds them to confidentiality and trains them at onboarding and yearly. Management receives cybersecurity training.

| Maps to | Backing document | Status |
|---|---|---|
| Art. 21(2)(g), (i); Art. 20(2); §30(2) no. 7 and no. 9; §38(3) BSIG (applies to the customer's management, here by analogy) | [Training and awareness programme](../../organization/training-and-awareness.md); [NIS2-04](04-management-accountability.md); simulated records [SIM-NIS2-001](../records/simulated/nis2/SIM-NIS2-001-management-cybersecurity-training.md) and SIM-PPL-003 (baseline training, added 2026-11-10) | Simulated records only. Nothing real has been delivered |

### C-15 Certification

Ayka states which certifications it holds. It currently holds none. ISO/IEC 27001 is the stated target; TISAX on demand.

| Maps to | Backing document | Status |
|---|---|---|
| Art. 21(3) | [NIS2-05](05-supply-chain-security.md) A.2 | Accurate as stated |

### C-16 Liability, term, precedence

`[for counsel: liability cap and carve-outs for breach of C-2 to C-4, term, order of precedence against the DPA]`. Not drafted here.

## 4. Annexes to the addendum

| Annex | Content | Source | State |
|---|---|---|---|
| 1 | Security measures as of signing, copied from NIS2-02 with statuses | [NIS2-02](02-risk-management-measures.md) | Fill at signing; do not upgrade a status |
| 2 | Significance thresholds S-1 to S-9 | [NIS2-03](03-incident-reporting-procedure.md) section 4 | Ready |
| 3 | Sub-processors, locations, transfer mechanisms | [Processor register](../GDPR/processor-register.md) | Ready as a draft |

## 5. Facts added by parallel work on 2026-11-10 that this document relies on

These were written by other work in the same session and are stated here for the owner to verify. None of it was applied to a cloud account.

- Terraform for GuardDuty, Security Hub, Config, EventBridge alerts to SNS and AWS Backup with vault lock; Region `eu-central-1`; platform roots in the gate. Used in C-2, C-10, C-12.
- `.github/workflows/security-checks.yml`, `SECURITY.md`, `.well-known/security.txt`, `Governance/policies/vulnerability-disclosure-policy.md`. Used in C-9.
- Simulated records SIM-INC-001, SIM-SUP-001, SIM-PPL-003, SIM-BCP-001, SIM-AUD-001, SIM-MR-001. Used in C-2 to C-4, C-7, C-8, C-12, C-14.

## Revision history

| Version | Date | Author | Change |
|---|---|---|---|
| 1.0 | 2026-11-10 | CISO role (AI-drafted) | First template |
