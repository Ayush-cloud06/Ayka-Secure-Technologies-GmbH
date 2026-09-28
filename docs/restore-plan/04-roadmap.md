# 04 · Roadmap: phases, milestones, timeline

> **Assumption:** 2 sessions a week of 1–2 hours, **Tuesday and Thursday evenings**, starting the week of **2026-10-05**. Move the days freely; the order matters, the dates don't.
> **Core restoration:** 13 sessions (about 20 hours) → **flagship-ready by Sat 2026-11-21**, with one buffer session.
> **Phase 6** is optional growth, December 2026 – January 2027.

---

## 1. Schedule

```mermaid
gantt
    title Restoration schedule, 2 sessions per week
    dateFormat YYYY-MM-DD
    axisFormat %d %b
    section Phase 0 Orient
    S1 baseline tag, tools, local chain      :p0a, 2026-10-06, 1d
    M0 baseline recorded                     :milestone, m0, 2026-10-06, 0d
    section Phase 1 Secrets
    S2 inspect accounts and OIDC role        :p1a, 2026-10-08, 1d
    S3 refactor passwords, fix risk register :p1b, 2026-10-13, 1d
    M1 no plaintext secrets in HEAD          :milestone, m1, 2026-10-13, 0d
    section Phase 2 Codex triage
    S4 find or declare lost                  :p2a, 2026-10-15, 1d
    M2 codex decision recorded               :milestone, m2, 2026-10-15, 0d
    section Phase 3 Prune
    S5 empties in Internal-IT                :p3a, 2026-10-20, 1d
    S6 governance stubs and ISMS index       :p3b, 2026-10-22, 1d
    S7 renames, links, gitignore, dry checks :p3c, 2026-10-27, 1d
    M3 zero empty files                      :milestone, m3, 2026-10-27, 0d
    section Phase 4 Pipeline honest green
    S8 tfsec path and workload dir           :p4a, 2026-10-29, 1d
    S9 evaluator input checks and tests      :p4b, 2026-11-03, 1d
    S10 strict regression, checksums, OIDC   :p4c, 2026-11-05, 1d
    S11 triage portal, pin, GitHub settings  :p4d, 2026-11-10, 1d
    M4 honest green run URL                  :milestone, m4, 2026-11-10, 0d
    section Phase 5 README and demo
    S12 README rewrite                       :p5a, 2026-11-12, 1d
    S13 doc fixes and demo rehearsal         :p5b, 2026-11-17, 1d
    Buffer and review                        :buf, 2026-11-19, 1d
    M5 flagship-ready                        :milestone, m5, 2026-11-21, 0d
    section Phase 6 Optional growth
    6a remote state for ayka-portal          :p6a, 2026-12-01, 12d
    6b small real sandbox apply              :p6b, 2026-12-14, 10d
    6c governance linked to evidence         :p6c, 2027-01-05, 12d
```

| Phase | Goal | Sessions | Dates | Hours |
|---|---|---:|---|---:|
| [0 Orient](05-phase-playbooks/phase-0-orient.md) | re-learn, install tools, record a baseline | 1 | Tue 10-06 | 1.5 |
| [1 Secrets](05-phase-playbooks/phase-1-secrets.md) | no plaintext credentials; exposure decision; inspect the OIDC role | 2 | Thu 10-08, Tue 10-13 | 3 |
| [2 Codex triage](05-phase-playbooks/phase-2-codex-branch-triage.md) | find the AI branch or declare it lost | 1 | Thu 10-15 | 1 |
| [3 Prune](05-phase-playbooks/phase-3-prune.md) | zero empty files, one pipeline source, fixed names and links | 3 | Tue 10-20, Thu 10-22, Tue 10-27 | 4.5 |
| [4 Pipeline honest-green](05-phase-playbooks/phase-4-pipeline-green.md) | fail-open bugs fixed, tests in CI, strict regression, GitHub settings | 4 | Thu 10-29, Tue 11-03, Thu 11-05, Tue 11-10 | 8 |
| [5 README + demo](05-phase-playbooks/phase-5-readme-and-demo.md) | honest README, doc fixes, 3-minute demo | 2 | Thu 11-12, Tue 11-17 | 3 |
| Buffer | catch-up or rest | 1 | Thu 11-19 | 0–2 |
| [6 Next growth](05-phase-playbooks/phase-6-next-growth.md) | optional: remote state → sandbox apply → governance links | open | Dec – Jan | — |

> **Why this order?**
> 1. **Secrets first:** the exposure is public today and doesn't depend on anything else.
> 2. **Codex before prune:** don't delete things you might want to compare against.
> 3. **Prune before pipeline work:** fewer files, and no duplicate pipeline YAMLs to confuse you.
> 4. **Pipeline before README:** the README has to describe what the pipeline really does.

---

## 2. Phases with "stop and review" gates

