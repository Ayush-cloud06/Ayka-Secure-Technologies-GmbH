# SIM-ACC-002 Credential and secret handling check

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-ACC-002 |
| Authored | 2026-11-10 |
| Scenario date | 2026-06-29 |
| Participants | EMP-014 (Vulnerability Manager, runs the check), EMP-003 (Privileged Administrator, owner of the identity code), EMP-013 (CI/CD), EMP-011 (password manager administration), EMP-002 (CISO, decisions) |
| Procedure exercised | [Access control policy POL-AC-01](../../../policies/access-control-policy.md) section 4.2 (authentication, items 1 to 5) and section 4.5; [Cryptography policy POL-CRY-01](../../../policies/cryptography-policy.md) section 4.6 (secrets) |
| Controls | ISO/IEC 27001:2022 Annex A A.5.17 (not raised); looked at: A.8.5, A.8.24. SOC 2 AC-01, AC-14 |

This record mixes two kinds of statement and keeps them apart. **Scenario** statements are marked as such. **Real observation (2026-11-10)** statements are about the repository as it exists, found by reading it with `git` on the Authored date. Secret values are never written here.

## 1. The check as the two documents define it

There is no written "credential check procedure". The check was built from the rules:

| Rule | Source | Test the walk used |
|---|---|---|
| MFA for every interactive login to Entra ID, AWS, GitHub and administrative functions | POL-AC-01 4.2 item 1 | Read the tenant setting. Try a sign-in without a second factor |
| Tier 0 uses FIDO2 keys or passkeys | 4.2 item 2 | Count registered keys for Tier 0 accounts |
| Legacy authentication that cannot do MFA is blocked | 4.2 item 3 | Read the tenant setting |
| Passwords at least 14 characters, not reused, approved manager allowed and encouraged | 4.2 item 4 | Read the password policy; count manager enrolment |
| Secrets never committed. Initial passwords generated (`random_password`) and handed out of band; changed at first login | 4.2 item 5 and POL-CRY-01 4.6 item 1 | Read the Terraform that creates users. Search the tree and history |
| Runtime secrets in Secrets Manager under the key, rotated at least every 90 days in production | POL-CRY-01 4.6 item 2 | Read the workload Terraform |
| Generated secrets sit in state, so state is Restricted until a managed source exists | POL-CRY-01 4.6 item 3 | Where is state, who can read it |
| No IAM users or long-lived keys for people | POL-AC-01 4.1 item 3 | Gate rule `IAM_USER_PROHIBITED` and an account list |

## 2. Results

### Scenario readings (no tenant or account exists)

| Test | Result (scenario) |
|---|---|
| MFA at sign-in | Conditional Access is off and the tenant is on the Free plan. A test sign-in with a password alone succeeded for a standard user. For the 4 admin accounts, the same |
| FIDO2 keys for Tier 0 | 0 of 4 admin accounts have a key. None were bought. This matches [SIM-PPL-004](../people/SIM-PPL-004-leaver-emp-023.md) ("none issued") for the leaver |
| Legacy authentication | Cannot be read on the Free plan. Not verifiable |
| Password length and reuse | The tenant default is read. Whether it equals 14 characters is not shown by the plan |
| Password manager | 18 of 24 enrolled. EMP-011 administers it. The break-glass entries sit in a shared vault with no custody record (same gap as [SIM-ACC-001](SIM-ACC-001-q2-2026-access-review.md)) |
| Personal access tokens on GitHub | Not listable by the organisation (SIM-PPL-004 finding 7) |

### Real observation (2026-11-10)

