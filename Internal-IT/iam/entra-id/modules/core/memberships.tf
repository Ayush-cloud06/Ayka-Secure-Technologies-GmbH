# ----- Department Membersips -----
resource "azuread_group_member" "department_memberships" {

  for_each = local.normalized_personnel

  group_object_id  = azuread_group.department_groups[each.value.department_key].id
  member_object_id = azuread_user.users[each.key].id
}

# ------ Security ROle memberships ------
resource "azuread_group_member" "normal_security_role_memberships" {

  for_each = local.non_privileged_personnel

  group_object_id  = azuread_group.security_role_groups[each.value.security_role_key].id
  member_object_id = azuread_user.users[each.key].id
}


# ------ Tier Membersips ------
resource "azuread_group_member" "tier_memberships" {

  for_each = local.normalized_personnel

  group_object_id  = azuread_group.tier_groups[each.value.tier_key].id
  member_object_id = azuread_user.users[each.key].id
}
