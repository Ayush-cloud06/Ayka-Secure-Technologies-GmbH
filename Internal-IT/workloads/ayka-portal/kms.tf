resource "aws_kms_key" "workload" {
  description             = "Customer-managed KMS key for the ayka-portal workload"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_workload.json
}

data "aws_iam_policy_document" "kms_workload" {
  # checkov:skip=CKV_AWS_109:KMS key policies require resource=*
  # checkov:skip=CKV_AWS_111:KMS key policies require resource=*
  # checkov:skip=CKV_AWS_356:KMS key policies require resource=*
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::123456789012:root"]
    }
  }

  statement {
    sid    = "Allow S3 to use the key"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }

  statement {
    sid    = "Allow CloudWatch Logs to use the key"
    effect = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey*"
    ]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["logs.ap-south-1.amazonaws.com"]
    }
  }
}

resource "aws_kms_alias" "workload" {
  name          = "alias/${var.name_prefix}-workload"
  target_key_id = aws_kms_key.workload.key_id
}
