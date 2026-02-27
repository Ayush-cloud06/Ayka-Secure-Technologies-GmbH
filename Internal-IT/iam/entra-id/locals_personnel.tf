locals {

  # Load HR dataset
  personnel = jsondecode(file("${path.module}/personnel.json"))

  # Normalize for safe group naming
  normalized_personnel = {
    for id, p in local.personnel :
    id => merge(p, {
      department_key    = lower(replace(p.department, " ", "-"))
      security_role_key = lower(replace(p.security_role, " ", "-"))
      tier_key          = lower(p.tier)
    })
  }

  # Unique Departments
  departments = toset([
    for p in local.normalized_personnel :
    p.department_key
  ])

  # Unique Security Roles
  security_roles = toset([
    for p in local.normalized_personnel :
    p.security_role_key
  ])

  # Unique Tiers
  tiers = toset([
    for p in local.normalized_personnel :
    p.tier_key
  ])

  # Privileged Subset (Dual Account Engine)
  privileged_personnel = {
    for id, p in local.normalized_personnel :
    id => p
    if p.privileged == true
  }

}
