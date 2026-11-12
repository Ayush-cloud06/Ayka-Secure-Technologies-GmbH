# Runs only in a fresh payer (management) account.
resource "aws_organizations_organization" "ayka" {
  feature_set = "ALL"

  # SCPs can only be attached once the policy type is enabled on the root.
  enabled_policy_types = ["SERVICE_CONTROL_POLICY"]

  # IAM Identity Center needs trusted access to the organization.
  aws_service_access_principals = ["sso.amazonaws.com"]
}
