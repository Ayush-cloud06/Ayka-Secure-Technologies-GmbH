resource "azuread_user" "admin_users" {

  for_each = local.privileged_personnel

  user_principal_name = "admin-${lower(each.key)}@ayushgta175outlook.onmicrosoft.com"
  display_name        = "Admin ${each.value.display_name}"
  mail_nickname       = "admin${lower(each.key)}"

  password                    = "TempAdminP@ss123!"
  force_password_change       = true
  disable_password_expiration = false
}

resource "azuread_group_member" "admin_tier_membership" {

  for_each = local.privileged_personnel

  group_object_id  = azuread_group.tier_groups["tier0"].id
  member_object_id = azuread_user.admin_users[each.key].id
}

resource "azuread_group_member" "admin_security_role_membership" {

  for_each = local.privileged_personnel

  group_object_id  = azuread_group.security_role_groups[each.value.security_role_key].id
  member_object_id = azuread_user.admin_users[each.key].id
}
