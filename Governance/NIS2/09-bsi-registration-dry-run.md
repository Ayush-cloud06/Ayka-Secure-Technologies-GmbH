# BSI Registration Dry Run (§33, §34 BSIG)

| Field | Value |
|---|---|
| Document ID | NIS2-09 |
| Organization | Ayka Secure Technologies GmbH, Stuttgart (simulated case study) |
| Owner | Compliance Officer (Regulatory Reporting) |
| Version | 1.0 |
| Date | 2026-11-10 |
| Status | Draft. **Not submitted. Not required.** |
| Classification | Internal |

> **Not submitted; not required.** Ayka is not a NIS2 entity ([NIS2-01](01-applicability-assessment.md), [NIS2-08](08-applicability-reassessment-2026-11.md)). This page shows the data a registration would need, filled with the fictional company's data, so that the work is a copy-and-paste on the day Ayka qualifies. Every value below is fictional or a placeholder. Nothing was entered in any portal, and no BSI account exists.

## 1. Rules read on 2026-11-10

| Rule | Content | Source |
|---|---|---|
| §33(1) BSIG | Registration through a facility run jointly by the BSI and the BBK, no later than three months after the entity first qualifies as an essential or important entity | <https://lxgesetze.de/bsig/33> |
| §33(1) nos. 1 to 5 | Name incl. legal form and commercial register number; address and current contact data incl. e-mail, public IP ranges, telephone numbers; relevant sector from Annex 1 or 2; list of EU Member States where Annex 1 or 2 services are provided; competent federal and Land supervisory authorities for the registered activities | same |
| §33(5) | Changes without delay, at the latest within two weeks of becoming aware | same |
| §34(1) | Additional registration for the entity types in §60(1) Satz 1 BSIG. That list includes "Anbieter von Cloud-Computing-Diensten". Items: name; sector, branch and entity type per Annex 1; address of the main EU establishment and other EU sites; current contact data; Member States where services are provided; public IP ranges. Same three-month deadline | <https://www.gesetze-im-internet.de/bsig_2025/__34.html>, `__60.html` |
| §34(2) | Changes without delay, at the latest within three months of the change | same |
| NIS2 Art. 27(2)(a) to (d) | The Union-level register carries name, sector and entity type, address of main establishment and other Union establishments, and contact details | EUR-Lex, read as an extract |

Not verified in this session: the portal's actual form fields, whether §33 and §34 are submitted in one step, and the sign-in method (NIS2-01 mentions an ELSTER organisation certificate; §33 as read does not).

## 2. Data set, filled in

| # | Item | Required by | Value (fictional) | Status |
|---|---|---|---|---|
| 1 | Legal name and form | §33(1) no. 1; §34(1) no. 1 | Ayka Secure Technologies GmbH | From [business model](../../organization/business-model.md) |
| 2 | Commercial register number | §33(1) no. 1 | **None exists** (fictional company). Placeholder `HRB [number]`, Amtsgericht Stuttgart | Placeholder |
| 3 | Address | §33(1) no. 2; §34(1) no. 3 | Stuttgart. Street and postcode not recorded in the case study | Incomplete |
| 4 | Main EU establishment, other EU sites | §34(1) no. 3 | Main establishment: Stuttgart. No other sites recorded | From personnel register location |
| 5 | General contact: e-mail, telephone | §33(1) no. 2; §34(1) no. 4 | `[to be created]`. A role mailbox (not a personal one) and a switchboard number would be used. None exists | Placeholder |
| 6 | Contact for BSI reports | NIS2-01 section 8 (not found in §33 as read) | Compliance Officer role (EMP-021) as holder, Incident Coordinator (EMP-005) as deputy, per [NIS2-03](03-incident-reporting-procedure.md) section 2. 24-hour reachability: no rota exists | Role only |
| 7 | Public IP ranges | §33(1) no. 2; §34(1) no. 6 | **None.** Nothing is deployed. In production the ALB and NAT addresses in `eu-central-1` would be listed; the Terraform assigns them at apply time | Not available |
| 8 | Sector (Annex 1 or 2) | §33(1) no. 3; §34(1) no. 2 | Digital infrastructure: cloud computing service provider (classification treated as probable, open item O-3 in NIS2-01) | Open legal question |
| 9 | Entity type for §34 | §34(1) no. 2 | Anbieter von Cloud-Computing-Diensten (§60(1) Satz 1) | As row 8 |
| 10 | Member States where services are provided | §33(1) no. 4; §34(1) no. 5 | Germany. Further EU states: **unknown**, no customer exists | Placeholder |
| 11 | Competent supervisory authorities | §33(1) no. 5 | BSI for the NIS2 duties; the data protection authority is LfDI Baden-Wuerttemberg (GDPR, not part of the NIS2 registration list). Sector regulators for the activities: not determined | Open |
| 12 | Headcount and size class (not a field in the list read, but the BSI will test it) | §28(2) no. 3 | 24 staff; small enterprise. Turnover and balance sheet not recorded | See NIS2-08 |
| 13 | Account for the portal | NIS2-01 section 8 | Not requested. Lead time said to be days to weeks (NIS2-01); not verified | Not started |

## 3. What would block a real registration today

1. Row 2, 3, 5, 7, 10 have no real value.
2. Row 6 depends on a 24-hour contact that [NIS2-03](03-incident-reporting-procedure.md) calls a precondition that does not exist.
3. Row 8: the legal opinion on classification (NIS2-01 O-3) should exist before Ayka registers or relies on being out of scope.

## 4. When to run this for real

Trigger T-1 in NIS2-01 section 7 (40 AWU) starts the preparation: request the portal access, collect rows 2 to 7, fill row 10 from the customer list. Registration itself is due three months after Ayka first qualifies (§33(1), §34(1)).

## Revision history

| Version | Date | Author | Change |
|---|---|---|---|
| 1.0 | 2026-11-10 | Compliance Officer role (AI-drafted) | First dry run |
