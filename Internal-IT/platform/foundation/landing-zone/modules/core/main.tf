# Customer-managed key for CloudTrail, the log bucket and the alert topic
module "kms" {
  source = "./kms"

  account_id = var.account_id
  aws_region = var.aws_region
}

# IAM Foundation (Roles & Root Protection)
module "iam" {
  source = "./iam"

  account_id = var.account_id
}

# Logging & CloudTrail
module "logging" {
  source = "./logging"

  account_id         = var.account_id
  aws_region         = var.aws_region
  kms_key_arn        = module.kms.key_arn
  log_retention_days = var.log_retention_days
}

# S3 Guardrails (Public Access Block)
module "s3" {
  source = "./s3"
}

# Security Alerts (SNS)
module "alerts" {
  source               = "./alerts"
  security_alert_email = var.security_alert_email
  account_id           = var.account_id
  kms_key_arn          = module.kms.key_arn
}
