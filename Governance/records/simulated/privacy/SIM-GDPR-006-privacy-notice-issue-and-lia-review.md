# SIM-GDPR-006: Privacy notices issued and legitimate-interests assessment reviewed

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-GDPR-006 |
| Authored | 2026-11-10 (real date) |
| Scenario date | 2026-03-23 |
| Participants | EMP-004 (GDPR Lead, owner of all three documents), EMP-012 (HR & Administration, issues the employee notice), EMP-022 (Marketing Specialist, publishes the website notice), EMP-013 (DevOps Engineer, repository practice), EMP-002 (CISO, logging facts), EMP-001 (Managing Director, scenario decisions). The 24 staff receive the employee notice |
| Procedure exercised | [Privacy notice: employees GDPR-15](../../../GDPR/privacy-notice-employees.md) version 0.1; [privacy notice: website GDPR-16](../../../GDPR/privacy-notice-website.md) version 0.1; [legitimate interests assessment GDPR-13](../../../GDPR/legitimate-interests-assessment.md) version 1.0 |
| Controls | GDPR Art. 6(1)(f), 13, 14, 21(4); BDSG section 26 (to verify); ISO/IEC 27001:2022 A.5.34; related PA-01 to PA-03 |

## Scenario

Three weeks after the ISMS approvals and two weeks after the DPO decision ([SIM-GDPR-001](SIM-GDPR-001-dpo-decision-minutes.md), 2026-03-09: an external DPO is to be designated, no contract yet), EMP-004 takes the three texts to issue. All are used as they stand on the Authored date and treated as in force on 2026-03-23. The company is fictional and so are the address and contact in the texts.

## 1. Employee notice (GDPR-15)

