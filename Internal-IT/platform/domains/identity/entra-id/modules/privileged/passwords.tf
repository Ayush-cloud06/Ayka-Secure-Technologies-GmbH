# One-time initial password for the admin accounts (force_password_change = true).
resource "random_password" "initial_admin" {
  length           = 24
  special          = true
  override_special = "!#%*-_=+"
}

output "initial_admin_password" {
  value     = random_password.initial_admin.result
  sensitive = true
}
