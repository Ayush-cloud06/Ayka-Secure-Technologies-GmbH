# D-codex findings: codex / AI-cleanup comparison

Agent: D-codex. Date: 2026-09-28. Repo: <repo>, main = 53b0532. Nothing tracked was modified; the checked-out branch stayed the same. I only fetched PR refs into `refs/remotes/origin/pr/*`.

## TL;DR
- **The codex work (f68766c / `codex/pre-restore-ai-cleanup-20260823`) cannot be retrieved from anywhere I can reach.** It is not in the local object DB, not on GitHub, not in any PR ref and not in any fork, and GitHub's own activity log shows it was **never pushed**. It exists only on the owner's machine, if it still exists at all.
- **`fe1b27e "Revert: cleanup"` is not a `git revert`, and the AI cleanup is not in main's history.** Its parent is 243c3b1 (2026-04-15). It adds 84 one-line stub .md files under Governance/ISMS, fills 3 empty files, and adds 3 lines to .gitignore plus tree.md. It touches no code.
- **Code on main is byte-identical to 243c3b1 (15 Apr 2026)** for tests/, .github/ and all of Internal-IT/ (every *.tf, script, rego and yaml).
- So the claim "293 files, +9.5k/−3.8k" is **UNVERIFIABLE**, and no per-change TAKE/SKIP is possible. What I did instead:
  - (a) I checked each fix category the prompt says codex made against main, so the plan can re-implement them in the owner's own voice.
  - (b) I wrote the exact commands the owner can run locally to recover or export the branch if it still exists.

## 1. Where is the codex work? (evidence)

| Check | Command / source | Result |
|---|---|---|
| Local object | `git cat-file -t f68766c` | `fatal: Not a valid object name f68766c` (exit 128) |
| Fetch by SHA | `git fetch origin f68766c` | `fatal: couldn't find remote ref f68766c` |
| Fetch branch | `git fetch origin refs/heads/codex/pre-restore-ai-cleanup-20260823:...` | `fatal: couldn't find remote ref refs/heads/codex/pre-restore-ai-cleanup-20260823` |
| Remote refs | `git ls-remote origin` | HEAD, refs/heads/main (53b0532), refs/pull/1..6/head only |
| GitHub MCP | `list_branches` | `[{"name":"main","sha":"53b0532…"}]` |
| GitHub MCP | `get_commit sha=f68766c` | `No commit found for SHA: f68766c` |
| GitHub REST | `GET /repos/…/commits/f68766c` | HTTP 422 (no commit) |
| GitHub REST | `GET /repos/…` | public, `forks_count: 0`, pushed_at 2026-08-23T05:56:28Z |
| GitHub activity API | `/activity?activity_type=force_push` | 0 events |
| GitHub activity API | `/activity?activity_type=branch_creation` | only main (2026-01-16), test-pipeline, test-pipeline-2 (2026-03-22) |
| GitHub activity API | `/activity?activity_type=branch_deletion` | test-pipeline-2 (2026-03-29) and test-pipeline (2026-03-22) only |
| GitHub activity API | `/activity` (last 100, 2026-03-12..2026-08-23) | pushes to main: `713a6bb->243c3b1` (04-15), then `243c3b1->fe1b27e` (08-23 03:55Z), `fe1b27e->0a3c53b`, `0a3c53b->53b0532`. **No non-fast-forward, no codex ref** |
| Actions runs | `/actions/runs` (131 runs) | head_branch only `main` (109) and `test-pipeline-2` (22); no run on f68766c |
| PR refs | `git fetch origin '+refs/pull/*/head:refs/remotes/origin/pr/*'` | PR1 b3c9b56, PR2 2a6063a (03-22), PR3 1af4386 (03-25), PR4 1b8b535 (03-27), PR5 27088da (03-28), PR6 f4dd7e0 (03-28). All closed, all "test-pipeline*" heads, **all ancestors of main** (`merge-base --is-ancestor` = yes). None is the cleanup |
| Local leftovers | reflog, stash, packed-refs, `git fsck --lost-found` | nothing (fresh depth-50 shallow clone; shallow boundary is in March 2026, so all Apr–Aug history is present) |
| Filesystem | `find / -name '*.bundle'`, other `.git` dirs, grep for f68766c / pre-restore | nothing except this session's own logs |

### What `fe1b27e "Revert: cleanup"` really is
- `git log --format='%h %P %s' -3 fe1b27e`:
  - `fe1b27e 243c3b13… Revert: cleanup`
  - `243c3b1 713a6bb6… mock creds for pipeline`
  - `713a6bb 1365182e… tfsec artifact moving`
