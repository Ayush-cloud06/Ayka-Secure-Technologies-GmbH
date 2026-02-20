module "security_landing_zone" {
  source = "git::https://github.com/Ayush-cloud06/cloud-platform-control-plane.git"

  providers = {
    aws = aws.security
  }

  environment = "security"
}

module "dev_landing_zone" {
  source = "git::https://github.com/Ayush-cloud06/cloud-platform-control-plane.git"

  providers = {
    aws = aws.dev
  }

  environment = "dev"
}

module "prod_landing_zone" {
  source = "git::https://github.com/Ayush-cloud06/cloud-platform-control-plane.git"

  providers = {
    aws = aws.prod
  }

  environment = "prod"
}
