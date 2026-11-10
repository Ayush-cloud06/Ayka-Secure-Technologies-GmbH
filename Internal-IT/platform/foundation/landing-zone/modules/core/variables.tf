variable "security_alert_email" {
  description = "Email address to receive security alerts"
  type        = string
}

variable "account_id" {
  description = "12-digit ID of this account (passed in, so no AWS call is needed to plan)"
  type        = string
}

variable "aws_region" {
  description = "AWS region for the landing zone"
  type        = string
  default     = "eu-central-1"
}

variable "log_retention_days" {
  description = "Retention and Object Lock period of the log bucket, in days (548 = 18 months)"
  type        = number
  default     = 548
}
