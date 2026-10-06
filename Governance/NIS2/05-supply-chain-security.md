# Supply-Chain Security under NIS2

| Field | Value |
|---|---|
| Document ID | NIS2-05 |
| Organization | Ayka Secure Technologies GmbH (simulated case study) |
| Owner | CISO |
| Contributors | Finance & Procurement Officer (Supplier Risk Coordinator), Sales Manager, Customer Success Manager |
| Version | 1.0 |
| Status | Draft. Not approved: no approval record exists. |
| Classification | Internal; Part A section 3 may be shared with customers under NDA |

Supply-chain security runs in two directions at Ayka:

- **Part A, Ayka as a supplier.** In-scope customers must manage the security of their direct suppliers (NIS2 Art. 21(2)(d) and 21(3); §30(2) no. 4 BSIG). This is where NIS2 reaches Ayka today.
- **Part B, Ayka's own suppliers.** AWS, Microsoft and GitHub. Ayka would owe this assessment by law only if it came into scope, but customers will ask how Ayka manages its own supply chain as part of Part A.

## Part A: Ayka as a supplier to NIS2 entities

### A.1 What customers will ask

NIS2 Art. 21(3) tells in-scope entities to consider their suppliers' vulnerabilities, the quality of their products and their cybersecurity practices, including secure development. In practice that arrives at Ayka as:

| Request | Typical form | How often to expect it |
|---|---|---|
| Security questionnaire | Customer's own spreadsheet, VDA ISA (automotive), or a shortened NIS2 checklist | Every new contract with an in-scope customer; annual refresh |
| Incident notification clause | "Supplier notifies customer of any security incident affecting customer data or services within X hours" | Most contracts; X is usually 24, sometimes 12 or 48 |
| Right to audit | On-site or remote audit, or evidence on request | Most contracts; usually limited to once a year |
| Subcontractor transparency | List of subcontractors with access to customer data; notice before changes | Overlaps with GDPR Art. 28 sub-processor terms |
| Certification | ISO 27001 certificate, TISAX label, SOC 2 report or BSI C5 attestation | Larger customers; automotive OEM supply chains favour TISAX |
| Vulnerability handling | Commitment to patch critical vulnerabilities within a set time; notice of vulnerabilities affecting the customer | Increasingly common |
| Exit and data return | Return and deletion of data at contract end, in a usable format | Most contracts |

### A.2 Ayka's standard positions

These are the terms Sales may offer without asking the CISO. Anything stricter needs the CISO's written approval before signature, because a promise Ayka cannot keep is worse than a slower one it can.

| Topic | Ayka's standard position | Can Ayka keep it today? |
|---|---|---|
| Incident notification | Notice without undue delay and no later than **24 hours** after Ayka becomes aware of an incident affecting the customer's data or services, following [NIS2-03](03-incident-reporting-procedure.md) | **Not yet.** Ayka has no detection capability ([NIS2-02](02-risk-management-measures.md) No. 2). The clock starts at awareness, and today awareness depends on luck. Do not sign 12-hour clauses |
| Cooperation in the customer's own reporting | Ayka provides the facts the customer needs for its BSI early warning, notification and final report, in the structure of NIS2-03 templates T-2 and T-3 | Yes, as a process |
| Audit | Evidence on request once a year: policies, the [compliance gate](../../README.md) evidence bundle for any change, supplier list, and this document. Remote audit on 30 days' notice, at the customer's cost if more than once a year | Partly. The gate evidence is real and checksummed; operating records (access reviews, incidents, training) do not exist yet |
| Certification | No certification today. ISO 27001 is the target; TISAX on demand from the first automotive contract that requires it | Honest answer: none |
| Subcontractors | List in the [processor register](../GDPR/processor-register.md); 30 days' notice of new sub-processors with a right to object | Yes, as a process |
| Data location | Customer data processed in the EU (target `eu-central-1`, Frankfurt) | **No.** The Terraform still targets `ap-south-1` (RISK-011 in the [risk register](../ISMS/03-risk-management/risk-register.md)). Must be fixed before any contract promises EU processing |
| Vulnerabilities | Critical vulnerabilities in Ayka's service fixed or mitigated within 7 days of a fix being available, high within 30 days; customer informed if exploitation affected them | Not yet measured. Infrastructure findings are gated in CI; application dependency scanning does not exist |
| Exit | Export of customer data in a documented format, then deletion within 30 days, confirmed in writing | Designed only |

### A.3 Evidence pack for customers

