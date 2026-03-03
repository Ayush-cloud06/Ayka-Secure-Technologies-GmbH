resource "aws_ssoadmin_account_assignment" "platform_admin_assignment" {
  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.platform_admin.arn

  principal_type = "GROUP"
  principal_id   = data.aws_identitystore_group.tier0.group_id

  target_type = "AWS_ACCOUNT"
  target_id   = var.management_account_id
}

data "aws_identitystore_group" "tier0" {
  identity_store_id = data.aws_ssoadmin_instances.this.identity_store_ids[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "Tier0"
  }
}

data "aws_identitystore_group" "tier1" {
  identity_store_id = data.aws_ssoadmin_instances.this.identity_store_ids[0]

  filter {
    attribute_path  = "DisplayName"
    attribute_value = "Tier1"
  }
}
