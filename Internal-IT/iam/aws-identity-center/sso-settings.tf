data "aws_ssoadmin_instances" "this" {}

output "identity_center_instance_arn" {
  value = data.aws_ssoadmin_instances.this.arns[0]
}

# Identity Center must already be enabled once in console.
# Terraform cannot enable it from zero.
