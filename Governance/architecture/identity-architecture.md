User Lifecycle

HR → Personnel Register
        ↓
Entra ID user creation
        ↓
Group membership assignment
        ↓
SCIM provisioning
        ↓
AWS Identity Center
        ↓
Permission Sets
        ↓
IAM Roles in AWS accounts

---
personnel.json
      ↓
Terraform
      ↓
Entra ID
 ├ Users
 ├ Department groups
 └ Security roles
      ↓
SCIM
      ↓
AWS Identity Center
 ├ Users
 └ Tier groups
 
Groups → Permission Sets → AWS Accounts
---

Tier 0 – Security Administration
Tier 1 – Infrastructure Operators
Tier 2 – Developers