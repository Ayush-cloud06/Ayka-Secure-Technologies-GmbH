# Break Glass Emergency Role
resource "aws_iam_role" "break_glass" {

  name                 = "BreakGlassRole"
  description          = "Emergency administrative role used only during identity system failure or incident response."
  assume_role_policy   = data.aws_iam_policy_document.break_glass_assume_role.json
  max_session_duration = 3600

  tags = {
    SecurityLevel = "Critical"
    ManagedBy     = "Terraform"
    Purpose       = "EmergencyAccess"
  }
}

# Attach Administrator Policy
resource "aws_iam_role_policy_attachment" "break_glass_admin" {
  role       = aws_iam_role.break_glass.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
