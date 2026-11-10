# SIM-PPL-003: Training completion: awareness for 24, role-based for Tier 0 and Tier 1

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-PPL-003 |
| Authored | 2026-11-10 (real date) |
| Scenario date | 2026-03-04 to 2026-04-28 |
| Participants | EMP-012 (Training Coordinator, keeps records), EMP-002 (programme owner, content, assessor), EMP-001, all 24 staff as trainees |
| Procedure exercised | [Training and awareness programme](../../../../organization/training-and-awareness.md) sections 3 to 6; [Competence matrix](../../../ISMS/01-organization/competence-matrix.md) sections 3 and 4 |
| Controls | ISO 27001:2022 clause 7.2, clause 7.3, A.6.3; SOC 2 CE-05; GDPR Art. 32(4) |

## Scenario summary

The campaign opened on 2026-03-04, two days after policy approval. EMP-012 sent the due date, 2026-03-20, by e-mail. The modules are the seven topics in programme section 3.1. The course ended with a 10-question quiz. Pass mark 8 of 10, scenario decision by EMP-002 on 2026-03-04 (the programme sets none). The last completion was recorded on 2026-03-31, the end of the campaign.

The record fields follow programme section 5: employee ID, training name, completion date, certification. Two columns are added: result and note.

Imperfections that happened:

- **Two late completions:** EMP-010 on 2026-03-26 and EMP-022 on 2026-03-31. Both were reminded on 2026-03-23. Their Identity Center and GitHub grants waited for completion (SIM-PPL-001).
- **One quiz failure:** EMP-007 scored 6 of 10 on 2026-03-10 and retook it on 2026-03-16 after reading the module again with EMP-003. Passed 9 of 10.

## 1. Baseline awareness (all 24)

| ID | Training | Completion date | Result | Certification | Note |
|---|---|---|---|---|---|
| EMP-001 | Baseline security awareness 2026 | 2026-03-05 | Completed | None |  |
| EMP-002 | Baseline security awareness 2026 | 2026-03-05 | Completed | None |  |
| EMP-003 | Baseline security awareness 2026 | 2026-03-06 | Completed | None |  |
| EMP-004 | Baseline security awareness 2026 | 2026-03-06 | Completed | None |  |
| EMP-005 | Baseline security awareness 2026 | 2026-03-09 | Completed | None |  |
| EMP-006 | Baseline security awareness 2026 | 2026-03-09 | Completed | None |  |
| EMP-007 | Baseline security awareness 2026 | 2026-03-16 | Completed | None | First attempt 2026-03-10: 6 of 10, not passed. Retake 2026-03-16: 9 of 10, passed |
| EMP-008 | Baseline security awareness 2026 | 2026-03-10 | Completed | None |  |
| EMP-009 | Baseline security awareness 2026 | 2026-03-11 | Completed | None |  |
| EMP-010 | Baseline security awareness 2026 | 2026-03-26 | Completed late | None | Completed after the 2026-03-20 due date |
| EMP-011 | Baseline security awareness 2026 | 2026-03-12 | Completed | None |  |
| EMP-012 | Baseline security awareness 2026 | 2026-03-12 | Completed | None |  |
| EMP-013 | Baseline security awareness 2026 | 2026-03-13 | Completed | None |  |
| EMP-014 | Baseline security awareness 2026 | 2026-03-13 | Completed | None |  |
| EMP-015 | Baseline security awareness 2026 | 2026-03-16 | Completed | None |  |
| EMP-016 | Baseline security awareness 2026 | 2026-03-16 | Completed | None |  |
| EMP-017 | Baseline security awareness 2026 | 2026-03-17 | Completed | None |  |
| EMP-018 | Baseline security awareness 2026 | 2026-03-17 | Completed | None |  |
| EMP-019 | Baseline security awareness 2026 | 2026-03-18 | Completed | None |  |
| EMP-020 | Baseline security awareness 2026 | 2026-03-18 | Completed | None |  |
| EMP-021 | Baseline security awareness 2026 | 2026-03-19 | Completed | None |  |
| EMP-022 | Baseline security awareness 2026 | 2026-03-31 | Completed late | None | Completed after the 2026-03-20 due date |
| EMP-023 | Baseline security awareness 2026 | 2026-03-20 | Completed | None |  |
| EMP-024 | Baseline security awareness 2026 | 2026-03-20 | Completed | None |  |

