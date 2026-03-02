variable "tenant_id" {
  description = "Entra ID Tenant ID"
  type        = string
}

variable "enable_conditional_access" {
  description = "Toggle Conditional Access deployment"
  type        = bool
  default     = false
}
