# SIM-SDL-001 Feature security lifecycle: audit-log export

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-SDL-001 |
| Authored | 2026-11-10 |
| Scenario date | 2026-09-07 (requirements) to 2026-09-25 (release decision) |
| Participants | EMP-006 (Product Manager, Requirements Lead), EMP-007 (Backend Engineer, author), EMP-008 (Frontend Engineer), EMP-014 (Security Engineer, threat model and review), EMP-003 (Cloud Platform Engineer, architecture), EMP-013 (DevOps, CI), EMP-015 (QA Engineer, test data), EMP-002 (CISO, release decision) |
| Procedure exercised | [Secure development policy POL-SDL-01](../../../policies/secure-development-policy.md) sections 4.1 to 4.4, 4.6 and 4.8; [Data masking standard STD-MSK-01](../../../policies/data-masking-standard.md) sections 3 and 4; [Cloud security policy POL-CLD-01](../../../policies/cloud-security-policy.md) (architecture and network rows); [Identity architecture ARCH-IAM-01](../../../architecture/identity-architecture.md); [Change management procedure ISMS-OPS-03](../../../ISMS/06-operational-procedures/change-management-procedure.md) |
| Controls | ISO/IEC 27001:2022 Annex A A.5.8, A.8.25, A.8.26, A.8.27, A.8.28, A.8.33, A.8.11; SOC 2 CM-01, CM-02, CM-05, CO-05 |

The feature is fictional. **Real observation (2026-11-10):** no application code exists in the repository. The task definition runs the placeholder image `nginx:stable` (POL-SDL-01 banner; `Internal-IT/workloads/ayka-portal/envs/dev.tfvars`). This walk applies the written lifecycle to a design. Statements marked **Real observation** read the repository on the Authored date. All other facts are scenario values.

Consistency with earlier records: the walk happens after the incident INC-2026-001 of 2026-08-12 ([SIM-INC-001](../incident/SIM-INC-001-inc-2026-001-customer-export-in-public-ci.md)), where a real customer file was used as a fixture, and after the CI check for fixtures was merged on 2026-08-27 ([SIM-CHG-001](../improvement/SIM-CHG-001-ci-check-for-personal-data-in-fixtures.md)). Corrective actions CA-2 (onboarding route, 2026-09-28) and CA-3 (shorter pytest output, 2026-09-29) of [SIM-CAPA-003](../improvement/SIM-CAPA-003-real-customer-data-used-as-test-fixture.md) are **not yet done** on the dates below. The repository ruleset requires 0 approving reviews.

## 1. The feature

"Audit-log export": a tenant administrator in the portal exports the tenant's audit log (who did what, when, from where) for a date range as CSV or JSON, to hand to their own auditor. The log holds user names, work e-mail addresses and IP addresses, so it is personal data (Confidential). Pilot: Customer A (fictional).

## 2. Lifecycle walk (POL-SDL-01 section 4.1 stage table)

| Stage | Date | What the walk did | Result |
|---|---|---|---|
| Requirement | 2026-09-07 | EMP-006 and EMP-014 wrote the security requirements in the pull request description (section 3). No template exists | Done. Recorded in the PR only |
| Threat model | 2026-09-09 | EMP-014 with EMP-003 (section 4). Input: the threat scenarios catalogue | Done. Two scenarios were not in the catalogue |
| Architecture review | 2026-09-11 | EMP-003, EMP-013, EMP-014 (section 5) | Done. Two design gaps |
| Build and coding rules | 2026-09-14 to 09-18 | EMP-007 wrote the code. Rules of POL-SDL-01 4.4 applied (section 6) | Done with one scanner finding |
| Test data | 2026-09-16 | Section 7 | Real data refused. Synthetic data made |
| Review | 2026-09-18 | EMP-014 reviewed the pull request. **Voluntary**, not enforced: the ruleset requires 0 approvals (same as SIM-CHG-001). He found one missing tenant check | Defect fixed before merge |
| Script and unit tests, validate, plan, scan, regression | 2026-09-18 to 09-22 | The five required checks plus `fixture-check` (six) passed on the head commit | Done |
| Security scans (SAST, dependency, secrets) | 2026-09-22 | See section 6 | Not a required check |
| Merge | 2026-09-22 | EMP-007 merged his own pull request after the checks and EMP-014's comment | Allowed by the ruleset |
| Release decision | 2026-09-25 | Section 8 | Pilot environment only, with conditions |

## 3. Security requirements (A.8.26, POL-SDL-01 4.2 item 2)

| Item (policy list) | Requirement set |
|---|---|
| Authentication | Tenant admin session with MFA. Step-up authentication (fresh MFA within 15 minutes) at export request |
| Authorisation, tenant isolation | Only the tenant administrator role. `tenant_id` comes from the session, never from request parameters. Support staff cannot export (no support path in version 1) |
| Input validation | Date range required, maximum 90 days. Format allow-list (CSV, JSON). Row cap 1,000,000. Free-text columns neutralised against spreadsheet formula injection |
| Logging (STD-LOG-01 section 5, item 4) | Every export request and outcome is logged: who, what range, row count, file hash, from where. The export file content is not logged |
| Data classification | Export file Confidential. Stored in the export prefix with a 7-day lifecycle expiry. Download link valid 15 minutes. Log fields: user name, work e-mail, IP address |
| Retention | Export file 7 days. Audit log itself per tenant contract |

