# ISMS communication plan

| Field | Value |
|---|---|
| Document ID | ISMS-00-08 |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or when a channel is set up or removed, or the first customer contract is signed |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company with fictional staff and no customers. No staff-facing or external ISMS briefing record exists. Repository pull requests are real communication evidence; they do not establish receipt of policies by a workforce. Section 4 lists which channels exist today.

## 1. Purpose

ISO/IEC 27001:2022 clause 7.4 asks Ayka to decide on internal and external communication relevant to the ISMS: what, when, with whom, who communicates, and how. A.5.14 (information transfer), A.5.24 to A.5.26 (incidents), A.6.3 (awareness) and A.6.8 (event reporting) depend on it. Incident and breach reporting is defined in [POL-IR-01](../../policies/incident-response-plan.md) and [NIS2-03](../../NIS2/03-incident-reporting-procedure.md); this plan links them and does not repeat their deadlines.

## 2. Internal communication

| ID | What | When | With whom | Who communicates | How | Record |
|---|---|---|---|---|---|---|
| IC-I-01 | Information security policy and topic policies; changes to them | On approval and on each change; at onboarding | All staff and contractors | CISO | Link to the document in the repository; briefing at onboarding; policy change briefing ([training programme §4](../../../organization/training-and-awareness.md#4-awareness-activities)) | Acknowledgement per staff member. None exist |
| IC-I-02 | ISMS objectives and progress | Quarterly; at the management review | Managing Director | CISO | Quarterly security report ([NIS2-04 §3](../../NIS2/04-management-accountability.md#3-oversight-in-practice)); [ISMS objectives](isms-objectives.md); [KPIs and metrics](../08-monitoring-and-measurement/kpis-and-metrics.md) | [Quarterly report log](../../NIS2/04-management-accountability.md#53-quarterly-security-report-log). No entries yet |
| IC-I-03 | Risks above the acceptance threshold; requests for risk acceptance | When identified | Managing Director | CISO | Written request per the [risk criteria](../03-risk-management/risk-criteria.md) | [Risk acceptance log](../03-risk-management/risk-acceptance-log.md) |
| IC-I-04 | Suspected security events and incidents | Immediately | Security Operations (Incident Coordinator) | Anyone who notices | Security mailbox or on-call number per [POL-IR-01 §7.1](../../policies/incident-response-plan.md#71-detection-and-reporting). Neither exists yet (SOC 2 IC-03, Planned); until then, directly to the CISO using an established contact; this document supplies no live contact endpoint | Incident record ([POL-IR-01 §10](../../policies/incident-response-plan.md#10-incident-record-template)) |
| IC-I-05 | Incident status and escalation | During an incident | Managing Director; affected staff | Incident Commander / Incident Coordinator | [POL-IR-01 §8](../../policies/incident-response-plan.md#8-notification); [NIS2-03 §2](../../NIS2/03-incident-reporting-procedure.md#2-roles) | Incident record |
| IC-I-06 | Awareness topics, newsletter, phishing results | Quarterly | All staff | HR & Administration with the CISO | [Training programme §4](../../../organization/training-and-awareness.md#4-awareness-activities) | Training records. None exist |
| IC-I-07 | Changes to ISMS documents | On merge | Document owners; staff affected by the change | Author of the change | Pull request on GitHub (notification to the maintainer); for staff-facing changes, a short note in the next newsletter | Pull request history |
| IC-I-08 | Internal audit results | After each audit | CISO, Managing Director, process owners | Internal auditor | Audit report per the [audit programme](../09-internal-audit/audit-programme.md) | Audit findings log |
| IC-I-09 | Management review decisions and actions | After each review | CISO and action owners | Managing Director | [Management review action log](../10-management-review/management-review-action-log.md) | Action log. No entries yet |
| IC-I-10 | Introduction or change of logging, identity or other systems able to monitor staff; rules of conduct | Before introduction | Works council, if one is elected | HR & Administration | Written information and consultation (legal register [LR-11](legal-and-regulatory-register.md)) | Correspondence. None: no works council recorded |
| IC-I-11 | Joiners, movers and leavers | Before the start date or change; on the last day | Cloud Platform Engineering (access) | HR & Administration | Per the [onboarding and offboarding procedure](../01-organization/onboarding-and-offboarding-procedure.md) | Ticket or checklist. None exist |

## 3. External communication

| ID | What | When | With whom | Who communicates | How | Record |
|---|---|---|---|---|---|---|
| IC-E-01 | Security incident affecting customer data or services | Per the deadlines in [NIS2-03 §5](../../NIS2/03-incident-reporting-procedure.md#5-reporting-timeline) and the contract | Affected customers | Customer communication role, drafted by the Incident Coordinator ([NIS2-03 §2](../../NIS2/03-incident-reporting-procedure.md#2-roles)) | E-mail to the customer's security contact using template [T-1](../../NIS2/03-incident-reporting-procedure.md#t-1-customer-incident-notice) | Incident log T-4 |
| IC-E-02 | Personal-data breach | Per [NIS2-03 §6](../../NIS2/03-incident-reporting-procedure.md#6-personal-data-breaches-gdpr) | LfDI Baden-Württemberg (Ayka as controller); data subjects if the risk is high; customers (Ayka as processor) | GDPR lead role in Compliance & Risk Management, approved by the Managing Director | The authority's online form; direct message to data subjects; customer notice as IC-E-01 | Breach log (T-4 with GDPR fields) |
| IC-E-03 | Significant incident reports to the BSI | Not required under the current working applicability assessment; verify actual scope before real operation ([NIS2-01 §1](../../NIS2/01-applicability-assessment.md#1-result)). Voluntary reporting possible | BSI | CISO decides; regulatory reporting role submits | Per [NIS2-03 §5](../../NIS2/03-incident-reporting-procedure.md#5-reporting-timeline) and template T-2 | Incident log T-4 |
| IC-E-04 | Facts customers need for their own NIS2 reports | On request during an incident | Customers in NIS2 scope | Incident Coordinator | Structure of NIS2-03 templates T-2 and T-3 ([NIS2-05 A.2](../../NIS2/05-supply-chain-security.md#a2-aykas-standard-positions)) | Incident record |
| IC-E-05 | Crime reports | When a crime is suspected and the Managing Director agrees | Police cybercrime unit (ZAC, LKA Baden-Württemberg) | Managing Director | Per [NIS2-03 §7](../../NIS2/03-incident-reporting-procedure.md#7-other-parties-to-consider) | Incident record |
| IC-E-06 | Security commitments, system description, DPA, sub-processor list, security contact | At contract; on material change | Customers and prospects | Product & Engineering, with the CISO for anything stricter than NIS2-05 A.2 | Contract documents; [processor register](../../GDPR/processor-register.md); security questionnaires per [NIS2-05 A.1](../../NIS2/05-supply-chain-security.md#a1-what-customers-will-ask) | Contract file. No customer exists |
| IC-E-07 | New or replaced sub-processor | 30 days before the change ([NIS2-05 A.2](../../NIS2/05-supply-chain-security.md#a2-aykas-standard-positions)) | Customers | Compliance & Risk Management | E-mail notice with a right to object | Notice file. None |
| IC-E-08 | Support cases, abuse reports, incident notices | When a provider's service is affected or needed | AWS, Microsoft, GitHub | Cloud Platform Engineering | Provider support portals; status and security advisory subscriptions (not set up: [NIS2-05 B.3](../../NIS2/05-supply-chain-security.md#b3-what-is-missing)) | Support case IDs in the incident record |
| IC-E-09 | Vulnerability reports from researchers and the public | On receipt; acknowledge within 5 working days (target) | Reporter | Security Operations | `SECURITY.md` pointing to a monitored security mailbox. Neither exists; GitHub private vulnerability reporting is switched off (read 2026-10-14) | Ticket. None |
| IC-E-10 | Capability status and honest limits of the case study | On each change of the README | Public readers of the repository | Maintainer | Root [README, capability status](../../../README.md#4-capability-status) | Git history |
| IC-E-11 | Audit evidence and readiness | When an audit is planned | Certification body or TISAX audit provider | CISO | ISMS index, Statement of Applicability, evidence bundles | Audit file. No audit engaged |
| IC-E-12 | Incident notice under an insurance policy | Per policy terms | Insurer | Managing Director | Per policy | None: no policy recorded |

## 4. Channels that exist today

| Channel | Exists? | Evidence |
|---|---|---|
| GitHub pull requests and their notifications | Yes | Ruleset `protect-main`; pull request history |
| GitHub issues on the public repository | Enabled, but not a security channel: anything posted there is public | GitHub API, read 2026-10-14 |
| GitHub private vulnerability reporting | No: switched off | GitHub API, read 2026-10-14 |
| `SECURITY.md` | No: no such file in the repository root, `.github/` or `docs/` | Checked 2026-10-14 |
| Security mailbox, on-call number | No | [SOC2-03](../../SOC2/03-control-matrix.md#3-information-and-communication-ic) IC-03, Planned |
| Out-of-band channel if e-mail or Entra ID is compromised | No | [NIS2-03 §8](../../NIS2/03-incident-reporting-procedure.md#8-preconditions-that-do-not-exist-yet) |
| Customer security contact list | No: no customers | NIS2-03 §8 |

Until the security mailbox exists, internal and external security reports cannot reach Ayka reliably. This is a precondition for IC-I-04, IC-E-09 and every notification deadline in sections 2 and 3.

## 5. Rules

- Only the roles named in sections 2 and 3 speak for Ayka about a security incident. Nobody else confirms or denies an incident externally.
- External messages that admit a breach of contract need the Managing Director's approval ([NIS2-03 §2](../../NIS2/03-incident-reporting-procedure.md#2-roles)).
- Information goes out at its classification level ([POL-DATA-01 §5.4](../../policies/data-classification-and-confidentiality-policy.md#54-sharing)): Confidential only under NDA or DPA.
- Deadlines come from the linked procedures. Where they differ, the shorter one applies until the conflict is fixed (section 6).

## 6. Current gaps

| Gap | Reference |
|---|---|
| No security mailbox, `SECURITY.md` or on-call number | SOC 2 IC-03 |
| Customer notice deadline differs: [POL-IR-01 §8](../../policies/incident-response-plan.md#8-notification) says at the latest 48 hours after confirming a breach of customer data; [NIS2-03 §6](../../NIS2/03-incident-reporting-procedure.md#6-personal-data-breaches-gdpr) and NIS2-05 A.2 commit to 24 hours | Owner of POL-IR-01 to align |
| No provider status or advisory subscriptions | NIS2-05 B.3 |
| No staff acknowledgement, customer notice or incident communication record exists; GitHub change discussion is limited to the repository | RISK-010 |

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
