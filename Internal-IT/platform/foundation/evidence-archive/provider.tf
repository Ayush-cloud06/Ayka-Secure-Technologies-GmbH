terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  # Plan-only CI sets TF_VAR_mock_credentials=true: the provider then makes no AWS call.
  skip_credentials_validation = var.mock_credentials
  skip_requesting_account_id  = var.mock_credentials
  skip_metadata_api_check     = var.mock_credentials

  default_tags {
    tags = {
      Environment        = "security"
      Owner              = "cloud-platform-engineering"
      DataClassification = "Confidential"
      ManagedBy          = "terraform"
      Workload           = "evidence-archive"
    }
  }
}
