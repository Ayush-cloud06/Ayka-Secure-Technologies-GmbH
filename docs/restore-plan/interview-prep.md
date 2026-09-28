# Interview prep: 10 questions, grounded in your own files

> **How to use this:** say each answer out loud in under 2 minutes, with the cited file open. If you can't point at the line, you don't own the answer yet.
> **Honesty rule:** answers marked **(after Phase 4)** describe fixes you haven't made yet. Until you've made them, say "I found X and my plan is Y". Never claim them as done.
> Deeper background: [how-it-works.md](how-it-works.md).

---

### Q1. "Walk me through this project in two minutes."

**Outline**
1. **Problem:** Infrastructure-as-code reviews are manual. Scanner output is noisy and speaks in tool IDs, not controls. Auditors want evidence, not screenshots.
2. **What I built:** a GitHub Actions gate for Terraform.
   - Checkov and OPA scan the plan JSON; tfsec scans the source.
   - A Python evaluator maps every finding to my own control IDs (`control-mapping.yaml`, 38 controls with ISO 27001:2022 Annex A references).
   - It then decides `pass`, `approval_required` or `fail` (`evaluate-results.py:417-421`).
3. **Proof it works:** two workloads. `ayka-portal` is a realistic app that should pass. `control-validation-scenarios` is deliberately broken and must fail. Run #68 on 2026-08-23: portal `pass` (14 LOW), scenarios `fail` (4 HIGH).
4. **Evidence:** every run uploads raw JSON, a summary, a Markdown report and a SHA-256 checksum file.
5. **Honest framing:** the company, Ayka Secure Technologies GmbH, is a simulated ISO 27001 case study. Nothing is deployed; apply is simulated.

