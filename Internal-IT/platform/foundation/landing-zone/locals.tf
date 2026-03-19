locals {
  security_role_arn = "arn:aws:iam::${var.security_account_id}:role/OrganizationAccountAccessRole"
  dev_role_arn      = "arn:aws:iam::${var.dev_account_id}:role/OrganizationAccountAccessRole"
  prod_role_arn     = "arn:aws:iam::${var.prod_account_id}:role/OrganizationAccountAccessRole"
}
