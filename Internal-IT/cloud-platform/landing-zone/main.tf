module "security_landing_zone" {
  source = "./modules/account_landing_zone"

  providers = {
    aws = aws.security
  }

  environment             = "security"
  aws_region              = var.aws_region
  security_alert_email    = var.security_alert_email
  features                = var.features
  vpc_quota               = var.vpc_quota
  monthly_budget_limit    = var.monthly_budget_limit
  break_glass_trusted_arn = "arn:aws:iam::${var.security_account_id}:root"
}

module "dev_landing_zone" {
  source = "./modules/account_landing_zone"

  providers = {
    aws = aws.dev
  }

  environment             = "dev"
  aws_region              = var.aws_region
  security_alert_email    = var.security_alert_email
  features                = var.features
  vpc_quota               = var.vpc_quota
  monthly_budget_limit    = var.monthly_budget_limit
  break_glass_trusted_arn = "arn:aws:iam::${var.security_account_id}:root"
}

module "prod_landing_zone" {
  source = "./modules/account_landing_zone"

  providers = {
    aws = aws.prod
  }

  environment             = "prod"
  aws_region              = var.aws_region
  security_alert_email    = var.security_alert_email
  features                = var.features
  vpc_quota               = var.vpc_quota
  monthly_budget_limit    = var.monthly_budget_limit
  break_glass_trusted_arn = "arn:aws:iam::${var.security_account_id}:root"
}

output "security_alerts_topic_arns" {
  description = "SNS topic ARNs per environment"
  value = {
    security = module.security_landing_zone.security_alerts_topic_arn
    dev      = module.dev_landing_zone.security_alerts_topic_arn
    prod     = module.prod_landing_zone.security_alerts_topic_arn
  }
}
