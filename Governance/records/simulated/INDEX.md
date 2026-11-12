# Index of simulated records

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | INDEX (list of simulated records, not an event) |
| Authored | 2026-11-10 |
| Scenario date | 2026-03-02 to 2026-10-30 (span of the records listed) |
| Participants | None. See each record |
| Procedure exercised | [Simulated record rules](README.md) |
| Controls | See each row |

One plan-do-check-act year of a fictional company, walked as tabletops. Read the [rules](README.md) and [ADR-0006](../../ADR/0006-simulated-operating-records.md) first. Every procedure and register is used as its text stands on the Authored date and treated as in force at the scenario date.

## 1. Event chain

| ID | Title | Scenario date | Procedure | Controls |
|---|---|---|---|---|
| [SIM-GOV-001](governance/SIM-GOV-001-management-commitment-and-approvals.md) | Management commitment and ISMS approval decisions | 2026-03-02 | Document control ISMS-00-07; MR agenda section 3 | Cl. 5.1, 5.2, 5.3, 6.1.3, 6.2, 7.1, 7.5.2; A.5.1, A.5.2, A.5.4; CE-01, CE-03, CE-06 |
| [SIM-RISK-001](risk/SIM-RISK-001-risk-review-and-acceptance-minutes.md) | Risk review and risk acceptance minutes | 2026-03-16 | Risk methodology, risk criteria, acceptance log | Cl. 6.1.2, 6.1.3, 8.2, 8.3; RA-01, RA-04, MO-03 |
| [SIM-MON-001](monitoring/SIM-MON-001-q1-2026-kpi-results.md) | Q1 2026 KPI and monitoring results | 2026-04-08 | ISMS-MON-01 | Cl. 6.2, 9.1; A.5.36; CE-06, MO-01, CM-02, CM-05 |
| [SIM-GOV-002](governance/SIM-GOV-002-authority-and-community-contacts-check.md) | Authority and community contacts check | 2026-04-14 | ISMS-00-08 rows IC-E-02, IC-E-03, IC-E-05; NIS2-03 sections 5 to 7 | A.5.5, A.5.6 (not raised); IC-03 |
| [SIM-GOV-003](governance/SIM-GOV-003-legal-register-and-ip-review.md) | Legal register review and intellectual property review (includes a labelled real read of licence metadata) | 2026-04-28 | ISMS-00-05; POL-AUP-01; POL-SDL-01 4.4 | A.5.31, A.5.32; cl. 4.2 |
| [SIM-INC-007](incident/SIM-INC-007-staff-security-event-report.md) | Staff report of a phishing mail | 2026-05-06 | ISMS-00-08 IC-I-04; POL-IR-01 7.1 and 7.2 | A.6.8 (not raised); A.5.25; IC-03 |
| [SIM-PHY-001](physical/SIM-PHY-001-office-and-home-workplace-security-assessment.md) | Office and home workplace security assessment | 2026-05-11 and 2026-05-12 | POL-PHY-01, POL-DESK-01, POL-REM-01 | A.7.1 to A.7.3, A.7.7 to A.7.9, A.7.11 to A.7.13, A.6.7; A.7.4 to A.7.6 not raised; CC6.4 |
| [SIM-END-001](endpoint/SIM-END-001-endpoint-baseline-check.md) | Endpoint baseline check of 24 laptops and one malware alert | 2026-05-20 | POL-END-01, POL-AUP-01, POL-IR-01 7 | A.8.1, A.8.7, A.8.19; A.8.18, A.8.23 not raised; AC-16 |
| [SIM-TI-001](monitoring/SIM-TI-001-tfsec-upstream-status-assessment.md) | Threat intelligence assessment: tfsec upstream status | 2026-05-20 | ISMS-OPS-09 | A.5.7, A.8.8, A.5.21; OP-01, AC-14 |
| [SIM-PHY-002](physical/SIM-PHY-002-equipment-and-media-disposal.md) | Equipment and media disposal | 2026-06-17 | POL-END-01 4, POL-RET-01 5 | A.7.10, A.7.14; AC-18 |
| [SIM-ACC-001](access/SIM-ACC-001-q2-2026-access-review.md) | Q2 2026 access review | 2026-06-22 | ISMS-OPS-02, ISMS-OPS-01, POL-AC-01 | A.5.15, A.5.16, A.5.18, A.8.2; cl. 9.1; AC-06, AC-07, AC-09 |
| [SIM-ACC-002](access/SIM-ACC-002-credential-and-secret-handling-check.md) | Credential and secret handling check (includes labelled real observations of Git history) | 2026-06-29 | POL-AC-01 4.2, POL-CRY-01 4.6 | A.5.17 (not raised); A.8.5, A.8.24; AC-01, AC-14 |
| [SIM-SUP-001](supplier/SIM-SUP-001-annual-critical-supplier-review.md) | Annual review of AWS, Microsoft, GitHub | 2026-07-06 | ISMS-MON-02, ISMS-OPS-07, POL-VEN-01 | A.5.19 to A.5.23; cl. 8.1; VM-01, VM-02, AC-17; GDPR Art. 28, 44 to 46 |
| [SIM-MON-002](monitoring/SIM-MON-002-q2-2026-kpi-results.md) | Q2 2026 KPI and monitoring results | 2026-07-08 | ISMS-MON-01 | Cl. 6.2, 9.1; A.5.18, A.5.36; CE-06, AC-07, CM-02, CM-05, MO-03 |
| [SIM-INF-001](information/SIM-INF-001-classification-labelling-and-transfer-review.md) | Classification, labelling and an outbound transfer to Customer A (fictional) | 2026-07-20 | POL-DATA-01, POL-AUP-01 | A.5.10, A.5.12, A.5.13, A.5.14; CO-01 to CO-03 |
| [SIM-SDL-002](sdlc/SIM-SDL-002-external-developer-engagement.md) | External developer engagement considered, not engaged | 2026-07-27 | POL-SDL-01, POL-VEN-01, ISMS-OPS-07 | A.8.30 (not raised); A.5.19, A.5.20, A.5.32; CC9.2 |
| [SIM-INC-001](incident/SIM-INC-001-inc-2026-001-customer-export-in-public-ci.md) | Incident INC-2026-001: customer user list in a public pull request and CI log | 2026-08-12 | POL-IR-01, NIS2-03 | A.5.24 to A.5.28, A.6.8, A.8.11, A.8.12, A.8.33; OP-06, OP-07, IC-03, CO-05; GDPR Art. 28, 33, 34; NIS2 Art. 23 |
| [SIM-INC-002](incident/SIM-INC-002-t1-customer-notice-24h-draft.md) | T-1 customer notice (24 h), draft never sent; 24 h missed | 2026-08-13 | NIS2-03 T-1 | A.5.24, A.5.26; OP-06, IC-02; GDPR Art. 33(2) |
| [SIM-INC-003](incident/SIM-INC-003-t2-bsi-field-list-not-submitted.md) | T-2 BSI field list, not submitted | 2026-08-12 | NIS2-03 T-2 | A.5.5, A.5.26; OP-06; NIS2 Art. 23(4) |
| [SIM-INC-004](incident/SIM-INC-004-t1-customer-update-72h-draft.md) | T-1 customer update (72 h), draft never sent | 2026-08-14 | NIS2-03 T-1 | A.5.26; OP-06; GDPR Art. 33(2), 33(3) |
| [SIM-CHG-001](improvement/SIM-CHG-001-ci-check-for-personal-data-in-fixtures.md) | Change record: CI check for personal data in fixtures | 2026-08-19 | ISMS-OPS-03, POL-CHG-01 | A.8.25, A.8.29, A.8.32, A.8.11, A.8.33; CM-01, CM-02, CM-05, CO-05 |
| [SIM-IMP-001](improvement/SIM-IMP-001-lessons-learned-inc-2026-001.md) | Lessons learned from INC-2026-001 | 2026-08-25 | POL-IR-01 section 9; lessons learned log | A.5.27; cl. 10.1, 10.2; OP-07, MO-03 |
| [SIM-PPL-007](people/SIM-PPL-007-disciplinary-case.md) | Security-related disciplinary case from INC-2026-001 | 2026-08-17 to 2026-08-27 | ISMS-01-03; POL-IR-01 7.1 | A.6.4; CE-02 |
| [SIM-SDL-001](sdlc/SIM-SDL-001-feature-security-lifecycle.md) | Feature security lifecycle: audit-log export | 2026-09-07 to 2026-09-25 | POL-SDL-01, STD-MSK-01, POL-CLD-01, ISMS-OPS-03 | A.5.8, A.8.25 to A.8.28, A.8.33, A.8.11; CM-01, CM-02, CM-05, CO-05 |
| [SIM-INC-005](incident/SIM-INC-005-t3-final-report-draft.md) | T-3 final report, draft never sent | 2026-09-14 | NIS2-03 T-3 | A.5.26, A.5.27; cl. 10.2; OP-06, OP-07 |
| [SIM-INC-006](incident/SIM-INC-006-t4-incident-and-breach-log.md) | T-4 incident and breach log | 2026-09-15 | NIS2-03 T-4 | A.5.25, A.5.26, A.5.28; OP-06; GDPR Art. 30(2), 33(5) |
| [SIM-BCP-001](continuity/SIM-BCP-001-restore-and-dr-tabletop.md) | Backup restore and DR tabletop | 2026-09-15 | ISMS-OPS-06, POL-BCDR-01 | A.5.29, A.5.30, A.8.13, A.8.14; RM-01, AV-02, AV-03, AV-04, AC-08 |
| [SIM-AUD-001](audit/SIM-AUD-001-internal-audit-plan-2026.md) | Internal audit plan 2026 | 2026-10-05 | ISMS-AUD-01, ISMS-AUD-02 | Cl. 9.2.1, 9.2.2; A.5.35, A.5.36; MO-02 |
| [SIM-AUD-002](audit/SIM-AUD-002-completed-checklists-and-sampling.md) | Completed checklists and sampling working papers | 2026-10-09 | ISMS-AUD-03, ISMS-AUD-02 | Cl. 9.2.2, 4 to 10; Annex A per row; MO-02 |
| [SIM-AUD-003](audit/SIM-AUD-003-internal-audit-report-2026.md) | Internal audit report 2026 | 2026-10-16 | ISMS-AUD-01, ISMS-AUD-02, ISMS-AUD-04 | Cl. 9.2.2, 10.2; A.5.3, A.5.35, A.8.5, A.8.32; MO-02, MO-03, CM-05, AC-03, RA-01, AC-07 |
| [SIM-INF-002](information/SIM-INF-002-customer-data-deletion-at-contract-end.md) | Customer B (fictional) data deletion at pilot end; confirmation draft never sent | 2026-10-19 (deletion 2026-10-23) | POL-RET-01 2 and 5, POL-DATA-01 5.3 | A.8.10, A.5.33; CO-04; GDPR Art. 28(3)(g) |
| [SIM-MR-001](management-review/SIM-MR-001-management-review-2026.md) | Management review minutes 2026 | 2026-10-26 | ISMS-MR-01, ISMS-MR-02 | Cl. 9.3.1 to 9.3.3, 10.1, 7.1, 5.1; CE-06, MO-03, RA-01 |
| [SIM-OPS-001](operations/SIM-OPS-001-capacity-clock-and-network-design-review.md) | Capacity, clock and network design review of the workload Terraform (labelled real observations and scenario) | 2026-10-28 | POL-BCDR-01 5, STD-LOG-01 5.1, POL-CLD-01 4.7 | A.8.22; A.8.6, A.8.17 not raised; AV-05, OP-03 |

