# SCIM Provisioning Configuration

## Purpose

Enable automatic user and group synchronization from Microsoft Entra ID to AWS IAM Identity Center.

SCIM ensures identity lifecycle (create, update, disable) is centrally managed in Entra.

---

## Region

ap-south-1

---

## Configuration Steps (AWS Side)

1. Navigate to IAM Identity Center → Settings.
2. Enable Automatic Provisioning.
3. Generate SCIM endpoint URL.
4. Generate SCIM access token.
5. Store token securely (not committed to repository).

---

## Notes

- Entra ID becomes authoritative identity source.
- AWS Identity Center acts as authorization engine.
- SCIM provisioning logs available in AWS console.

