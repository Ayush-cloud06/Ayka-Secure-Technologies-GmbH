# EventBridge rules that publish to the existing security-alerts topic (SOC 2 G6).
#
# CloudTrail sends events of global services (IAM, root console sign-in, the
# global STS endpoint) to EventBridge in us-east-1 only. The rules marked
# global = true therefore also exist in us-east-1, where they forward matching
# events to the default bus in the home Region; the home-Region rule with the
# same pattern then publishes them. Regional events (CloudTrail API, GuardDuty)
# arrive in the home Region directly.
#
# Not tested against a live account: no rule has fired yet.

locals {
  break_glass_role_names = ["emergency-break-glass-role", "BreakGlassRole"]

  alert_rules = {
    root-activity = {
      description = "Any sign-in or API call by the root user"
      global      = true
      pattern = jsonencode({
        detail-type = ["AWS Console Sign In via CloudTrail", "AWS API Call via CloudTrail"]
        detail = {
          userIdentity = { type = ["Root"] }
        }
      })
    }

    break-glass-assumed = {
      description = "A break-glass role was assumed"
      global      = true
      pattern = jsonencode({
        source      = ["aws.sts"]
        detail-type = ["AWS API Call via CloudTrail"]
        detail = {
          eventSource = ["sts.amazonaws.com"]
          eventName   = ["AssumeRole"]
          requestParameters = {
            roleArn = [for name in local.break_glass_role_names : { wildcard = "arn:aws:iam::*:role/${name}" }]
          }
        }
      })
    }

    cloudtrail-tampering = {
      description = "CloudTrail logging stopped, deleted or changed"
      global      = false
      pattern = jsonencode({
        source      = ["aws.cloudtrail"]
        detail-type = ["AWS API Call via CloudTrail"]
        detail = {
          eventSource = ["cloudtrail.amazonaws.com"]
          eventName   = ["StopLogging", "DeleteTrail", "UpdateTrail", "PutEventSelectors"]
        }
      })
    }

    iam-policy-change = {
      description = "An IAM policy or a role trust policy was created, changed, attached or removed"
      global      = true
      pattern = jsonencode({
        source      = ["aws.iam"]
        detail-type = ["AWS API Call via CloudTrail"]
        detail = {
          eventSource = ["iam.amazonaws.com"]
          eventName = [
            "CreatePolicy", "DeletePolicy", "CreatePolicyVersion", "DeletePolicyVersion", "SetDefaultPolicyVersion",
            "AttachRolePolicy", "DetachRolePolicy", "AttachUserPolicy", "DetachUserPolicy",
            "AttachGroupPolicy", "DetachGroupPolicy", "PutRolePolicy", "DeleteRolePolicy",
            "PutUserPolicy", "DeleteUserPolicy", "PutGroupPolicy", "DeleteGroupPolicy",
            "UpdateAssumeRolePolicy", "PutRolePermissionsBoundary", "DeleteRolePermissionsBoundary",
          ]
        }
      })
    }

    guardduty-finding = {
      description = "GuardDuty finding of medium severity or higher"
      global      = false
      pattern = jsonencode({
        source      = ["aws.guardduty"]
        detail-type = ["GuardDuty Finding"]
        detail = {
          severity = [{ numeric = [">=", 4] }]
        }
      })
    }
  }

  global_rules = { for name, rule in local.alert_rules : name => rule if rule.global }
}

# Home Region: every rule publishes to the topic.
resource "aws_cloudwatch_event_rule" "alert" {
  for_each = local.alert_rules

  name          = "security-${each.key}"
  description   = each.value.description
  event_pattern = each.value.pattern
}

resource "aws_cloudwatch_event_target" "alert" {
  for_each = local.alert_rules

  rule      = aws_cloudwatch_event_rule.alert[each.key].name
  target_id = "security-alerts"
  arn       = var.security_alerts_topic_arn
}

# us-east-1: forward global-service events to the home Region's default bus.
data "aws_iam_policy_document" "forward_assume" {
  statement {
    actions = ["sts:AssumeRole"]
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

resource "aws_iam_role" "forward" {
  name               = "security-events-forwarder"
  assume_role_policy = data.aws_iam_policy_document.forward_assume.json
}

data "aws_iam_policy_document" "forward" {
  statement {
    actions   = ["events:PutEvents"]
    resources = ["arn:aws:events:${var.aws_region}:${var.account_id}:event-bus/default"]
  }
}

resource "aws_iam_policy" "forward" {
  name   = "security-events-forward-home-region"
  policy = data.aws_iam_policy_document.forward.json
}

resource "aws_iam_role_policy_attachment" "forward" {
  role       = aws_iam_role.forward.name
  policy_arn = aws_iam_policy.forward.arn
}

resource "aws_cloudwatch_event_rule" "forward" {
  for_each = local.global_rules
  provider = aws.global

  name          = "forward-security-${each.key}"
  description   = "Forward to ${var.aws_region}: ${each.value.description}"
  event_pattern = each.value.pattern
}

resource "aws_cloudwatch_event_target" "forward" {
  for_each = local.global_rules
  provider = aws.global

  rule      = aws_cloudwatch_event_rule.forward[each.key].name
  target_id = "home-region-bus"
  arn       = "arn:aws:events:${var.aws_region}:${var.account_id}:event-bus/default"
  role_arn  = aws_iam_role.forward.arn
}
