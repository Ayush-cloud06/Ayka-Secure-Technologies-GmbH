# Tier0 — Platform Admin
resource "aws_ssoadmin_permission_set" "platform_admin" {
  name         = "Platform-Admin"
  instance_arn = data.aws_ssoadmin_instances.this.arns[0]

  session_duration = "PT8H"
}

resource "aws_ssoadmin_managed_policy_attachment" "platform_admin_policy" {
  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.platform_admin.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


# Tier1 — Operations
resource "aws_ssoadmin_permission_set" "tier1_ops" {
  name         = "Tier1-Ops"
  instance_arn = data.aws_ssoadmin_instances.this.arns[0]

  session_duration = "PT8H"
}

resource "aws_ssoadmin_managed_policy_attachment" "tier1_readonly" {
  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.tier1_ops.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_ssoadmin_managed_policy_attachment" "tier1_iam_readonly" {
  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.tier1_ops.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

resource "aws_ssoadmin_managed_policy_attachment" "tier1_billing_readonly" {
  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.tier1_ops.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess"
}

resource "aws_ssoadmin_managed_policy_attachment" "tier1_security_audit" {
  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.tier1_ops.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
}


# Tier2 — Workload operators
resource "aws_ssoadmin_permission_set" "tier2_workload" {
  name         = "Tier2-Workload"
  instance_arn = data.aws_ssoadmin_instances.this.arns[0]

  session_duration = "PT8H"
}

resource "aws_ssoadmin_managed_policy_attachment" "tier2_ec2" {
  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.tier2_workload.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_ssoadmin_managed_policy_attachment" "tier2_s3" {
  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.tier2_workload.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_ssoadmin_managed_policy_attachment" "tier2_rds" {
  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.tier2_workload.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}
