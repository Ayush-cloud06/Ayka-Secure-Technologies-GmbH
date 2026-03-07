aws_region           = "ap-south-1"
security_alert_email = "secops@aykasecure.com"

# Account IDs for org-style multi-account deployment.
security_account_id = "347363495303"
dev_account_id      = "173128528324"
prod_account_id     = "474189600248"

# Stricter enterprise defaults.
vpc_quota            = 5
monthly_budget_limit = 20

features = {
  siem_integration = true
  quotas           = true
  break_glass      = true
  cost_controls    = true
}
