# NIS2 Applicability Reassessment, November 2026

| Field | Value |
|---|---|
| Document ID | NIS2-08 |
| Organization | Ayka Secure Technologies GmbH, Stuttgart (simulated case study) |
| Owner | CISO |
| Prepared by | Compliance Officer (Regulatory Reporting) role; text drafted by an AI assistant |
| Decision by | Managing Director (no decision record exists) |
| Version | 1.1 |
| Assessment date | 2026-11-10 |
| Previous assessment | [NIS2-01](01-applicability-assessment.md), 2026-10-06 |
| Next scheduled review | 2027-05-10, or earlier on any trigger in NIS2-01 section 7 |
| Status | Draft. Not approved. |
| Classification | Internal |

> **What kind of document this is.** A real analysis of fictional facts. The legal text was really read on 2026-11-10 (sources in section 6). The company, its 24 employees and its figures are fictional and come from the case-study files. Nothing here is a legal opinion.

## 1. Result

**Conclusion unchanged: Ayka is not a NIS2 entity.** Staff 24 is below the 50 that §28(2) no. 3 BSIG sets for an important entity, and no turnover or balance-sheet figure exists that could reach the alternative test. No trigger in NIS2-01 section 7 has fired. Customers who are in scope still push duties down by contract; that is handled in [NIS2-05](05-supply-chain-security.md), [the customer addendum](06-customer-security-addendum.md) and [the questionnaire response](07-supplier-questionnaire-response.md).

## 2. Facts re-checked

| Fact | NIS2-01 (2026-10-06) | Now (2026-11-10) | Source | Change |
|---|---|---|---|---|
| Employees | 24, all full-time | 24 rows EMP-001 to EMP-024, all "Full-time" | [personnel register](../../organization/personnel-register.md) | None |
| Age of that register | "last updated 2026-02-19" | Still shows "Last Updated: 19-02-2026". **No quarterly headcount check record exists in the repository**, although NIS2-01 section 7 (T-1) assigns one to HR & Administration | same | Gap: the figure is nine months old and nobody confirmed it. Counted as "no evidence of change", not as "confirmed" |
| AWU | 24.0 | 24.0 if all 24 are full-time for the whole year. Employees joined between 2026-01-01 and 2026-02-13, so the **annual average for 2026 is below 24** (e.g. EMP-024 started 13-02-2026) | register start dates | Margin to 50 is larger than the table in NIS2-01 shows |
| Turnover, balance sheet | Not recorded (O-1) | Not recorded. First financial year ends 2026-12-31 if the year is the calendar year (assumption, not in the files); no annual accounts can exist before then | - | Open |
| Linked or partner enterprises | None recorded (O-2) | None recorded. No shareholder list exists in the repository | [org structure](../../organization/org-structure.md) | Open |
| Services | Compliance SaaS, onboarding, audit preparation, advisory | Unchanged. No feature that operates or monitors a customer's ICT or security tooling is described | [business model](../../organization/business-model.md) | None |
| Deployment | Not deployed, no customers | Not deployed. Infrastructure code only; plan-only | [README](../../README.md) | None |

## 3. Thresholds against the legal text

| Rule | Text read on 2026-11-10 | Ayka |
|---|---|---|
| §28(2) no. 3 BSIG, important entity | "einer der in den Anlagen 1 und 2 bestimmten Einrichtungsarten zuzuordnen sind und a) mindestens 50 Mitarbeiter beschäftigen oder b) einen Jahresumsatz und eine Jahresbilanzsumme von jeweils über 10 Millionen Euro aufweisen" | 24 staff: limb a) not met. Limb b) needs **both** figures above EUR 10 m: not recorded, not plausible for a company founded in 2026 with no customers, but unconfirmed |
| §28(1) no. 4 BSIG, essential entity | "mindestens 250 Mitarbeiter" or turnover over EUR 50 m **and** balance sheet over EUR 43 m | Not met on any reading |
| §28(3) BSIG | Business activities that are "vernachlässigbar" compared with the whole business may be disregarded | Does not help: the SaaS is the main business |
| §28(4) BSIG | The Commission Recommendation 2003/361/EG applies, "mit Ausnahme von Artikel 3 Absatz 4 des Anhangs"; data of partner or linked enterprises are not added where the enterprise is independent of them | As NIS2-01 section 4. Only relevant if a partner or linked enterprise appears (T-3) |
| NIS2 Art. 2(1) | Applies to entities of a type in Annex I or II "which qualify as medium-sized" or exceed the ceilings for medium-sized enterprises (opening of the paragraph read; the rest and Annex I were not read in this session) | Consistent with §28. Sector classification is taken from NIS2-01 and **not re-verified** |

Two points read from the statute that NIS2-01 does not make:

