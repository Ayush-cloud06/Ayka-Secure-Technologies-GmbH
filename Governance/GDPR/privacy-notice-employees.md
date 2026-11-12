# Privacy notice for employees

| Field | Value |
|---|---|
| Document ID | GDPR-15 |
| Owner | Compliance & Risk Management |
| Approver | Managing Director |
| Version | 0.1 |
| Effective | On approval |
| Next review | When a purpose, recipient, retention period or the DPO changes, and every 12 months |
| Status | **Draft.** Not approved, not issued to anyone. Controller details are fictional. Not legal advice |

> Ayka Secure Technologies GmbH, its address and its staff are fictional. This is the text an employee would receive under Art. 13 and 14 GDPR. Bracketed items are not decided yet.

## 1. Who is responsible

| Item | Entry (fictional) |
|---|---|
| Controller (Art. 13(1)(a)) | Ayka Secure Technologies GmbH, Beispielstraße 1, 70000 Stuttgart (fictional address) |
| Contact for data protection | privacy@ayka.example (fictional address, not monitored) |
| Data protection officer (Art. 13(1)(b)) | [Not yet appointed. The [DPO decision](dpo-and-legal-basis.md) recommends an external officer. Their name and contact are inserted here before this notice is issued] |

## 2. What we process, why, and on what basis

| Purpose | Data | Legal basis (Art. 13(1)(c)) | Source |
|---|---|---|---|
| Creating your accounts and access to Microsoft Entra ID and AWS, groups and privilege tier (PA-01) | Name, display name, role, department, employment type, line manager, security role, privilege tier, start date | Art. 6(1)(b) GDPR with § 26(1) BDSG (employment). Where a law obliges us: Art. 6(1)(c) | You and HR |
| Personnel administration, onboarding, awareness training (PA-04) | Name, role, manager, start date, training completion | Art. 6(1)(b) with § 26(1) BDSG | You and HR |
| Source control and the compliance pipeline (PA-02) | Git author name and e-mail address, GitHub username, comments, workflow logs | Art. 6(1)(f): our interest in traceable changes ([assessment](legitimate-interests-assessment.md)) | You, GitHub |
| Security logging (PA-03), once it operates | IP address, user or role identifier, request metadata, timestamps | Art. 6(1)(f): our interest in network and information security ([assessment](legitimate-interests-assessment.md)). The impact assessment is [here](dpia-ayka-portal.md) | Our systems |

We do not rely on your consent for these purposes. We do not use security logs to assess your performance or working time. We do not take decisions about you based solely on automated processing, and we do not profile you (Art. 13(2)(f)).

## 3. Who receives it (Art. 13(1)(e))

Amazon Web Services and Microsoft (planned processors for identity and hosting), GitHub (repository hosting, in use). Staff in HR, IT and security roles on a need-to-know basis. Authorities where the law requires. [Payroll and tax advisers: not selected.]

## 4. Transfers outside the EU (Art. 13(1)(f))

Repository data is stored by GitHub in the United States. We rely on the EU–US Data Privacy Framework adequacy decision (Art. 45) where the provider is certified, and on standard contractual clauses (Art. 46(2)(c)) otherwise. Which of these applies is still being verified. Copies of the clauses can be requested at the privacy contact. Identity and hosting data are planned for the EU Region Frankfurt (`eu-central-1`). Support access from outside the EU can occur and is covered by the same safeguards. See the [transfer assessment](data-flow-and-transfer-assessment.md).

## 5. How long we keep it (Art. 13(2)(a))

Retention periods per record type are not approved yet. Working figures from the [retention policy](../policies/records-and-data-retention-policy.md): security logs 365 days; CI artifacts 90 days; personnel records per record type once set. Commit history is kept as long as the repository exists, because it cannot be changed without rewriting history. [Insert approved periods before issue.]

## 6. Your rights (Art. 13(2)(b) to (d))

You can ask for access (Art. 15), rectification (Art. 16), erasure (Art. 17), restriction (Art. 18) and portability (Art. 20). Send the request to the privacy contact or to Compliance & Risk Management. We answer within one month (Art. 12(3)); how, is in the [rights procedure](data-subject-rights-procedure.md). You can complain to the supervisory authority: the Landesbeauftragte für den Datenschutz und die Informationsfreiheit Baden-Württemberg, or the authority of your place of residence or work.

## 7. Right to object (Art. 21)

**You have the right to object, on grounds relating to your particular situation, at any time to processing based on Art. 6(1)(f), including the source-control and security-logging purposes above.** We then stop the processing unless we show compelling legitimate grounds that override your interests, rights and freedoms, or the processing serves the establishment, exercise or defence of legal claims (Art. 21(1)). Send the objection to the privacy contact. This paragraph is shown separately from the rest of the notice, as Art. 21(4) requires.

## 8. Is providing the data required (Art. 13(2)(e))

The data in section 2 for PA-01 and PA-04 is needed to employ you and to give you system access. Without it we cannot create your accounts.

## 9. What this notice does not cover

Job applicants and former staff, works-council arrangements (none recorded), and any monitoring beyond what is listed.

## Revision history

| Version | Date | Change |
|---|---|---|
| 0.1 | 2026-11-10 | First draft |
