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
  region = "eu-central-1"

  # These validation scenarios are intended to generate plan JSON locally/CI
  # without requiring live AWS account discovery during policy testing.
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  skip_region_validation      = true

  default_tags {
    tags = {
      Environment        = "test"
      Owner              = "cloud-platform-engineering"
      DataClassification = "Internal"
      ManagedBy          = "terraform"
      Workload           = "control-validation-scenarios"
    }
  }
}
