locals {
  personnel = jsondecode(file("${path.module}/personnel.json"))
}

locals {
  departments = toset([
    for p in local.personnel :
    p.department
  ])
}

locals {
  functional_roles = toset([
    for p in local.personnel :
    p.primary_role
  ])
}

locals {
  tiers = toset([
    for p in local.personnel :
    p.tier
  ])
}

locals {
  privileged_personnel = {
    for id, p in local.personnel :
    id => p
    if p.privileged == true
  }
}

locals {
  normalized_personnel = {
    for id, p in local.personnel :
    id => merge(p, {
      department_key = lower(replace(p.department, " ", "-"))
      role_key       = lower(replace(p.primary_role, " ", "-"))
      tier_key       = lower(p.tier)
    })
  }
}
