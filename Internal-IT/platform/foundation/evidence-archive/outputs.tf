output "bucket_name" {
  description = "Evidence archive bucket"
  value       = aws_s3_bucket.evidence.bucket
}

output "writer_role_arn" {
  description = "Role the pipeline would assume to upload a bundle"
  value       = aws_iam_role.writer.arn
}