Every gate is a 10-minute check at the end of a phase. If a gate fails, you go back into the phase, not forward.

```mermaid
stateDiagram-v2
    [*] --> Orient
    Orient --> Gate0
    Gate0 --> Secrets : baseline tag pushed, local chain matches run 68
    Gate0 --> Orient : results differ, investigate first
    Secrets --> Gate1
    Gate1 --> CodexTriage : no literals in HEAD, decision written
    Gate1 --> Secrets : validate fails or decision missing
    CodexTriage --> Gate2
    Gate2 --> Prune : ADR-0003 has an outcome
    Prune --> Gate3
    Gate3 --> PipelineGreen : 0 empty files, 8 of 8 roots validate, 0 references
    Gate3 --> Prune : something references a deleted path
    PipelineGreen --> Gate4
    Gate4 --> ReadmeDemo : green run with tfsec in by_tool, tests in CI
    Gate4 --> PipelineGreen : CI red or regression not strict
    ReadmeDemo --> Gate5
    Gate5 --> FlagshipReady : DoD D1 to D10 checked
    Gate5 --> ReadmeDemo : a claim has no evidence
    FlagshipReady --> NextGrowth : optional
    FlagshipReady --> [*]
    NextGrowth --> [*]
```

**At every gate, ask these four questions (write the answers in your commit message or a short note):**

1. Is `git status` clean, and is everything pushed?
2. Is CI green on the latest commit? If red, is that expected and explained?
3. Can I explain every change in this phase out loud, without notes?
4. Did I update the progress tracker in [README.md](README.md) and any ADR status?

---

## 3. Milestones and proof

| Milestone | Target date | Proof it's done |
|---|---|---|
| **M0** Baseline recorded | 2026-10-06 | tag `baseline-2026-10` on `53b0532` visible on GitHub; run #68 artifacts saved locally; your local chain prints `pass` 0/0/14 for ayka-portal |
| **M1** No plaintext secrets in HEAD | 2026-10-13 | `git grep -nE 'password[[:space:]]*=[[:space:]]*"' -- '*.tf'` is empty on `main`; ADR-0007 **Accepted** with your rotation/history decision; `risk-register.md:21` corrected |
| **M2** Codex decision recorded | 2026-10-15 | ADR-0003 **Accepted** with "recovered and archived at …" or "declared lost on …" |
| **M3** Zero empty files | 2026-10-27 | the Phase 3 empty-file check prints only `vpc/permissive-network-acl/main.tf` (implemented in Phase 4); `git ls-files \| wc -l` ≈ 203 outside `docs/` (201 after Phase 4 removes `OPA/aws`); 8/8 roots validate (dry-run result on 2026-09-28) |
| **M4** Honest green | 2026-11-10 | **URL of a green run on `main`** whose summary lists `checkov`, `opa` **and** `tfsec` in `by_tool`, with pytest and `opa test` steps; the regression job is strict; screenshot of the branch ruleset |
| **M5** Flagship-ready | 2026-11-21 | new README merged; Definition of Done D1–D10 ([02-target-state.md §6](02-target-state.md#6-definition-of-done-flagship-ready)) ticked; demo rehearsed in under 3 minutes |
| M6a Remote state | Dec 2026 | ayka-portal `terraform init` uses a remote backend; drift workflow run shows "No changes" against real state |
| M6b Sandbox apply | Dec 2026 | a CI or local run that really applied a small slice, then destroyed it; budget alarm screenshot |
| M6c Governance linked | Jan 2027 | risk register / SoA rows cite control IDs from `control-mapping.yaml` and CI run URLs; no broken links |

---

## 4. Three-month vision

```mermaid
timeline
    title Ayka gate, October 2026 to January 2027
    section Restore
        Oct 2026 : Orient and baseline tag
                 : Secrets removed and exposure decided
                 : Codex branch archived or declared lost
                 : 172 placeholder files pruned
    section Make it true
        Nov 2026 : tfsec findings counted, inputs validated
                 : Tests and strict regression in CI
                 : Branch protection and reviewers
                 : Honest README and 3-minute demo
    section Grow
        Dec 2026 : Remote state for ayka-portal
                 : Small real sandbox apply then destroy
        Jan 2027 : Governance rows linked to control IDs and CI evidence
                 : Optional Rego v1 migration
```

---

## 5. How to run a session (the same every time)

| Minutes | What you do |
|---:|---|
| 0–10 | Re-read the phase playbook section you're on. Run `git pull` and `git status`. |
| 10–80 | Do the next 1–3 numbered steps. Commit after each step. |
| 80–90 | Push. Tick the checklist. Write one line in the tracker: "stopped at step N, next is …". |

**If you miss a week:** nothing breaks. Every playbook has a *safe stopping point*. Restart at the step your tracker note names. Don't try to catch up by doing two phases in one session: that's how the first round got fragmented.
