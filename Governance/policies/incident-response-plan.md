# Incident Response Plan

| Field | Value |
|---|---|
| Document ID | POL-IR-01 |
| Classification | Internal |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, and after every Severity 1 incident or exercise |
| Status | Draft. Not approved. Never exercised |

## 1. Purpose

Ayka detects, contains and recovers from security incidents quickly, tells the people it must tell on time, and learns from each one. This plan is the single procedure for that.

## 2. Scope

Any event that threatens the confidentiality, integrity or availability of the Ayka Portal, customer data, Ayka's internal data, or the systems that build and change them (GitHub repository and pipeline, AWS, Entra ID). Lost or stolen laptops and phishing that reaches staff are included.

## 3. References

| Framework | Requirement |
|---|---|
| SOC 2 | CC7.3, CC7.4, CC7.5, CC2.3 |
| ISO/IEC 27001:2022 | A.5.24, A.5.25, A.5.26, A.5.27, A.5.28, A.6.8 |
| GDPR | Art. 33 (notify the authority within 72 hours), Art. 34 (notify data subjects), Art. 33(2) (processor notifies controller without undue delay) |
| Controls | OP-05, OP-06, OP-07, IC-03 |

## 4. Definitions

- **Security event**: something observed that might affect security, such as an alert, a failed login burst or a user report.
- **Security incident**: an event confirmed, or reasonably suspected, to compromise confidentiality, integrity or availability.
- **Personal data breach**: an incident that leads to the destruction, loss, alteration, unauthorised disclosure of or access to personal data (GDPR Art. 4(12)).

## 5. Severity

| Severity | Examples | Response start | Updates to management |
|---|---|---|---|
| **SEV 1, critical** | Confirmed access to customer data; ransomware; compromise of Tier 0 identity, the AWS management account or the pipeline; portal down for all customers | Immediately, 24 × 7 | Every 2 hours |
| **SEV 2, high** | Suspected data access not yet confirmed; one customer affected; break-glass used without approval; malware on a laptop with production access | Within 1 hour, 24 × 7 | Every 4 hours |
| **SEV 3, medium** | Contained malware on a laptop without production access; credential phished but MFA blocked use; a HIGH configuration finding reached production | Next business day | Daily |
| **SEV 4, low** | Policy violation without data exposure; spam or blocked phishing reported by staff | Within 5 business days | In the monthly report |

When in doubt, classify higher and lower it later.

## 6. Roles

| Role | Who | Duties |
|---|---|---|
| Incident Commander (IC) | CISO; deputy: Security Operations Analyst | Declares and classifies, runs the response, decides on containment, owns the incident record |
| Technical Lead | Cloud Platform Engineer on call | Investigation, containment and recovery in AWS, Entra ID and GitHub |
| Communications Lead | Managing Director; deputy: Head of Sales and Customer Success | Customer, authority and public communication; approves all external statements |
| Privacy Lead | GDPR Lead | Decides whether a personal data breach occurred; drafts authority and data subject notifications |
| Scribe | Anyone assigned by the IC | Keeps the timeline in the incident record |

## 7. Response phases

### 7.1 Detection and reporting

- Sources: alerts on the `security-alerts` topic (OP-05, planned), GuardDuty, the gate (a HIGH finding that reached `main`), staff reports, customer reports to the security mailbox, provider notices from AWS, Microsoft or GitHub.
- Every member of staff reports suspected incidents immediately to the security mailbox or the on-call number. Reporting a mistake you made yourself is never a disciplinary matter.

### 7.2 Triage (target: within 30 minutes for SEV 1 and 2)

1. Open an incident record (section 10) and start the timeline.
2. Confirm whether it is an incident; classify severity; name the IC.
3. Ask the Privacy Lead whether personal data may be involved. If yes, the 72-hour GDPR clock is assessed from the moment Ayka became aware.

### 7.3 Containment

Typical actions, chosen by the IC:

| Situation | Containment |
|---|---|
| Compromised workforce identity | Disable in Entra ID, revoke sessions, remove from Identity Center groups, rotate any secrets the person could read |
| Compromised IAM role or keys | Attach a deny-all policy, revoke active sessions, rotate |
| Compromised pipeline or repository | Lock `main` (ruleset), disable Actions, revoke tokens and deploy keys, review the last merged changes and environment approvals |
| Compromised workload | Isolate the ECS task or security group, snapshot for forensics before changing anything, block at WAF |
| Data exposure in S3 | Re-apply the public access block, review object access logs |

Containment changes follow the emergency path in the [Change Management Policy](change-management-policy.md#6-emergency-changes).

### 7.4 Eradication and recovery

Remove the cause, rebuild from Terraform rather than repairing in place, restore data from backups per the [BC/DR plan](business-continuity-and-disaster-recovery-plan.md), and monitor closely for 14 days after recovery.

### 7.5 Evidence preservation

Preserve CloudTrail, VPC flow, WAF and application logs and snapshots before cleaning up. Record who collected what and when. Do not run investigation tools on the only copy.

## 8. Notification

| Who | When | Who decides | How |
|---|---|---|---|
| Managing Director | SEV 1 and 2: immediately | IC | Phone |
| Affected customers (Ayka as processor) | Without undue delay, at the latest 48 hours after confirming a breach of their data, so they can meet their own 72-hour deadline | Communications Lead with Privacy Lead | E-mail to the customer's registered security contact, then call |
| Supervisory authority (Ayka as controller, e.g. employee data) | Within 72 hours of awareness, unless the breach is unlikely to result in a risk to people | Privacy Lead, approved by Managing Director | The Baden-Württemberg data protection authority's online form |
| Data subjects (Ayka as controller) | Without undue delay when there is a high risk to them | Privacy Lead, approved by Managing Director | Direct message |
| National CSIRT under NIS2 | Where Ayka itself is in scope of the German NIS2 implementation: early warning within 24 hours of a significant incident, notification within 72 hours, final report within one month | IC with Managing Director | BSI reporting portal |
| Cyber insurer | Per policy terms | Managing Director | Per policy |
| Law enforcement | When a crime is suspected and the Managing Director agrees | Managing Director | Police cybercrime unit (ZAC) |

The reasoning for every decision not to notify is recorded in the incident record.

## 9. Post-incident review

For every SEV 1 and SEV 2 incident, and for every exercise, the IC holds a blameless review within 10 business days. It records the timeline, root cause, what worked, what did not, and actions with owners and due dates. Actions enter the risk treatment plan. The review also checks whether a gate rule could have prevented the incident; if yes, adding that rule is one of the actions.

## 10. Incident record template

| Field | Content |
|---|---|
| Incident ID | `INC-YYYY-NNN` |
| Opened, closed | Timestamps (UTC) |
| Severity | Initial and final, with reason for changes |
| Reporter and source | |
| Systems and data affected | Including customers and data categories |
| Personal data breach | Yes or no, and the reasoning |
| Timeline | Timestamped actions and decisions |
| Notifications | Each party, time sent, content reference |
| Root cause | |
| Actions | Owner and due date each |
| Review | Date and attendees |

No incident records exist yet.

## 11. Exercises

A tabletop exercise is held at least once a year, rotating through these scenarios: compromised Tier 0 identity; malicious change slipped into the pipeline; customer data exposed through misconfiguration; AWS Region outage. The first exercise should use RISK-001 (credentials in Git history) as its scenario because it is a real condition in this repository.

## 12. Current gaps

No alerting exists to feed this plan (OP-05). The security mailbox, the on-call rota and the customer contact list do not exist yet. The plan has not been exercised.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-06 | First issue |