## 2. Corrective actions

| ID | Nonconformity | Opened | Source | Status on 2026-10-26 | Controls |
|---|---|---|---|---|---|
| [SIM-CAPA-001](improvement/SIM-CAPA-001-leaver-github-seat-removed-late.md) | Leaver kept a GitHub seat 12 days | 2026-06-22 | SIM-ACC-001 E-1 | Awaiting effectiveness review (2026-12-14) | Cl. 10.2; A.5.18, A.6.5, A.8.2; AC-06, AC-07 |
| [SIM-CAPA-002](improvement/SIM-CAPA-002-mover-kept-old-engineering-group.md) | Mover kept an engineering permission set; exception control not in place | 2026-06-22 | SIM-ACC-001 E-2 | Action in progress (2026-11-30) | Cl. 10.2; A.5.3, A.5.15, A.5.18, A.8.2; AC-04, AC-07 |
| [SIM-CAPA-003](improvement/SIM-CAPA-003-real-customer-data-used-as-test-fixture.md) | Real customer data used as test fixture | 2026-08-25 | SIM-INC-001, SIM-IMP-001 | Awaiting effectiveness review (2026-12-15) | Cl. 10.2; A.8.11, A.8.33; CO-05 |
| [SIM-CAPA-004](improvement/SIM-CAPA-004-customer-notice-24h-missed-and-evidence-lost.md) | 24 h customer notice missed; evidence deleted before capture | 2026-08-25 | SIM-INC-001, SIM-IMP-001 | Action in progress, one part overdue | Cl. 10.2; A.5.24, A.5.26, A.5.28; OP-06, IC-02 |
| [SIM-CAPA-005](improvement/SIM-CAPA-005-change-approval-not-independent.md) | No independent change approval; compensating review never ran (major) | 2026-10-16 | SIM-AUD-003 NC-01 | Action in progress (check 2027-03-05) | Cl. 10.2; A.5.3, A.8.32; CM-01, CM-05 |
| [SIM-CAPA-006](improvement/SIM-CAPA-006-mfa-not-enforced-for-privileged-access.md) | MFA not enforced for privileged access (minor) | 2026-10-16 | SIM-AUD-003 NC-02 | Action in progress (check 2027-01-15) | Cl. 10.2; A.8.5, A.5.17; AC-03 |
| [SIM-CAPA-007](improvement/SIM-CAPA-007-scheduled-isms-activities-missed.md) | Scheduled reviews and agreed follow-ups missed (minor) | 2026-10-16 | SIM-AUD-003 NC-03 | Action in progress (check 2027-01-29) | Cl. 6.1.2, 6.1.3, 8.2, 9.1, 10.2; RA-01, AC-07 |

