output "guardduty_detector_id" {
  value       = aws_guardduty_detector.this.id
  description = "GuardDuty detector in the home Region"
}

output "alert_rule_names" {
  value       = [for rule in aws_cloudwatch_event_rule.alert : rule.name]
  description = "EventBridge rules that publish to security-alerts"
}
