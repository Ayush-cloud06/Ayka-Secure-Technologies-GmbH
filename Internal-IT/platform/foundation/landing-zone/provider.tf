terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# One provider per account and Region. Every account is reached through
# OrganizationAccountAccessRole. Plan-only CI sets TF_VAR_mock_credentials=true:
# then no role is assumed and the provider makes no AWS call.
#
# The *_global aliases are us-east-1. CloudTrail delivers events of global
# services (IAM, root console sign-in, the global STS endpoint) to EventBridge
# only there, so a forwarding rule in us-east-1 sends them to eu-central-1.

provider "aws" {
  alias  = "security"
  region = var.aws_region

  skip_credentials_validation = var.mock_credentials
  skip_requesting_account_id  = var.mock_credentials
  skip_metadata_api_check     = var.mock_credentials

  dynamic "assume_role" {
    for_each = var.mock_credentials ? [] : [local.security_role_arn]
    content {
      role_arn = assume_role.value
    }
  }

  default_tags {
    tags = merge(local.platform_tags, { Environment = "security" })
  }
}

provider "aws" {
  alias  = "security_global"
  region = "us-east-1"

  skip_credentials_validation = var.mock_credentials
  skip_requesting_account_id  = var.mock_credentials
  skip_metadata_api_check     = var.mock_credentials

  dynamic "assume_role" {
    for_each = var.mock_credentials ? [] : [local.security_role_arn]
    content {
      role_arn = assume_role.value
    }
  }

  default_tags {
    tags = merge(local.platform_tags, { Environment = "security" })
  }
}

provider "aws" {
  alias  = "dev"
  region = var.aws_region

  skip_credentials_validation = var.mock_credentials
  skip_requesting_account_id  = var.mock_credentials
  skip_metadata_api_check     = var.mock_credentials

  dynamic "assume_role" {
    for_each = var.mock_credentials ? [] : [local.dev_role_arn]
    content {
      role_arn = assume_role.value
    }
  }

  default_tags {
    tags = merge(local.platform_tags, { Environment = "dev" })
  }
}

provider "aws" {
  alias  = "dev_global"
  region = "us-east-1"

  skip_credentials_validation = var.mock_credentials
  skip_requesting_account_id  = var.mock_credentials
  skip_metadata_api_check     = var.mock_credentials

  dynamic "assume_role" {
    for_each = var.mock_credentials ? [] : [local.dev_role_arn]
    content {
      role_arn = assume_role.value
    }
  }

  default_tags {
    tags = merge(local.platform_tags, { Environment = "dev" })
  }
}

provider "aws" {
  alias  = "prod"
  region = var.aws_region

  skip_credentials_validation = var.mock_credentials
  skip_requesting_account_id  = var.mock_credentials
  skip_metadata_api_check     = var.mock_credentials

  dynamic "assume_role" {
    for_each = var.mock_credentials ? [] : [local.prod_role_arn]
    content {
      role_arn = assume_role.value
    }
  }

  default_tags {
    tags = merge(local.platform_tags, { Environment = "prod" })
  }
}

provider "aws" {
  alias  = "prod_global"
  region = "us-east-1"

  skip_credentials_validation = var.mock_credentials
  skip_requesting_account_id  = var.mock_credentials
  skip_metadata_api_check     = var.mock_credentials

  dynamic "assume_role" {
    for_each = var.mock_credentials ? [] : [local.prod_role_arn]
    content {
      role_arn = assume_role.value
    }
  }

  default_tags {
    tags = merge(local.platform_tags, { Environment = "prod" })
  }
}
