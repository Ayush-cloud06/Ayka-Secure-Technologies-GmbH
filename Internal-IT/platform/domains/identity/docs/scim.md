# SCIM Provisioning Configuration

## Purpose

Enable automatic user and group synchronization from Microsoft Entra ID to AWS IAM Identity Center.

SCIM ensures identity lifecycle (create, update, disable) is centrally managed in Entra.

---

## Region

Target Region: `eu-central-1` (ADR-0003).

Historical note: the instance configured through the console in 2026 was created in `ap-south-1`. Identity Center cannot move between Regions, so that instance has to be deleted and re-created in `eu-central-1` before go-live; the region SCP would block it otherwise.

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

