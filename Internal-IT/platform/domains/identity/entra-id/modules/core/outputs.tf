output "tier_groups" {
  value = azuread_group.tier_groups
}

output "security_role_groups" {
  value = azuread_group.security_role_groups
}

output "privileged_personnel" {
  value = local.privileged_personnel
}

output "non_privileged_personnel" {
  description = "Personnel without an admin account (normal accounts only)"
  value       = local.non_privileged_personnel
}
