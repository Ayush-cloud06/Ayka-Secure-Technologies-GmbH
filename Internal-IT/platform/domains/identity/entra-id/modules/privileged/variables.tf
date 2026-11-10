variable "privileged_personnel" {
  description = "Personnel who get an admin account (from the core module)"
  type        = any
}

variable "tier_groups" {
  description = "Tier groups from the core module"
  type        = any
}

variable "security_role_groups" {
  description = "Security role groups from the core module"
  type        = any
}

variable "break_glass_upn" {
  description = "User principal name of the manually managed break-glass account."
  type        = string
}
