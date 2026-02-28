resource "azuread_group" "tier_groups" {

  for_each = local.tiers

  display_name     = "grp-tier-${each.value}"
  security_enabled = true

  description = "Privilege tier group ${each.value}"

}

/*
grp-tier-tier0
grp-tier-tier1
grp-tier-tier2
grp-tier-tier3
*/
