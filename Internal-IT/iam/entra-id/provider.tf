terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-platform-terraform-state"
    storage_account_name = "stplatformtfstate066"
    container_name       = "entra-id"
    key                  = "identity.tfstate"
    subscription_id      = "95e55ff8-de4c-4bee-bc80-a81d20394683"
  }
}

provider "azuread" {
  tenant_id = var.tenant_id
}
