# Security Audit Role (Cross Account)
resource "aws_iam_role" "security_audit_role" {

  name               = "SecurityAuditRole"
  description        = "Role used by the security account to audit this account"
  assume_role_policy = data.aws_iam_policy_document.security_account_assume_role.json

  max_session_duration = 3600

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "SecurityAudit"
  }
}

resource "aws_iam_role_policy_attachment" "security_audit_attachment" {
  role       = aws_iam_role.security_audit_role.name
  policy_arn = aws_iam_policy.security_audit_policy.arn
}


# Platform Operations Role 
resource "aws_iam_role" "platform_ops_role" {

  name               = "PlatformOperationsRole"
  description        = "Role assumed by the platform account to manage infrastructure"
  assume_role_policy = data.aws_iam_policy_document.identity_center_assume_role.json

  max_session_duration = 3600

  permissions_boundary = aws_iam_policy.workload_permission_boundary.arn

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "PlatformOperations"
  }
}

resource "aws_iam_role_policy_attachment" "platform_ops_policy" {
  role       = aws_iam_role.platform_ops_role.name
  policy_arn = aws_iam_policy.platform_engineer_policy.arn
}


# Workload Operations Role
resource "aws_iam_role" "workload_operator_role" {

  name                 = "WorkloadOperatorRole"
  description          = "Role used by workload teams to operate application resources"
  assume_role_policy   = data.aws_iam_policy_document.identity_center_assume_role.json
  permissions_boundary = aws_iam_policy.workload_permission_boundary.arn

  max_session_duration = 3600

  tags = {
    ManagedBy = "Terraform"
    Purpose   = "WorkloadOperations"
  }
}

resource "aws_iam_role_policy_attachment" "workload_operator_policy_attachment" {
  role       = aws_iam_role.workload_operator_role.name
  policy_arn = aws_iam_policy.workload_operator_policy.arn
}
