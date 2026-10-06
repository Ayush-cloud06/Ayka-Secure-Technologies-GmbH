# NIS2 Applicability Assessment (Betroffenheitsprüfung)

| Field | Value |
|---|---|
| Document ID | NIS2-01 |
| Organization | Ayka Secure Technologies GmbH, Stuttgart (simulated case study) |
| Owner | CISO |
| Prepared by | Compliance Officer (Regulatory Reporting) |
| Decision by | Managing Director |
| Version | 1.0 |
| Assessment date | 2026-10-06 |
| Next scheduled review | 2027-04-06, or earlier on any trigger in section 7 |
| Status | Draft. Not approved: no decision record exists (section 9). |
| Classification | Internal |

## 1. Result

**Ayka is not a NIS2 entity today.** It is neither a *besonders wichtige Einrichtung* (essential entity) nor a *wichtige Einrichtung* (important entity) under §28 BSIG.

- **Sector test: probably met.** The SaaS platform most likely counts as a *cloud computing service* (NIS2 Annex I, sector 8, "Digital infrastructure"). We treat it that way rather than argue the point.
- **Size test: not met.** With 24 employees Ayka is a small enterprise. Cloud computing service providers are only in scope from 50 employees, or from more than EUR 10 m annual turnover **and** more than EUR 10 m balance sheet total.
- **No size-independent category applies.** Ayka is not a telecoms provider, trust service provider, DNS service provider or TLD registry, and is not a KRITIS operator.

Consequences:

| Duty | Applies to Ayka today? |
|---|---|
| Registration with the BSI (§33, §34 BSIG) | No |
| Risk-management measures as a legal duty (§30 BSIG, NIS2 Art. 21) | No. Adopted voluntarily in part, see [NIS2-02](02-risk-management-measures.md) |
| Reporting significant incidents to the BSI (§32 BSIG, NIS2 Art. 23) | No. Voluntary reporting is possible; see [NIS2-03](03-incident-reporting-procedure.md) |
| Management approval, oversight and training (§38 BSIG, NIS2 Art. 20) | No. The general duty of care of a GmbH managing director still applies; see [NIS2-04](04-management-accountability.md) |
| Supply-chain requirements from customers who are in scope | **Yes, indirectly, by contract.** See [NIS2-05](05-supply-chain-security.md) |

The indirect route is the one that matters commercially. Ayka sells to automotive Tier-2 and Tier-3 suppliers and manufacturing SMEs ([business model](../../organization/business-model.md)). Many of those customers have 50+ employees, fall under Annex II ("Manufacturing", motor vehicles) and must manage the security of their suppliers under §30(2) no. 4 BSIG. They will push NIS2-style requirements down to Ayka through contracts and questionnaires whether or not Ayka is in scope itself.

## 2. What this assessment rests on

### 2.1 Legal basis

| Source | Use in this assessment |
|---|---|
| Directive (EU) 2022/2555 (NIS2), Art. 2, 3, 6 and Annexes I and II | Sectors, entity types, definitions |
| NIS2 recital 33 | Cloud service models, including SaaS |
| BSI-Gesetz as amended by the NIS2UmsuCG (in force since 2025-12-06, no transition period) | §28 classification, §30 measures, §32 reporting, §33/§34 registration, §38 management duties |
| Commission Implementing Regulation (EU) 2024/2690 | Technical requirements and significant-incident thresholds for cloud computing service providers, MSPs and MSSPs. Applies directly once Ayka is in scope |
| Commission Recommendation 2003/361/EC | How employees, turnover and balance sheet are counted (§28 BSIG refers to it) |

The German text of §28 BSIG was read from a secondary publication of the statute, not from the official gazette. Check it against the BGBl. version before relying on any single sentence of this document in a dispute.

### 2.2 Facts about Ayka

