module "ec2_imdsv2" {
  count  = contains(var.enabled_scenarios, "ec2_imdsv2") ? 1 : 0
  source = "./ec2/no-imdsv2"
}

module "ec2_openssh" {
  count  = contains(var.enabled_scenarios, "ec2_openssh") ? 1 : 0
  source = "./ec2/open-ssh-security-group"
}

module "s3_encryption" {
  count  = contains(var.enabled_scenarios, "s3_encryption") ? 1 : 0
  source = "./s3/missing-encryption"
}

module "s3_public" {
  count  = contains(var.enabled_scenarios, "s3_public") ? 1 : 0
  source = "./s3/public-bucket"
}

module "vpc_permissive_network_acl" {
  count  = contains(var.enabled_scenarios, "vpc_permissive_network_acl") ? 1 : 0
  source = "./vpc/permissive-network-acl"
}
