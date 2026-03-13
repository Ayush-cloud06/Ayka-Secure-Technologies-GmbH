# Tier 0
resource "aws_ssoadmin_account_assignment" "tier0_admin" {

  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.platform_admin.arn

  principal_id   = aws_identitystore_group.groups["Tier0"].group_id
  principal_type = "GROUP"

  target_id   = var.management_account_id
  target_type = "AWS_ACCOUNT"
}

# Tier 1
resource "aws_ssoadmin_account_assignment" "tier1_ops" {

  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.tier1_ops.arn

  principal_id   = aws_identitystore_group.groups["Tier1"].group_id
  principal_type = "GROUP"

  target_id   = var.management_account_id
  target_type = "AWS_ACCOUNT"
}

# Tier 2
resource "aws_ssoadmin_account_assignment" "tier2_workload" {

  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.tier2_workload.arn

  principal_id   = aws_identitystore_group.groups["Tier2"].group_id
  principal_type = "GROUP"

  target_id   = var.management_account_id
  target_type = "AWS_ACCOUNT"
}
