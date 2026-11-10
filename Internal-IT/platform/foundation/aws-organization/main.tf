module "scp" {
  source          = "./modules/scp"
  workloads_ou_id = module.ou-structure.Workloads_ou_id
}

module "ou-structure" {
  source = "./modules/ou-structure"
  # Read from the organization this root creates, not from a data source: the
  # data source needs an AWS call, so the root could not be planned offline.
  root_id = aws_organizations_organization.ayka.roots[0].id
}
