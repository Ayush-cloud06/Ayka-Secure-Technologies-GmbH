output "security_alerts_topic_arn" {
  description = "SNS topic ARN for security alerts in this account"
  value       = module.core.security_alerts_topic_arn
}

output "cloudtrail_bucket_arn" {
  description = "CloudTrail bucket ARN in this account"
  value       = module.core.cloudtrail_bucket_arn
}
