resource "aws_ssoadmin_account_assignment" "platform_admin_assignment" {
  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.platform_admin.arn

  principal_type = "GROUP"
  principal_id   = var.entra_group_ids["tier0"]

  target_type = "AWS_ACCOUNT"
  target_id   = var.management_account_id
}
