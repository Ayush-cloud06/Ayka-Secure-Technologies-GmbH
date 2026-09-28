variable "privileged_personnel" {}
variable "tier_groups" {}
variable "security_role_groups" {}

variable "break_glass_upn" {
  description = "User principal name of the manually managed break-glass account."
  type        = string
}
