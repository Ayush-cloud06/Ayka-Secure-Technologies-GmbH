# Tier0 — Platform Admin
resource "aws_ssoadmin_permission_set" "platform_admin" {
  name             = "Platform-Admin"
  instance_arn     = data.aws_ssoadmin_instances.this.arns[0]
  session_duration = "PT8H"
}

data "aws_iam_policy_document" "tier0_assume_breakglass" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      "arn:aws:iam::*:role/BreakGlassRole"
    ]
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "tier0_assume_breakglass" {
  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.platform_admin.arn
  inline_policy      = data.aws_iam_policy_document.tier0_assume_breakglass.json
}

# Tier1 — Platform Operations
resource "aws_ssoadmin_permission_set" "tier1_ops" {

  name             = "Tier1-Ops"
  instance_arn     = data.aws_ssoadmin_instances.this.arns[0]
  session_duration = "PT8H"
}

data "aws_iam_policy_document" "tier1_assume_platform_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      "arn:aws:iam::*:role/PlatformOperationsRole",
      "arn:aws:iam::*:role/SecurityAuditRole"
    ]
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "tier1_assume_platform_role" {
  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.tier1_ops.arn
  inline_policy      = data.aws_iam_policy_document.tier1_assume_platform_role.json
}


# Tier2 — Workload Operators
resource "aws_ssoadmin_permission_set" "tier2_workload" {
  name             = "Tier2-Workload"
  instance_arn     = data.aws_ssoadmin_instances.this.arns[0]
  session_duration = "PT8H"
}

data "aws_iam_policy_document" "tier2_assume_workload_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      "arn:aws:iam::*:role/WorkloadOperatorRole"
    ]
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "tier2_assume_workload_role" {
  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.tier2_workload.arn
  inline_policy      = data.aws_iam_policy_document.tier2_assume_workload_role.json
}
