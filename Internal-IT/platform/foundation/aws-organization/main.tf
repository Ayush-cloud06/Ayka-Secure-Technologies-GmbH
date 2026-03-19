module "scp" {
  source          = "./modules/scp"
  workloads_ou_id = module.ou-structure.Workloads_ou_id
}

module "ou-structure" {
  source  = "./modules/ou-structure"
  root_id = data.aws_organizations_organization.current.roots[0].id
}

data "aws_organizations_organization" "current" {}
