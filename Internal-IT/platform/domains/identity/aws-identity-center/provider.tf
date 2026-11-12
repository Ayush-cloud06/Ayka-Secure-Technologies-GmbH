terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# IAM Identity Center has one home Region. Per ADR-0003 it must be eu-central-1;
# see docs/identity-source.md for the instance that still has to be re-created.
provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      Environment        = "management"
      Owner              = "identity-owner"
      DataClassification = "Internal"
      ManagedBy          = "terraform"
      Workload           = "aws-identity-center"
    }
  }
}
