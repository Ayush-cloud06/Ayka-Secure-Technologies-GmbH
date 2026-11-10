# SIM-GOV-003 Legal register and intellectual property review

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-GOV-003 |
| Authored | 2026-11-10 |
| Scenario date | 2026-04-28 (review meeting). Section 4 is a **real observation of 2026-11-10**, not a scenario |
| Participants | EMP-004 (Compliance Analyst, owner of the register's upkeep), EMP-021 (Compliance Officer, second reader), EMP-018 (Governance & Risk Analyst, minutes), EMP-013 (DevOps, tool list), EMP-003 (Cloud Platform Engineer), EMP-002 (CISO), EMP-001 (Managing Director, budget decision) |
| Procedure exercised | [Legal, regulatory and contractual requirements register ISMS-00-05](../../../ISMS/00-context-and-governance/legal-and-regulatory-register.md) sections 2, 5, 7 and 8; [Acceptable use policy POL-AUP-01](../../../policies/acceptable-use-policy.md) section 2 (software and services, publication and licences rows); [Secure development policy POL-SDL-01](../../../policies/secure-development-policy.md) section 4.4 item 2 and section 4.9 |
| Controls | ISO/IEC 27001:2022 Annex A A.5.31, A.5.32; clause 4.2 b. SOC 2 CC1.1 (context) |

Nothing here is legal advice. The register is used as its text stands on the Authored date and treated as in force at the scenario date.

## Part 1. Review of the register (A.5.31), scenario

**What the register asks.** Section 7 lists sources to watch and how often. The review of each row asks: does the requirement still apply, is the source current, is the owner right, is the "How met" column true, is the status the weakest true one.

**Population (real count of the document):** 21 rows, 14 laws (LR-01 to LR-14) and 7 contracts (CR-01 to CR-07). In the "Applies?" column 9 rows begin with "To verify" (LR-04, LR-09, LR-10, LR-12, LR-13, LR-14, CR-03, CR-05, CR-07) and 3 more carry a verification note inside the text (LR-02, LR-03, CR-04). 10 rows have the status Planned. 5 open items (LO-1 to LO-5) are listed.

| Step | Result (scenario) |
|---|---|
| 1. Read each row against its primary source | EMP-004 and EMP-021 read the text of the statutes the register links (GDPR, HGB §257, AO §147, BetrVG §87) for the cited provisions. **They could confirm that the cited provisions exist and say what the register says. They could not confirm applicability to Ayka.** Applicability turns on facts (headcount, sector, whether a works council exists, controller or processor role) and on interpretation that needs counsel |
| 2. Close "to verify" rows | **0 of 9 closed.** Each needs a legal view (LR-04 cookies law, LR-09 export control, LR-10 AI Act role, LR-12 Data Act, LR-13 CRA scope, LR-14 whistleblower channel) or a real contract that does not exist yet (CR-03, CR-05, CR-07) |
| 3. Check owners | LR-03 is owned by the CISO, LR-05 by the Managing Director, LR-06 by the Managing Director. The roles exist ([SIM-PPL-006](../people/SIM-PPL-006-role-holder-appointments.md)). No person owns "watching" a source |
| 4. Source watching (section 7) | No subscription to any source exists. The register says so itself. EMP-018 proposes a monthly 30-minute read for EMP-004; nobody has set it up |
| 5. Counsel questions | EMP-004 wrote five questions for external counsel: (1) DPO duty and BDSG §26 (LR-02); (2) NIS2 size and sector reading (LR-03); (3) controller or processor for copies Ayka makes of customer data (GDPR Art. 28(10)); (4) works council status and BetrVG §87 (LR-11); (5) licence terms of the pipeline tools (LO-5, LR-08) |
| 6. Decision | Scenario decision by EMP-001: obtain a fixed-price opinion on questions (1) and (2) only. Questions (3) to (5) wait. Budget decision not recorded elsewhere |
| 7. Update | Register unchanged except a review date. A new row is added by EMP-004: employer duties for the personnel file (retention and access), because EMP-012's recruitment records raise the question (scenario) |

**Result.** The review can be carried out as a read-through and a question list. It cannot reach a legal conclusion without counsel. That is the register's own limit. **No row changed status.**

## Part 2. Intellectual property review, scenario (A.5.32)

POL-AUP-01 section 2: "Obtain owner approval before publication; check confidentiality, third-party rights and contract restrictions"; "install only reviewed, licensed software". POL-SDL-01 4.4: pin third-party code. Register section 5: Ayka's repository is Apache 2.0; pipeline tool licences are "to verify"; third-party Actions and providers have no recorded licences; standards text must be paraphrased.

Scenario walk on 2026-04-28:

| Topic | Result |
|---|---|
| Ayka's own work | Apache 2.0 licence file present. EMP-004 notes that employee contributions are made under the employment contract and an Apache licence at publication; nothing says who approves publication of a new document (POL-AUP-01 says "owner") |
| Inventory of tools, actions and libraries | EMP-013 listed the pinned tools from `toolchain.versions`, the Actions from the workflows and the providers from the lock files. **A list, not an inventory:** no licence column exists, no format, no owner, no storage |
| Licence compatibility with Apache 2.0 | Not possible without reading each licence. 15 minutes per item at best. Not done for any item |
| Standards text | EMP-018 spot-checked three ISMS documents for copied control text. The SoA says its labels "do not reproduce normative control text". No full check |
| Third-party content in documents | None known |
| Contribution intake | The repository is public. Nothing stops a pull request from an outside party. No contributor rule exists. (See [SIM-SDL-002](../sdlc/SIM-SDL-002-external-developer-engagement.md).) |

Result: the **walk can be done**: list, read, classify, decide. It cannot be finished for lack of the licence texts and a reviewer's time. The row for A.5.32 is raised to Simulated operation because the lawful-use steps of the written design (inventory, check, permission) were followed on paper and one real part was done (Part 3).

## Part 3. Real observation of the repository (2026-11-10)

This part is not scenario. It was done on the Authored date by reading metadata with tools on the author's machine. **It is a read of declared metadata, not a legal licence review.**

### 3.1 What was inspected

The local virtual environment `.venv` (git-ignored, on the author's machine) holds the Python test environment. Declared licences are those in each installed package's own metadata.

| Package (version) | Declared licence | In `tests/requirements.txt`? |
|---|---|---|
| pytest 9.1.1 | MIT | Yes, pinned `pytest==9.1.1` |
| PyYAML 6.0.1 | MIT | Yes, pinned `pyyaml==6.0.1` |
| exceptiongroup 1.3.1 | MIT | No (dependency of pytest) |
| iniconfig 2.3.1 | MIT | No (dependency of pytest) |
| packaging 26.3 | Apache-2.0 OR BSD-2-Clause | No (dependency of pytest) |
| pluggy 1.7.0 | MIT | No (dependency of pytest) |
| Pygments 2.21.0 | BSD-2-Clause | No (dependency of pytest) |
| tomli 2.5.0 | MIT | No (dependency of pytest) |
| typing_extensions 4.16.0 | PSF-2.0 | No (dependency of pytest) |
| pip 22.0.2, setuptools 59.6.0 | MIT (setuptools: classifier only, licence field "UNKNOWN") | No (environment tools) |

Both direct dependencies match the pinned versions. All declared licences are permissive and compatible with an Apache 2.0 repository **as declared**. The transitive packages are not pinned by version in the repository: `tests/requirements.txt` has two lines.

### 3.2 What was not inspected

- Licence texts of the three Terraform providers in the workload lock file (`hashicorp/aws` 5.100.0, `hashicorp/random` 3.8.1, `hashicorp/tls` 4.2.1). Versions read; licences not read. Other roots use further providers (`azuread`, `azurerm`).
- Licences of the pinned CLI tools: Terraform 1.7.5, TFLint 0.53.0, conftest 0.45.0, OPA 0.56.0, tfsec 1.28.14, Checkov 3.3.20. **The binaries on this machine are not the pinned ones** (Terraform reports 1.16.5; conftest 0.71.0 with OPA 1.21.0; Checkov 3.3.22), so the pinned releases' licence files cannot be read from it. From the author's general knowledge, not verified for this record, the vendor of Terraform moved newer releases from an open-source licence to a source-available licence in 2023, and whether version 1.7.5 sits under it and what use is allowed is exactly the question the register leaves open ("identify the exact terms covering Terraform 1.7.5"). It stays **to verify**.
- Six distinct third-party GitHub Actions are used, pinned by commit SHA: `actions/checkout`, `actions/setup-python`, `actions/upload-artifact`, `actions/download-artifact`, `hashicorp/setup-terraform`, `terraform-linters/setup-tflint`. Licences not read. `actions/upload-artifact` is pinned at **two different commits** in different workflows, so the same action runs at two versions.
- Tools that `security-checks.yml` installs (Bandit 1.8.6, pip-audit 2.9.0, cyclonedx-bom 7.1.0, gitleaks, actionlint, shellcheck): not installed here, licences not read.
- No copyright check of document text against the standards was run.

### 3.3 Other real observations

- 10 documents under `Governance/` outside the records carry "AI-drafted" in their revision history (for example [NIS2-06](../../../NIS2/06-customer-security-addendum.md)). Who owns and may publish AI-assisted text is a rights question the legal register does not name. LR-10 covers duties under the AI Act, not authorship (to verify).
- The register's own statements "read 2026-10-14" for HGB §257 and AO §147 are dated on the Authored side. A review at the scenario date would have to record its own reading date.

## Findings

1. **A.5.32 has no inventory format.** Register section 5 and LO-5 ask for a licence inventory. No format, storage or owner exists. Provide a table: component, version, licence, source of the licence text, compatibility note, reviewer, date.
2. **Transitive Python dependencies are not pinned.** `tests/requirements.txt` has two lines. Ten further packages arrive by resolution. POL-SDL-01 4.4 item 2 says Python test dependencies are pinned by exact version. The CycloneDX SBOM in `security-checks.yml` (which has not yet run on GitHub) would list them. A lock file with hashes would pin them.
3. **Pinned tools cannot be verified locally.** The environment where licences might be read does not hold the pinned versions. State where the licence of a pinned binary is read (the release archive's licence file, recorded with the checksum).
4. **Two pins of one action.** `actions/upload-artifact` runs at two different commits. The pins of Actions are not checked against each other by any test known to this record.
5. **Applicability cannot be concluded by staff.** The register says so. It does not say who pays for counsel and when the answer is due. LO-1 has no date.
6. **No place for "read on" dates in the review.** Statements "read 2026-10-14" pin a source version to a day. The review procedure should require the reviewer's own reading date for each source.
7. **No owner for watching sources.** Section 7 names the group (Compliance & Risk Management) and no person. No subscription exists.
8. **Authorship of AI-assisted drafts is unaddressed.** Ten documents say "AI-drafted". The register has no row for rights in such text (to verify with counsel).
9. **Publication approval is undefined.** POL-AUP-01 requires owner approval before publication. The repository publishes on merge. Nothing records an approval for documents.

## What this does not show

- A legal opinion. The five counsel questions are not answered.
- That any dependency or tool is compatible with an Apache 2.0 repository beyond what a package says about itself. Declared metadata can be wrong or incomplete.
- Any review of providers, pinned tools, Actions or scanner tools. They are listed as not inspected.
- A meeting on 2026-04-28 or counsel's engagement. Those are scenario.
