# Permission Boundary Policy
data "aws_iam_policy_document" "workload_permission_boundary" {

  statement {

    sid    = "DenyPrivilegeEscalation"
    effect = "Deny"

    actions = [
      "iam:CreatePolicyVersion",
      "iam:SetDefaultPolicyVersion",
      "iam:AttachUserPolicy",
      "iam:AttachGroupPolicy",
      "iam:AttachRolePolicy",
      "iam:PutUserPolicy",
      "iam:PutRolePolicy",
      "iam:PutGroupPolicy"
    ]

    resources = ["*"]
  }

  statement {

    sid    = "DenyOrganizationChanges"
    effect = "Deny"

    actions = [
      "organizations:*"
    ]

    resources = ["*"]
  }
}


# Creatiung IAM Policy Resources
resource "aws_iam_policy" "workload_permission_boundary" {

  name        = "WorkloadPermissionBoundary"
  description = "Prevents privilege escalation inside workload roles"

  policy = data.aws_iam_policy_document.workload_permission_boundary.json
}

# Adding to roles : permissions_boundary = aws_iam_policy.workload_permission_boundary.arn 
