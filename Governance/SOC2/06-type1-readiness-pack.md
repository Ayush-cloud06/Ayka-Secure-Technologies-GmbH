# SOC 2 Type I Readiness Pack

| Field | Value |
|---|---|
| Document ID | SOC2-06 |
| Owner | Compliance and Risk |
| Approver | CISO |
| Version | 1.0 |
| As-of date | 2026-11-10 |
| Next review | Before the auditor is engaged, and at each re-assessment of [SOC2-04](04-readiness-assessment.md) |
| Status | Draft. Not approved. Walk-through for a fictional entity |

> Ayka Secure Technologies GmbH is a simulated company and `ayka-portal` has never been deployed. This pack shows what a service auditor would do for a Type I examination as of 2026-11-10 and what they would find. **No auditor has examined anything.** Nothing here is an assertion that Ayka has issued or can issue.

## 1. Purpose and basis

A Type I report gives an opinion on whether management's description of the system is fair and whether the controls were suitably designed and **implemented** as of one date. For each of the 65 controls in the [control matrix](03-control-matrix.md) this pack states:

- the **population** the auditor would ask for;
- the **sample**: for a Type I, one item per control (the auditor decides; this is the planning assumption of [SOC2-05](05-audit-approach-and-evidence.md#5-typical-sample-sizes));
- the **test procedure**, using the four methods: inquiry, inspection, observation and re-performance;
- **where the evidence is**; and
- the **expected result today**.

The matrix status used is that of version 1.3 (2026-11-10). Fourteen controls are Simulated operation there; they still **fail** here, because a tabletop is not an instance (section 2). Evidence cited as "run artifacts" comes from the GitHub Actions runs listed in the [observation period log](07-observation-period-log.md).

## 2. How the expected result is decided

The rule is written once and applied to all 65 rows.

| Result | Rule |
|---|---|
| **pass** | The control is Implemented in the matrix, its evidence can be inspected or re-performed today, and nothing found contradicts it. Caveats are printed in the row |
| **fail** | A manual control, or a control whose subject can be inspected now, has no operating instance by the as-of date. A tabletop walk-through is **not** an instance, and a missing instance is not "cannot test". Every policy is unapproved (gap G9), so no manual control is "in force". A control whose existing Terraform contradicts it also fails (for example a mutable image tag) |
| **cannot test** | The subject of the control is the deployed environment, which does not exist, or the control is carved out to a subservice organization. A Type I auditor cannot inspect a control over a system that is not running |

The result describes the auditor's test, not the quality of the design. A `fail` row can have an excellent design.

## 3. Summary

| Expected result | Controls |
|---|---:|
| pass | 13 |
| fail | 32 |
| cannot test | 20 |
| **Total** | **65** |

All 13 passes are controls that run in CI or are configured in GitHub: CA-01, CA-02, IC-01, RA-04, MO-01, AC-09, AC-14, OP-01, CM-01 to CM-04 and CO-05. They cover the change-management and policy-enforcement part of the system, not the service. An auditor asked to opine on the description of the Ayka Portal system would also find the description untrue as of the date, because the system it describes is not running (see section 5).

## 4. Tests by control

### Control environment (CE)

| ID | Population | Sample | Test procedure | Where the evidence is | Expected result today |
|---|---|---|---|---|---|
| CE-01 | Policies in the [policy register](../policies/README.md) | Information security policy | Inspection of the approval record and the publication date; inquiry of the Managing Director | Policy in Git; merge record | **fail**: no approval record exists for any policy (G9) |
| CE-02 | Personnel on the HR roster | 3 joiners and 3 existing staff | Inspection of acknowledgements for the code of conduct and the acceptable use policy | HR system (not in this repository) | **fail**: no acknowledgement collected |
| CE-03 | Roles in the org chart | CISO role | Inspection of org chart and role description; inquiry about the last review | `organization/org-structure.md`, `organization/roles-and-responsibilities.md` | **fail**: no dated review |
| CE-04 | Joiners since the start of the period | Each joiner in the period | Inspection of the screening checklist dated before first access | HR system | **fail**: nobody has been screened |
| CE-05 | Personnel at the date of the examination | 3 staff, including one Tier 0 | Inspection of completion records for onboarding and annual training | Training system export | **fail**: no completion record |
| CE-06 | Quarters since the control began | Latest quarter | Inspection of report and approved minutes | Management report file | **fail**: no meeting has taken place |
| CE-07 | Job descriptions and annual reviews | 3 job descriptions, 2 review forms | Inspection for the security clause and the review section | HR system | **fail**: not written into any job description |

### Information and communication (IC)

| ID | Population | Sample | Test procedure | Where the evidence is | Expected result today |
|---|---|---|---|---|---|
| IC-01 | Pipeline runs on `main` and pull requests | 1 run, plus the run of the latest merge | Re-performance: download the `compliance-evidence` artifact, run `sha256sum -c artifacts.sha256`, compare `manifest.json` with the commit | GitHub Actions run artifacts; see [SOC2-07](07-observation-period-log.md) | **pass**: artifacts of runs from 2026-10-05 to 2026-10-14 are still available (expire 2027-01-03 and 2027-01-12) |
| IC-02 | Customers and material changes | 1 contract and 1 change notice | Inspection of the customer pack and the notice log | Customer pack; notice log | **fail**: no customer pack, no customer |
| IC-03 | Messages received at the security address | 3 messages and the latest quarterly test | Inspection of mailbox configuration; re-performance: send a test message | Mailbox configuration; ticket system | **fail**: no mailbox is configured |

### Risk assessment (RA)

| ID | Population | Sample | Test procedure | Where the evidence is | Expected result today |
|---|---|---|---|---|---|
| RA-01 | Risk register reviews in the period | Latest review | Inspection of the dated review and management approval | [Risk register](../ISMS/03-risk-management/risk-register.md) | **fail**: no management approval and the scheduled review of 2026-09-30 is recorded as overdue |
| RA-02 | Annual assessments | Current assessment | Inspection of the approved assessment and the check records | [Assessment](../policies/fraud-and-insider-risk-assessment.md) | **fail**: draft, not approved, no check has run |
| RA-03 | Significant changes in the period | 1 change | Inspection of the trigger list and the review before go-live | Risk review records | **fail**: no trigger list; no production release |
| RA-04 | Entries in `exceptions.yaml` (13) | 2 entries | Inspection for reason, owner and expiry; re-performance: run the evaluator tests with an expired entry | `exceptions.yaml`; `tests/compliance/test_evaluate_results.py`; the report section Excepted Findings | **pass**: all 13 entries have an expiry (2027-03-31); a test shows an expired entry counts again |

### Monitoring activities (MO)

| ID | Population | Sample | Test procedure | Where the evidence is | Expected result today |
|---|---|---|---|---|---|
| MO-01 | Pipeline runs | 1 run | Inspection of the `regression` job log; re-performance: `check-regression.sh` locally | Run logs; `Internal-IT/engineering/ci-cd/scripts/check-regression.sh` | **pass**: the job succeeded in all 20 push runs since 2026-10-01 |
| MO-02 | Annual self-assessments | Current year | Inspection of workpapers | Workpapers (SOC2-05, section 7.6) | **fail**: no self-assessment performed |
| MO-03 | Deficiencies identified in the period | 2 deficiencies | Inspection of the log for owner, due date and closure | Deficiency log (MO-03), [risk treatment plan](../ISMS/03-risk-management/risk-treatment-plan.md) | **fail**: no separate deficiency log |

### Control activities (CA)

| ID | Population | Sample | Test procedure | Where the evidence is | Expected result today |
|---|---|---|---|---|---|
| CA-01 | Mapped rules (38) | 1 rule | Inspection of the mapping; re-performance: `pytest tests/compliance/test_control_mapping.py` and the local chain | `control-mapping.yaml`; `tests/compliance/` | **pass**: mapping tests pass |
| CA-02 | Failure modes of the evaluator | Missing, empty and malformed scanner output | Re-performance of the evaluator tests | `evaluate-results.py`; `tests/compliance/test_evaluate_results.py` | **pass**: tests pass |

### Logical and physical access (AC)

| ID | Population | Sample | Test procedure | Where the evidence is | Expected result today |
|---|---|---|---|---|---|
| AC-01 | Workforce identities in Entra ID | 3 identities | Inspection of the tenant against the personnel source | Entra ID tenant | **cannot test**: Terraform not applied; no deployed system |
| AC-02 | AWS access paths | 1 permission set and the IAM user list | Inspection of Identity Center and IAM; re-performance of `IAM_USER_PROHIBITED` on a plan | Identity Center; gate report | **cannot test**: federation is design only; the gate part alone would pass |
| AC-03 | Administrative sign-ins | 3 administrators | Inspection of the Conditional Access export and the Identity Center MFA setting | Entra ID; Identity Center | **fail**: Conditional Access is disabled on the Free licence, so MFA is not enforced (G4) |
| AC-04 | Roles and permission sets | 3 roles | Inspection of boundaries and ABAC tags; re-performance of `IAM_WILDCARD_POLICY` | IAM; gate report | **cannot test**: boundaries and ABAC are design only |
| AC-05 | Permission sets | Platform administrator set | Inspection of session duration | Identity Center | **cannot test**: not applied |
| AC-06 | Joiners and leavers in the period | 2 joiners, 2 leavers | Inspection of tickets and identity change commits; compare dates | Ticket system; Git | **fail**: no tickets, no events |
| AC-07 | Quarterly access reviews | Latest quarter | Inspection of the review record, counts and removals | Access review record | **fail**: no review performed; the collaborator list was never reviewed |
| AC-08 | Uses of break-glass and the SCP | 1 use (or a test) and the SCP | Inspection of the SCP and the role trust policy; inquiry about the 24-hour review | AWS Organizations; CloudTrail | **cannot test**: not deployed; the alert does not exist |
| AC-09 | Repository settings and collaborators | The ruleset and the CODEOWNERS file | Inspection of the ruleset export; observation that a direct push is refused | GitHub ruleset 24482491; `.github/CODEOWNERS` | **pass**: ruleset active since 2026-10-05 with the five required checks |
| AC-10 | Network resources | 1 VPC, the NACLs and the security groups | Inspection of the deployed network; re-performance of the four gate rules | AWS; gate report | **cannot test**: network is gated design only |
| AC-11 | Public entry points | The ALB | Inspection of the WAF association and rule groups | AWS WAF | **cannot test**: not deployed |
| AC-12 | Listeners and the RDS parameter group | 1 listener, the database | Inspection of the TLS policy and the parameter | AWS | **cannot test**: not deployed |
| AC-13 | Encrypted stores | 1 RDS instance, 1 bucket, 1 log group | Inspection of the KMS key and rotation | AWS | **cannot test**: not deployed |
| AC-14 | Workflows and actions | All actions in `.github/` | Inspection for commit-SHA pins and the absence of `id-token`; re-performance of the checksum step | `.github/actions/`; `toolchain.versions` | **pass**: actions pinned by SHA; no OIDC |
| AC-15 | Container images in task definitions | The portal task definition | Inspection of the image reference | `modules/compute` task definition | **fail**: the reference is the mutable tag `nginx:stable` and there is no registry or scan |
| AC-16 | Laptops in the device inventory | 3 devices | Inspection of the compliance report | Device management report | **fail**: no device is managed and no product is selected |
| AC-17 | Data centres | Not tested by Ayka | Inspection of the provider's report (VM-02) | AWS SOC 2 report | **cannot test**: carved out; relies on the CSOC for AWS and the report is not on file |
| AC-18 | Devices that left custody | All in the period | Inspection of wipe certificates | Certificate file | **fail**: no certificate |

### System operations (OP)

| ID | Population | Sample | Test procedure | Where the evidence is | Expected result today |
|---|---|---|---|---|---|
| OP-01 | Runs of the gate | 1 run | Inspection of the compliance summary; re-performance with `run-local-chain.sh` | Run artifacts; local `output/` (not committed) | **pass**: holds for `ayka-portal`; the platform roots are outside the scan (G12) |
| OP-02 | Weekly scan reports | 5 weeks | Inspection of reports and ticket ageing | Scanner output; tickets | **fail**: only infrastructure code is scanned today |
| OP-03 | Accounts and Regions | 1 account | Inspection of the trail and log file validation | CloudTrail | **cannot test**: not deployed |
| OP-04 | Log groups and buckets | 3 log sources | Inspection of retention settings | AWS | **cannot test**: gated design; not deployed |
| OP-05 | Alert rules | Each rule and its test | Inspection of the rule; observation of a test alert | EventBridge; GuardDuty | **cannot test**: not deployed; the Terraform has no publisher to the topic |
| OP-06 | Incidents in the period | 1 incident | Inspection of the ticket timeline against the plan | Incident tickets | **fail**: no incident handled; the plan is not approved |
| OP-07 | Severity 2+ incidents and annual exercises | 1 | Inspection of the post-incident review | Review record | **fail**: no exercise held |
| OP-08 | Daily drift runs | 20 days | Inspection of workflow runs | Drift workflow runs | **cannot test**: manual and refuses without a remote backend; nothing deployed to drift |

### Change management (CM)

| ID | Population | Sample | Test procedure | Where the evidence is | Expected result today |
|---|---|---|---|---|---|
| CM-01 | Changes merged to `main` in the period | 3 pull requests | Inspection of the ruleset; inspection of the pull request list; reconcile commits to pull requests | Ruleset; [REAL-SOC2-001](../records/real/soc2/REAL-SOC2-001-change-review-2026-10.md) | **pass**: all 37 non-merge commits of October are inside a merged pull request. PRs #7 and #8 merged before the ruleset existed and #7 is not in git |
| CM-02 | Merged pull requests | 3 pull requests | Inspection of the five check results at the head commit | `.github/workflows/test.yml`; GitHub checks | **pass**: 5 of 5 successful for all 17 October pull requests |
| CM-03 | Gate decisions | 1 pass, 1 fail, 1 approval-required case | Inspection of the enforcement levels; re-performance of the evaluator tests; inspection of the environment history | [Enforcement levels](../../Internal-IT/engineering/ci-cd/compliance-gates/enforcement-levels.md); tests | **pass**: no MEDIUM approval occurred in October, so the approval path is shown by tests only |
| CM-04 | Apply job runs | 1 completed apply job | Re-performance of `run-apply.sh`; inspection of the job result | `run-apply.sh`; `tests/compliance/test_evidence.py` | **pass**: design and re-performance pass; the job has not completed in CI since 2026-10-05 (G14), which would be an exception in Type II |
| CM-05 | Merged pull requests | 3 pull requests | Compare approver and author | Pull request reviews | **fail**: 0 approvals in 17 pull requests; the compensating review has reviewer equal to author |
| CM-06 | Emergency changes | All in the period | Inspection of the emergency log and retrospective reviews | Emergency change log | **fail**: no log; no event |

### Risk mitigation and vendors (RM, VM)

| ID | Population | Sample | Test procedure | Where the evidence is | Expected result today |
|---|---|---|---|---|---|
| RM-01 | BC/DR tests | Latest test | Inspection of the test record | Test record | **fail**: no test |
| RM-02 | Insurance policies | The policy schedule | Inspection of cover against contractual liability | Policy schedule | **fail**: no policy |
| VM-01 | Suppliers touching customer data or the system | All | Inspection of the register for tier, data, location and contract | [Processor register](../GDPR/processor-register.md) | **fail**: no risk tiering |
| VM-02 | Critical vendors (3) | AWS | Inspection of the review record and the report | Vendor review record | **fail**: no report retrieved |

### Availability (AV)

| ID | Population | Sample | Test procedure | Where the evidence is | Expected result today |
|---|---|---|---|---|---|
| AV-01 | Capacity controls | The autoscaling target, quotas, budgets | Inspection of settings | AWS | **cannot test**: not deployed |
| AV-02 | Database and load balancer | Both | Inspection of Multi-AZ and the subnets | AWS | **cannot test**: not deployed |
| AV-03 | Backups and bucket versions | The RDS backup and 1 bucket | Inspection of retention and deletion protection | AWS | **cannot test**: not deployed |
| AV-04 | Restore tests | Latest quarter | Inspection of the test record with measured RPO and RTO | Restore test record | **cannot test**: no database to restore |
| AV-05 | Monthly availability reports | Latest 3 months | Inspection of probe configuration and reports | Monitoring service | **cannot test**: nothing to monitor |

### Confidentiality (CO)

| ID | Population | Sample | Test procedure | Where the evidence is | Expected result today |
|---|---|---|---|---|---|
| CO-01 | Data stores | 3 resources | Inspection of the `DataClassification` tag | Terraform; AWS | **fail**: no Terraform sets the tag |
| CO-02 | Buckets | All buckets | Inspection of public access block; re-performance of `S3_PUBLIC_ACCESS` | AWS; gate report | **cannot test**: buckets not deployed; the rule alone would pass |
| CO-03 | Personnel with access | 3 people | Compare NDA date with first access date | NDA index (private) | **fail**: no agreement executed |
| CO-04 | Contract ends | 1 | Inspection of the deletion ticket and written confirmation | Ticket system | **fail**: no customer has left |
| CO-05 | Test and development data | All fixtures | Inspection of the fixtures and access logs | `Internal-IT/workloads/` | **pass**: all scenarios are synthetic Terraform |

## 5. Draft management assertion

> **DRAFT. NOT ISSUED. SIMULATED ENTITY.** This text shows the form of the assertion that management signs for a Type I. It has not been signed and must not be, for the reasons below.

*Management's assertion (draft form)*

We have prepared the description of Ayka Secure Technologies GmbH's Ayka Portal system as of 2026-11-10 (the description), based on the criteria for a description of a service organization's system in DC section 200, 2018 Description Criteria. The description is intended to provide users with information about the system that may be useful when assessing the risks arising from interactions with the system, particularly information about system controls that Ayka has designed and implemented to provide reasonable assurance that its service commitments and system requirements were achieved, based on the trust services criteria for security, availability and confidentiality in TSP section 100, 2017 Trust Services Criteria.

The description indicates that complementary subservice organization controls and complementary user entity controls are suitably designed and operating effectively, and that Ayka's controls are suitable only if those controls are operating effectively. The description does not disclose the actions taken by the subservice organizations.

We confirm, to the best of our knowledge and belief, that:

1. the description fairly presents the Ayka Portal system that was designed and implemented as of 2026-11-10;
2. the controls stated in the description were suitably designed as of 2026-11-10 to provide reasonable assurance that the service commitments and system requirements would be achieved based on the applicable trust services criteria, if the controls operated effectively and the subservice organizations and user entities applied the complementary controls assumed in the design; and
3. the controls stated in the description were implemented as of 2026-11-10.

*Why this cannot be signed today*

| Statement | Position |
|---|---|
| 1. The description fairly presents the system that was implemented | **False today.** The system is not deployed; the Region in some Terraform roots differs from the stated commitment (G2); the description is a design |
| 2. The controls were suitably designed | Partly true for the CI controls. Not shown for the 20 controls that cannot be tested. Segregation of duties in change management is not designed to be met (CM-05) |
| 3. The controls were implemented | True for 13 controls (section 3). Not true for 32 and not testable for 20 |

A signable assertion needs the readiness gaps G1, G4, G5 and G14 of [SOC2-04](04-readiness-assessment.md) closed and the people-process controls run at least once with real records. The Managing Director would also sign a management representation letter at the end of fieldwork ([SOC2-05](05-audit-approach-and-evidence.md#8-management-representation-letter)).

## 6. Complementary controls

### 6.1 Complementary subservice organization controls

The description uses the carve-out method ([SOC2-01, section 7](01-system-description.md)). Ayka assumes the following controls at the subservice organizations. The auditor would read each provider's own report; none has been retrieved (VM-02), so every row is **to verify**.

| Subservice organization | Service | Controls Ayka relies on | Criteria | How Ayka would monitor | Status today |
|---|---|---|---|---|---|
| Amazon Web Services | Hosting, storage, database, key management, logging | Physical and environmental protection of data centres; secure destruction of media; availability of the underlying hardware and zones; tenant isolation by the hypervisor; protection of KMS key material | CC6.4, CC6.5, A1.2, CC6.1 | Annual review of the AWS SOC 2 Type II report and bridge letter (VM-02); map its CUECs to Ayka controls | No report on file |
| Microsoft (Entra ID) | Workforce identity provider | Availability and integrity of authentication; protection of the tenant directory and token-signing keys | CC6.1, A1.2 | Annual review of the Microsoft report (VM-02) | No report on file |
| GitHub (Microsoft) | Source control, CI runners, artifact storage | Integrity of repositories, rulesets and environment approvals; isolation of hosted runners; protection of stored artifacts | CC8.1, CC6.1 | Annual review of the GitHub report (VM-02) plus the monthly ruleset export (SOC2-08, section 3) | No report on file |

The auditor would test, for each row, that Ayka has a process to monitor the provider (VM-02) and that the provider's report covers the services Ayka uses. VM-02 is Designed and has no instance, so that test would fail today.

### 6.2 Complementary user entity controls

These are the customer-side controls of [SOC2-01, section 6](01-system-description.md). The auditor does not test them at Ayka; Ayka's description must state them and its contracts must put them on the customer.

| ID | Customer responsibility | Criteria | What Ayka does about it |
|---|---|---|---|
| CUEC-01 | Customers approve, review and remove their own users and tell Ayka when an administrator leaves | CC6.2, CC6.3 | States it in the customer pack (IC-02); no customer exists yet |
| CUEC-02 | Customers that connect their own identity provider enforce MFA in it | CC6.1 | States it in the customer pack; the portal's own MFA design is part of AC-03 |
| CUEC-03 | Customers protect credentials and API tokens issued to them | CC6.1 | States it in the customer pack |
| CUEC-04 | Customers classify what they upload and do not upload excluded data categories | C1.1 | States it in the customer pack and the DPA |
| CUEC-05 | Customers report suspected incidents or misuse to Ayka's security contact | CC7.3 | The security address of IC-03 and `SECURITY.md` |
| CUEC-06 | Customers keep their own copies of evidence they must retain beyond their subscription | A1.2, C1.2 | States it in the customer pack and the exit terms (CO-04) |

## 7. Open items before a real Type I

1. Deploy a system and make the description true (G1, G2).
2. Close the findings that fail on inspection even without a deployed system: MFA (G4), credential exposure (G5), apply approval (G14).
3. Have the Managing Director approve the policies by a merged pull request (G9) and collect real acknowledgements.
4. Run each people process once with real records (G8), and keep them in [`records/real/`](../records/real/README.md).
5. Retrieve the three provider reports and review them (VM-02).
6. Re-run this pack as the self-assessment (MO-02) and replace every `fail` and `cannot test` with a dated result.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-11-10 | First issue |
