variable "account_id" {
  description = "12-digit ID of this account"
  type        = string
}

variable "aws_region" {
  description = "Home Region (eu-central-1). Global-service events are forwarded here from us-east-1."
  type        = string
}

variable "security_alerts_topic_arn" {
  description = "The existing security-alerts SNS topic every rule publishes to"
  type        = string
}

variable "log_bucket_name" {
  description = "Log bucket that receives AWS Config snapshots under config/"
  type        = string
}

variable "log_bucket_arn" {
  description = "ARN of the log bucket"
  type        = string
}

variable "kms_key_arn" {
  description = "Key that encrypts the log bucket"
  type        = string
}
