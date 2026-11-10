# The defaults are AWS documentation account IDs, enough for a plan-only run.
# Set the real IDs in terraform.tfvars (untracked) before any apply.
variable "security_account_id" {
  description = "Security account ID"
  type        = string
  default     = "111122223333"

  validation {
    condition     = can(regex("^[0-9]{12}$", var.security_account_id))
    error_message = "security_account_id must be a 12-digit AWS account ID."
  }
}

variable "management_account_id" {
  description = "AWS organization management account ID"
  type        = string
  default     = "123456789012"

  validation {
    condition     = can(regex("^[0-9]{12}$", var.management_account_id))
    error_message = "management_account_id must be a 12-digit AWS account ID."
  }
}

variable "aws_region" {
  description = "ADR-0003 fixes eu-central-1."
  type        = string
  default     = "eu-central-1"

  validation {
    condition     = var.aws_region == "eu-central-1"
    error_message = "aws_region must be eu-central-1 (ADR-0003)."
  }
}

variable "environment" {
  description = "Environment tag of the account this root is applied to."
  type        = string
  default     = "shared"
}

variable "mock_credentials" {
  description = "true only for plan-only CI with mock credentials. Never set it for an apply."
  type        = bool
  default     = false
}
