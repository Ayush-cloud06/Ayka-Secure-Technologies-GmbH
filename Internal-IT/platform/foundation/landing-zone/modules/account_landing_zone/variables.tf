variable "account_id" {
  description = "12-digit ID of the account this landing zone is applied to"
  type        = string
}

variable "log_retention_days" {
  description = "Retention and Object Lock period of the log bucket, in days"
  type        = number
}

variable "aws_region" {
  description = "AWS Region to deploy to"
  type        = string
}

variable "security_alert_email" {
  description = "Email for security notifications"
  type        = string
}

variable "features" {
  description = "Feature flags to enable/disable specific security modules"
  type        = map(bool)
}

variable "vpc_quota" {
  description = "Max number of VPCs allowed in each account"
  type        = number
  default     = 10
}

variable "monthly_budget_limit" {
  description = "Monthly budget limit in USD"
  type        = number
  default     = 20
}

variable "break_glass_trusted_arn" {
  description = "Principal ARN trusted to assume break-glass role"
  type        = string
  default     = null
}
