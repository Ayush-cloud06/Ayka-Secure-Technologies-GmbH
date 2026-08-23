# Threat Scenarios Catalog

- **Organization:** Ayka Secure Technologies GmbH (simulated case study)
- **Owner:** CISO role
- **Version:** 1.0
- **Historical baseline:** 2026-04-16
- **Catalog completed:** 2026-08-23
**Purpose:** Reusable scenarios for consistent assessment; not a claim that every event has occurred

## Using the catalog

Select a scenario only when its conditions apply. Tailor the asset, weakness, consequence, and evidence in the risk register. A scenario ID supports consistency; it does not replace analysis.

| Scenario ID | Area | Cause-event-consequence scenario | Observable warning signs | Related risks |
|---|---|---|---|---|
| THR-001 | Identity credentials | Because reusable identity secrets existed in public history, unauthorized use of a still-valid or reused credential could result in privileged tenant or downstream access | Sign-ins from unexpected locations, password reuse, unresolved historical exposure, no rotation record | RISK-001 |
| THR-002 | Terraform state | Because backend ownership and state handling are fragmented, loss, disclosure, concurrent modification, or accidental deletion of state could expose secrets or make infrastructure changes unsafe | Local state files, missing locking, unknown backups, untested restore, roots without authoritative backends | RISK-002 |
| THR-003 | IAM authorization | Because permissions boundaries, trust policies, wildcard permissions, and ABAC attributes are not verified together, a principal could receive broader access than intended or be unable to perform an approved task | Unexpected policy-simulation result, overlapping tier membership, missing session tags, wildcard bypass | RISK-003 |
| THR-004 | Identity lifecycle | Because Entra, SCIM, Identity Center, and Terraform membership sources do not form one proven lifecycle, leavers or role changes could retain access and new joiners could be provisioned inconsistently | Stale memberships, duplicate identities, failed SCIM jobs, manual console changes, mismatched UPNs | RISK-004 |
| THR-005 | Change governance | Because repository and environment protections are external and not evidenced in source, an unauthorized or insufficiently reviewed change could reach a protected branch or future apply gate | Direct push to `main`, missing required reviewers, bypassed checks, unprotected environment | RISK-005 |
| THR-006 | Security logging | Because log-delivery definitions are plan-only, CloudTrail or ALB/S3 logs could fail to arrive while the configuration appears compliant | Empty destination, denied delivery events, missing object prefixes, no retrieval test, stale trail status | RISK-006 |
| THR-007 | Assurance custody | Because evidence is produced and checked within the same transient pipeline, artifacts could expire, be replaced, or lack independent attribution and review | Missing manifest, retention expiry, same actor produces and approves, no protected destination | RISK-007 |
| THR-008 | Misrepresentation | Because the workload uses mock credentials, refresh-free planning, and a no-change apply simulation, a reviewer could rely on it as if it demonstrated a live platform | “Deployed,” “enforced,” or “audit-ready” claims without dated runtime evidence | RISK-008 |
| THR-009 | Cloud hardening | Because scanner findings and service-specific exceptions are not yet triaged by threat, insecure storage, TLS, network, or logging behavior could enter a future deployment | Findings suppressed in bulk, unresolved high-impact storage issues, no exception owner or expiry | RISK-009 |
| THR-010 | Governance evidence | Because policies exist without performed-and-retained operating records, the organization could be unable to demonstrate that access, incident, training, supplier, risk, and management processes operate | Blank approval fields, undated reviews, records created after the fact, policy-only evidence | RISK-010 |
| THR-011 | Privacy and Region | Because actual processing locations and transfer safeguards are not established, inaccurate residency or GDPR statements could drive incorrect customer or management decisions | Conflicting Region names, no data-flow record, unsupported “EU only” claim, missing processor facts | RISK-011 |
| THR-012 | AWS bootstrap | Because organization, account, landing-zone, identity, and state dependencies lack one approved order, applying roots in an assumed sequence could create orphaned resources or unsafe trust | Unknown account IDs, circular prerequisites, root-account assumptions, no rollback point | RISK-012 |
| THR-013 | Emergency access | Because competing emergency identities and roles are untested, the path could fail during an incident or be abused without timely detection | Unknown credential custodian, no exercise, unverified MFA/alerts, multiple active break-glass routes | RISK-013 |

## Scenario prompts

When assessing a change, ask:

1. What real asset or decision becomes unsafe if the assumption is wrong?
2. Is the safeguard source-defined, locally tested, externally observed, or operating?
3. Could a control fail silently while documentation still looks correct?
4. Does the scenario depend on state, identity, Region, account, or reviewer settings outside the repository?
5. What evidence would make the risk owner comfortable lowering likelihood?
6. What constraint prevents exposure while treatment is incomplete?

## Exclusions

This catalog does not currently score:

- live customer-data breach scenarios, because no deployed customer application or real data flow is evidenced;
- supplier failure scenarios beyond AWS/GitHub/Entra dependencies, because supplier inventory and contracts are not populated; or
- financial loss amounts, because no approved thresholds or business-impact data are present.

Add those scenarios only when factual context, ownership, and evidence exist.
