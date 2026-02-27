resource "azuread_group" "security_role_groups" {

  for_each = local.security_roles

  display_name     = "grp-sec-${each.value}"
  security_enabled = true

  description = "Security role group for ${each.value}"

}

/*
privileged-administrator
internal-auditor
standard-user
incident-handler
risk-acceptance-authority
*/
