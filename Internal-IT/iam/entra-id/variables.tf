variable "tenant_id" {
  default = "7ab9d7cc-50a6-4c39-a3b3-0388eda52d89"
}

variable "enable_conditional_access" {
  description = "Toggle Conditional Access deployment"
  type        = bool
  default     = false
}
