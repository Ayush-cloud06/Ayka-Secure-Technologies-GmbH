output "tier_groups" {
  value = azuread_group.tier_groups
}

output "security_role_groups" {
  value = azuread_group.security_role_groups
}

output "privileged_personnel" {
  value = local.privileged_personnel
}
