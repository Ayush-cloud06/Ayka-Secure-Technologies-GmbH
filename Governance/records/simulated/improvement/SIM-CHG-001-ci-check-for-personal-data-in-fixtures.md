# SIM-CHG-001 Change record: CI check for personal data in test fixtures

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-CHG-001 |
| Authored | 2026-11-10 |
| Scenario date | 2026-08-19 (opened). Merged 2026-08-27 |
| Participants | EMP-013 (author), EMP-014 (independent reviewer), EMP-002 (CISO review; holds the GitHub owner role, SIM-PPL-001), EMP-015 (test of the check) |
| Procedure exercised | [Change management procedure ISMS-OPS-03](../../../ISMS/06-operational-procedures/change-management-procedure.md) sections 2 to 4; [POL-CHG-01](../../../policies/change-management-policy.md) |
| Controls | ISO/IEC 27001:2022 Annex A A.8.25, A.8.29, A.8.32, A.8.11, A.8.33; SOC 2 CM-01, CM-02, CM-05, CO-05 |

Source: incident INC-2026-001 action A-01 (SIM-INC-001), corrective action SIM-CAPA-003.

## 1. Change record (procedure section 2)

| Field | Content |
|---|---|
| Purpose | Fail CI when a file under any `tests/**/fixtures/` path contains an e-mail address outside the reserved example domains (`example.com`, `example.org`, `example.net`) |
| Affected assets | `.github/workflows/test.yml` (new job `fixture-check`), new script in `Internal-IT/engineering/ci-cd/scripts/`, ruleset `protect-main` (required checks) |
| Risk/treatment IDs | RISK-011 (personal data where it should not be); STD-MSK-01 rule 1 |
| Security/privacy/Region impact | Reduces the chance of personal data in public logs. Does not detect names without e-mails. No Region impact |
| Test plan | Known-good fixture (synthetic, `example.com`) must pass. Known-bad fixture (address at a made-up non-reserved domain) must fail. Script has unit tests |
| Rollback | Revert pull request; remove the required check from the ruleset |
| Class | **Standard** by the table. CI workflow changes are not in the Elevated list. EMP-002 asked for CISO review anyway because `.github/` is a CODEOWNERS path |

## 2. Validation and review (section 3)

| Step | Result |
|---|---|
| 1. Fixed commit, relevant tests | Unit tests for the script, pytest, and the full offline chain run on the head commit. All passed (scenario value) |
| 2. Scanner outputs and decision | Gate decision for ayka-portal unchanged: pass, 6 LOW, 14 excepted (scenario value). The change does not touch Terraform |
| 3. Mapping and exceptions | Not changed |
| 4. Reviewer | EMP-014 reviewed security impact, tests and rollback, and approved on 2026-08-26. Author and reviewer differ |
| 5. Independence | Recorded: independent. The GitHub ruleset still requires 0 approvals, so the approval was voluntary, not enforced |
| Smoke test | EMP-015 pushed a branch with the known-bad fixture on 2026-08-26. `fixture-check` failed as expected. Known-good passed |

## 3. Merge and verify (section 4)

- Merged 2026-08-27 by EMP-013. Five required checks green, plus the new check.
- 2026-08-27: EMP-002, as holder of the owner role, added `fixture-check` to the required checks in ruleset `protect-main` at EMP-013's request. This was a settings change in GitHub. It has no pull request and no reviewer.
- Retained: PR, head SHA, run ID, review, ruleset change time (restricted change folder). The ruleset change was made by the same person who did the CISO review.
- Post-merge verify by EMP-013: a later pull request showed six required checks. Done 2026-08-28.

## Findings

1. **Repository settings changes have no route.** The procedure covers pull requests. Ruleset, environment and required-check changes are made in GitHub settings, with no record, no review and no rollback note. Section 4 should require a settings change record with before/after export.
2. **CI workflow changes are "Standard".** The Elevated list names gate logic and mappings, but not `.github/` workflows or required checks. A workflow change can switch off the gate. Add CI workflows and rulesets to Elevated.
3. **Downstream documents depend on "five checks".** KPI M-02, the document control procedure and the README all say five required checks. The procedure has no step to find documents that describe the changed control. Add "update every document that states the old behaviour" to section 4.
4. **Independent review is voluntary.** Step 5 tells the reviewer to record independence, but nothing enforces it. Here it happened because the author asked. SIM-AUD-003 found it did not happen in the sampled real changes.

## What this does not show

- No pull request, script, job or ruleset change exists. The repository has no `fixture-check` job.
- The procedure is used as its text stands on the Authored date (2026-11-10) and treated as in force at the scenario date.
- One reviewed change says nothing about the population of changes. See SIM-AUD-002 for the sample.