Gap found while writing this: POL-SDL-01 4.2 item 2 asks for these items "before build, recorded in the pull request or design note". There is no pull-request template (section 8 of the policy lists this as a gap). The items sat in free text.

## 4. Threat model (POL-SDL-01 4.2 item 3)

| ID | Threat | Mitigation decided |
|---|---|---|
| T-1 | Cross-tenant read (insecure direct object reference) | Session-derived `tenant_id`; unit test with two tenants |
| T-2 | Spreadsheet formula injection through user names | Prefix risky leading characters in CSV cells |
| T-3 | Oversized export exhausts the task (memory, time) or the database | Row cap, date cap, streaming, one export at a time per tenant. See [SIM-OPS-001](../operations/SIM-OPS-001-capacity-clock-and-network-design-review.md) for the task size |
| T-4 | Download link leaks | 15-minute link, bound to the session, download logged |
| T-5 | Compromised tenant admin exfiltrates the log | Step-up MFA, notify other admins of the tenant on each export |
| T-6 | The exported log is not trustworthy as evidence | **Not in the catalogue.** The audit log table is writable by the application. No integrity protection exists. A hash of the file proves nothing about the content. Decision: version 1 states "not tamper-evident" in the export header. Integrity design is a later item |
| T-7 | The export is itself personal data in an unexpected place | **Not in the catalogue.** Covered by the 7-day expiry and by the deletion work in [SIM-INF-002](../information/SIM-INF-002-customer-data-deletion-at-contract-end.md) |

## 5. Architecture review (A.8.27, POL-SDL-01 4.3 and POL-CLD-01)

| Principle (POL-SDL-01 4.3) | How the feature meets it | Gap |
|---|---|---|
| Defence in depth | Request passes WAF, ALB (TLS only), ECS task in a private subnet, then the database | None new |
| Least privilege | A separate task role permission for the export prefix only. No access to other prefixes | **Real observation:** the task role `aws_iam_role.ecs_task` in `Internal-IT/workloads/ayka-portal/modules/security/main.tf` has no permission policy attached. The least-privilege design has no code to review. The permission must be written and scanned (`IAM_WILDCARD_POLICY`) |
| Fail closed | Missing tenant in session returns 403, not a default tenant | None |
| No standing credentials | The task uses its role. No keys in code | None |
| Secure defaults | The export prefix is in the existing encrypted bucket with public access blocked | The workload uses one KMS key for all data and logs ([POL-CRY-01](../../../policies/cryptography-policy.md) 4.4 item 2). Exports and logs are readable under the same key policy. Known, accepted for the pilot |

Gap in the documents: [ARCH-IAM-01](../../../architecture/identity-architecture.md) describes **workforce** identity (Entra ID, Identity Center, tiers). It says nothing about customer tenants, sessions or tenant isolation in the application. There is no application architecture document. The review used the system description section 3 and the Terraform. The SoA links ARCH-IAM-01 as the architecture evidence for A.8.27.

## 6. Coding rules and scanner results (A.8.28, POL-SDL-01 4.4)

| Rule | Result |
|---|---|
| 1. No secrets in source | No secret in the export code. EMP-014 read the diff by hand as well, because a clean scan is not proof (REAL-SDLC-001; see [SIM-ACC-002](../access/SIM-ACC-002-credential-and-secret-handling-check.md) finding 2) |
| 2. Third-party code pinned | One new CSV helper library, pinned to an exact version in the application's dependency list (scenario). **Real observation:** no such list exists. `tests/requirements.txt` holds only the test dependencies (pytest, pyyaml). The policy does not say where application dependencies are pinned |
| 3. Maintained libraries, supported language | Yes (scenario) |
| 4. ASVS level 2 for relevant features | Chapters on access control, validation, logging and data protection were checked. **Which ASVS version applies was not decided.** POL-SDL-01 says "version to verify at first use". Nobody verified it. EMP-014 used the chapter names only |
| 5. SAST and dependency scanning on every pull request | **Scenario assumption:** the `security-checks.yml` workflow existed and ran on the PR. **Real observation:** it was added on 2026-11-10, has not run on GitHub and is not a required check. In the scenario Bandit raised one MEDIUM (temporary file in a shared directory). EMP-007 removed the file and streams to the response. The dependency audit raised one advisory in a transitive dependency of the CSV helper. A fixed version existed. EMP-007 updated the pin |
| 6. Secret scanning on every push | The same workflow. GitHub-native secret scanning and push protection stay disabled (POL-SDL-01 4.4 item 6, read 2026-10-14) |

## 7. Test data (A.8.33 and A.8.11)

