# REAL-ISMS-001: Actions only the repository owner can take (all open)

> **REAL RECORD.** Performed on the date shown. Scope and limits are stated below.

| Field | Value |
|---|---|
| Record ID | REAL-ISMS-001 |
| Performed | 2026-11-10 |
| Performed by | Repository owner, AI-assisted review of the repository (Claude Code reading files and running read-only commands) |
| Controls | ISO/IEC 27001:2022 clauses 5.1, 6.1.2, 7.5, 9.2, 9.3; A.5.17, A.5.19 to A.5.22, A.5.35, A.8.8, A.8.32; SOC 2 G14; RISK-001, RISK-002, RISK-005, RISK-007 |
| Related | [SoA 1.2](../../../ISMS/04-controls-and-soa/statement-of-applicability.md), [gap analysis 1.2](../../../ISMS/04-controls-and-soa/control-gap-analysis.md), [ISMS register](../../../ISMS/README.md) |

## 1. What this is

A list of things that need the repository owner's own hand: a GitHub setting, a credential, an acknowledgement, an approval, a choice of person. Per the [real records rules](../README.md), each stays **open** until the owner does it. Nobody has done any of them on the owner's behalf, and no AI agent may mark one done. When an item is done, add the date, what was done and the evidence to its row; do not delete the row.

What was actually performed on 2026-11-10 is the review that produced this list: reading the real records, the SoA and the gap analysis, and the read-only checks in section 3.

## 2. Open items

| ID | Action | Why | Source | Status |
|---|---|---|---|---|
| O-01 | Enable GitHub secret scanning and push protection on the repository | Not enabled when last read; gitleaks runs only in a workflow that has not yet run on GitHub | [POL-SDL-01](../../../policies/secure-development-policy.md) gaps; [REAL-SDLC-001](../sdlc/REAL-SDLC-001-first-local-scan.md) limits | Open |
| O-02 | Enable GitHub private vulnerability reporting | [`SECURITY.md`](../../../../SECURITY.md) and `security.txt` name a placeholder address; POL-VDP-01 points at private reporting | [POL-VDP-01](../../../policies/vulnerability-disclosure-policy.md) | Open |
| O-03 | Add the new CI jobs to the `protect-main` required checks: `Platform Gate (...)`, `Platform Validate (no scanner coverage)` and the Security Checks jobs, after their first green run on GitHub | Today a red platform or security job does not block a merge | [REAL-INFRA-001](../infra/REAL-INFRA-001-gate-run-all-roots.md) section 3; REAL-SDLC-001 | Open |
| O-04 | Resolve RISK-001: find out whether the Entra tenant and the accounts created from the bootstrap passwords existed; rotate or delete them; record the result | The passwords remain in public Git history; source cleanup cannot close this | [Risk register](../../../ISMS/03-risk-management/risk-register.md) RISK-001 | Open |
| O-05 | If the Azure storage account recorded in the local, untracked `Internal-IT/platform/foundation/remote-state/terraform.tfstate` still exists, rotate both storage access keys, then delete or move that state file | Section 3: the file holds populated `primary_access_key` and `secondary_access_key` attributes in plaintext. It is gitignored and not tracked, so it is not public, but it sits on the owner's disk | Section 3; RISK-002 | Open |
| O-06 | Decide about the Azure subscription ID hard-coded in the tracked backend block of `Internal-IT/platform/domains/identity/entra-id/provider.tf` (line 20): keep it (it is an identifier, not a secret) or move it to a backend config file outside git | It is public and identifies the owner's subscription | Section 3 | Open |
| O-07 | Hold and record a dated risk review of RISK-001 to RISK-013 | The scheduled 2026-09-30 review is overdue; the simulated review SIM-RISK-001 does not clear it | Risk register header | Open |
| O-08 | Read and acknowledge the policy set (dated list: policy ID, version, date) | No acknowledgement exists; the document control procedure 1.1 names this list as the evidence of publication | [Document control](../../../ISMS/00-context-and-governance/document-control-procedure.md) section 7 | Open |
| O-09 | Approve, or reject with reasons, the design baseline (scope, policy set, SoA 1.2, risk treatment plan) as the repository owner, and record the decision | Every document says "Draft. Not approved"; the simulated approval SIM-GOV-001 changes nothing | Document control section 5 | Open |
| O-10 | Store a copy of the evidence bundles and real records outside GitHub (for example a dated archive on separate storage) and record where and its checksum | GitHub keeps artifacts 90 days; the evidence-archive root is not deployed | RISK-007; gap G08 | Open |
| O-11 | Find an independent reviewer for the internal audit (a person who did not write or operate the work) | Nobody independent exists; the simulated audit used a fictional auditor | [Audit programme](../../../ISMS/09-internal-audit/audit-programme.md) section 3; gap G01 | Open |
| O-12 | Re-read the supplier pages marked "extract" in REAL-SUP-001 on the live sites, search the EU-US Data Privacy Framework list for AWS, Microsoft and GitHub, and confirm which GitHub terms govern the personal account | Those rows are second-hand; the DPF listing was not retrieved | [REAL-SUP-001](../supplier/REAL-SUP-001-supplier-attestations.md) O1, O3, O4 | Open |
| O-13 | Investigate why 14 of 20 push runs on `main` in October failed at the `apply` job (one was still waiting) and decide whether that is intended | A red run on `main` is the first thing an auditor sees; the README cites one of these runs | [REAL-SOC2-001](../soc2/REAL-SOC2-001-change-review-2026-10.md) F4 and follow-up 2; SOC 2 G14 | Open |

## 3. Checks performed for O-05 and O-06

Read-only, on 2026-11-10. No key or ID value was printed, copied or written anywhere.

```
git ls-files --error-unmatch Internal-IT/platform/foundation/remote-state/terraform.tfstate
  -> error: did not match any file known to git   (not tracked)
git check-ignore -v Internal-IT/platform/foundation/remote-state/terraform.tfstate
  -> .gitignore:6:*.tfstate                       (ignored)
jq '[.resources[] | select(.type=="azurerm_storage_account") | .instances[].attributes | keys[] | select(test("access_key"))] | unique'
  -> primary_access_key, secondary_access_key, shared_access_key_enabled
jq '[... .attributes.primary_access_key | length > 0]'
  -> [true]                                       (populated)
git ls-files Internal-IT/platform/domains/identity/entra-id/provider.tf
  -> tracked; line 20 is subscription_id inside the azurerm backend block
```

Whether the storage account or the subscription still exists was not checked: that needs the owner's Azure sign-in.

## 4. Limits

- This record lists actions; it shows none of them done.
- The list is what the review found on 2026-11-10. It is not a complete list of everything the owner must do before a real ISMS operates; the [gap analysis](../../../ISMS/04-controls-and-soa/control-gap-analysis.md) is the full list.
- GitHub settings (secret scanning, push protection, private vulnerability reporting, ruleset contents) were not re-read through the API in this review. Their state is taken from the documents dated 2026-10-14 and REAL-INFRA-001.
