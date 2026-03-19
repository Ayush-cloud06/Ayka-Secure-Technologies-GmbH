output "organization_id" {
  value = aws_organizations_organization.ayka.id
}

output "root_id" {
  value = aws_organizations_organization.ayka.roots[0].id
}
