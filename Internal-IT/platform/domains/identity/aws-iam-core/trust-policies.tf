# Identity Center → AssumeRole → IAM Role
data "aws_iam_policy_document" "identity_center_assume_role" {

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["sso.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# Cross Account Access
data "aws_iam_policy_document" "security_account_assume_role" {

  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.security_account_id}:root"
      ]
    }
    actions = ["sts:AssumeRole"]
  }
}

# Break Glass Access
data "aws_iam_policy_document" "break_glass_assume_role" {

  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.management_account_id}:root"
      ]
    }

    actions = ["sts:AssumeRole"]
    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }
}
