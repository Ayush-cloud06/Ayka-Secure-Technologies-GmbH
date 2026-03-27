resource "aws_s3_bucket" "public_bucket" {
  bucket = "control-validation-public-bucket-example"
}

resource "aws_s3_bucket_acl" "public_read" {
  bucket = aws_s3_bucket.public_bucket.id
  acl    = "public-read" # Wrong: bucket contents are publicly readable.
}
