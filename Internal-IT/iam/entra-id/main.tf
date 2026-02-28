module "core" {
  source = "./modules/core"
}

module "privileged" {
  source = "./modules/privileged"

  privileged_personnel = module.core.privileged_personnel
  tier_groups          = module.core.tier_groups
  security_role_groups = module.core.security_role_groups
}

module "security" {
  source = "./modules/security"
}

module "output" {
  source = "./modules/output"
}