| Fact | Value | Source | Confidence |
|---|---|---|---|
| Legal form and seat | GmbH, Stuttgart | [business model](../../organization/business-model.md) | Confirmed |
| Employees | 24, all full-time, no part-time or apprentices | [personnel register](../../organization/personnel-register.md), last updated 2026-02-19 | Confirmed for that date. HR to reconfirm at each quarterly check |
| Annual work units (AWU) | 24.0 | Derived: full-time staff count as 1 AWU each | Confirmed if the register is current |
| Annual turnover | **Not recorded** | No financial statements exist in the case study | Open item O-1 |
| Balance sheet total | **Not recorded** | As above | Open item O-1 |
| Linked or partner enterprises | None recorded. The Managing Director is the founder; no investor or group company appears anywhere | [org structure](../../organization/org-structure.md) | Open item O-2 |
| Services offered | Compliance SaaS (three tiers), onboarding packages, audit preparation support, security architecture advisory | [business model](../../organization/business-model.md) | Confirmed |
| Service status | Not deployed; plan-only infrastructure; no customers | [README, scope](../../README.md#2-scope-a-plan-analysis-gate) | Confirmed |

The assessment is made for the business **as described** (a SaaS company with customers in the EU), not only for the plan-only repository. A company that has not launched yet still has to know which regime it launches into.

## 3. Step 1: sector and entity type

| Candidate category | NIS2 reference | Does Ayka fit? | Reasoning |
|---|---|---|---|
| Cloud computing service provider | Annex I, 8; Art. 6(30); recital 33 | **Probably yes** | Art. 6(30) covers "on-demand administration and broad remote access to a scalable and elastic pool of shareable computing resources". Recital 33 names SaaS as a service model. A multi-tenant compliance platform on ECS Fargate and RDS ([ayka-portal](../../Internal-IT/workloads/ayka-portal/)) fits that description. Some commentators read "computing resources" narrowly and would exclude ordinary SaaS applications. We do not rely on that reading: it is untested, and relying on it would leave us unprepared if it fails. |
| Data centre service provider | Annex I, 8 | No | Ayka runs no data centre; it consumes AWS. |
| Managed service provider (MSP) | Annex I, 9; Art. 6(39) | No | Ayka does not install, manage, operate or maintain customers' ICT systems. The SaaS reads what customers upload; it does not administer their environments. |
| Managed security service provider (MSSP) | Annex I, 9; Art. 6(40) | **Not today; watch** | "Security architecture advisory" is consulting, which is not a managed service. It becomes MSSP work the moment Ayka operates security tooling *for* a customer, for example running scans in a customer's AWS account through a cross-account role, or monitoring their alerts. Product must flag any such feature to the CISO before launch (trigger T-4). |
| Digital providers (marketplace, search engine, social network) | Annex II, 6 | No | Not Ayka's business. |
| Manufacturing, other Annex II sectors | Annex II | No | Ayka's customers are here, Ayka is not. |
| Size-independent entities (public electronic communications, trust services, TLD registries, DNS) | Art. 2(2)(a); §28(1) and (2) BSIG | No | None of these services are offered. |
| KRITIS operator | §28(1) no. 1 BSIG, BSI-KritisV | No | No critical infrastructure is operated; Ayka is far below every KRITIS threshold. |

§28 BSIG lets an entity disregard business activities that are negligible compared with its whole business. That rule does not help Ayka: the SaaS **is** the main business, so the cloud classification cannot be set aside as negligible.

**Step 1 result:** treat Ayka as a cloud computing service provider for all planning. Record the classification question as open item O-3 for a legal opinion before Ayka would ever rely on being out of scope for sector reasons.

## 4. Step 2: size

NIS2 Art. 2(1) and §28 BSIG exclude small and micro enterprises from the size-capped sectors. Recommendation 2003/361/EC defines the classes. Note the "and" in the financial test: an enterprise with fewer than 50 staff only leaves the small class if **both** turnover and balance sheet exceed EUR 10 m.

| Class | Staff (AWU) | Turnover | Balance sheet | NIS2 consequence for a cloud provider |
|---|---|---|---|---|
| Small (or micro) | < 50 | and turnover ≤ EUR 10 m **or** balance sheet ≤ EUR 10 m | | Out of scope |
| Medium | 50 to 249, **or** turnover and balance sheet both > EUR 10 m | ≤ EUR 50 m or ≤ EUR 43 m | | *Wichtige Einrichtung* (important entity) |
| Large | ≥ 250, **or** turnover > EUR 50 m and balance sheet > EUR 43 m | | | *Besonders wichtige Einrichtung* (essential entity) |

| Ayka figure | Value | Threshold | Margin |
|---|---|---|---|
| Staff | 24 AWU | 50 | 26 people |
| Turnover | not recorded | > EUR 10 m together with balance sheet | Founded January 2026 with no customers; a figure near EUR 10 m is not plausible, but it must be confirmed (O-1) |
| Balance sheet | not recorded | > EUR 10 m together with turnover | As above |

Counting rules to apply at every check:

- Count AWU, not heads: part-time staff and seasonal workers count pro rata; apprentices and students in vocational training do not count; staff on parental leave do not count.
- Under the Recommendation, the class is only lost after the threshold is exceeded in **two consecutive** financial years. §28 BSIG does not obviously carry that grace over, and the BSI's guidance has to be checked when the question becomes real. Plan on the stricter reading: Ayka is in scope as soon as it reaches 50 AWU.
- Linked enterprises (more than 50 % control) and partner enterprises (25 to 50 %) are aggregated. A future investment round can change Ayka's class overnight without one new hire (trigger T-3).

**Step 2 result:** small enterprise. Out of scope.

## 5. Step 3: designation and special cases

Member States may bring smaller entities into scope individually, for example a sole provider of a critical service in the country (NIS2 Art. 2(2)(b) to (e)). Ayka provides nothing for which it is the only supplier in Germany and has received no notice from the BSI. **Not designated.**

## 6. Step 4: indirect applicability through customers

| Customer group | Likely NIS2 position | What they will ask Ayka for |
|---|---|---|
| Automotive Tier-2/3 suppliers with 50+ staff | Important entity, Annex II "Manufacturing" (motor vehicles, NACE C29), or parts suppliers under other manufacturing codes | Security questionnaire, contractual incident notification fast enough for their own 24-hour early warning, right to audit or evidence on request, subcontractor transparency. Often bundled with a TISAX label requirement (CR-02 in the legal register) |
| Manufacturing SMEs below 50 staff | Out of scope themselves | Usually nothing NIS2-specific, unless they in turn supply an in-scope entity |
| EU SaaS start-ups | Mostly out of scope | Little; GDPR Art. 28 terms dominate |
| Any customer that is itself a cloud provider or MSP with 50+ staff | Important entity, bound by Implementing Regulation 2024/2690, Annex 5 (supply-chain security) | The most detailed requirements: supplier security assessment, contractual security clauses, termination and exit provisions |

How Ayka answers these requests is in [NIS2-05](05-supply-chain-security.md).

## 7. When this assessment must be repeated

The review is scheduled every six months. Each of these triggers forces an earlier one:

| ID | Trigger | Watched by | How it is noticed |
|---|---|---|---|
| T-1 | Headcount reaches **40 AWU** | HR & Administration | Quarterly count from the personnel register. 40 rather than 50, because the BSIG has no transition period: the measures, the reporting process and the registration must be ready **on the day** Ayka reaches 50 |
| T-2 | Annual accounts show turnover **and** balance sheet above EUR 8 m | Financial Controller | Annual financial statements |
| T-3 | Any investment, acquisition or shareholding of 25 % or more, in either direction | Managing Director | Shareholder resolution |
| T-4 | A new service in which Ayka operates, monitors or administers ICT or security tooling for customers (possible MSP or MSSP) | Product Manager | Product requirements review; CISO sign-off before launch |
| T-5 | A service offered to customers in another EU Member State through an establishment there | Managing Director | Corporate change |
| T-6 | Change in NIS2, the BSIG, the implementing regulation or BSI guidance on SaaS classification | Compliance Officer | Monthly check of BSI publications |
| T-7 | Any letter from the BSI | Managing Director | Post |

## 8. If Ayka comes into scope

This section keeps the reassessment short. As a cloud computing service provider with 50 to 249 AWU, Ayka would be a **wichtige Einrichtung**. From the day the threshold is crossed:

1. **Measures.** §30 BSIG applies, with the detailed technical content taken from Implementing Regulation 2024/2690 and its annex. Starting point: [NIS2-02](02-risk-management-measures.md).
2. **Registration.** Within three months via the joint BSI/BBK registration portal (§33 BSIG), plus the additional data that §34 requires from cloud providers. The portal sign-in uses the company's *Mein Unternehmenskonto* (ELSTER organisation certificate). Getting that certificate takes days to weeks by post, so request it at trigger T-1, not at 50 AWU. Data needed: legal name and form, address, contact details including an incident contact reachable around the clock, IP ranges in public use, sector and entity type, EU Member States served, and the EU establishments.
3. **Reporting.** Significant incidents to the BSI within 24 hours, 72 hours and one month (§32 BSIG). Process already written: [NIS2-03](03-incident-reporting-procedure.md).
4. **Management.** The Managing Director must approve the measures, oversee them and train regularly (§38 BSIG). See [NIS2-04](04-management-accountability.md).
5. **Supervision and fines.** The BSI supervises important entities after the fact (on indication of a breach). Fines for important entities go up to EUR 7 m or 1.4 % of worldwide annual turnover, whichever is higher.

## 9. Open items

| ID | Item | Owner | Needed before |
|---|---|---|---|
| O-1 | Confirm turnover and balance sheet from the first annual accounts | Financial Controller | Next scheduled review |
| O-2 | Confirm that no linked or partner enterprise exists (shareholder list) | Managing Director | Next scheduled review |
| O-3 | Legal opinion: does a compliance SaaS on AWS count as a "cloud computing service" under Art. 6(30)? | Compliance Officer with external counsel | Trigger T-1 |
| O-4 | Check whether the BSI applies the two-consecutive-years rule of Recommendation 2003/361 under §28 BSIG | Compliance Officer | Trigger T-1 |

## 10. Decision record

This is a record, so it stays empty until a real decision is taken. No one has approved this assessment.

| Date | Decision | Decided by | Signature or reference |
|---|---|---|---|
| | Ayka is not a NIS2 entity; adopt the voluntary measures in NIS2-02 and the customer commitments in NIS2-05 | Managing Director | |

## 11. Sources

- Directive (EU) 2022/2555 (NIS2): <https://eur-lex.europa.eu/eli/dir/2022/2555/oj>
- Commission Implementing Regulation (EU) 2024/2690: <https://eur-lex.europa.eu/eli/reg_impl/2024/2690/oj>
- Commission Recommendation 2003/361/EC: <https://eur-lex.europa.eu/eli/reco/2003/361/oj>
- §28 BSIG (secondary text): <https://lxgesetze.de/bsig/28>
- NIS2 and SaaS as cloud computing service: <https://nisd2.eu/en/wiki/scope/am-i-cloud-provider-nis2>

## Revision history

| Version | Date | Author | Change |
|---|---|---|---|
| 1.0 | 2026-10-06 | Compliance Officer (Regulatory Reporting) | First assessment after the NIS2UmsuCG entered into force |
