# Identity Source Configuration

## Overview

AWS IAM Identity Center was configured to use Microsoft Entra ID as an external SAML identity provider.

This change enables federated authentication and centralizes identity management in Entra ID.

---

## Region

Target Region: `eu-central-1` (ADR-0003).

Historical note: the instance configured through the console in 2026 was created in `ap-south-1`. Identity Center cannot move between Regions, so that instance has to be deleted and re-created in `eu-central-1` before go-live; the region SCP would block it otherwise.

---

## Identity Provider

Microsoft Entra ID  
Protocol: SAML 2.0

Enterprise Application used:
AWS IAM Identity Center (successor to AWS Single Sign-On)

---

## Configuration Steps Performed (GUI)

1. Created AWS IAM Identity Center Enterprise Application in Entra ID (Gallery app).
2. Enabled SAML Single Sign-On in the Enterprise Application.
3. Configured Basic SAML Settings:
   - Identifier (Entity ID) = AWS IAM Identity Center issuer URL
   - Reply URL (ACS URL) = AWS IAM Identity Center ACS URL
4. Downloaded Federation Metadata XML from Entra ID.
5. In AWS IAM Identity Center:
   - Changed Identity Source to External Identity Provider.
   - Uploaded Entra Federation Metadata XML.
   - Confirmed change via ACCEPT confirmation.

---

## Result

- AWS IAM Identity Center now delegates authentication to Entra ID.
- MFA enforcement is handled in Entra ID (Conditional Access policies).
- Permission Sets and account assignments remain managed via Terraform.
- Identity lifecycle can be extended using SCIM provisioning (planned).

---

## Governance Notes

- Identity provider configuration performed by platform administrator.
- Change documented under identity management control.
- Entra ID designated as authoritative identity source.
- AWS Identity Center used strictly for authorization (RBAC).

---

## Next Planned Improvement

Enable SCIM provisioning for automatic user and group synchronization.