# Department Resource Isolation Policy
resource "aws_iam_policy" "abac_department_isolation" {

  name        = "ABACDepartmentIsolation"
  description = "Allow actions only on resources belonging to user's department"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        Effect = "Allow"
        Action = [
          "ec2:*",
          "rds:*",
          "s3:*",
          "lambda:*"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:ResourceTag/Department" = "$${aws:PrincipalTag/Department}"
          }
        }
      }
    ]
  })
}


# Mandatory Tag-On-Create Policy
resource "aws_iam_policy" "abac_mandatory_tags" {

  name        = "ABACMandatoryTags"
  description = "Deny resource creation if required tags are missing"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        Effect = "Deny"
        Action = [
          "ec2:RunInstances",
          "ec2:CreateVolume",
          "rds:CreateDBInstance",
          "s3:CreateBucket"
        ]

        Resource = "*"
        Condition = {
          Null = {
            "aws:RequestTag/Department"  = "true"
            "aws:RequestTag/Environment" = "true"
            "aws:RequestTag/Owner"       = "true"
          }
        }
      }
    ]
  })
}

# Protect Critical Infrastructure
resource "aws_iam_policy" "abac_protect_platform" {

  name        = "ABACProtectPlatformResources"
  description = "Prevent modification of platform owned resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        Effect = "Deny"
        Action = [
          "ec2:TerminateInstances",
          "ec2:DeleteVolume",
          "rds:DeleteDBInstance",
          "s3:DeleteBucket"
        ]

        Resource = "*"

        Condition = {
          StringEquals = {
            "aws:ResourceTag/Owner" = "PlatformTeam"
          }
        }
      }
    ]
  })
}

# Environment Isolation Policy
resource "aws_iam_policy" "abac_environment_control" {

  name        = "ABACEnvironmentIsolation"
  description = "Restrict actions based on environment tag"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        Effect = "Allow"
        Action = [
          "ec2:*",
          "rds:*",
          "s3:*"
        ]

        Resource = "*"

        Condition = {
          StringEquals = {
            "aws:ResourceTag/Environment" = "$${aws:PrincipalTag/Environment}"
          }
        }
      }
    ]
  })
}

# Read-Only Cross Department Visibility
resource "aws_iam_policy" "abac_cross_department_readonly" {

  name        = "ABACCrossDepartmentReadOnly"
  description = "Allow read-only visibility across departments"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "rds:Describe*",
          "s3:List*",
          "s3:GetBucketLocation"
        ]

        Resource = "*"
      }
    ]
  })
}
