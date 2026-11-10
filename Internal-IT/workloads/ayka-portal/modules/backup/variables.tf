variable "name_prefix" {
  description = "Prefix for backup resource names"
  type        = string
}

variable "kms_key_arn" {
  description = "Workload key that encrypts the recovery points"
  type        = string
}

variable "protected_resource_arns" {
  description = "ARNs of the RDS instance and S3 buckets to back up"
  type        = list(string)
}

variable "retention_days" {
  description = "Days each daily recovery point is kept"
  type        = number
  default     = 35
}

variable "schedule" {
  description = "Backup schedule (UTC)"
  type        = string
  default     = "cron(0 2 * * ? *)"
}
