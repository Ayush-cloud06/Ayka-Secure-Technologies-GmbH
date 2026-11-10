variable "account_id" {
  description = "12-digit ID of this account"
  type        = string
}

variable "aws_region" {
  description = "Home Region of the trail"
  type        = string
}

variable "kms_key_arn" {
  description = "Customer-managed key for the trail and the bucket"
  type        = string
}

variable "log_retention_days" {
  description = "Object Lock retention and expiry of log objects, in days (548 = 18 months)"
  type        = number
}
