variable "target_bucket_arn" {
  description = "The ARN of the central S3 bucket for SIEM log integration"
  type        = string
}

variable "kms_key_arn" {
  description = "Customer-managed key for the stream and its S3 objects"
  type        = string
}
