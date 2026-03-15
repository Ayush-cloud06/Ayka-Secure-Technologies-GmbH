# Identity Provisioning & Role Assignment Workflow

**Organization:** Ayka Secure Technologies GmbH  
**Location:** Stuttgart, Germany  
**Owner:** Cloud Platform Engineering / IT Support  
**Last Updated:** 2026-03-03  

---

## 1. Purpose
This runbook defines the standard operating procedure (SOP) for provisioning new user identities and assigning them to AWS Role-Based Access Control (RBAC) groups. 

Due to current licensing constraints (Microsoft Entra ID Free), group-based SCIM provisioning is not supported. Therefore, we utilize a split-brain identity model:
* **Microsoft Entra ID** is the Authoritative Source for **User Identities** (Lifecycle & Authentication).
* **AWS Terraform** is the Authoritative Source for **RBAC Group Memberships** (Authorization).

---

## 2. Prerequisites
* Administrator access to Microsoft Entra ID (User Admin or Global Admin).
* Access to the `cloud-platform` Terraform repository.
* AWS SCIM provisioning must be actively running in Entra ID.

---

## 3. The Provisioning Workflow

When a new employee is onboarded (or changes roles), IT must execute the following steps in exact order to prevent Terraform state failures (race conditions).

### Step 1: Create the User in Entra ID
All identity lifecycles begin in the Identity Provider (IdP).
1. Navigate to **Microsoft Entra ID > Users**.
2. Create the new user with their official company UPN (e.g., `firstname.lastname@aykasecure.com`).
3. Assign the user to the `AWS IAM Identity Center` Enterprise Application in Entra ID. 
   *(Note: This flags the user to be picked up by the SCIM provisioning agent).*

### Step 2: Await SCIM Synchronization
Terraform cannot assign a user to an AWS group until the AWS Identity Store is aware of the user.
1. Wait for the Entra ID SCIM provisioning cycle to run (runs automatically every 40 minutes).
2. **To expedite (Manual Override):** Navigate to the Enterprise Application > Provisioning > select **Provision on demand**, enter the user's UPN, and force the sync.
3. Verify the user appears in the AWS IAM Identity Center console under **Users**.

### Step 3: Map Group Memberships via Terraform
Once the user exists in the AWS Identity Store, we authorize them via Infrastructure as Code.
1. Pull the latest `main` branch of the `cloud-platform` repository.
2. Navigate to `Internal-IT/iam/entra-id/modules/core/personnel.json` (or your local memberships mapping block).
3. Add the user's UPN to the appropriate access tier/group list.
4. Run standard CI/CD validation:
   ```bash
   terraform plan
5. Ensure the plan successfully looks up the user via the data "aws_identitystore_user" block and   
   shows the creation of an aws_identitystore_group_membership resource.
6. Merege and apply the code : terrraform apply

## Troubleshooting & Race Conditions

Error: 
 Error: multiple Identity Store Users matched... or ResourceNotFoundException.
 Root Cause: You ran terraform apply before SCIM successfully pushed the user from Entra ID to AWS. Terraform is searching for a UPN that AWS doesn't know about yet.
 Fix: Verify the SCIM provisioning logs in Entra ID. Wait for a successful sync event, then re-run terraform plan.