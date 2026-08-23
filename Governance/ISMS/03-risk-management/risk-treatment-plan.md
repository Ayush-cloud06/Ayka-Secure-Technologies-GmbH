# Risk Treatment Plan

- **Organization:** Ayka Secure Technologies GmbH (simulated case study)
- **Plan owner:** CISO role
- **Version:** 1.0
- **Historical baseline:** 2026-04-16
- **Plan completed:** 2026-08-23
**Status:** Proposed treatments; completion and approval are not implied

## Treatment approach

The plan uses **due gates** where an arbitrary calendar promise would be misleading. A gate states what must be true before a risky capability or claim is allowed to proceed. Calendar dates may be added when named owners formally schedule the work.

A treatment is complete only when the required evidence exists, the risk is rescored, and the reviewer records the decision.

## Treatment register

| Treatment | Risk | Action and intended outcome | Treatment owner | Due gate | Evidence required | Target | Status |
|---|---|---|---|---|---|---:|---|
| TRT-001 | RISK-001 | Determine which historical Entra credentials were applied or reused; disable or rotate affected identities, review sign-ins, investigate downstream reuse, then coordinate any history rewrite | Identity owner with CISO oversight | Before identity reuse, public-history rewrite, or declaring the exposure resolved | Identity inventory without secrets, rotation/disable records, dated sign-in review, reuse decision, coordinated rewrite plan | 10 Medium | Awaiting external action |
| TRT-002 | RISK-002 | Inventory state locations without printing secrets; assign ownership, create a protected backup, select backend/locking/access rules, migrate one root, and test restore | Cloud Platform owner | Before any live apply or scheduled drift | State inventory, owner, backend design, backup record, restore result, access review, migration log | 10 Medium | Open |
| TRT-003 | RISK-003 | Simulate effective permissions for named Tier1, Tier2, Platform Operations, and Workload Operator paths; verify Region/account/role ARNs and test ABAC allow/deny cases | Identity owner | Before deploying identity roots or describing ABAC as enforced | Policy-simulation outputs, expected/actual matrix, corrected source, peer review, verified inputs | 10 Medium | Source work started; runtime review open |
| TRT-004 | RISK-004 | Select one authoritative Entra-to-AWS lifecycle; reconcile identities, groups, permission sets, tiers, memberships, and SCIM/SAML assumptions; exercise joiner, mover, and leaver cases | Identity owner / IT Support | Before onboarding a real identity or claiming automated provisioning | Approved flow, named test identity, provisioning logs, membership diff, removal proof, exception handling | 8 Medium | Open |
| TRT-005 | RISK-005 | Configure required pull-request checks, branch protection, and environment reviewers; capture a reviewed pipeline run and current settings | Repository owner | Before real apply or claiming independent approval is enforced | Dated API export or screenshots, reviewer list, protected-branch rules, successful reviewed run | 8 Medium | Awaiting external action |
| TRT-006 | RISK-006 | After state and non-production deployment are authorized, test CloudTrail and ALB/S3 delivery, retrieve sample objects, and verify service-required encryption exceptions | Cloud Platform owner | Before treating logging controls as operating or enabling downstream SIEM work | Trail/status output, object metadata, delivery timestamps, retrieval test, exception rationale, reviewer result | 8 Medium | Source correction complete; runtime test blocked |
| TRT-007 | RISK-007 | Choose a protected evidence destination; define ownership, access, retention, deletion, and independent review; retain and retrieve one real pipeline evidence set | Assurance owner | Before using “audit-ready,” “immutable,” or operating-effectiveness language | Manifest, source run, protected storage record, access review, independent review, retrieval and deletion test | 8 Medium | Open |
| TRT-008 | RISK-008 | Keep the workload explicitly offline and simulated; prohibit real credentials and apply; display the evidence boundary wherever results are summarized | Repository owner / CISO | Continuous condition while the case study remains plan-only | Source labels, no-change apply behavior, checksum verification, current audit boundary, review at each release | 8 Medium | Monitored; acceptance pending |
| TRT-009 | RISK-009 | Group the 124 Checkov failures by threat and service boundary; fix, time-limit, or technically reject each relevant group without blanket suppression | Cloud Platform owner | Before selecting the workload for deployment readiness | Triage register, threat mapping, fixes or exception rationale, owner, expiry, rescans, delivery/recovery tests where relevant | 8 Medium | Open |
| TRT-010 | RISK-010 | Build the first operating records only from performed work: risk review, access review, incident exercise, training event, supplier review, and management review | CISO and process owners | Before claiming an operating or audit-ready ISMS | Dated source, named owner/reviewer, decision, follow-up, retention rule, and link for each activity | 6 Medium | Started with evidence-bounded risk records; approvals absent |
| TRT-011 | RISK-011 | Map actual data categories, processors, AWS/Entra/GitHub locations, transfers, and safeguards; reconcile Region language and make a DPIA/transfer decision from the facts | Privacy owner / CISO | Before making residency, transfer, or GDPR readiness claims | Data-flow map, processor/Region inventory, legal basis, transfer mechanism, DPIA decision, reviewed wording | 8 Medium | Open |
| TRT-012 | RISK-012 | Choose create-versus-adopt for AWS Organizations; document account owners, root order, inputs/outputs, state boundaries, rollback points, and deliberately manual steps | Cloud Platform owner | Before applying any organization, landing-zone, or cross-account identity root | Reviewed sequence diagram, account/Region inventory, state ownership, rollback test or tabletop, excluded roots | 10 Medium | Open; live apply avoided |
| TRT-013 | RISK-013 | Select one emergency-access model; define custody, authentication, activation, alerting, expiry, review, and a controlled exercise; disable or document competing paths | CISO / Identity owner | Before relying on emergency access for production or resilience claims | Custody record, reachable-path test, alert evidence, access log, post-use review, competing-path disposition | 10 Medium | Open |

## Treatment dependencies

The work is intentionally ordered:

1. **Contain identity exposure** - TRT-001 is independent and urgent.
2. **Create safe infrastructure custody** - TRT-002 and TRT-012 precede live apply or drift.
3. **Prove identity behavior** - TRT-003, TRT-004, and TRT-013 share account, Region, and trust prerequisites.
4. **Establish external governance** - TRT-005 must exist before a real apply approval can be claimed.
5. **Generate runtime proof** - TRT-006 and TRT-009 require an authorized non-production deployment.
6. **Retain and review evidence** - TRT-007 follows a real pipeline activity.
7. **Create honest operating records** - TRT-010 and TRT-011 use actual decisions and data flows rather than retroactive paperwork.

## Interim constraints

Until the treatments are complete:

- do not run a live apply from the demonstrated pipeline;
- keep scheduled drift disabled;
- do not describe SCIM, ABAC, logging, emergency access, branch approval, or evidence retention as operating;
- do not delete or migrate unknown Terraform state casually;
- do not reproduce historical credential values in records;
- do not suppress scanner findings merely to obtain a clean result; and
- present Ayka as a simulated case study, not a certified or deployed company platform.

## Review and closure

At each review, the CISO role should record:

- evidence received since the last review;
- changed likelihood or impact and the reason;
- overdue gate or failed interim constraint;
- decision to continue, revise, avoid, or propose acceptance; and
- reviewer and next review date.

See [risk-acceptance-log.md](risk-acceptance-log.md) for acceptance decisions and [risk-register.md](risk-register.md) for current scores.
