package terraform.security

deny[msg] {
  input.resource_type == "aws_s3_bucket"
  not input.encryption
  msg := "S3 bucket must have encryption enabled"
}