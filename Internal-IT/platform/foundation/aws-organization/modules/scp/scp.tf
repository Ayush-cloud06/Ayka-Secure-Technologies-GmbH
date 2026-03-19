resource "aws_organizations_policy" "deny_root" {
  name        = "DenyRootUsage"
  description = "Prevent root user actions"
  type        = "SERVICE_CONTROL_POLICY"
  content     = file("${path.module}/deny-root-usage.json")

}

resource "aws_organizations_policy" "deny_cloudtrail_disable" {
  name        = "DenyDisableCloudTrail"
  description = "Prevents disabling or deleting CloudTrail"
  type        = "SERVICE_CONTROL_POLICY"
  content     = file("${path.module}/deny-disable-cloudtrail.json")
}

resource "aws_organizations_policy" "restrict_regions" {
  name        = "RestrictRegions"
  description = "Restricts usage to approved AWS regions"
  type        = "SERVICE_CONTROL_POLICY"
  content     = file("${path.module}/restrict-region.json")
}
