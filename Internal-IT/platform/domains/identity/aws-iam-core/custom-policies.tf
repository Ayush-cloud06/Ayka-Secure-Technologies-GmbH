# Platform Engineer Policy
data "aws_iam_policy_document" "platform_engineer_policy" {

  statement {
    sid    = "PlatformInfrastructure"
    effect = "Allow"

    actions = [
      "ec2:*",
      "rds:*",
      "s3:*",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "cloudwatch:*",
      "logs:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "platform_engineer_policy" {
  name        = "PlatformEngineerPolicy"
  description = "Infrastructure management permissions for platform engineers"

  policy = data.aws_iam_policy_document.platform_engineer_policy.json
}



# Workload Operator Policy
data "aws_iam_policy_document" "workload_operator_policy" {

  statement {
    sid    = "WorkloadServices"
    effect = "Allow"

    actions = [
      "ec2:Describe*",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:RebootInstances",
      "rds:Describe*",
      "rds:StartDBInstance",
      "rds:StopDBInstance",
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "workload_operator_policy" {
  name        = "WorkloadOperatorPolicy"
  description = "Limited workload operations for application teams"

  policy = data.aws_iam_policy_document.workload_operator_policy.json
}



# Security Audit Policy
data "aws_iam_policy_document" "security_audit_policy" {

  statement {

    sid    = "SecurityAuditRead"
    effect = "Allow"

    actions = [
      "cloudtrail:DescribeTrails",
      "cloudtrail:GetTrailStatus",
      "guardduty:*",
      "config:*",
      "securityhub:*",
      "iam:Get*",
      "iam:List*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "security_audit_policy" {
  name        = "SecurityAuditExtended"
  description = "Extended security visibility policy"

  policy = data.aws_iam_policy_document.security_audit_policy.json
}
