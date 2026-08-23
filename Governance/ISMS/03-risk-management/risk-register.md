# Risk Register

- **Organization:** Ayka Secure Technologies GmbH (simulated case study)
- **Register owner:** CISO role
- **Version:** 1.0
- **Historical baseline:** 2026-04-16
- **Register populated:** 2026-08-23
- **Next scheduled review:** 2026-09-30
**Status:** Working case-study record; no management approval or operating ISMS is evidenced

## How to read this register

Scores use [risk-criteria.md](risk-criteria.md). “Current” reflects safeguards evidenced in the repository as of the assessment date. “Target” is not a forecasted achievement; it is the score to reassess after the linked treatment evidence exists.

The register is anchored to the [current audit](../../../AUDIT/CURRENT_STATE.md), [finding register](../../../AUDIT/FINDINGS.md), and [roadmap](../../../AUDIT/ROADMAP_AND_PIPELINE_NOTES.md). It does not convert source code or local test output into claims of deployed control effectiveness.

## Current risk position

| ID | Risk scenario | Owner role | Inherent | Current | Target | Response | Evidence confidence | Status |
|---|---|---|---:|---:|---:|---|---|---|
| RISK-001 | Historical Entra bootstrap credentials remain in public Git history; if applied or reused, an attacker could obtain privileged identity access even though current source is clean | Identity owner / CISO | 5 x 5 = **25 Critical** | 3 x 5 = **15 High** | 2 x 5 = **10 Medium** | Mitigate | E2 source/local scan; external use unresolved | Awaiting external action |
| RISK-002 | Fragmented or local Terraform state may expose secrets, lose authoritative ownership, or make recovery and drift decisions unreliable | Cloud Platform owner | 4 x 5 = **20 Critical** | 4 x 5 = **20 Critical** | 2 x 5 = **10 Medium** | Mitigate | E1 design; ignored state observed but not inspected | Open |
| RISK-003 | IAM boundaries, trust paths, and ABAC attributes may grant unintended access or block required access because effective permissions are not verified end to end | Identity owner | 4 x 5 = **20 Critical** | 3 x 5 = **15 High** | 2 x 5 = **10 Medium** | Mitigate | E2 source fixes and local validation | Treating |
| RISK-004 | Contradictory Entra, SCIM, Identity Center, tier, and membership assumptions may leave joiner/mover/leaver access incomplete or excessive | Identity owner / IT Support | 4 x 4 = **16 Critical** | 4 x 4 = **16 Critical** | 2 x 4 = **8 Medium** | Mitigate | E1 source and conflicting documentation | Open |
| RISK-005 | Unprotected `main` or unreviewed apply environments could allow unapproved changes to bypass intended separation of duties | Repository owner | 4 x 4 = **16 Critical** | 4 x 4 = **16 Critical** | 2 x 4 = **8 Medium** | Mitigate | E3 dated GitHub observation from 2026-08-10 | Awaiting external action |
| RISK-006 | CloudTrail and workload log delivery may fail silently because source corrections have not been validated against live AWS delivery and recovery | Cloud Platform owner | 4 x 4 = **16 Critical** | 3 x 4 = **12 High** | 2 x 4 = **8 Medium** | Mitigate | E2 source/plan; runtime not evidenced | Treating |
| RISK-007 | Same-pipeline, transient evidence could be altered, expire, or lack independent review, weakening audit traceability and control decisions | Assurance owner / CISO | 4 x 4 = **16 Critical** | 3 x 4 = **12 High** | 2 x 4 = **8 Medium** | Mitigate | E2 checksums and local verification only | Treating |
| RISK-008 | A reviewer could mistake the mock-provider, refresh-free workload and simulated apply for a deployed platform, leading to unsafe reliance or overstated compliance claims | Repository owner / CISO | 3 x 4 = **12 High** | 2 x 4 = **8 Medium** | 2 x 4 = **8 Medium** | Accept with constraints | E2 truthful labels and tests | Monitored; acceptance pending |
| RISK-009 | Untreated storage, logging, TLS, network, and service-boundary findings could be carried into a future deployment without threat-based triage | Cloud Platform owner | 4 x 4 = **16 Critical** | 4 x 4 = **16 Critical** | 2 x 4 = **8 Medium** | Mitigate | E2 scanner snapshot: 124 Checkov failures | Open |
| RISK-010 | Missing operating records for access review, incidents, training, suppliers, risk decisions, and management review could make governance claims unauditable | CISO / process owners | 5 x 3 = **15 High** | 4 x 3 = **12 High** | 2 x 3 = **6 Medium** | Mitigate | E1 policies; operating records absent | Open |
| RISK-011 | Inconsistent Region and privacy statements may lead to unsupported residency or transfer claims before actual data flows and safeguards are known | Privacy owner / CISO | 3 x 4 = **12 High** | 3 x 4 = **12 High** | 2 x 4 = **8 Medium** | Mitigate | E1 documentation; processing facts incomplete | Open |
| RISK-012 | The AWS organization, landing zone, member-account, delegated-admin, identity, and state roots may be applied in an unsafe order because no authoritative bootstrap sequence exists | Cloud Platform owner | 4 x 5 = **20 Critical** | 3 x 5 = **15 High** | 2 x 5 = **10 Medium** | Avoid live apply until treated | E1 source architecture; no applied sequence | Open |
| RISK-013 | Multiple untested emergency-access paths may be unavailable during an incident or provide broader access than intended without reliable alerting and review | CISO / Identity owner | 3 x 5 = **15 High** | 3 x 5 = **15 High** | 2 x 5 = **10 Medium** | Mitigate | E1 source and procedure; no exercise | Open |

## Priority view

1. **RISK-001** requires owner-led identity investigation; source cleanup alone cannot resolve it.
2. **RISK-002** and **RISK-012** block any responsible move toward live apply or scheduled drift.
3. **RISK-003**, **RISK-004**, and **RISK-013** should be handled as one identity trust-and-lifecycle workstream.
4. **RISK-005** remains external to source control and must not be marked fixed from workflow YAML.
5. **RISK-006**, **RISK-007**, and **RISK-009** form the evidence-and-runtime proof workstream.
6. **RISK-010** and **RISK-011** require real activities and processing facts, not additional blank templates.

## Review history

| Date | Review type | Outcome |
|---|---|---|
| 2026-08-23 | Initial evidence-bounded population | Thirteen risks recorded from the consolidated audit; no risk closed and no acceptance made effective |

## Status rules

- **Open:** response is agreed in principle but treatment has not started or is not evidenced.
- **Treating:** a source or process change exists, but completion evidence or residual review is outstanding.
- **Awaiting external action:** resolution depends on tenant, account, GitHub, history, or another state outside repository source.
- **Monitored:** exposure is deliberately constrained and reviewed.
- **Closed:** treatment evidence, residual scoring, review, and any necessary acceptance are complete.