| Step | What the document says | What happened in the scenario |
|---|---|---|
| 1 Fill the brackets | DPO name and contact; approved retention periods; payroll and tax advisers | None can be filled. No DPO exists; no retention period is approved; no adviser is chosen. Scenario decision by EMP-001: issue with the brackets replaced by "not yet appointed" and "working figures, to be confirmed", and re-issue when they are known |
| 2 Contact | privacy@ayka.example, "fictional address, not monitored" | EMP-004 replaces it with a role address she monitors (scenario value). Nothing creates that address in the repository; the DPO decision is still open |
| 3 Issue | n/a | EMP-012 e-mails the notice to 24 staff on 2026-03-23. 22 acknowledge receipt by 2026-03-26. EMP-017 on 2026-03-27 and EMP-022 on 2026-03-31. An acknowledgement is receipt, not consent |
| 4 Timing | Art. 13: at the time the data is obtained | Staff data was obtained from screening in December 2025 and starts between 2026-01-01 and 2026-02-13 ([SIM-PPL-001](../people/SIM-PPL-001-joiner-batch.md)). The notice reaches everyone 6 to 12 weeks late. The document has no rule for the order: notice first, account second |
| 5 Content check against practice | Section 3 says AWS and Microsoft are "planned processors". Section 4 says identity data is "planned for Frankfurt". Section 5 says retention figures are "not approved" | Entra accounts existed from January and Identity Center tiers from March (SIM-PPL-001). They are not planned. The Identity Center instance sits in `ap-south-1` ([GDPR index](../../../GDPR/README.md#region)), so what staff are told about the Region is wrong. Section 4 also does not name the safeguard: it says "which of these applies is still being verified", which does not give Art. 13(1)(f) what it asks for |
| 6 Right to object | Section 7 stands alone, as Art. 21(4) requires | Kept. EMP-004 notes the objection route ends at the unmonitored address until step 2 is done |

## 2. Website notice (GDPR-16), published as a scenario

There is no website in the repository. For this record EMP-022 puts a one-page site with a contact form online on 2026-03-23, with the notice at its footer. EMP-004 approves the text by scenario decision.

| Step | What the document says | What happened |
|---|---|---|
| 1 Hosting | "Hosting and mail providers are not selected" | A site needs a host. The notice says no host exists while one serves it. EMP-022 picks a hosting plan the same week. The notice cannot be accurate until it is updated for that provider |
| 2 Cookies | None used in this draft | Kept. EMP-022 confirms no analytics and no embedded third-party content |
| 3 Retention | "[30 days. Not approved]" and "[until the enquiry is closed plus 6 months. Not approved]" | Published with the bracketed figures. The notice therefore says the periods are not approved |
| 4 Activity in the RoPA | The notice describes server logs and enquiries | The RoPA had no activity for either. They were found missing by the annual review on 2026-09-28 ([SIM-GDPR-002](SIM-GDPR-002-ropa-annual-review.md)): the notice was published six months before the processing it describes was recorded |
| 5 Imprint | Not in the notice | A German commercial website normally needs a legal notice (to verify). No such document exists in the repository |

## 3. Legitimate interests assessment (GDPR-13)

EMP-004 reviews the assessment before the notices rely on it.

| Check | Result |
|---|---|
| PA-03 purpose and necessity | Unchanged. The security logging does not run, so the assessment is of a design |
| PA-03 balancing, staff | The safeguard "logs are not used for performance review" has no home outside this document. Nothing in the acceptable use policy or the employee notice binds managers. The employee notice does say it, in section 2 |
| Staff or works council | The assessment says consult if one exists. EMP-012 confirms none is recorded. Scenario decision: no consultation |
| PA-02 who is affected | The assessment names "the owner and any outside contributor". Six engineers commit to the public repository. EMP-013 asks what address their commits use: three the work address, two a personal address, one a GitHub noreply address (scenario values). The assessment says Ayka "should" give noreply guidance. No guidance exists, so real addresses are already in permanent public history |
| PA-02 basis for staff | For staff the notice says Art. 6(1)(f). Commits made as part of the job may fit Art. 6(1)(b) with section 26 BDSG better (to verify) |
| Conclusion | Scenario decision by EMP-001: accept the assessment as the working basis for 12 months (review 2027-03-23). It is not reviewed by counsel and no DPO has advised |

## Findings

Defects in GDPR-15, GDPR-16 and GDPR-13 as written:

1. **The employee notice cannot be issued as written.** Three required items (DPO, retention, advisers) are brackets, and the document says "before issue". There is no rule for issuing with unknown items.
2. **No timing rule.** Art. 13 requires the notice when data is obtained. The documents do not say that the notice precedes the account and the screening.
3. **Statements about processors and Region are wrong for the staff.** The notice says planned; identity is in use, and in a Region outside the EU.
4. **The transfer paragraph does not name a safeguard.** It describes a decision still being made. The reader of the notice cannot learn what protects the data.
5. **The contact is not monitored.** Both notices name an address "not monitored". The design needs a monitored address before issue, and an owner who watches it.
6. **No delivery record.** The document gives no way to show who received the notice and when.
7. **The website notice describes processing before it is recorded.** Server logs and enquiries had no RoPA entry. A notice should be written from the RoPA.
8. **The website notice says hosting is not chosen** while it is being served. Its status line ("No website exists") is a repository fact that stops being true on publication.
9. **The LIA is written for a single owner.** Its PA-02 section speaks of "the owner and any outside contributor". With 24 staff the affected group is different, and the safeguard on addresses depends on guidance that does not exist.
10. **LIA safeguard is not enforced anywhere.** The commitment not to use logs for performance review is a sentence in two documents and in no rule.
11. **No review owner and no start for the 12-month clock** in any of the three documents. All say "on approval".

## What this does not show

- That a notice was sent, received, acknowledged or published. The 24 staff, the website, the hosting plan and the role address are scenario values.
- That any text complies with Art. 13 or 14. Legal bases, the effect of BDSG section 26 and the imprint rules are marked "to verify" and no counsel has reviewed them.
- That any DPO exists. None does.
- That the website exists: the repository has none.
