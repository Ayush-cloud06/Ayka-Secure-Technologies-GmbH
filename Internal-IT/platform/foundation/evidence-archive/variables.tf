variable "account_id" {
  description = "Security account that owns the archive. The default is an AWS documentation ID for plan-only runs."
  type        = string
  default     = "111122223333"

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "account_id must be a 12-digit AWS account ID."
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

variable "retention_days" {
  description = "Object Lock retention of every evidence object. 548 days is 18 months (SOC 2 G7)."
  type        = number
  default     = 548

  validation {
    condition     = var.retention_days >= 548
    error_message = "retention_days must be at least 548 (18 months)."
  }
}

variable "github_repository" {
  description = "owner/name of the repository whose pipeline may write evidence"
  type        = string
  default     = "Ayush-cloud06/Ayka-Secure-Technologies-GmbH"
}

variable "mock_credentials" {
  description = "true only for plan-only CI with mock credentials. Never set it for an apply."
  type        = bool
  default     = false
}
