resource "azuread_user" "break_glass_1" {
  user_principal_name = "breakglass-01@ayushgta175outlook.onmicrosoft.com"
  display_name        = "Break Glass Emergency 01"
  mail_nickname       = "breakglass01"

  password                    = "SuperStrongTempPassword!"
  force_password_change       = false
  disable_password_expiration = true
}

resource "azuread_group_member" "break_glass_tier0" {
  group_object_id  = var.tier_groups["tier0"].id
  member_object_id = azuread_user.break_glass_1.id
}
