# ADR-0009: Governance documents must link to real evidence

- **Status:** Proposed
- **Date:** 2026-09-28
- **Deciders:** Ayush (owner)

## Context and problem statement

Your best writing in this repository is the risk-management set in `Governance/ISMS/03-risk-management/`. It does things most portfolio projects don't:

- It rates every risk with an **evidence-confidence** level (E1 Defined → E4 Operating, `risk-management-methodology.md:87-90`). The register shows that level per row (`risk-register.md:19-33`).
- It defines strict status rules. For example, "Closed" requires treatment evidence and review (`risk-register.md:50-56`).
- It refuses to invent records: "Creating meeting minutes … now would manufacture evidence" (`2026-q1-risk-assessment.md:12`).

That is the model this ADR keeps. What breaks it is where the evidence points:

- **10 links go to `AUDIT/`**, a folder that is ignored by git (`.gitignore:23`) and was never committed. On GitHub they are all broken:
  - `risk-register.md:15` (three links)
  - `risk-management-methodology.md:36,167-169`
  - `2026-q1-risk-assessment.md:19-20`
- **Some statuses describe the discarded AI-cleanup state, not `main`:**
  - RISK-001 "current source is clean" (`risk-register.md:21`, see ADR-0007)
  - TRT-003 "Source work started" (`risk-treatment-plan.md:22`)
  - TRT-006 "Source correction complete" (`:25`)

  But `git diff 243c3b1 53b0532 -- Internal-IT .github tests` is empty.
- **"124 Checkov failures"** (`risk-register.md:29`, `risk-treatment-plan.md:28`) has no artifact behind it. CI on `main` reports 14 Checkov findings for ayka-portal (run #68). Which state or scan produced 124 is **UNVERIFIED**.
- Across all 8 risk documents there are **zero** repository paths and **zero** `control-mapping.yaml` control IDs ([research/inventory.md](../research/inventory.md) §6.1). The documents describe the gate, but they don't point at it.

> **Why this matters to you:** a governance document is only as strong as its weakest link, literally. An auditor, or an interviewer, clicks one evidence link. If it 404s, every other claim in the document loses credibility, even the true ones.

## Decision drivers

- Every link must resolve for a stranger on GitHub.
- Evidence must outlive GitHub's retention: artifacts expire (run #68's on 2026-11-21) and logs expire (drift logs already return HTTP 410).
- Keep the risk-register style. Change links and statuses, not the method.
- Never commit secrets or unreviewed AI output as "evidence".

## Considered options

1. Commit the local `AUDIT/` folder as it is.
2. Replace every `AUDIT/` link with a repository `path:line`, a CI run URL, or a **committed evidence snapshot**.
3. Delete the links and leave the statements unsupported.
4. Leave the documents unchanged.

## Decision outcome

Chosen option: 2. Each claim in a governance document links to one of three things, in this order of preference:

1. **Repository path and line**, for claims about code or configuration. Example: `evaluate-results.py:417-421` for the decision rule.
2. **CI run URL**, for claims about behaviour. Example: run #68 for "the regression workload fails".
3. **Committed evidence snapshot**, for claims that must outlive GitHub retention. This is a folder such as `docs/evidence/2026-10-baseline/` containing:
   - `compliance-summary.json`, `compliance-report.md` and `artifacts.sha256`, downloaded from the run;
   - a short README with the run URL, commit SHA, date and tool versions.

   **Do not commit `tfplan.json` as-is.** The plan JSON embeds provider credentials as `constant_value` (mock values today; [research/terraform.md](../research/terraform.md) §4).

Also:

- Correct the statuses that describe fixes not on `main`: RISK-001, TRT-003 and TRT-006.
- Re-source or remove "124 Checkov failures".
- Where there is no evidence yet, say so. "E1 — no evidence yet" is a valid entry. Your own methodology says so.

## Consequences

### Positive

- Every governance link works for a stranger.
- The governance layer points at the gate, and the gate produces the evidence. That link is the whole point of "compliance as code".
- The run #68 baseline survives the 2026-11-21 artifact expiry (milestone M0 downloads it in Phase 0).

### Negative

- Snapshots are frozen. They need a date in their name, and they go stale. A snapshot is evidence *of that date*, never of "now".
- A few KB of JSON is committed. Keep snapshots few: a baseline, the "honest green" run (M4), and later milestones.
- `AUDIT/` may contain useful notes, but they stay local. Anything you want to cite must be rewritten, reviewed and committed first, and the risk docs must be edited to match.
- Correcting RISK-001, TRT-003 and TRT-006 makes the register look *less* advanced. That is the accurate position.

## Pros and cons of the options

### 1. Commit `AUDIT/`

- Good: links work immediately.
- Bad: content unreviewed here and probably AI tool output (it was gitignored together with `annotations` and `graphify-out` in fe1b27e). It may contain things you don't want public.

### 2. Paths, run URLs and snapshots

- Good: verifiable, and durable when snapshotted.
- Bad: one session of careful editing.

### 3. Delete the links

- Good: quick.
- Bad: claims lose their support. That is the opposite of your methodology.

### 4. Leave unchanged

- Good: none.
- Bad: 10 broken links and three statuses that are false for `main`.

## Evidence

- `Governance/ISMS/03-risk-management/risk-register.md:15,19-33,21,29,50-56`
- `Governance/ISMS/03-risk-management/risk-management-methodology.md:36,87-90,167-169`
- `Governance/ISMS/03-risk-management/risk-assessment-results/2026-q1-risk-assessment.md:12,19-20`
- `Governance/ISMS/03-risk-management/risk-treatment-plan.md:22,25,28`
- `.gitignore:23` (`AUDIT/`). `git ls-files | grep -c '^AUDIT/'` gives 0.
- `git diff --stat 243c3b1 53b0532 -- tests .github Internal-IT` prints nothing.
- Run #68: <https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/actions/runs/32621618951>. Artifacts expire 2026-11-21 ([research/facts-lead.md](../research/facts-lead.md), GitHub API `expires_at`).
- [research/inventory.md](../research/inventory.md) §6.1: 0 repository paths and 0 control IDs across the 8 risk documents.

## Links

- Related: [ADR-0006](0006-honesty-labelling.md), [ADR-0007](0007-entra-bootstrap-secrets.md), [ADR-0004](0004-delete-placeholders.md)
- Phase playbooks: [phase 0](../05-phase-playbooks/phase-0-orient.md) (download artifacts), [phase 5](../05-phase-playbooks/phase-5-readme-and-demo.md), [phase 6](../05-phase-playbooks/phase-6-next-growth.md)
