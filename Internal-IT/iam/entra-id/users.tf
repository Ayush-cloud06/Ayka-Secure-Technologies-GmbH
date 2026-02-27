resource "azuread_user" "users" {

  for_each = local.normalized_personnel

  user_principal_name = "${lower(each.key)}@ayushgta175outlook.onmicrosoft.com"
  display_name        = each.value.display_name
  mail_nickname       = lower(each.key)

  password                    = "TempP@ssw0rd123!"
  force_password_change       = true
  disable_password_expiration = false

}