All 24 completed. 22 on time, 2 late. 1 failed first attempt and passed on retake.

## 2. Role-based cloud security training (Tier 0 and Tier 1)

Due by 2026-04-30. The six people are the Tier 0 and Tier 1 members in the identity source. Sessions were delivered in small groups by EMP-002 and EMP-014. The competence outcome uses the four values in the [competence matrix](../../../ISMS/01-organization/competence-matrix.md) section 3.

| ID | Track | Completion date | Result | Assessor | Competence outcome |
|---|---|---|---|---|---|
| EMP-002 | Security and compliance track plus cloud security fundamentals and IAM least privilege | 2026-04-07 | Completed | EMP-001 (not a security assessor) | Competent for assigned work |
| EMP-003 | Engineering track: cloud security fundamentals, IAM least privilege, IaC security, CI/CD security | 2026-04-14 | Completed | EMP-002 | Competent for assigned work |
| EMP-013 | Engineering track: cloud security fundamentals, IAM least privilege, IaC security, CI/CD security | 2026-04-15 | Completed | EMP-002 | Competent for assigned work |
| EMP-014 | Engineering track (cloud security fundamentals, IAM least privilege) plus security and compliance track | 2026-04-16 | Completed | EMP-002 | Competent for assigned work |
| EMP-004 | Security and compliance track plus cloud security fundamentals | 2026-04-21 | Completed | EMP-002 | Competent for assigned work |
| EMP-001 | Executive track plus cloud security fundamentals | 2026-04-28 | Completed | None available. Completion only | Not assessed |

The six grants of privileged access in SIM-PPL-001 each follow the date in this table.

## 3. Not done in this scenario

Role-based topics for executives, security and compliance staff, and IT support (programme section 3.2) were not scheduled for non-privileged staff. SOC 2 CE-05 asks for role-based training only for Tier 0 and Tier 1. The quarterly phishing simulation and the incident tabletop have no records here.

## Findings

1. **No deadline in the programme.** It says "upon onboarding" and "before production access". There is no due date, no reminder rule, and no consequence for a late completion. The 2026-03-20 date was set by HR in an e-mail.
2. **No assessment rule.** The programme measures competence by "training completion tracking". There is no quiz, no pass mark and no retake rule. The pass mark and the single retake here were invented in the scenario. Without a rule, a failed quiz has no recorded handling.
3. **Role-based scope is inconsistent.** The programme (section 3.2) assigns role-based topics to every role. SOC 2 CE-05 limits the control to Tier 0 and Tier 1. The competence matrix wants role assessment for HR and for Product. Three documents, three scopes.
4. **Training happened after access.** All hires had accounts for three to nine weeks before the campaign (SIM-PPL-001, Phase A). The programme says baseline training is required before production access, which only works if the campaign opens at hire. Staff hired before the ISMS cannot meet it.
5. **Assessor independence.** The competence matrix requires a separately competent reviewer. EMP-002 assessed four of the six. EMP-001 assessed EMP-002 but is not a security assessor. EMP-001 has no assessor. This is RISK-005 in practice.
6. **Records by HR, content by CISO, no cross-check.** The programme gives records to HR and ownership to the CISO. It does not say who compares the HR list with the staff list. EMP-012's own completion and EMP-023's are recorded by EMP-012.
7. **Role training before privileged access is an undeclared dependency.** The competence matrix says "before privileged access". The user access procedure lists "NDA/training prerequisites" without naming role-based training. This walk-through followed the competence matrix.
8. **Part-year staff.** Training evidence for a leaver (EMP-023) stays in the HR record under the retention policy. The programme says "retained for audit purposes" without a period.

## What this does not show

- Any real course content, platform, quiz question or score other than the two scores above.
- That a person understood the material. The quiz is one measure.
- The annual refresh. It is not due until 2027.
- Anything about the quarterly phishing simulation or the annual tabletop.
