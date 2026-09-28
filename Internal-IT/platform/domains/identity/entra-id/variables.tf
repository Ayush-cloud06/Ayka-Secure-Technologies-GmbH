variable "tenant_id" {
  description = "Entra ID Tenant ID"
  type        = string
}

variable "enable_conditional_access" {
  description = "Toggle Conditional Access deployment"
  type        = bool
  default     = false
}

variable "break_glass_upn" {
  description = "User principal name of the manually managed break-glass account (not a secret)."
  type        = string
}
