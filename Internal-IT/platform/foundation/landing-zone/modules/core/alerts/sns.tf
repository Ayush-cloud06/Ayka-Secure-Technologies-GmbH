# Central SNS topic for all security-related alerts. EventBridge rules in
# ../../detection publish to it.

variable "security_alert_email" {
  description = "Email address to receive security alerts"
  type        = string
}

variable "account_id" {
  description = "12-digit ID of this account"
  type        = string
}

variable "kms_key_arn" {
  description = "Customer-managed key that encrypts the topic"
  type        = string
}

resource "aws_sns_topic" "security_alerts" {
  name              = "security-alerts"
  kms_master_key_id = var.kms_key_arn
}

data "aws_iam_policy_document" "security_alerts" {
  statement {
    sid       = "AllowEventBridgeRulesOfThisAccount"
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.security_alerts.arn]
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

  statement {
    sid = "AccountOwnerManagesTopic"
    actions = [
      "sns:GetTopicAttributes",
      "sns:SetTopicAttributes",
      "sns:Subscribe",
      "sns:ListSubscriptionsByTopic",
      "sns:Publish",
    ]
    resources = [aws_sns_topic.security_alerts.arn]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:root"]
    }
  }
}

resource "aws_sns_topic_policy" "security_alerts" {
  arn    = aws_sns_topic.security_alerts.arn
  policy = data.aws_iam_policy_document.security_alerts.json
}

# Email subscription (must be confirmed by the recipient once)
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "email"
  endpoint  = var.security_alert_email
}
