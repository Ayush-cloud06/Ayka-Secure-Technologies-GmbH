# Writer role for the pipeline, assumed through GitHub OIDC from main only.
# Design only: no workflow in .github/ requests an OIDC token today, and plan-only
# CI keeps using mock credentials (ADR-0013). Wiring the upload step is a separate change.

resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  # Required by the provider schema; AWS no longer checks it for this issuer.
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

data "aws_iam_policy_document" "writer_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repository}:ref:refs/heads/main"]
    }
  }
}

resource "aws_iam_role" "writer" {
  name                 = "evidence-archive-writer"
  assume_role_policy   = data.aws_iam_policy_document.writer_trust.json
  max_session_duration = 3600
}

# Put only: the role can neither read, delete nor change retention.
data "aws_iam_policy_document" "writer" {
  statement {
    sid       = "PutEvidence"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.evidence.arn}/runs/*"]
  }

  statement {
    sid       = "EncryptWithArchiveKey"
    actions   = ["kms:GenerateDataKey"]
    resources = [aws_kms_key.evidence.arn]
  }
}

resource "aws_iam_policy" "writer" {
  name   = "evidence-archive-put"
  policy = data.aws_iam_policy_document.writer.json
}

resource "aws_iam_role_policy_attachment" "writer" {
  role       = aws_iam_role.writer.name
  policy_arn = aws_iam_policy.writer.arn
}
