variable "security_account_id" {
  description = "AWS account ID for the security account. The default is an AWS documentation ID for plan-only runs."
  type        = string
  default     = "111122223333"

  validation {
    condition     = can(regex("^[0-9]{12}$", var.security_account_id))
    error_message = "security_account_id must be a 12-digit AWS account ID."
  }
}

variable "dev_account_id" {
  description = "AWS account ID for the dev account. The default is an AWS documentation ID for plan-only runs."
  type        = string
  default     = "444455556666"

  validation {
    condition     = can(regex("^[0-9]{12}$", var.dev_account_id))
    error_message = "dev_account_id must be a 12-digit AWS account ID."
  }
}

variable "prod_account_id" {
  description = "AWS account ID for the prod account. The default is an AWS documentation ID for plan-only runs."
  type        = string
  default     = "777788889999"

  validation {
    condition     = can(regex("^[0-9]{12}$", var.prod_account_id))
    error_message = "prod_account_id must be a 12-digit AWS account ID."
  }
}

variable "aws_region" {
  description = "AWS Region to deploy to. ADR-0003 fixes eu-central-1; the region SCP denies every other Region."
  type        = string
  default     = "eu-central-1"

  validation {
    condition     = var.aws_region == "eu-central-1"
    error_message = "aws_region must be eu-central-1 (ADR-0003, EU data residency)."
  }
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

variable "mock_credentials" {
  description = "true only for plan-only CI with mock credentials: no role is assumed and no AWS call is made. Never set it for an apply."
  type        = bool
  default     = false
}

variable "log_retention_days" {
  description = "Retention of CloudTrail and AWS Config logs, and of their Object Lock. 548 days is 18 months."
  type        = number
  default     = 548

  validation {
    condition     = var.log_retention_days >= 548
    error_message = "log_retention_days must be at least 548 (18 months)."
  }
}
