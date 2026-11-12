module "core" {
  source = "../core"

  account_id           = var.account_id
  aws_region           = var.aws_region
  security_alert_email = var.security_alert_email
  log_retention_days   = var.log_retention_days
}

# GuardDuty, Security Hub, AWS Config and the EventBridge alert rules (SOC 2 G6).
module "detection" {
  source = "../detection"

  providers = {
    aws        = aws
    aws.global = aws.global
  }

  account_id                = var.account_id
  aws_region                = var.aws_region
  security_alerts_topic_arn = module.core.security_alerts_topic_arn
  log_bucket_name           = module.core.log_bucket_name
  log_bucket_arn            = module.core.cloudtrail_bucket_arn
  kms_key_arn               = module.core.kms_key_arn
}

module "siem" {
  source = "../siem"
  count  = var.features.siem_integration ? 1 : 0

  target_bucket_arn = module.core.cloudtrail_bucket_arn
  kms_key_arn       = module.core.kms_key_arn
}

module "quotas" {
  source = "../quotas"
  count  = var.features.quotas ? 1 : 0

  vpc_quota = var.vpc_quota
}

module "break_glass" {
  source = "../break_glass"
  count  = var.features.break_glass ? 1 : 0

  # Default: the account's own root, built from the account ID instead of an API call.
  break_glass_trusted_arn = coalesce(var.break_glass_trusted_arn, "arn:aws:iam::${var.account_id}:root")
}

module "cost_controls" {
  source = "../cost_controls"
  count  = var.features.cost_controls ? 1 : 0

  notification_email   = var.security_alert_email
  monthly_budget_limit = var.monthly_budget_limit
}
