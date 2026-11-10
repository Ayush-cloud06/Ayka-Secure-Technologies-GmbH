output "db_endpoint" {
  value = aws_db_instance.this.endpoint
}

output "db_secret_arn" {
  value     = aws_secretsmanager_secret.db.arn
  sensitive = true
}

output "db_instance_arn" {
  description = "ARN of the RDS instance (backed up by AWS Backup)"
  value       = aws_db_instance.this.arn
}
