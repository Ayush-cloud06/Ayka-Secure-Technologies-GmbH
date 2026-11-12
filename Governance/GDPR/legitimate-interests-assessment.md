# Legitimate interests assessment

| Field | Value |
|---|---|
| Document ID | GDPR-13 |
| Owner | Compliance & Risk Management |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or when the data categories, retention or recipients change |
| Status | Draft. Not approved. Reviewed by the repository owner with AI assistance, not by counsel. Not legal advice |

Ayka Secure Technologies GmbH is a simulated company. This assessment supports Art. 6(1)(f) for two activities in the [processing record](record-of-processing-activities.md): security logging (PA-03) and repository and CI metadata (PA-02). It follows the three parts used by the CJEU and the EDPB: a legitimate interest, necessity, and a balance against the person's interests, rights and freedoms (Art. 6(1)(f); Recital 47). Recital 49 names network and information security as a legitimate interest. Other texts cited here are **to verify** against current wording.

## 1. Security logging (PA-03)

Reality: planned. No log source delivers personal data (RISK-006). This is an assessment of the design, to be repeated against the built system.

### 1.1 Purpose test

| Question | Answer |
|---|---|
| Interest | Detect and investigate unauthorised access, misuse and incidents in the AWS accounts and the portal; keep evidence for the breach procedure (Art. 33) |
| Whose | Ayka's, and its customers' (they rely on Ayka's detection) |
| Lawful in itself | Yes. Recital 49 recognises ensuring network and information security, including preventing unauthorised access to electronic communications networks, as a legitimate interest of the controller. Art. 32 requires appropriate security. Art. 32 supports the necessity; it is not by itself the Art. 6 basis for logging every user |
| Real and present | Designed only. The interest is real for any internet-facing service; it is not yet exercised |

### 1.2 Necessity test

| Question | Answer |
|---|---|
| Is the processing needed for the interest | Yes for authentication events, administrative actions and request metadata at the edge. Without user or role identifiers an incident cannot be attributed |
| Less intrusive way | IP addresses can be truncated or tokenised for analytics; they cannot be for investigation. Content of requests and customer evidence is not logged. Identifiers are limited to those named in PA-03 |
| Data minimised | IP address, user or role identifier, request metadata, timestamps. No request bodies, no evidence content, no keystroke or screen capture |
| Retention | Proposed 365 days for selected workload logs and a longer CloudTrail target in [POL-RET-01](../policies/records-and-data-retention-policy.md). Not approved. The CloudTrail period needs its own proportionality review before it operates |

### 1.3 Balancing test

| Factor | Assessment |
|---|---|
| Who is affected | 24 staff (employment context, so an imbalance exists) and customer users, numbers unknown |
| Reasonable expectations | Staff are told in the [employee notice](privacy-notice-employees.md). Customer users are told in the [website notice](privacy-notice-website.md) and by the customer. Security logging of a company account is generally expected |
| Impact | Moderate for staff because logs attribute actions to a named person and could be used for performance monitoring. Low to moderate for customer users |
| Safeguards | Purpose limitation: logs are used for security and incident handling, not for performance or attendance review; access to the log archive limited to security roles ([logging standard](../policies/logging-and-monitoring-standard.md)); retention limit; no routine review of a named person's activity without a trigger; works-council or staff representative consultation if one exists (BetrVG, **to verify**; none recorded) |
| Right to object | Art. 21(1) applies. Staff and users can object on grounds relating to their situation; Ayka then stops unless it shows compelling legitimate grounds. For security logs the compelling grounds are usually shown for the minimum fields; the answer is recorded per request |
| Conclusion | Art. 6(1)(f) is supported for the minimum data set above, with the safeguards. Not supported for use of the logs for performance review. Employee-specific limits of BDSG § 26 and the position after CJEU C-34/21 are **to verify** and could change the basis for staff to Art. 6(1)(b) or (c) in part |

The result feeds the [DPIA](dpia-ayka-portal.md) (PA-03).

## 2. Repository and CI metadata (PA-02)

Reality: real, small.

### 2.1 Purpose test

| Question | Answer |
|---|---|
| Interest | Traceable change history (who changed what and when), code review and the compliance gate, which supports Art. 32 and the integrity of evidence |
| Lawful in itself | Yes. Accountability for changes is a normal business interest |

### 2.2 Necessity test

| Question | Answer |
|---|---|
| Needed | Git cannot record a change without an author field. The author name and e-mail address are what the tool records; the GitHub username is added by the host |
| Less intrusive way | Contributors can use a GitHub noreply address and a pseudonymous name. Ayka should say so in the contributor guidance. A real address in a commit cannot later be removed from public history without rewriting it |
| Minimised | Commit metadata, pull-request text and workflow logs only. No personal content is added on purpose to logs |

### 2.3 Balancing test

| Factor | Assessment |
|---|---|
| Who is affected | Repository contributors, currently the owner and any outside contributor |
| Expectation | A contributor to a public repository expects the name on a commit to be visible |
| Impact | Low for a pseudonym; moderate for a real name and personal e-mail, because history is permanent and indexed |
| Safeguards | Noreply address recommended; CI artifacts expire (90 days measured); no secret-scanning of personal content; DSR path in the [rights procedure](data-subject-rights-procedure.md) states that history may keep a copy |
| Right to object | Art. 21(1). Erasure of history means a rewrite; that is a separate decision under the rights procedure |
| Conclusion | Art. 6(1)(f) is supported for commit metadata and CI logs. It does not cover `personnel.json` (PA-01), which is a separate disclosure and has its own open gap |

## 3. What this assessment does not decide

- It is not counsel's opinion and not approved by anyone.
- It does not cover customer evidence (PP-01); the customer sets the basis there.
- It does not conclude whether staff representatives must be involved.
- The balance for staff changes if logs are ever used to assess performance. That use needs a new assessment and probably a different basis.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-11-10 | First issue |