- `git show --stat fe1b27e` reports `89 files changed, 100 insertions(+), 2 deletions(-)`. `--name-status` gives **84 A, 5 M**:
  - **A (84):** new one-line "# Title" stubs in Governance/ISMS: 00-context 8, 01-org 9, 02-asset 7, 03-risk 7, 04-controls 4, 05-policies 17, 06-procedures 12, 07-evidence 4, 08-monitoring 5, 09-audit 3, 10-mgmt-review 4, 11-improvement 4. None of these paths existed earlier in history (`git log --diff-filter=D -- Governance/ISMS` is empty).
  - **M (5):**
    - `.gitignore` gains `annotations`, `graphify-out` and `AUDIT/`, which look like AI tool output folders.
    - `Governance/ISMS/README.md` and 04-controls-and-soa `{access-control-evidence-index,privileged-access-justification}.md` go from empty to a heading.
    - `Governance/ISMS/tree.md` is updated.
- `git diff --stat 243c3b1 53b0532 -- tests .github Internal-IT` is **empty**. `git diff --shortstat 243c3b1 53b0532` shows `90 files changed, 675 insertions(+), 175 deletions(-)`, all Governance/*.md plus .gitignore.
- Inference (UNVERIFIED): you reset main to the 15 Apr state and never pushed the AI branch. You then kept only the AI's ISMS file *names* as heading stubs, ignored the AI tool output folders, and on the same day (0a3c53b / 53b0532) added risk docs that reference the local `AUDIT/` folder and describe the source as "clean". That description fits the AI-cleanup state, not main (lead FACTS: risk-register.md:21).

### How the owner can recover it (run on your machine, not in the planning sandbox)
```
git cat-file -t f68766c                                  # does the object still exist locally?
git branch -a --contains f68766c; git reflog | grep -i -E 'codex|cleanup|f68766c'
git diff --shortstat main f68766c                         # verify the 293 files / +9.5k/-3.8k claim
git diff --stat main f68766c -- tests .github Internal-IT/engineering/ci-cd/scripts Internal-IT/engineering/policy-as-code '*.tf'
# share it without touching main (either one):
git push origin f68766c:refs/heads/archive/codex-ai-cleanup-20260823
git bundle create codex-ai-cleanup.bundle codex/pre-restore-ai-cleanup-20260823 ^main
```
After that, this analysis can be re-run with `git fetch origin archive/codex-ai-cleanup-20260823`. Per-file extraction would then be `git diff main f68766c -- <path> | git apply` or `git checkout f68766c -- <path>`.

## 2. Overall stats vs claim
- Claim: 293 files, +9.5k/−3.8k vs main. **UNVERIFIABLE**, because the commit is unavailable.
- For scale: main has 373 tracked files, so 293 would be about 79% of the repo, which fits a sweeping repo-wide rewrite.

## 3. Reconstruction table (the codex fix categories, checked against main)
The codex diff is gone, so "TAKE" here means **re-implement by hand** (small, owner-authored commits). All evidence is on main 53b0532, which equals 243c3b1 for code. Items marked (lead) are already in FACTS-lead.md; I re-verified them locally where noted.

| # | Category the codex work claims | State on main (evidence) | Severity | Suggested own fix (size) | Rec. |
|---|---|---|---|---|---|
| 1 | tfsec output path | `run-tfsec.sh:13-19`: `tfsec … --format json --out output/tfsec-result` writes the literal file `tfsec-result`, and the missing-`.json` fallback then writes `{"results":[]}`. **Reproduced locally with tfsec v1.28.14:** on control-validation-scenarios, `output/tfsec-result` holds 25 findings (15 HIGH, 2 CRITICAL) but `tfsec-result.json` = `{"results":[]}`. Every tfsec finding is dropped (FAIL-OPEN). CI logs agree (lead). | HIGH | Use `--out "$OUTPUT_DIR/tfsec-result.json"`. Replace the fallback with a hard fail when the file is missing (~3 lines). Add a test. | RE-IMPLEMENT |
| 2 | WORKLOAD_DIR passing | `run-tfsec.sh:9` defaults to ayka-portal. `check/action.yml` has no `workload_dir` input or env. The reusable workflow never sets WORKLOAD_DIR. The regression job inherits `test.yml:13` WORKLOAD_DIR=ayka-portal, so it tfsec-scans the wrong directory (lead, from logs). | MED | Add a `workload_dir` input to `check/action.yml`, pass it as `env: WORKLOAD_DIR`, and make run-tfsec fail if it is unset (~8 lines). | RE-IMPLEMENT |
| 3 | Evaluator fail-open | Reproduced with `scratchpad/d-codex/probe_eval.py` against the real control-mapping.yaml:<br>• checkov on a **missing plan** exits 0 with `failed_checks: []` plus `parsing_errors: [...]`; `normalize_checkov` (`evaluate-results.py:220-222`) ignores parsing_errors → **pass**.<br>• checkov `{}` or a summary-only dict → pass.<br>• tfsec `{}` → pass.<br>• OPA `[]` → pass.<br>• Unmapped checkov with severity null → LOW → pass (`normalize_severity` :48-54).<br>• checkov list output → AttributeError crash (fails closed by accident).<br>• OPA error payload → exit 1 (good). | HIGH | Validate each input's shape (checkov dict with `results`; tfsec `results` is a list; OPA non-empty list with namespaces). Fail on checkov `parsing_errors`. Optionally treat unmapped findings as MEDIUM (~30-40 lines plus tests). | RE-IMPLEMENT |
| 4 | Test coverage | `tests/compliance/test_evaluate_results.py` has 5 tests, all happy-path mapping. No test covers malformed or empty inputs, tfsec file naming, or the shell scripts. **CI never runs the tests:** there is no pytest/unittest in .github, and `validate-scripts` only runs `bash -n`. No `*_test.rego` exists (`opa test` finds 0 tests). | MED | Add a CI step `python3 -m pytest -q tests/`. Add tests for items 1 and 3. Add 1-2 rego unit tests per package (~100-150 lines). | RE-IMPLEMENT |
| 5 | Action pinning | Unpinned (tag refs):<br>• `plan/action.yml:24` aws-actions/configure-aws-credentials@v4<br>• `plan/action.yml:30` hashicorp/setup-terraform@v3<br>• `validate/action.yml:17` hashicorp/setup-terraform@v3<br>• `validate/action.yml:22` terraform-linters/setup-tflint@v4 with `tflint_version: latest` (:24)<br>• `policy-check.yml:18` actions/checkout@v4<br>13 other `uses:` are pinned to SHAs. Tool installs are unverified: `pip install checkov` has no version (`check/action.yml:15`), and the tfsec/conftest `wget` downloads skip checksum checks (`check/action.yml:18`, `policy/action.yml:11`). | MED | Pin to the same SHAs used elsewhere. Pin the checkov and tflint versions. Verify sha256 after wget (~15 lines). | RE-IMPLEMENT |
| 6 | Rego syntax | All 6 rego files use v0 syntax. They pass with OPA 0.56 (the conftest 0.45.0 bundle) but **fail OPA 1.0 parsing: 45 errors** (`opa1 check`), e.g. `aws_vpc.rego:34` "`contains` keyword is required". Passes with `--v0-compatible`. Not broken today because conftest is pinned to 0.45.0. | LOW (latent) | Either keep conftest pinned and document it, or add `import rego.v1` and `if`/`contains` (mechanical, ~50 lines). | OPTIONAL |
| 7 | OPA/aws vs OPA/terraform | `OPA/aws/{ec2,s3}.rego` read `input.instances` / `input.buckets`, so they never fire on plan JSON, yet they are loaded by `run-policy-check.sh:14` (whole OPA dir, `--all-namespaces`). `s3.rego:8` has the typo "publicy". The OPA/terraform rules only walk `child_modules[_].resources` (lead). | LOW / MED | Delete OPA/aws (dead code) or point `--policy` at OPA/terraform. Extend the rules to root-module resources (separate change). | RE-IMPLEMENT (delete) |
| 8 | Regression job strictness | `test.yml:76` sets `continue-on-error: true` on the decision step. `:94-98` only prints `WARNING` when decision != `fail`, so the regression job stays green even if the gate stops catching violations. | MED | Exit 1 unless decision == fail. Optionally assert expected control IDs or counts from compliance-summary.json (~10 lines). | RE-IMPLEMENT |
| 9 | Checksum coverage | (lead) `terraform-workflow.yml:96-105` hashes tfplan.json and compliance-summary.json, but the upload (`evidence/action.yml:28-32`) omits `output/compliance-summary.json`. `run-apply.sh:14` uses `--ignore-missing`, so only tfplan.json is verified. The checksum travels in the same artifact. tfplan.binary (the file apply would use) is not hashed. | MED | Upload the summary. Hash tfplan.binary as well. Drop `--ignore-missing`. | RE-IMPLEMENT |
| 10 | export-evidence.sh | Copies only `output/*.json`, so the real tfsec output (`tfsec-result`, no extension) and `opa-result.stderr.log` are never exported. The `evidence/raw/<timestamp>` layout is fine. | LOW | Fixed as a side effect of item 1. | covered by #1 |
| 11 | run-apply.sh | Only echoes "Apply complete! Resources: 14 added" (`:24-27`), which is hardcoded (lead). This is intentional for the mock environment, but it is presented as an apply. | LOW (honesty) | Label it clearly as a simulation in the log and README. | OPTIONAL |
| 12 | decision action jq | (lead) `decision/action.yml:38` has `\"unknown\"` inside single quotes → jq syntax error, so schema_version is empty. | LOW | Use `// "unknown"` (1 line). | RE-IMPLEMENT |
| 13 | Entra-ID passwords | (lead) literal `password =` at `entra-id/modules/core/users.tf:16`, `privileged/break_glass.tf:6` and `privileged/admin_accounts.tf:9`. risk-register.md:21 says the source is "clean", which is true only for the AI state. | HIGH (portfolio optics) | Use `random_password` or a `sensitive = true` variable (A-terraform owns this). | RE-IMPLEMENT (A-terraform) |
| 14 | Drift detection | The scheduled workflow failed 61/61 times (2026-04-16..06-15) and is now `disabled_inactivity`. From the run 27530067596 job steps: "Report Drift" (`if: exitcode == '2'`) **ran and failed**, so plan returned 2 (changes) every night. That fits infra never being applied, since run-apply only echoes. | MED | Either disable the schedule or make it meaningful (plan against the mock state, or remove it). | DECIDE (owner) |
| 15 | Deleted empty files | Main has **73 zero-byte tracked files**: Internal-IT/engineering 23, Internal-IT/assurance 18, Internal-IT/platform 11, Internal-IT/workloads 10, Governance/GDPR 4, Governance/ISMS 3, organization 3, Governance/company-security-roadmap.md 1. There are also 84+ one-line heading stubs from fe1b27e. What codex actually deleted is UNVERIFIABLE. | LOW (optics) | Owner decides: keep stubs, delete them, or fill a few. Don't bulk-delete without your say (that is what you reverted). | DECIDE (owner) |

Per-change TAKE/SKIP against the codex diff, and extraction commands, are **N/A**: the diff is unavailable. If the owner supplies the branch (section 1), each row maps to `git diff main f68766c -- <file>`. The rows to compare first are 1 (run-tfsec.sh), 3 (evaluate-results.py), 4 (tests/), 5 (.github/actions/*), 8 (test.yml) and 9 (terraform-workflow.yml, run-apply.sh, evidence/action.yml).

## 4. Test results
| Tree | Command | Result |
|---|---|---|
| main 53b0532 (export `scratchpad/tree-D-main`) | `python3 -m pytest -q tests/` | **5 passed** in 0.39s (pytest 9.1.1, PyYAML 6.0.1) |
| main | `python3 -m unittest discover -s tests` | 0 tests (no `__init__.py` in tests/compliance; use `-s tests/compliance`) |
| main | `opa test Internal-IT/engineering/policy-as-code/OPA` (OPA 0.56.0) | 0 tests, exit 0; no `*_test.rego` |
| main | `opa check` (0.56.0) / `opa check` (1.0.0) / `opa check --v0-compatible` (1.0.0) | ok / **45 errors, all 6 files fail** / ok |
| main | `run-tfsec.sh` with WORKLOAD_DIR=control-validation-scenarios (tfsec v1.28.14) | `tfsec-result` = 25 findings; `tfsec-result.json` = `{"results":[]}` → fail-open reproduced |
| main | `probe_eval.py` (9 malformed-input cases) | see row 3: 6 cases pass or exit 0 when they should fail |
| codex f68766c | — | **NOT RUN: commit unavailable** |

## 5. Things the codex branch deleted
UNVERIFIABLE (commit unavailable). Indirect hints only, all UNVERIFIED:
- fe1b27e re-created 84 ISMS stub files whose names match an expanded tree.md. The AI branch probably created, or restructured, ISMS docs with those names.
- `.gitignore` gained `annotations`, `graphify-out` and `AUDIT/` (AI tooling outputs).
- Candidate deletion targets on main today: the 73 zero-byte files (row 15), `Internal-IT/workloads/control-validation-scenarios/tfplan.binary` (a committed plan binary, lead), dead `OPA/aws/*.rego`, and the unused `policy-check.yml` (a reusable workflow that nothing calls, lead).

## Files
- `scratchpad/gh_activity*.json`, `gh_fp.json`, `gh_bc.json`, `gh_runs*.json`: raw GitHub API evidence.
- `scratchpad/d-codex/probe_eval.py`: evaluator edge-case probe (`python3 probe_eval.py <tree-root>`).
- `scratchpad/tree-D-main/`: git-archive export of 53b0532 (plus `git init` for run-tfsec.sh).
- `scratchpad/d-codex/tfsec-out-test/`: tfsec `--out` naming reproduction.
