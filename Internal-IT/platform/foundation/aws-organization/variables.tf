variable "aws_region" {
  description = "Home Region of the management account. ADR-0003 fixes eu-central-1."
  type        = string
  default     = "eu-central-1"

  validation {
    condition     = var.aws_region == "eu-central-1"
    error_message = "aws_region must be eu-central-1 (ADR-0003)."
  }
}

variable "mock_credentials" {
  description = "true only for plan-only CI with mock credentials. Never set it for an apply."
  type        = bool
  default     = false
}
