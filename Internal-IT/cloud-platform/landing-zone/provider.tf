terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  alias  = "security"
  region = var.aws_region

  assume_role {
    role_arn = local.security_role_arn
  }
}

provider "aws" {
  alias  = "dev"
  region = var.aws_region

  assume_role {
    role_arn = local.dev_role_arn
  }
}

provider "aws" {
  alias  = "prod"
  region = var.aws_region

  assume_role {
    role_arn = local.prod_role_arn
  }
}