What Ayka can send to a customer's supplier-risk team today, and what it must not claim:

| Can send | Must not claim |
|---|---|
| This NIS2 document set and the [ISMS index](../ISMS/README.md) showing what is draft and what is planned | That Ayka is certified, audited or "NIS2 compliant" |
| A recent `compliance-evidence` bundle from the pipeline, with the manifest and checksums | That the platform is running in production with these controls |
| The [S3 encryption control chain](../ISMS/04-controls-and-soa/control-chain-s3-encryption.md) as an example of risk-to-evidence tracing | Penetration test results (none exist) |
| The processor register with the providers' own certifications, once retrieved | EU-only data processing (not true yet) |

Saying "not yet, and here is the plan" costs a deal less often than a customer's auditor later finding that a "yes" was false.

## Part B: Ayka's own suppliers

### B.1 Critical suppliers

Supplier criticality follows one question: if this supplier failed or was compromised, could Ayka still deliver its service, and could an attacker reach customer data through it?

| ID | Supplier | Service | Criticality | Why | Attestations to request (to verify) |
|---|---|---|---|---|---|
| SUP-01 | Amazon Web Services | Hosting: ECS, RDS, S3, KMS, IAM Identity Center | **Critical** | All customer data and the whole service run here. Single Region, single provider | ISO 27001 certificate; SOC 2 Type 2 report; BSI C5 Type 2 attestation (all through AWS Artifact) |
| SUP-02 | Microsoft | Entra ID (identity source for all staff and AWS access) | **Critical** | A compromised tenant gives an attacker AWS access through the Identity Center integration | ISO 27001; SOC 2 Type 2; BSI C5 (Service Trust Portal) |
| SUP-03 | GitHub (Microsoft) | Source code, CI pipeline, compliance gate | **Critical** | The change path to production. A compromised repository or Actions runner can change infrastructure | SOC 2 Type 2; ISO 27001 |
| — | Terraform providers, Checkov, tfsec, conftest/OPA, GitHub Actions | Tooling in the pipeline | High | Code that runs inside the change path | Not attestations: pinned versions and checksums, reviewed on update |

The supplier IDs match the [processor register](../GDPR/processor-register.md), which holds the contract and transfer details.

### B.2 What is already controlled

- **Software supply chain in CI**: every third-party GitHub Action is pinned to a commit SHA, and scanner versions and checksums are pinned in [`toolchain.versions`](../../Internal-IT/engineering/ci-cd/toolchain.versions), with a test that keeps CI and local runs in sync. This is the measure most SaaS companies of Ayka's size do not have.
- **Gate ownership**: [CODEOWNERS](../../.github/CODEOWNERS) puts the control mapping, the exceptions and the evaluator under the owner's review.
- **Terraform provider lock files** are committed for every root except `entra-id`.

### B.3 What is missing

| Gap | Consequence | Action | Owner |
|---|---|---|---|
| No attestation retrieved for any supplier | Ayka cannot answer a customer's "how do you assess your suppliers?" with evidence | Download and date the reports listed in B.1; record their period and any exceptions noted by the auditor | Supplier Risk Coordinator |
| No review of the complementary user entity controls (CUECs) in the SOC 2 reports | The providers' reports assume Ayka does certain things (MFA, logging, key management); nobody has checked that Ayka does | Map each CUEC to an Ayka control or a gap in NIS2-02 | CISO |
| Concentration risk on AWS in one Region | A Regional outage or account compromise stops the whole service | Decide and document acceptance or a recovery Region in the BCP | Managing Director, on CISO's proposal |
| No supplier notification subscriptions | Ayka would learn of a supplier incident from the news | Subscribe to AWS Health, Microsoft service health for Entra ID, GitHub status and security advisories | Security Operations |
| No exit plan per critical supplier | NIS2 IR 2024/2690 Annex section 5 expects one from in-scope cloud providers | Short exit note per critical supplier: data export path, time to migrate | Cloud Platform Engineer |

### B.4 Supplier assessment record (template)

One row per supplier per year. No assessment has been carried out.

| Supplier ID | Date | Assessor | Attestations reviewed (type, period, auditor) | Exceptions in the report | CUECs mapped (yes/partly/no) | Incidents in the period | Result (accept / accept with actions / reject) | Next review |
|---|---|---|---|---|---|---|---|---|
| | | | | | | | | |

No entries yet.

## Revision history

| Version | Date | Author | Change |
|---|---|---|---|
| 1.0 | 2026-10-06 | CISO | First version |
