module "core" {
  source = "./modules/core"
}

module "privileged" {
  source = "./modules/privileged"

  privileged_personnel = module.core.privileged_personnel
  tier_groups          = module.core.tier_groups
  security_role_groups = module.core.security_role_groups
}



# NOTE:
# Conditional Access policies require Entra ID Premium P1/P2.
# This module is currently disabled due to licensing limitations.
module "conditional_access" {
  source = "./modules/security/conditional_access"

  tier_groups               = module.core.tier_groups
  break_glass_user_id       = module.privileged.break_glass_user_id
  enable_conditional_access = var.enable_conditional_access

  count = var.enable_conditional_access ? 1 : 0
}

module "output" {
  source = "./modules/output"
}
