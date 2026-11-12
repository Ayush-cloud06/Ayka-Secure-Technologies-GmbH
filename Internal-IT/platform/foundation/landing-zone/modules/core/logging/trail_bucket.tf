# Log bucket for CloudTrail (AWSLogs/) and AWS Config (config/).
# Object Lock in COMPLIANCE mode: no one, root included, can delete or shorten
# a log object before log_retention_days (18 months) have passed.

locals {
  trail_name = "account-cloudtrail"
  trail_arn  = "arn:aws:cloudtrail:${var.aws_region}:${var.account_id}:trail/${local.trail_name}"
}

resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket              = "cloudtrail-logs-${var.account_id}"
  force_destroy       = false
  object_lock_enabled = true
}

resource "aws_s3_bucket_ownership_controls" "cloudtrail_bucket" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Block all public access

resource "aws_s3_bucket_public_access_block" "cloudtrail_block" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Object Lock needs versioning.
resource "aws_s3_bucket_versioning" "cloudtrail_bucket" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "cloudtrail_bucket" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = var.log_retention_days
    }
  }

  depends_on = [aws_s3_bucket_versioning.cloudtrail_bucket]
}

# Default encryption with the landing zone key

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_encrypt" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn
    }
    bucket_key_enabled = true
  }
}

# Expire after the retention period. Locked versions cannot be removed earlier;
# lifecycle only deletes them once their lock has run out.
resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail_bucket" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  rule {
    id     = "expire-after-retention"
    status = "Enabled"

    filter {}

    expiration {
      days = var.log_retention_days + 1
    }

    noncurrent_version_expiration {
      noncurrent_days = 1
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  depends_on = [aws_s3_bucket_versioning.cloudtrail_bucket]
}

data "aws_iam_policy_document" "cloudtrail_bucket" {
  statement {
    sid       = "AWSCloudTrailAclCheck"
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.cloudtrail_bucket.arn]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [local.trail_arn]
    }
  }

  statement {
    sid       = "AWSCloudTrailWrite"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.cloudtrail_bucket.arn}/AWSLogs/${var.account_id}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [local.trail_arn]
    }
  }

  statement {
    sid     = "DenyInsecureTransport"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.cloudtrail_bucket.arn,
      "${aws_s3_bucket.cloudtrail_bucket.arn}/*",
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudtrail_bucket" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id
  policy = data.aws_iam_policy_document.cloudtrail_bucket.json

  depends_on = [aws_s3_bucket_public_access_block.cloudtrail_block]
}
