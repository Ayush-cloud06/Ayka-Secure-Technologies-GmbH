# One customer-managed key per account for CloudTrail, the log bucket, AWS Config
# delivery and the security-alerts topic.

variable "account_id" {
  description = "12-digit ID of this account"
  type        = string
}

variable "aws_region" {
  description = "Region of the trail and the key"
  type        = string
}

data "aws_iam_policy_document" "key" {
  statement {
    sid       = "AccountAdministration"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:root"]
    }
  }

  statement {
    sid       = "CloudTrailEncryptLogs"
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey*"]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
      values   = ["arn:aws:cloudtrail:${var.aws_region}:${var.account_id}:trail/*"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.account_id]
    }
  }

  statement {
    sid       = "CloudTrailDescribeKey"
    effect    = "Allow"
    actions   = ["kms:DescribeKey"]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }

  # EventBridge publishes to the encrypted security-alerts topic.
  statement {
    sid       = "EventBridgePublishToEncryptedTopic"
    effect    = "Allow"
    actions   = ["kms:GenerateDataKey*", "kms:Decrypt"]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.account_id]
    }
  }
}

resource "aws_kms_key" "logs" {
  description             = "Landing zone key for CloudTrail, AWS Config and security alerts"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.key.json
}

resource "aws_kms_alias" "logs" {
  name          = "alias/landing-zone-logs"
  target_key_id = aws_kms_key.logs.key_id
}

output "key_arn" {
  value       = aws_kms_key.logs.arn
  description = "ARN of the landing zone key"
}
