data "aws_caller_identity" "current" {}

locals {
  # If not explicitly provided, trust the current account root for break-glass.
  effective_break_glass_trusted_arn = coalesce(
    var.break_glass_trusted_arn,
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  )
}

module "core" {
  source = "../core"

  aws_region           = var.aws_region
  security_alert_email = var.security_alert_email
}

module "siem" {
  source = "../siem"
  count  = var.features.siem_integration ? 1 : 0

  target_bucket_arn = module.core.cloudtrail_bucket_arn
}

module "quotas" {
  source = "../quotas"
  count  = var.features.quotas ? 1 : 0

  vpc_quota = var.vpc_quota
}

module "break_glass" {
  source = "../break_glass"
  count  = var.features.break_glass ? 1 : 0

  break_glass_trusted_arn = local.effective_break_glass_trusted_arn
}

module "cost_controls" {
  source = "../cost_controls"
  count  = var.features.cost_controls ? 1 : 0

  notification_email   = var.security_alert_email
  monthly_budget_limit = var.monthly_budget_limit
}
