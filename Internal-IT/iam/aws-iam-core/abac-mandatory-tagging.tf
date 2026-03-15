resource "aws_iam_policy" "mandatory_resource_tags" {

  name        = "MandatoryResourceTags"
  description = "Enforce mandatory tags on resource creation"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        Sid    = "DenyCreateWithoutDepartmentTag"
        Effect = "Deny"

        Action = [
          "ec2:RunInstances",
          "ec2:CreateVolume",
          "rds:CreateDBInstance",
          "rds:CreateDBCluster",
          "s3:CreateBucket",
          "lambda:CreateFunction"
        ]

        Resource = "*"

        Condition = {
          Null = {
            "aws:RequestTag/Department" = "true"
          }
        }
      },

      {
        Sid    = "DenyCreateWithoutEnvironmentTag"
        Effect = "Deny"

        Action = [
          "ec2:RunInstances",
          "ec2:CreateVolume",
          "rds:CreateDBInstance",
          "rds:CreateDBCluster",
          "s3:CreateBucket",
          "lambda:CreateFunction"
        ]

        Resource = "*"

        Condition = {
          Null = {
            "aws:RequestTag/Environment" = "true"
          }
        }
      },

      {
        Sid    = "DenyCreateWithoutOwnerTag"
        Effect = "Deny"

        Action = [
          "ec2:RunInstances",
          "ec2:CreateVolume",
          "rds:CreateDBInstance",
          "rds:CreateDBCluster",
          "s3:CreateBucket",
          "lambda:CreateFunction"
        ]

        Resource = "*"

        Condition = {
          Null = {
            "aws:RequestTag/Owner" = "true"
          }
        }
      }
    ]
  })
}
