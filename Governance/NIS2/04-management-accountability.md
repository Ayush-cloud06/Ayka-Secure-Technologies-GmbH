# Management Accountability for Cybersecurity

| Field | Value |
|---|---|
| Document ID | NIS2-04 |
| Organization | Ayka Secure Technologies GmbH (simulated case study) |
| Owner | Managing Director |
| Prepared by | CISO |
| Version | 1.0 |
| Status | Draft. Not approved: no approval record exists. |
| Classification | Internal |

## 1. Who "management" is at Ayka

NIS2 Art. 20 and §38 BSIG address the *Geschäftsleitung*: for a GmbH, the managing directors (*Geschäftsführer*) registered in the commercial register. Ayka has one: the Managing Director and founder (EMP-001). There is no supervisory board and no second managing director.

The CISO is **not** management in this sense. The CISO runs the ISMS and advises; the duties below stay with the Managing Director even when the work is delegated.

## 2. The duties, and where Ayka stands

Ayka is not a NIS2 entity ([NIS2-01](01-applicability-assessment.md)), so §38 BSIG does not bind the Managing Director today. The general duty under §43(1) GmbHG still does: a managing director must run the company with the care of a prudent businessperson, and that includes not ignoring known, serious IT risks. If damage results from a neglected security risk, the company can claim it from the managing director under §43(2) GmbHG, NIS2 or not. In practice, §38 BSIG mostly writes down what the courts already expect.

| Duty | §38 BSIG / NIS2 Art. 20 | Binding today? | What the Managing Director does |
|---|---|---|---|
| **Approve** the risk-management measures | §38(1): implement the measures under §30; NIS2 Art. 20(1): approve them | No (GmbHG duty of care applies) | Approves the [information security policy](../ISMS/00-context-and-governance/information-security-policy.md), the [NIS2 gap assessment](02-risk-management-measures.md) and its priority list, and the budget to close them |
| **Oversee** their implementation | §38(1) | No | Receives the CISO's quarterly security report (section 3); asks for evidence, not assurances |
| **Be liable** for breaches of these duties | §38(2): liability to the company under company law, here §43 GmbHG | §43 GmbHG yes | Keeps the records in section 5, which are the only defence that a duty was met |
| **Train** regularly | §38(3): enough knowledge to identify and assess risks and risk-management practices and their effect on the services | No | Attends training anyway (section 4), because approving measures one cannot assess is not oversight |
| **Offer training** to staff | NIS2 Art. 20(2) encourages regular training for employees | No | Funds the [training and awareness programme](../../organization/training-and-awareness.md) |

Delegation: the Managing Director can delegate the work (to the CISO, to engineering), but not the accountability. A clear written delegation, adequate resources and actual follow-up are what make delegation defensible. Signing a policy once and never asking about it again is not oversight.

## 3. Oversight in practice

| What | Frequency | Content | Evidence it happened |
|---|---|---|---|
| Security report from the CISO | Quarterly | Status of the NIS2-02 priority list; open risks above the acceptance threshold; incidents and near misses; supplier issues; changes in NIS2 applicability (headcount, turnover, new services) | Report file and the Managing Director's written response |
| Risk acceptance | Each time a risk above the threshold in the [risk criteria](../ISMS/03-risk-management/risk-criteria.md) is accepted | Named risk, reason, expiry | Entry in the [risk acceptance log](../ISMS/03-risk-management/risk-acceptance-log.md) signed by the Managing Director |
| Significant incident | Within 4 hours of the significance decision | Per [NIS2-03](03-incident-reporting-procedure.md) | Entry in the incident log |
| Management review | Annually | ISO 27001 clause 9.3 inputs, plus this document's duties | Minutes |
| NIS2 applicability | Every six months | [NIS2-01](01-applicability-assessment.md) section 7 triggers | Updated assessment with decision record |

The quarterly report should fit on two pages. A report that nobody reads gives no protection.

## 4. Training for the Managing Director

§38(3) BSIG does not set a frequency or a format. Ayka's rule:

- **First training** within six months of approving this document, at least one working day, covering: current threats to SaaS companies, how to read a risk register and accept or reject a risk, the reporting duties and deadlines in NIS2-03, and personal liability.
- **Refresher** every year, half a day, focused on what changed (law, threats, Ayka's own incidents).
- **Provider**: an external course that issues a certificate of attendance. Several German chambers of commerce and training providers now run courses designed for §38(3); check that the syllabus covers the four topics above.
- The CISO attends the same training, so that both speak the same language in the quarterly report.

## 5. Records

These are templates. No training has taken place and no approval has been given.

### 5.1 Approval of measures

| Date | Document and version | Decision | Managing Director's signature |
|---|---|---|---|
| | | | |

### 5.2 Management training record

| Date | Participant | Provider | Course title | Duration | Topics covered | Certificate filed (yes/no) |
|---|---|---|---|---|---|---|
| | | | | | | |

### 5.3 Quarterly security report log

| Quarter | Date presented | Main points | Decisions taken | Follow-up actions |
|---|---|---|---|---|
| | | | | |

## 6. D&O insurance

Check whether Ayka holds directors' and officers' liability insurance and whether it covers claims arising from cybersecurity failures. **No D&O policy is recorded in the case study.** Insurers increasingly ask about NIS2 measures when underwriting; the NIS2-02 gap assessment is the document to give them.

## Revision history

| Version | Date | Author | Change |
|---|---|---|---|
| 1.0 | 2026-10-06 | CISO | First version |
