output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "access_logs_bucket_name" {
  value = aws_s3_bucket.access_logs.bucket
  # The ALB checks it may write logs when it is created, so the policy must exist first.
  depends_on = [aws_s3_bucket_policy.access_logs]
}

output "bucket_arn" {
  description = "ARN of the data bucket (backed up by AWS Backup)"
  value       = aws_s3_bucket.this.arn
}