**Show:** the pipeline diagram in [how-it-works.md §1](how-it-works.md#1-the-30-second-version), then a CI run.
**Don't say:** "enterprise platform", "SOC 2", "SIEM", "zero trust", "continuous monitoring". None of these exist in code ([ADR-0006](adr/0006-honesty-labelling.md)).

---

### Q2. "How does a raw scanner finding become a pass/fail decision?"

**Outline**
- Each tool is normalised into one finding shape: `normalize_checkov` / `normalize_tfsec` / `normalize_opa`, `evaluate-results.py:220-314`.
- **Mapping:**
  - Checkov/tfsec rule ID → control via the `policy_id` index (`:137-159`).
  - OPA messages start with `[CONTROL_ID]`, parsed by a regex (`:29`, `:162-178`); the fallback is package + message pattern (`:190-206`).
- **Severity comes from my metadata, not the scanner**, once mapped (`:155`, `:174`). That's a deliberate choice: the organisation decides what is HIGH.
- **Decision:** any HIGH → `fail`, exit 1; any MEDIUM → `approval_required`; else `pass` (`:417-421`, `:453-454`).
- Walk one example: the open-SSH scenario. `aws_ec2.rego:6-21` emits `[EC2_OPEN_SSH]`, `control-mapping.yaml:2-23` marks it HIGH, so the build goes red.

**Likely follow-up:** "What about findings you didn't map?"
- Unmapped OPA findings become MEDIUM (`:208-217`).
- Unmapped Checkov findings keep the scanner's severity. Open-source Checkov usually reports none, which becomes LOW (`:48-54`). That's a known gap; see Q3.

---

### Q3. "What does fail-closed mean, and is your gate actually fail-closed?"

**Outline (the strongest answer in your portfolio; tell it as a story)**
- **Definition:** if the gate can't prove the change is safe, it must not say "pass".
- **What was right:**
  - a missing result file gives exit 1 (`evaluate-results.sh:13-18`);
  - invalid JSON gives exit 1 (`evaluate-results.py:32-37`);
  - a conftest crash becomes an error payload and exit 1 (`run-policy-check.sh:24-28`, `evaluate-results.py:282-285`).
- **What I found when I came back:**
  - The tfsec wrapper wrote to `output/tfsec-result` (no extension), then created an empty `tfsec-result.json` fallback (`run-tfsec.sh:13-19`).
  - So **every tfsec finding was silently dropped**, and the "missing file → fail" check was defeated.
  - Evidence: run #68 lists both files (4137 bytes vs 15 bytes), and tfsec is absent from `by_tool`.
  - Reproduced locally: 25 tfsec findings on the scenarios, 15 HIGH and 2 CRITICAL, never reached the evaluator.
  - A probe also showed that Checkov on a missing plan exits 0 with `parsing_errors`, which the evaluator ignored.
- **What I did (after Phase 4):**
  - fixed the path;
  - removed the fallback;
  - added input-shape validation;
  - added tests for each failure mode;
  - made the negative-test job fail the build if the scenarios stop failing.

**Lesson to state:** "A green pipeline is a claim. I verify the gate by checking what it *didn't* see, not just what it reported."

---

### Q4. "Why three scanners? Isn't that redundant?"

**Outline**
- **Different inputs, different blind spots:**
  - Checkov reads the resolved plan, so variables and modules are expanded.
  - tfsec reads the source.
  - OPA lets me write organisation-specific rules that no vendor ships, e.g. mandatory tags `aws_ec2.rego:83-107` and no Spot in prod `:127-142`.
- **Overlap is handled by the mapping, not by deleting tools.** One control can list several enforcements, e.g. `S3_VERSIONING_DISABLED` has Checkov `CKV_AWS_21` plus tfsec `AVD-AWS-0090` (`control-mapping.yaml:80-99`).
- **Honest limitation:**
  - The evaluator doesn't de-duplicate. The same issue from two tools counts twice in totals.
  - My OPA rules only look one module deep (`child_modules[_]`, e.g. `aws_ec2.rego:7`), so root-module resources are invisible to them.

---

### Q5. "What stops someone from setting everything to LOW in the mapping file to get a green build?"

**Honest answer today:** nothing technical. `main` isn't branch-protected (GitHub API: `protected: false`), and there's no CODEOWNERS file.

**Outline**
- It's a real risk. In run #68 all 14 ayka-portal findings are mapped to LOW controls, e.g. `CKV2_AWS_5` → `SECURITY_GROUP_UNUSED` (`control-mapping.yaml:560-575`).
- **My plan ([ADR-0014](adr/0014-control-mapping-changes-reviewed.md)):**
  - treat the mapping as a controlled document;
  - every severity needs a written rationale;
  - changes go through a protected branch with a required review and required CI;
  - the regression workload proves the HIGH controls still bite.
- **ISO angle:** this is change management applied to the gate itself (Annex A 8.32 as a reference, not a certification claim).

---

### Q6. "How do you know the gate works?"

**Outline**
- **Negative testing:** `control-validation-scenarios` contains five deliberately broken modules (`main.tf:1-24`), for example open SSH (`ec2/open-ssh-security-group/main.tf:5-10`). The regression job runs the full chain on them.
- **Unit tests:** `tests/compliance/test_evaluate_results.py` has 5 tests, all passing (`python3 -m pytest -q tests/`).
- **Be honest:** those tests weren't run in CI until Phase 4. The regression job only printed a WARNING when the scenarios passed (`test.yml:94-98`), and there were no rego unit tests.
- **After Phase 4:**
  - pytest and `opa test` run in CI;
  - the regression job exits 1 unless the decision is `fail`;
  - rego rules have their own tests.

---

### Q7. "How is the evidence protected? Could someone tamper with it?"

**Outline**
- **What exists:**
  - `sha256sum` of `tfplan.json` and `compliance-summary.json` (`terraform-workflow.yml:96-105`);
  - the apply job re-verifies it before its (simulated) apply (`run-apply.sh:14`).
- **What it proves:** the plan JSON the apply job received is byte-identical to the one that was scanned. That's **integrity** against accidents and run mix-ups.
- **What it doesn't prove:** authenticity. The hash lives in the same artifact as the data, so anyone who can rewrite the artifact can rewrite the hash.
- **Gaps I found:**
  - the summary wasn't in the uploaded artifact, so `--ignore-missing` silently skipped it; run #68 verified only `tfplan.json`;
  - `tfplan.binary`, the file a real apply would use, isn't hashed.
- **Next step (Phase 6, optional):** sign an attestation of the evidence, or store the hash somewhere write-once, outside the artifact.

---

### Q8. "How does this relate to ISO 27001? Is Ayka certified?"

**Outline**
- **No.** Ayka Secure Technologies GmbH is a simulated case study. My own risk register says so: "Working case-study record; no management approval or operating ISMS is evidenced" (`Governance/ISMS/03-risk-management/risk-register.md:9`).
- **What's real:** each technical control carries ISO/IEC 27001:2022 Annex A references, e.g. `EC2_OPEN_SSH` → A.8.20/A.8.21 (`control-mapping.yaml:9`). So a finding can be traced to the control objective it threatens.
- **The governance side:**
  - risk register, treatment plan, risk criteria (`Governance/ISMS/03-risk-management/`);
  - these are written to be evidence-bounded: every risk states its evidence confidence.
- **Be ready to admit:** some mappings need review. For example `SECURITY_GROUP_UNUSED` cites A.8.15 (logging) (`control-mapping.yaml:566-567`), which doesn't fit well.

---

### Q9. "What are the limitations?" (be proactive)

| Limitation | Evidence | What you'd do next |
|---|---|---|
| Nothing is deployed; apply is an `echo` | `run-apply.sh:24-27` | tiny real sandbox slice with a budget alarm ([ADR-0010](adr/0010-mock-plan-only-then-sandbox.md)) |
| Mock credentials, refresh-free plan | `ayka-portal/provider.tf:19-24`, `plan/action.yml:42` | only possible to change with a real backend and account |
| Drift detection can't work without state | 61/61 failed nightly runs (plan exit 2), now disabled | manual-only until remote state exists ([ADR-0008](adr/0008-drift-manual-only.md)) |
| OPA sees only one module level; some values are unknown at plan time | `aws_ec2.rego:7`; `aws_vpc.rego:18,30,41` | walk all modules; move ID-based checks to post-apply |
| Severity is decided by whoever edits the mapping | `control-mapping.yaml` | review + rationale ([ADR-0014](adr/0014-control-mapping-changes-reviewed.md)) |
| Checksum is integrity, not authenticity | `terraform-workflow.yml:96-105` | signed attestation (Phase 6) |
| Rego uses pre-1.0 syntax, pinned conftest | `policy/action.yml:11`; OPA 1.0 check: 45 errors | migrate to `rego.v1` (Phase 6) |
| The CI assumes a real AWS role it doesn't need | `test.yml:16,41`; run #68 OIDC step succeeded | remove or restrict ([ADR-0013](adr/0013-no-cloud-creds-for-plan-only.md)) |

---

### Q10. "What would you do differently if you started again?"

**Honest outline, specific to this repo**
1. **Tests in CI from day one.** I had 5 good evaluator tests that never ran in CI, so they protected nothing.
2. **Verify the gate's inputs, not just its logic.** The tfsec bug lived in a 20-line shell wrapper, not in the evaluator.
3. **No empty files.** I scaffolded about 155 empty or title-only documents to look complete. That made the repo look fragmented and hid the real work. Write a document only when there's evidence to put in it.
4. **Label reality from the start:** Implemented / Simulated / Planned. My first README claimed Terragrunt, SIEM and SOC 2, none of which exist in code.
5. **Never put credentials in Terraform, even "bootstrap" ones.** Git history is forever (`entra-id/modules/core/users.tf:16` and two others).
6. **Keep AI help at the scale of one reviewable change.** I reverted a 293-file AI cleanup because I couldn't follow it. Now I take small changes I can explain line by line.

---

## Bonus: the 3 numbers to remember

| Number | Meaning | Source |
|---|---|---|
| **38** | controls in the mapping | `control-mapping.yaml` |
| **14 LOW vs 4 HIGH** | portal vs scenarios, run #68 | CI logs |
| **25** | tfsec findings on the scenarios that CI silently dropped (15 HIGH, 2 CRITICAL) | local tfsec v1.28.14 reproduction |
