variable "tier_groups" {
  description = "Map of tier groups from core module"
  type        = any
}

variable "break_glass_user_id" {
  description = "Object ID of break glass account"
  type        = string
}

variable "enable_conditional_access" {
  type = bool
}
