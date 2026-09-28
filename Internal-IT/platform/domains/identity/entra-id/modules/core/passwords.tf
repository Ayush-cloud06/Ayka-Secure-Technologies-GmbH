# One-time initial password. Users must change it at first sign-in (users.tf).
# The value is stored in state: treat the state backend as secret.
resource "random_password" "initial_user" {
  length           = 24
  special          = true
  override_special = "!#%*-_=+"
}

output "initial_user_password" {
  value     = random_password.initial_user.result
  sensitive = true
}
