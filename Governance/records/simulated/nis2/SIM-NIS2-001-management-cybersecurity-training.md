# SIM-NIS2-001: Management cybersecurity training session

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-NIS2-001 |
| Authored | 2026-11-10 |
| Scenario date | 2026-04-20 |
| Participants | EMP-001 (Managing Director), EMP-002 (CISO), EMP-003 (Cloud Platform Engineer), EMP-004 (Compliance Analyst, GDPR Lead), EMP-005 (Security Operations Analyst), EMP-006 (Product Manager), EMP-009 (Sales Manager), EMP-012 (HR & Administration, Training Coordinator, attendance record) |
| Procedure exercised | [NIS2-04 section 4 and 5.2](../../../NIS2/04-management-accountability.md) |
| Controls | NIS2 Art. 20(2); §38(3) BSIG (does not bind Ayka, see [NIS2-01](../../../NIS2/01-applicability-assessment.md)); NIS2 Art. 21(2)(g); ISO/IEC 27001:2022 clause 7.2, A.6.3; SOC 2 CC1.4 |

## 1. Scenario

Ayka's Managing Director takes the first management training required by the NIS2-04 rule: at least one working day covering four topics, delivered by an external course that issues a certificate of attendance. The CISO attends the same day so both use the same vocabulary in the quarterly report. Department leads attend because the Managing Director delegates security work to them.

The provider is "an external training provider (fictional)". No real provider is named and no certificate is reproduced.

## 2. Walk-through

| Step in NIS2-04 | What the scenario shows | Output |
|---|---|---|
| Section 4: course of at least one working day | 8 h with breaks, 2026-04-20 | Attendance list (EMP-012 keeps it) |
| Topic 1: current threats to SaaS companies | Phishing of cloud admin accounts, leaked CI credentials, abuse of identity federation | Slide handout filed in the training folder |
| Topic 2: reading a risk register, accepting or rejecting a risk | EMP-001 and EMP-002 work through two entries of the [risk register](../../../ISMS/03-risk-management/risk-register.md) and the [risk acceptance log](../../../ISMS/03-risk-management/risk-acceptance-log.md) format | Scenario decision by EMP-001: one risk is accepted with an expiry date; one is not accepted |
| Topic 3: reporting duties and deadlines | The 24 h, 72 h, one-month sequence from [NIS2-03](../../../NIS2/03-incident-reporting-procedure.md); who is Incident Coordinator | Every participant can name the role holder |
| Topic 4: personal liability | §43(1), (2) GmbHG as written in NIS2-04 section 2; §38(2) BSIG noted as not binding | Notes only |
| Section 5.2: record row per participant | Filled below | Row per participant |
| Section 4: CISO attends | EMP-002 present | Yes |
| Section 4: refresher every year | Next due 2027-04-20 | Set in the HR calendar |

### Record row (template 5.2, filled for the scenario)

| Date | Participant | Provider | Course title | Duration | Topics covered | Certificate filed (yes/no) |
|---|---|---|---|---|---|---|
| 2026-04-20 | EMP-001 | External provider (fictional) | Cybersecurity for managing directors | 8 h | Threats; risk acceptance; reporting duties; liability | yes (scenario) |
| 2026-04-20 | EMP-002 | same | same | 8 h | same | yes (scenario) |
| 2026-04-20 | EMP-003, EMP-004, EMP-005, EMP-006, EMP-009 | same | same | 8 h | same | yes (scenario) |

## Findings

What the walk-through showed was wrong or missing in the procedure.

1. **No clock.** NIS2-04 section 4 says the first training is due "within six months of approving this document". No approval exists, so the six months never start. Needed: a fixed date or a trigger that does not depend on an approval record.
2. **Anachronism in the scenario itself.** The scenario date (2026-04-20) is before NIS2-04 and the applicability assessment were issued (2026-10-06). It is allowed in a walk-through, but a real training before the document would have to be covered by the general duty of care in §43 GmbHG only. The procedure does not say whether earlier training counts toward the first.
3. **Template 5.2 is thin.** It has no field for the course syllabus check that NIS2-04 requires ("check that the syllabus covers the four topics"), no learning check, and no next-due date. Add three fields.
4. **Capacity.** Eight of 24 staff out for a full day is a third of the company. The procedure says nothing about attendance of leads versus the Managing Director alone. The CISO-only attendance rule is clear; the lead attendance is invented by this walk-through and is not in NIS2-04.
5. **No link to the quarterly report.** NIS2-04 section 3 does not ask the CISO to report training status to the Managing Director. Add it as a standing line.
6. **Certificates.** The procedure says "certificate of attendance" but not where it is stored or for how long. The [retention policy](../../../policies/records-and-data-retention-policy.md) should name the class.

These findings concern the procedure in the repository and are true of it; they are candidates for the improvement register.

## What this does not show

- That any person at Ayka has attended any training. Ayka and its staff are fictional.
- That an external provider's syllabus matches the four topics; no provider or syllabus was checked.
- That the knowledge of the Managing Director improved; no test was run.
- Compliance with §38(3) BSIG, which does not bind Ayka.
- Anything about the baseline awareness training of all staff, which is the subject of [SIM-PPL-003](../people/SIM-PPL-003-training-completion.md) (a separate record).