1. §28(2) no. 3 says "50 Mitarbeiter", and §28(4) imports the Recommendation's counting rules. NIS2-01 section 4 already applies those rules (AWU, two-consecutive-years rule). The two-year rule comes from Annex Art. 4(2) of the Recommendation, which was **not re-read** in this session; keep it as NIS2-01 states it and verify before relying on it.
2. The word the statute uses is *Mitarbeiter*, the Recommendation's unit is annual work units. The difference cannot change the result at 24 against 50.

## 4. Triggers (NIS2-01 section 7)

| ID | Trigger | State on 2026-11-10 | Evidence |
|---|---|---|---|
| T-1 | 40 AWU | Not reached (24) | Personnel register; no recent count |
| T-2 | Turnover **and** balance sheet above EUR 8 m | Cannot be tested: no accounts. Not plausible | None |
| T-3 | Investment or shareholding of 25 % or more | None recorded | No shareholder resolution in the repository |
| T-4 | Service operating customers' ICT or security tooling | None described | Business model |
| T-5 | Establishment in another Member State | None recorded | - |
| T-6 | Change in NIS2, BSIG, IR 2024/2690 or BSI guidance | Statute text read on 2026-11-10 (section 6). No change found against NIS2-01's description; the BSIG version date was not shown on the page, so a later amendment cannot be excluded | gesetze-im-internet.de |
| T-7 | Letter from the BSI | None recorded | - |

## 5. Corrections to NIS2-01 found while reading the statute

NIS2-01 version 1.0 (2026-10-06) carried these statements. They were applied in NIS2-01 version 1.1 on 2026-11-10, where the legal text recorded here supports them, and marked "to verify" where it does not. The table is kept as the record of what was found.

| NIS2-01 | Statement | Finding |
|---|---|---|
| 2.1 | §28 BSIG was read from a secondary publication | It has now also been read on the federal publisher's site (gesetze-im-internet.de, `bsig_2025`). The text of §28(1) no. 4, (2) no. 3, (3) and (4) matches NIS2-01. That is still not the BGBl. gazette |
| 8, item 2 | Data to register "plus the additional data that §34 requires from cloud providers" | §33(1) lists five items (section 1 of [NIS2-09](09-bsi-registration-dry-run.md)). §34 applies to the entity types in §60(1) Satz 1 BSIG, and that list **does** include "Anbieter von Cloud-Computing-Diensten", so the point stands. But §34 asks for different items (main EU establishment, public IP ranges, Member States), and §33 as read does **not** name an "incident contact reachable around the clock" or "EU establishments". Those two items in NIS2-01 are not in the text read |
| 8, item 2 | Registration "within three months" | Confirmed: §33(1) and §34(1) both say no later than three months after the entity qualifies. Changes: §33(5) two weeks from knowledge; §34(2) three months from the change |
| 8, item 2 | Sign-in with a *Mein Unternehmenskonto* (ELSTER) certificate | §33(1) says only that submission goes through a registration facility run jointly by the BSI and the BBK. The ELSTER detail was **not verified** |

## 6. Sources read on 2026-11-10

| Source | URL | Read |
|---|---|---|
| §28 BSIG | <https://www.gesetze-im-internet.de/bsig_2025/__28.html> | Paragraphs (1) no. 4, (2) no. 3, (3), (4). Annexes not on the page |
| §33 BSIG | <https://lxgesetze.de/bsig/33> (secondary) | Deadline, data list, portal, change duty |
| §34 BSIG | <https://www.gesetze-im-internet.de/bsig_2025/__34.html> | Entity reference, data list, deadlines |
| §60(1) BSIG | <https://www.gesetze-im-internet.de/bsig_2025/__60.html> | List of entity types |
| NIS2 | <https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32022L2555> | Art. 2(1) opening, 2(2) opening, 3(1), 21(2)(a) to (j), 23(4)(a), (b), (d), 27(2)(a) to (d). Quoted through a fetch tool that returns extracts; re-read the Official Journal text before citing in a dispute |

## 7. Open items carried forward

| ID | State | Change since 2026-10-06 |
|---|---|---|
| O-1 turnover and balance sheet | Open | None. First accounts are due after year end |
| O-2 linked or partner enterprises | Open | None |
| O-3 legal opinion on "cloud computing service" | Open | None. Still treated as in the sector for planning |
| O-4 date of qualification under the two-year rule | Open | None |
| O-5 (new) | HR to produce and file a headcount count; the register is nine months old | HR & Administration, before the next review |

## 8. Decision record

| Date | Decision | Decided by | Reference |
|---|---|---|---|
| | Conclusion of this reassessment accepted | Managing Director | No decision recorded |

## Revision history

| Version | Date | Author | Change |
|---|---|---|---|
| 1.0 | 2026-11-10 | Compliance Officer role (AI-drafted) | First six-monthly reassessment under NIS2-01 section 7 |
| 1.1 | 2026-11-10 | Compliance Officer role (AI-drafted) | Section 5 lead-in states that the corrections are applied in NIS2-01 1.1; cross-reference to NIS2-09 corrected (section 1, not 6) |
