variable "workloads_ou_id" {
  type = string
}

resource "aws_organizations_policy_attachment" "deny_root_workloads" {
  policy_id = aws_organizations_policy.deny_root.id
  target_id = var.workloads_ou_id
}

resource "aws_organizations_policy_attachment" "deny_cloudtrail_workloads" {
  policy_id = aws_organizations_policy.deny_cloudtrail_disable.id
  target_id = var.workloads_ou_id
}

resource "aws_organizations_policy_attachment" "restrict_regions_workloads" {
  policy_id = aws_organizations_policy.restrict_regions.id
  target_id = var.workloads_ou_id
}
