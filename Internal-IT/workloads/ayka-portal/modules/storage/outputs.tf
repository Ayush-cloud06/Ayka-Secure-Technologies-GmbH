output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "access_logs_bucket_name" {
  value = aws_s3_bucket.access_logs.bucket
  # The ALB checks it may write logs when it is created, so the policy must exist first.
  depends_on = [aws_s3_bucket_policy.access_logs]
}
