resource "azurerm_resource_group" "tf_state" {
  name     = "rg-platform-terraform-state"
  location = "westeurope"
}

resource "azurerm_storage_account" "tf_state" {
  name                     = "stplatformtfstate066"
  resource_group_name      = azurerm_resource_group.tf_state.name
  location                 = azurerm_resource_group.tf_state.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"

  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 30
    }

    container_delete_retention_policy {
      days = 30
    }
  }
}

resource "azurerm_storage_container" "entra_id" {
  name                  = "entra-id"
  storage_account_name  = azurerm_storage_account.tf_state.name
  container_access_type = "private"
}