## 3. Records held by other authors

| ID | Area | Note |
|---|---|---|
| [SIM-PPL-001](people/SIM-PPL-001-joiner-batch.md) to [SIM-PPL-006](people/SIM-PPL-006-role-holder-appointments.md) | People: joiners, NDAs, training, leaver EMP-023, mover EMP-019, role holders | SIM-PPL-004 and SIM-PPL-005 are the HR side of SIM-ACC-001 E-1 and E-2 |
| [SIM-DSR-001](privacy/SIM-DSR-001-access-and-erasure-request.md) | Privacy: data subject request | Customer A (fictional) |
| [SIM-GDPR-001](privacy/SIM-GDPR-001-dpo-decision-minutes.md), [SIM-GDPR-002](privacy/SIM-GDPR-002-ropa-annual-review.md), [SIM-GDPR-003](privacy/SIM-GDPR-003-dpia-sign-off.md) | Privacy: DPO decision, RoPA review, DPIA sign-off | — |
| [SIM-NIS2-001](nis2/SIM-NIS2-001-management-cybersecurity-training.md), [SIM-NIS2-002](nis2/SIM-NIS2-002-customer-supplier-security-assessment.md) | NIS2: management training, customer supplier assessment | — |
| [SIM-GDPR-004](privacy/SIM-GDPR-004-dpa-conclusion-customer-a.md) | Data processing agreement prepared for Customer A (fictional) | Scenario date 2026-05-18 (pilot start). Cross-check against 2026-08-10 to 2026-09-24 |
| [SIM-GDPR-005](privacy/SIM-GDPR-005-transfer-assessment-review.md) | Review of the data-flow map and transfer assessment | Scenario date 2026-07-07, the day after SIM-SUP-001. Cross-check against 2026-08-10 |
| [SIM-GDPR-006](privacy/SIM-GDPR-006-privacy-notice-issue-and-lia-review.md) | Privacy notices issued and legitimate-interests assessment reviewed | Scenario date 2026-03-23 |
| [SIM-GDPR-007](privacy/SIM-GDPR-007-processor-register-and-tom-review.md) | Annual review of the processor register and the three TOM documents | Scenario date 2026-09-29, the day after SIM-GDPR-002 |
| [SIM-SOC2-001](soc2/SIM-SOC2-001-job-descriptions-and-performance-review.md) | Job descriptions and the security section of the performance review | Scenario date 2026-07-13 |
| [SIM-SOC2-002](soc2/SIM-SOC2-002-customer-onboarding-security-pack.md) | Customer onboarding security pack delivered to Customer A (fictional) | Scenario date 2026-05-18 (pilot start). Cross-check against 2026-08-13 and 2026-09-22 |
| [SIM-SOC2-003](soc2/SIM-SOC2-003-fraud-and-insider-risk-session.md) | Fraud and insider-risk assessment session | Scenario date 2026-04-21 |
| [SIM-SOC2-004](soc2/SIM-SOC2-004-emergency-change.md) | Emergency change during incident INC-2026-001 | Scenario date 2026-08-12 (change) to 2026-08-25 (retrospective review). Review due 2026-08-14 |
| [SIM-SOC2-005](soc2/SIM-SOC2-005-insurance-coverage-review.md) | Cyber insurance coverage review | Scenario date 2026-06-08 |
| [SIM-SOC2-006](soc2/SIM-SOC2-006-joiner-identity-provisioning-trace.md) | Joiner traced from the personnel source to a permission set and session duration | Scenario date 2026-02-09 (start date and Entra identity). The Identity Center step of the same trace is dated 2026-03-19, as in SIM-PPL-001 |

Real records referenced by ID only: REAL-SUP-001, REAL-INFRA-002.

## What this does not show

- None of the listed events happened. This index is a table of contents.
- A row here never raises a control above the status rules in ADR-0006.
