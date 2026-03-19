# AWS Identity Store Groups
locals {
  tier_groups = ["Tier0", "Tier1", "Tier2"]
}

resource "aws_identitystore_group" "groups" {
  for_each = toset(local.tier_groups)

  identity_store_id = data.aws_ssoadmin_instances.this.identity_store_ids[0]
  display_name      = each.value
  description       = "${each.value} - Managed by Terraform"
}
