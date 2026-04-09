resource "aws_kms_key" "workload" {
  description             = "Customer-managed KMS key for the ayka-portal workload"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "workload" {
  name          = "alias/${var.name_prefix}-workload"
  target_key_id = aws_kms_key.workload.key_id
}
