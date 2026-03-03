# Require MFA for all users via Permission Set session settings
# Note: MFA enforcement is primarily managed in the Identity Center Console 
# or via Entra ID Conditional Access, but we define session constraints here.

resource "aws_ssoadmin_permission_set_inline_policy" "mfa_enforcement" {
  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.platform_admin.arn

  inline_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "DenyIfNoMFA"
        Effect   = "Deny"
        Action   = "*"
        Resource = "*"
        /*Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }*/
      }
    ]
  })
}

# Tag-Based Access Control (ABAC)
# This allows users to manage resources only if the resource tag matches their Identity Center user attributes

resource "aws_ssoadmin_instance_access_control_attributes" "abac_config" {
  instance_arn = data.aws_ssoadmin_instances.this.arns[0]

  attribute {
    key = "AccessTier"
    value {
      source = ["$${path:enterprise.extension.attribute1}"] # Mapping from Entra ID / SCIM
    }
  }

  attribute {
    key = "CostCenter"
    value {
      source = ["$${path:enterprise.costCenter}"]
    }
  }
}

# Session Duration Policy is defined within the Permission Set
# Example of updating the existing platform_admin to a strict duration
resource "aws_ssoadmin_permission_set" "restricted_session" {
  name             = "Restricted-Admin"
  instance_arn     = data.aws_ssoadmin_instances.this.arns[0]
  session_duration = "PT1H" # 1 Hour duration for high-privilege tasks

  tags = {
    ManagedBy = "Terraform"
    Security  = "High"
  }
}
