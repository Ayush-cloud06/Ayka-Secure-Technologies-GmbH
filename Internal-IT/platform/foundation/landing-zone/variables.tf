variable "security_account_id" {
  description = "AWS account ID for the security account"
  type        = string
}

variable "dev_account_id" {
  description = "AWS account ID for the dev account"
  type        = string
}

variable "prod_account_id" {
  description = "AWS account ID for the prod account"
  type        = string
}

variable "aws_region" {
  description = "AWS Region to deploy to"
  type        = string
  default     = "ap-south-1"
}

variable "security_alert_email" {
  description = "Email for security notifications"
  type        = string
  default     = "test-admin@example.com"
}

variable "features" {
  description = "Feature flags to enable/disable specific security modules"
  type        = map(bool)
  default = {
    siem_integration = true
    quotas           = true
    break_glass      = true
    cost_controls    = true
  }
}

variable "vpc_quota" {
  description = "Maximum number of VPCs per account"
  type        = number
  default     = 10
}

variable "monthly_budget_limit" {
  description = "Monthly spend limit per account in USD"
  type        = number
  default     = 20
}
