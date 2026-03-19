output "Security_ou_id" {
  value = aws_organizations_organizational_unit.Security.id
}

output "Infrastructure_ou_id" {
  value = aws_organizations_organizational_unit.Infrastructure.id
}

output "Workloads_ou_id" {
  value = aws_organizations_organizational_unit.Workloads.id
}
