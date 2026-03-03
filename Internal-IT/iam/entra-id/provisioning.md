# SCIM Provisioning (Microsoft Entra ID)

## Purpose

Configure automatic user and group provisioning to AWS IAM Identity Center via SCIM.

---

## Configuration Steps

1. Open Enterprise Application:
   AWS IAM Identity Center (successor to AWS Single Sign-On)
2. Navigate to Provisioning.
3. Set Provisioning Mode = Automatic.
4. Enter:
   - Tenant URL = AWS SCIM endpoint
   - Secret Token = AWS SCIM token
5. Test connection.
6. Set Scope = Sync only assigned users and groups.
7. Assign required groups (Tier0, Tier1, Tier2).

---

## Result

- Users automatically provisioned to AWS.
- Groups automatically created in AWS Identity Store.
- De-provisioning handled automatically.