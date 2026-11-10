terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }

  # No backend block on purpose: this root creates the backends, so its own state
  # stays local (step 1 of the bootstrap order in ../README.md).
}

provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      Environment        = "management"
      Owner              = "cloud-platform-engineering"
      DataClassification = "Restricted"
      ManagedBy          = "terraform"
      Workload           = "remote-state"
    }
  }
}

provider "azurerm" {
  features {}

  skip_provider_registration = true
}
