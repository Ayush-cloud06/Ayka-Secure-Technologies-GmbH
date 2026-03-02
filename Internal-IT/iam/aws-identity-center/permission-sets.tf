resource "aws_ssoadmin_permission_set" "platform_admin" {
  name         = "Platform-Admin"
  instance_arn = data.aws_ssoadmin_instances.this.arns[0]

  session_duration = "PT8H"
}

resource "aws_ssoadmin_managed_policy_attachment" "platform_admin_policy" {
  instance_arn       = data.aws_ssoadmin_instances.this.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.platform_admin.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