| Test | Result |
|---|---|
| Hard-coded passwords in source | At commit `1aa4349` (2026-04-16, the last commit before the scenario date) three Terraform files assign a literal string to `password`: `Internal-IT/platform/domains/identity/entra-id/modules/core/users.tf` (line 16), `modules/privileged/admin_accounts.tf` (line 9) and `modules/privileged/break_glass.tf` (line 6). Values not copied |
| Break-glass account settings | In the same commit `break_glass.tf` sets `force_password_change = false` and `disable_password_expiration = true` next to the literal. The rule "the person changes it at first login" is not met for the emergency account by design |
| Where the files sit in history | The paths exist in their current place since the restructure commit `f15021e` (2026-03-19). RISK-001 in the [risk register](../../../ISMS/03-risk-management/risk-register.md) states public exposure since 2026-03-22. Earlier history under older paths was not traced |
| Removal | Commit `b364d60` (2026-09-28, "fix(identity): remove hard-coded Entra passwords") changed `break_glass.tf`. The register says the literals were replaced by `random_password` and a manually managed break-glass account on that date. The values stay in public history (SECURITY.md, "Known history") |
| Secret scanning | [POL-SDL-01](../../../policies/secure-development-policy.md) section 4.4 item 6 says the repository's gitleaks default rules did not flag these passwords, and that GitHub-native secret scanning and push protection were disabled when last read (2026-10-14). A clean scan result therefore proves nothing |
| Tenant check | Whether the accounts these passwords created ever existed in a tenant is still open (owner action O-04 in REAL-ISMS-001) |

## 3. Scenario of what the check does with the real finding

- 2026-06-29 11:00: EMP-014 finds the three literals by reading the Terraform after the scan came back clean. He tells EMP-002 at 11:20.
- EMP-002 decides (scenario decision): treat as RISK-001 follow-up, rotate by deleting and recreating the accounts, replace literals with generated values, create the break-glass entry by hand with a custody record. Owner EMP-003. Planned date 2026-07-31.
- Whether the tenant ever used the literals is not known. No sign-in log older than 7 days exists on the Free plan. EMP-014 cannot say.
- **The real record shows the fix landed on 2026-09-28, 59 days after the scenario's planned date.** The scenario does not explain why. A real tracked action with an owner and a date would have; none exists (SIM-CAPA-007 describes the same pattern for other items).
- Prior disclosure to anyone: none. The passwords are in a public repository. EMP-002 records that public history cannot be repaired.

## 4. Result for A.5.17

The control is "credentials and secrets are allocated, protected and not exposed". The check found three exposed initial passwords in a public repository (one for an emergency account that never needs to change), no phishing-resistant method for any Tier 0 account and an unverifiable tenant state. The walk shows the rule is not met. As with A.5.3 (no second approver), real evidence of failure keeps the row at **Designed**.

## Findings

1. **There is no credential check procedure.** POL-AC-01 and POL-CRY-01 state rules and no one owns testing them. The check above was improvised by EMP-014. Name an owner, a frequency and a list of tests.
2. **Clean scan result gives false assurance.** The gitleaks default rules did not match the real literals (a password assigned in Terraform). A custom rule for `password =` and similar assignments in `.tf` files, with a known-bad test, is missing. See also REAL-SDLC-001.
3. **"Initial passwords are generated and handed out of band" and the break-glass design contradict.** The emergency account needs a password that is neither generated by Terraform (it lands in state, POL-CRY-01 4.6 item 3) nor changed at first login. The policy has no design for emergency credentials. The 2026-09-28 change moved it to "manual" with no custody procedure.
4. **Break-glass custody has no record format.** POL-AC-01 section 4.5 says dual control for the management root user. For the two Entra emergency accounts it names no custodian, no storage and no test cadence (RISK-013).
5. **MFA coverage is not measurable.** POL-AC-01 4.2 asks for MFA on all interactive logins. The Free plan gives no report and no enforcement. State the evidence that would count (a sign-in log export with a claim per sign-in) and the plan needed to produce it.
6. **FIDO2 for Tier 0 has no purchase or enrolment step.** The rule exists and nothing in the onboarding procedure issues a key.
7. **State and secrets.** POL-CRY-01 4.6 item 3 treats Terraform state as Restricted. No remote, encrypted state exists (RISK-002), so the Restricted rule has no store to apply to.
8. **Two documents date the same facts differently.** POL-SDL-01 section 4.4 item 1 says literals were hard-coded "until 2026-09-28"; SECURITY.md says they were "removed from the current tree on 2026-09-28". Both say the history is public. Fine in substance. No document states when the first public commit was.

## What this does not show

- Whether any Entra tenant, account or sign-in with these passwords exists. The scenario tenant is fictional and the real tenant check is still open.
- That the scenario fix date was ever planned or missed. Only the real commit date is a fact.
- Any value of a password. None was read into this record.
- A test sign-in, a FIDO2 key count or a password-manager export. Those numbers are scenario values.
- That scanning tools other than the one named would have found the literals.
