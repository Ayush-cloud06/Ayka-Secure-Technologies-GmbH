resource "azuread_group" "department_groups" {

  for_each = local.departments

  display_name     = "grp-dept-${each.value}"
  security_enabled = true

  description = "Department group for ${each.value}"

}

/*
engineering
information-security
security-operations
finance
marketing
administration
executive
product
it
compliance
security*/
