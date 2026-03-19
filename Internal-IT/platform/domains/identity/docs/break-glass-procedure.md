# Standard Operating Procedure: Break-Glass (Emergency Access) 

**Organization:** Ayka Secure Technologies GmbH  
**Document ID:** SOP-IAM-001  
**Owner:** Cloud Platform Engineering / CISO  
**Classification:** Internal / Restricted  
**Last Updated:** 2026-03-15  

---

## 1. Purpose & Scope
This document outlines the procedural requirements for utilizing "Break-Glass" (Emergency Admin) accounts within Ayka Secure Technologies' cloud environment. 

The break-glass procedure is strictly reserved for "break-glass" scenarios where standard identity federation (Entra ID to AWS Identity Center) is unavailable, or a critical Tier 0 incident requires immediate, unfettered access to the AWS Organization management account.

**Scope of Accounts:**
* **Entra ID:** Dedicated Emergency Access Accounts (`emg-admin-1@aykasecure.com`) excluded from standard Conditional Access block policies.
* **AWS:** The `BreakGlassRole` located in the AWS Management Account.

## 2. Authorized Scenarios
Break-glass access is **ONLY** authorized under the following conditions:
1. **SSO Outage:** Microsoft Entra ID is experiencing a global outage, preventing standard SAML/OIDC federation into AWS.
2. **Ransomware / Identity Compromise:** The primary Entra ID tenant is compromised, and access must be severed and rebuilt from the AWS side.
3. **Critical Platform Outage:** A P1 incident requiring immediate root-level AWS access where standard Tier 0 personnel are unavailable.

## 3. Procedure: Shattering the Glass

### Phase 1: Authorization
* If time permits, explicit approval must be granted by the CISO or VP of Engineering (via Slack, phone, or written medium).
* In life-or-death system scenarios where leaders are unreachable, a Tier 0 Platform Admin may invoke the protocol independently but must immediately document the action.

### Phase 2: Credential Retrieval
1. Emergency Entra ID credentials and the AWS Root account MFA physical tokens (FIDO2 keys) are stored in a fireproof safe at the Stuttgart HQ (or a digital highly-restricted vault like 1Password/HashiCorp Vault accessible only via quorum).
2. Retrieve the secondary FIDO2 hardware key required for the `BreakGlassRole`.

### Phase 3: Execution
1. Assume the `BreakGlassRole` via the AWS CLI.
2. **Technical Control Enforcement:** The IAM trust policy strictly mandates `aws:MultiFactorAuthPresent == true`. The operator MUST tap the physical FIDO2 key to successfully assume the role.
3. Perform the necessary remediation tasks to restore service or lock out threat actors.

## 4. Monitoring & Alerting (The "Sirens")
**Reference: ISO 27001 A.8.15 (Logging)**
Break-glass execution is never silent. 
* Any `sts:AssumeRole` API call targeting the `BreakGlassRole` automatically triggers a high-severity alert via AWS CloudTrail -> EventBridge -> SNS.
* Alerts are broadcasted to the `#sec-incident-response` Slack channel and page the on-call security engineer via PagerDuty.

## 5. Post-Incident Review & Remediation
Within 24 hours of the break-glass protocol being invoked:
1. **Audit:** The Security team must review all CloudTrail logs associated with the break-glass session.
2. **Justification Report:** The operator must submit a formal incident report detailing *why* access was used and *what* was changed.
3. **Rotation:** All passwords and temporary credentials associated with the emergency accounts must be immediately rotated.