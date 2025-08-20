resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  kind                     = "StorageV2"

  # Secure defaults
  min_tls_version               = "TLS1_2"
  enable_https_traffic_only     = true
  allow_blob_public_access      = false
  public_network_access_enabled = var.public_network_access_enabled
  allow_shared_key_access       = var.allow_shared_key_access

  tags = var.tags
}