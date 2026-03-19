resource "azuread_user" "users" {

  for_each = local.normalized_personnel

  user_principal_name = "${lower(each.key)}@ayushgta175outlook.onmicrosoft.com"
  display_name        = each.value.display_name
  mail_nickname       = lower(each.key)

  given_name = each.value.first_name
  surname    = each.value.last_name

  department    = each.value.department
  job_title     = each.value.primary_role
  employee_type = each.value.employment_type

  password              = "TempP@ssw0rd123!"
  force_password_change = true

}
