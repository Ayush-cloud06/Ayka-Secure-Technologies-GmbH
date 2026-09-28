# ADR-0004: Remove placeholder and empty files rather than filling them

- **Status:** Proposed
- **Date:** 2026-09-28
- **Deciders:** Ayush (owner)

## Context and problem statement

Of the 373 tracked files, 75 are empty, 80 contain only a `# Title` line and 12 are short stubs. That is 167 files, 45% of the repository, that say nothing.

A reviewer who clicks three folders and finds three empty files will assume the rest is empty too. That includes the parts that work.

The placeholders come from two places:

- **Early scaffolding.** Most of the 75 empty files are under `Internal-IT/`: `engineering` 23, `assurance` 19, `platform` 12, `workloads` 10.
- **A deliberate skeleton.** In fe1b27e you **added 84 "# Title" stubs** under `Governance/ISMS/00-…` to `11-…`, using the names from the AI's ISMS tree. 77 of them are still title-only. The other 7 have since become real risk-management documents.

That second group matters. It records an intent: you wanted a complete ISO 27001 document set. The question is how to keep that intent without shipping 77 empty pages.

Your own risk register already answers half of this. RISK-010 and RISK-011 "require real activities and processing facts, not additional blank templates" (`risk-register.md:42`). The treatment plan says operating records should "use actual decisions and data flows rather than retroactive paperwork" (`risk-treatment-plan.md:44`).

> **Why this matters to you:** an empty file is a promise with no date. One table that says "planned, not started" is honest and takes 30 seconds to read. Filling 77 ISO documents in six weeks would produce exactly the "manufactured evidence" your Q1 assessment warns against (`2026-q1-risk-assessment.md:12`).

## Decision drivers

- Every file on `main` should have content that someone would miss if it were gone.
- Keep your intent (the ISO document skeleton) visible and dated.
- Don't fabricate governance records to fill gaps.
- Don't break anything. Some empty files are load-bearing (see Consequences).
- Fit in Phase 3's three sessions.

## Considered options

1. Fill every placeholder with content.
2. Leave the placeholders as they are.
3. Delete the placeholders, and keep the intent in **one** "planned documents" index.
4. Move the placeholders into a `_planned/` folder.

## Decision outcome

Chosen option: 3. It removes 153 files that carry no information and keeps your ISO skeleton as a single, reviewable list.

- `Governance/ISMS/README.md` is title-only today. It becomes the index: a table with columns *Document*, *ISO 27001 clause or Annex A reference*, *Status* (`Planned` / `Draft` / `In use`), *Evidence link*.
  - Every one of the 77 remaining fe1b27e stubs becomes a row with Status `Planned`.
  - The 7 documents that exist get `In use` and a link.
- `Governance/ISMS/tree.md` (134 lines, and matched by `.gitignore:68` anyway) is folded into that index, then deleted.
- When you really write one of those documents, add the file and change its row. Nothing else changes.
- The 12 stubs are judged one by one. [inventory/file-disposition.md](../inventory/file-disposition.md) marks 10 for deletion and 2 for rewriting.

## Consequences

### Positive

- 0 empty files on `main` (milestone M3). A reviewer never lands on a blank page.
- Your ISO skeleton survives as one table. It is more useful than 77 files, because it shows status and gaps at a glance.
- It fits the evidence-first style you already use in `03-risk-management/`.

### Negative

- The tree looks smaller. After Phase 3 there are about 195–205 files. Don't read that as losing work.
- Deleted paths break any bookmark or link pointing at them. `git grep -F` found no workflow, script or test that references an empty file ([research/inventory.md](../research/inventory.md) §2). Prose links still need a check.
- Two empty files are **load-bearing** and must not be bulk-deleted:
  - `Internal-IT/platform/domains/identity/entra-id/modules/output/compliance.tf` is the only file of a module called at `entra-id/main.tf:28-30`. Remove the module block first.
  - `control-validation-scenarios/vpc/permissive-network-acl/main.tf` is wired in at `control-validation-scenarios/main.tf:21-24`. [inventory/file-disposition.md](../inventory/file-disposition.md) marks it FIX in Phase 4 (implement the NACL scenario), not delete.
- Folders that become empty disappear, because git does not track empty directories. If a folder name documents a design (for example `Internal-IT/assurance/`), mention it in the index or README.

## Pros and cons of the options

### 1. Fill everything

- Good: looks complete.
- Bad: weeks of work with no real activity behind it. It produces backdated or invented records, which your own methodology forbids (`2026-q1-risk-assessment.md:12`).

### 2. Leave as is

- Good: zero effort.
- Bad: 45% of the repository stays blank, and reviewers judge the whole project by it.

### 3. Delete and keep one index

- Good: honest, small, reversible (git history keeps every path), and it keeps your intent.
- Bad: needs care around the two load-bearing files and prose links.

### 4. Move to `_planned/`

- Good: keeps the files.
- Bad: still 150+ empty files. Only the location changes.

## Evidence

- [research/inventory.md](../research/inventory.md) §2–§3: 75 empty, 80 title-only, 12 stub. All 80 title-only files are under `Governance/ISMS/`.
- `git show --name-status --format= fe1b27e` gives 84 `A` and 5 `M`. Of the 84 added paths, 77 are title-only today and 7 are substantive (cross-checked against [research/inventory.md](../research/inventory.md) §3).
- `Governance/ISMS/README.md:1`: the only line is the title.
- `Governance/ISMS/03-risk-management/risk-register.md:42`: "real activities and processing facts, not additional blank templates".
- `Governance/ISMS/03-risk-management/risk-treatment-plan.md:44`: "rather than retroactive paperwork".
- `Governance/ISMS/03-risk-management/risk-assessment-results/2026-q1-risk-assessment.md:12`: "would manufacture evidence".
- [inventory/file-disposition.md](../inventory/file-disposition.md): of the 155 empty or title-only files, 153 are DELETE and 2 are FIX.
- `Internal-IT/platform/domains/identity/entra-id/main.tf:28-30` and `Internal-IT/workloads/control-validation-scenarios/main.tf:21-24`: the load-bearing references.

## Links

- Related: [ADR-0003](0003-codex-branch-parts-bin.md) (why the prune waits for Phase 2), [ADR-0005](0005-github-single-source-of-truth.md), [ADR-0009](0009-governance-links-evidence.md)
- File-by-file list: [inventory/file-disposition.md](../inventory/file-disposition.md)
- Phase playbook: [phase 3 – prune](../05-phase-playbooks/phase-3-prune.md)
