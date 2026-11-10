output "security_alerts_topic_arn" {
  value       = module.alerts.topic_arn
  description = "SNS topic ARN for all security alerts"
}

output "cloudtrail_bucket_arn" {
  value       = module.logging.bucket_arn
  description = "The ARN of the CloudTrail bucket passed up from the logging module"
}

output "log_bucket_name" {
  value       = module.logging.bucket_name
  description = "Name of the log bucket (CloudTrail and AWS Config)"
}

output "kms_key_arn" {
  value       = module.kms.key_arn
  description = "Customer-managed key for logs and alerts"
}
