# Document control procedure

| Field | Value |
|---|---|
| Document ID | ISMS-00-07 |
| Owner | CISO |
| Approver | Managing Director |
| Version | 1.0 |
| Effective | On approval |
| Next review | 12 months after approval, or when the repository host, the ruleset or the number of maintainers changes |
| Status | Draft. Not approved: no approval record exists (simulated company) |

> Ayka Secure Technologies GmbH is a simulated company. The document system described here is real: this Git repository on GitHub. Settings marked "read 2026-10-14" were read from the GitHub API on that date.

## 1. Purpose and scope

How Ayka creates, updates, approves, publishes, protects, retains and withdraws ISMS documents (ISO/IEC 27001:2022 clauses 7.5.2 and 7.5.3), and how it plans changes to the ISMS (clause 6.3). It covers every Markdown file under `Governance/` and `organization/`, and the policy-as-code files that act as documented information (`control-mapping.yaml`, `exceptions.yaml`). Records follow section 13.

## 2. Document system

| Element | Setting | Status and evidence |
|---|---|---|
| Repository | `Ayush-cloud06/Ayka-Secure-Technologies-GmbH` on GitHub, visibility **public** | Implemented. [Repository API](https://api.github.com/repos/Ayush-cloud06/Ayka-Secure-Technologies-GmbH), read 2026-10-14 |
| Write access | One account with the admin role; no other collaborator | Implemented. GitHub API `collaborators`, read 2026-10-14 |
| Default branch | `main`; work happens on short-lived branches | Implemented; [repository](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH) |
| Branch ruleset `protect-main` | Active on the default branch: pull request required, five required checks (`validate-scripts`, `unit-tests`, `compliance / validate`, `compliance / compliance`, `Control Validation Regression`), force-push and deletion blocked, no bypass actors. Required approvals: **0** | Implemented. [Ruleset 24482491](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/rules/24482491), rechecked 2026-10-14; configured 2026-10-05 per the [risk register](../03-risk-management/risk-register.md#review-history) |
| CODEOWNERS | [`.github/CODEOWNERS`](../../../.github/CODEOWNERS) names the owner for `Internal-IT/engineering/policy-as-code/`, `Internal-IT/engineering/ci-cd/scripts/` and `.github/`. It does **not** cover `Governance/`, `organization/` or `tests/`, and the ruleset does not require code-owner review, so it requests a review but blocks nothing | Partial |
| Commit messages | `type(scope): summary`, for example `docs(governance): ...`, as used in the history | Implemented (convention, not checked by a tool) |

## 3. Document register and identification

- The [ISMS index](../README.md) is the document register: every ISMS document with its area, status (Draft, Covered elsewhere, Planned) and evidence note. Owner and review date are in each document's header table. Policies are also listed in the [policy index](../../policies/README.md).
- A document exists only when its file exists and the register links it. A `Planned` row is an intention, not a document.
- Each controlled document starts with the header table: Document ID, Owner (a role, never a person), Approver, Version, Effective, Next review, Status. Older documents (for example the [scope](scope.md) and the [information security policy](information-security-policy.md)) use a bold-field header instead; they are brought into the table format at their next revision.
- Document IDs: `ISMS-<area>-<nn>` for ISMS documents (area = folder number), `POL-<topic>-<nn>` and `STD-<topic>-<nn>` for policies and standards, `NIS2-<nn>` and `SOC2-<nn>` in those folders.

## 4. Creating and updating

1. Create a branch from `main`.
2. Write or change the document in Markdown. Keep the header table and end with a `## Revision history` table.
3. Versions: `1.0` is the first issue. A wording or link fix raises the minor number (`1.1`); a change of meaning, scope or responsibility raises the major number (`2.0`). Each version adds one revision-history row with date and change.
4. Use the weakest true status label from the [SOC 2 status vocabulary](../../SOC2/README.md#4-status-vocabulary) for every control or claim, with an evidence link.
5. Open a pull request. Its description says what changed, why, and which risk, finding or objective it serves ([POL-CHG-01 §5](../../policies/change-management-policy.md#5-rules), rule 5).
6. Update the ISMS index row in the same pull request if a document is added, renamed, withdrawn or changes status.

## 5. Review and approval

| Step | How it would work | What happens today |
|---|---|---|
| Technical checks | The five required checks pass, including the docs gate (section 8) | Implemented: merge is blocked until they pass |
| Content review | A reviewer other than the author reads the change and approves the pull request | Unavailable today: one maintainer; required approving reviews remain 0 ([ruleset](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/rules/24482491), rechecked 2026-10-14) |
| Approval of the document | The approver named in the header (usually the Managing Director) approves; the approval is recorded as a dated pull-request approval or a dated entry in the document's decision record, and the Status changes to "Approved" with the date | No approval has been recorded for the simulated company. Drafts remain "Draft. Not approved". Nobody may write an approval, signature or date that did not happen |
| Effective date | "On approval" until an approval is recorded | All documents stay "On approval" |

This is the main gap in document control. It is recorded as RISK-005 and objective [OBJ-03](isms-objectives.md).

## 6. Content verification

A document can state a requirement without showing that it operates. Owners must check the evidence behind each claim and distinguish requirements, design and observed operation (RISK-008).

| Rule | Check |
|---|---|
| The owner reads the full diff before merge; a draft is not an approved decision | Manual |
| Automated review comments on a pull request are advisory and never count as review or approval | Manual |
| Every non-Planned claim carries an evidence link (file, `path#anchor`, CI run URL or control ID) | Manual; links checked by the docs gate (section 8) |
| Facts about laws, providers or certifications that were not checked against a primary source are marked "to verify" | Manual |
| No invented records: no approvals, minutes, signatures, training, audit or test results | Manual |
| The capability-claim check in section 8 is run before merge | Manual |

## 7. Distribution, access and use

- **Availability (7.5.3 a):** documents are readable by anyone at github.com and in every clone. Internal links are relative, so they work in a clone and on GitHub.
- **Protection (7.5.3 b):** only the maintainer account can change `main`, and only through a pull request with the required checks. Confidentiality is not protected: the repository is public (section 9).
- **Communication of changes:** see the [communication plan](communication-plan.md).

## 8. Automated and manual checks

| Check | What it does | Runs where | Status |
|---|---|---|---|
| Docs gate: [`tests/governance/test_docs.py`](../../../tests/governance/test_docs.py) with [`docs_check.py`](../../../tests/governance/docs_check.py) | Every relative link in `Governance/**/*.md` points to an existing file or folder; no Markdown file is empty or title-only | `unit-tests`, a required check, on every pull request and every push to `main` | Implemented since commit `ff48fb3` (2026-10-05) |
| Anchors | The docs gate strips `#...`, so section anchors are **not** checked | Author checks by hand against the heading | Manual |
| Unsupported capability claims | Check that statements about operation, protection and assurance have scoped evidence; remove or qualify unsupported claims | Author, before merge | Manual; no CI job |
| Further gate tests | [SoA structure](../../../tests/governance/test_soa.py) and [control-evidence index](../../../tests/governance/test_control_evidence_index.py) | `unit-tests` | Designed additions in this change; local/CI execution must be reported separately |

## 9. Classification and marking

- The repository is **public**: every committed file, and every earlier version in Git history, is published worldwide. In effect everything in the repository is Public under [POL-DATA-01 §4](../../policies/data-classification-and-confidentiality-policy.md#4-classification-levels).
- Some documents carry a `Classification: Internal` row (for example POL-DATA-01 and [NIS2-01](../../NIS2/01-applicability-assessment.md)). That label describes how the simulated company would handle the document; it does not describe its actual exposure, which is public.
- Never commit Internal, Confidential or Restricted information: no secrets, credentials, real personal data beyond the maintainer's own commit metadata, customer data or security findings about real systems. A mistake cannot be removed by a later commit; it stays in Git history and pull-request refs (see RISK-001).
- New documents use the header table in section 3, without a classification row.

## 10. Storage, retention and disposition

| What | Where | Retention | Status |
|---|---|---|---|
| Current documents | [repository](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH) `main` branch | While the repository exists | Implemented |
| Earlier versions | Git history (`git log -- <path>`, `git show <commit>:<path>`) | While the repository exists. History can be rewritten by an admin and has been before (a local tag `backup/baseline-pre-rewrite` exists); it is retention, not tamper-proof storage | Partial |
| Restore baseline | Annotated tag `baseline-2026-10`, tagged 2026-09-28, pointing at commit `33593d6` (2026-08-23), present on the remote. The [ISMS index](../README.md) uses it to retrieve removed placeholder files | Kept, but not immutable: no tag ruleset protects it, so it can be moved or deleted | Partial |
| Pull requests and review comments | [GitHub pull requests](https://github.com/Ayush-cloud06/Ayka-Secure-Technologies-GmbH/pulls) | While the repository exists | Implemented |
| CI evidence bundles and logs | GitHub Actions artifacts | 90 days, the maximum for this repository (read 2026-10-14). Too short for an audit period (RISK-007, [OBJ-08](isms-objectives.md)) | Partial |
| Copies | Local clones | Not managed | Not controlled |

Retention periods per record type are set in the [records and data retention policy](../../policies/records-and-data-retention-policy.md).

## 11. Obsolete documents

1. Withdraw a document by deleting its file in a pull request and changing or removing its row in the ISMS index. The pull request says why and what replaces it.
2. Do not keep obsolete copies in the working tree. Earlier versions stay retrievable through Git history (section 10).
3. If a document has to stay for reference, its Status becomes "Superseded by <ID>" and the index row says so.
4. Links to a removed file fail the docs gate, so every reference has to be updated in the same pull request.

## 12. External documents

- Standards (ISO/IEC 27001:2022 and Amd 1:2024, SOC 2 criteria, VDA ISA), laws and provider terms are external documents. They are identified by title, version or date and link in the [legal and regulatory register](legal-and-regulatory-register.md) or in the document that uses them.
- They are not copied into the repository: the standards are copyrighted, and laws and terms change (legal register section 5).
- The owner of the legal register row watches for new versions (legal register section 7).

## 13. Records

- Records (review results, approvals, incidents, training completions, audit results) are documented information that proves an activity happened. They are only written when the activity really happened, with a date and evidence.
- Logs and record templates without real entries say "No entries yet" and why.
- Where records live: CI run history and evidence bundles (GitHub Actions); pull requests and approvals (GitHub); logs under `Governance/ISMS/` (for example the [risk acceptance log](../03-risk-management/risk-acceptance-log.md)). Templates for records are in [SOC2-05 §7](../../SOC2/05-audit-approach-and-evidence.md#7-record-templates).

## 14. Planning changes to the ISMS (clause 6.3)

A change to the ISMS is a change to scope, policy, roles, risk method, controls or this procedure. It is planned before it is made:

| Question | Where it is answered |
|---|---|
| Purpose of the change and its consequences | Pull request description; for significant changes, an entry in the [improvement register](../11-improvement/improvement-register.md) |
| Effect on the integrity of the ISMS (documents, links, controls that depend on it) | Pull request description; docs gate; affected ISMS index rows updated in the same pull request |
| Resources needed | [ISMS objectives §4](isms-objectives.md) |
| Who is responsible | Owner role in the header of each affected document |
| Risk impact | New or changed risks go into the [risk register](../03-risk-management/risk-register.md) through the [risk management methodology](../03-risk-management/risk-management-methodology.md) |

Significant changes (scope, policy, roles, risk criteria) are presented at the next management review ([agenda](../10-management-review/management-review-agenda.md)). No management review has taken place yet.

## 15. Current gaps

| Gap | Consequence | Reference |
|---|---|---|
| No second person can review or approve | No document is approved; segregation of duties absent | RISK-005, [OBJ-03](isms-objectives.md) |
| CODEOWNERS does not cover `Governance/` and code-owner review is not required | Governance changes get no owner-review request; even gate paths can merge without one | Section 2. [POL-CHG-01 §5](../../policies/change-management-policy.md#5-rules) rule 4 states that CODEOWNERS review is required; the ruleset does not require it |
| Tags and history can be changed by the admin | Retention depends on one account's conduct | Section 10 |
| CI evidence kept 90 days | Evidence for a 12-month period is lost | RISK-007, [OBJ-08](isms-objectives.md) |
| Anchors and capability claims not checked automatically | Broken section links and overstated claims can merge | Section 8 |

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-14 | First issue |