- 2026-09-16: EMP-015 asked for a copy of Customer A's pilot audit log to test performance with realistic volume.
- Decision by EMP-002, same day, scenario: refused. STD-MSK-01 rule 1 and POL-SDL-01 4.8 item 2 forbid production data in test. The exception path needs the CISO's written approval, masking first, the test run **inside the production account**, and a record of deletion. **No production account exists** (POL-SDL-01 4.7 is Planned), so the exception path cannot be used at all. EMP-002 also did not want a second INC-2026-001.
- Instead EMP-015 generated synthetic rows: reserved example domains (`example.com`), made-up names, IP addresses from the documentation range 203.0.113.0/24, volume 1,000,000 rows. `fixture-check` (SIM-CHG-001) passed. It checks only e-mail addresses. Names and IP addresses were checked by EMP-014 reading the generator and a sample.
- The first volume test (2026-09-21) loaded all rows into memory in a local container limited to 512 MB, matching the task size, and was killed. The streaming change (T-3) fixed it.
- 2026-09-17: a failing unit test printed 5 synthetic rows in the **public** CI log, because pytest prints full assertion diffs. CA-3 of SIM-CAPA-003 (shorten pytest output) was not done yet. The rows were synthetic, so nothing leaked. It shows that CA-3 mattered.
- Masking of real data: not needed, not done. `masking.py` ([REAL-PRIV-001](../../real/privacy/REAL-PRIV-001-dsr-tool-test-run.md)) was not used. The standard's section 4 test (a known identifier does not survive in the output) does not exist for this feature's fields, because there is no product data model.

## 8. Release decision (2026-09-25)

| Condition | Status |
|---|---|
| Required checks green on the head commit | Yes (six) |
| Security requirements met by tests | Unit tests for T-1, T-2, T-3. No integration test: no integration environment exists |
| DAST in a non-production environment (POL-SDL-01 4.5 item 3) | **Not possible.** No such environment and no DAST tool |
| External penetration test before the first production release | **Not done.** Planned |
| Independent code review | Done once, voluntarily. Not enforced |
| Residual risk record | T-6 (integrity of the exported log) left as a stated limit. Nobody entered it in the risk register (no rule says when a project risk goes there) |

Scenario decision by EMP-002: **release candidate accepted for the pilot environment (the dev workload, the only one that exists), with three conditions.** (C-1) the export header states "not tamper-evident"; (C-2) the least-privilege permission for the task role is added and scanned before first deployment; (C-3) a test with two tenants runs in the first integration environment. **No production release is decided.** It is blocked by the missing DAST, the missing penetration test and the missing production account.

## Findings

1. **No security record for a project.** POL-SDL-01 asks for requirements, a threat model and decisions but gives no place or template. The pull request body carried everything, and a threat model in a PR comment is not findable later. Name a "design note" location and add a template (this is the policy's own listed gap).
2. **Independent review is voluntary.** The ruleset requires 0 approvals, so the review that found the tenant-check defect was a courtesy. SIM-AUD-003 found the same in the real October sample ([REAL-SOC2-001](../../real/soc2/REAL-SOC2-001-change-review-2026-10.md)). This is also why A.5.3 stays Designed.
3. **No application architecture document.** ARCH-IAM-01 covers workforce identity only. Tenant isolation, session handling and export flows have no architecture home. The SoA cites ARCH-IAM-01 for A.8.27. It is the wrong document for application design.
4. **The task role has no policy.** The design needs a task permission. The Terraform has none. A least-privilege review of nothing proves nothing.
5. **Application dependencies have no pinning file.** POL-SDL-01 4.4 item 2 pins tests (`tests/requirements.txt`) but names no file for application dependencies. State where they live and who updates them.
6. **ASVS version undecided.** The policy leaves "version to verify at first use" and nothing assigns the verification. Pick a version and an owner.
7. **The production-data exception cannot be used.** POL-SDL-01 4.8 item 2 requires the test to run "inside the production account". No production account exists, and for a pilot the exception would never apply. State what the fallback is: synthetic data only.
8. **`fixture-check` catches e-mails only.** It does not catch real names, IP addresses, tenant identifiers or phone numbers in a fixture. A reviewer has to look. This was a known limit in SIM-CHG-001 and it applies to an audit log whose main content is names and IP addresses.
9. **A threat that is not in the catalogue has no path in.** T-6 and T-7 were new. POL-SDL-01 4.2 item 3 names the catalogue as the input. Nothing says how a new scenario gets added.
10. **No rule says when a project risk goes into the risk register.** T-6 stayed a note in a pull request.
11. **Security scans are not required checks.** The workflow that runs Bandit and the dependency audit is defined but not required. A merge can ignore its result.

## What this does not show

- No feature, pull request, scan, test or release exists. The repository has no application code. All times, counts, findings and decisions are scenario values.
- That any scanner finding of the kind described would be raised by the named tools. The assumption is stated in section 6, item 5.
- That the design is sound. It was reviewed by the same small team that wrote it.
- Any customer decision or statement. Customer A (fictional) has no role in the walk except as the source of data that was refused.
- Whether the Terraform for the export permission would pass the gate. It does not exist.
