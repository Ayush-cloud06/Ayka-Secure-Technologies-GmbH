output "vault_name" {
  description = "Backup vault with Vault Lock"
  value       = aws_backup_vault.this.name
}

output "plan_id" {
  description = "Daily backup plan"
  value       = aws_backup_plan.this.id
}
