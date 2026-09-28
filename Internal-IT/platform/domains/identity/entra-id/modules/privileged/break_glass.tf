# The break-glass account is created and rotated by hand, and its password is
# kept offline. Terraform only looks it up and keeps it in tier0.
data "azuread_user" "break_glass_1" {
  user_principal_name = var.break_glass_upn
}

# Stop managing the old resource WITHOUT deleting the real account.
removed {
  from = azuread_user.break_glass_1

  lifecycle {
    destroy = false
  }
}

resource "azuread_group_member" "break_glass_tier0" {
  group_object_id  = var.tier_groups["tier0"].id
  member_object_id = data.azuread_user.break_glass_1.object_id
}
