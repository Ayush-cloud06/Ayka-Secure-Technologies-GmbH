variable "name_prefix" {
  type = string
}

variable "bucket_suffix" {
  type = string
}

variable "kms_key_arn" {
  type = string
}

variable "account_id" {
  description = "AWS account that owns the buckets; scopes the log-delivery bucket policy"
  type        = string
}
