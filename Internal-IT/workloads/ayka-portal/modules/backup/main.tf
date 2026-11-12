# AWS Backup for the portal (SOC 2 G11, ISO A.8.13): daily, 35-day retention,
# in a vault whose lock stops anyone shortening retention or deleting recovery
# points early. Design only: never applied, no recovery point exists.

resource "aws_backup_vault" "this" {
  name        = "${var.name_prefix}-vault"
  kms_key_arn = var.kms_key_arn
}

# Vault Lock. Once changeable_for_days has passed the lock becomes immutable
# (compliance mode): it can no longer be removed, not even by root.
resource "aws_backup_vault_lock_configuration" "this" {
  backup_vault_name   = aws_backup_vault.this.name
  min_retention_days  = var.retention_days
  max_retention_days  = 365
  changeable_for_days = 3
}

resource "aws_backup_plan" "this" {
  name = "${var.name_prefix}-daily"

  rule {
    rule_name                = "daily-35d"
    target_vault_name        = aws_backup_vault.this.name
    schedule                 = var.schedule
    start_window             = 60
    completion_window        = 360
    enable_continuous_backup = false

    lifecycle {
      delete_after = var.retention_days
    }

    recovery_point_tags = {
      BackupPlan = "${var.name_prefix}-daily"
    }
  }
}

data "aws_iam_policy_document" "backup_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "backup" {
  name               = "${var.name_prefix}-backup"
  assume_role_policy = data.aws_iam_policy_document.backup_assume.json
}

resource "aws_iam_role_policy_attachment" "backup" {
  for_each = toset([
    "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup",
    "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores",
    "arn:aws:iam::aws:policy/AWSBackupServiceRolePolicyForS3Backup",
    "arn:aws:iam::aws:policy/AWSBackupServiceRolePolicyForS3Restore",
  ])

  role       = aws_iam_role.backup.name
  policy_arn = each.value
}

resource "aws_backup_selection" "this" {
  name         = "${var.name_prefix}-rds-s3"
  plan_id      = aws_backup_plan.this.id
  iam_role_arn = aws_iam_role.backup.arn
  resources    = var.protected_resource_arns
}
