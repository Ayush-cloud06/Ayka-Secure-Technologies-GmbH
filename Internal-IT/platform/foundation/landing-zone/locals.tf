locals {
  security_role_arn = "arn:aws:iam::${var.security_account_id}:role/OrganizationAccountAccessRole"
  dev_role_arn      = "arn:aws:iam::${var.dev_account_id}:role/OrganizationAccountAccessRole"
  prod_role_arn     = "arn:aws:iam::${var.prod_account_id}:role/OrganizationAccountAccessRole"

  # Environment is added per provider. Logs hold personal data (IP addresses, user names).
  platform_tags = {
    Owner              = "cloud-platform-engineering"
    DataClassification = "Confidential"
    ManagedBy          = "terraform"
    Workload           = "landing-zone"
  }
}
