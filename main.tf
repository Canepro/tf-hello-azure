data "azurerm_resource_group" "existing" {
  count = var.use_existing_resource_group ? 1 : 0
  name  = var.existing_resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.use_existing_resource_group ? 0 : 1
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

locals {
  rg_name     = var.use_existing_resource_group ? data.azurerm_resource_group.existing[0].name : azurerm_resource_group.rg[0].name
  rg_location = var.use_existing_resource_group ? data.azurerm_resource_group.existing[0].location : azurerm_resource_group.rg[0].location
  do_storage  = var.enable_storage
  do_create_sa = var.enable_storage && var.create_storage_account
}

data "azurerm_storage_account" "existing" {
  count               = local.do_storage && !var.create_storage_account ? 1 : 0
  name                = var.storage_account_name
  resource_group_name = local.rg_name
}

resource "azurerm_storage_account" "sa" {
  count                   = local.do_create_sa ? 1 : 0
  name                    = var.storage_account_name
  resource_group_name     = local.rg_name
  location                = coalesce(var.storage_account_location, local.rg_location)
  account_tier            = "Standard"
  account_replication_type = coalesce(var.storage_account_replication_type, "LRS")
  account_kind            = "StorageV2"

  # Secure defaults
  min_tls_version               = "TLS1_2"
  https_traffic_only_enabled    = true
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "static_website" {
    for_each = var.enable_static_website ? [1] : []
    content {
      index_document     = var.static_website_index_document
      error_404_document = var.static_website_error_404_document
    }
  }

  tags = var.tags

  lifecycle {
    # Avoid unnecessary replacements when importing existing accounts with different defaults
    ignore_changes = [
      access_tier,
      large_file_share_enabled,
  cross_tenant_replication_enabled,
  allow_nested_items_to_be_public,
  # provider-derived defaults or env settings
      # nested blocks often not explicitly set here
      blob_properties,
      queue_properties,
      share_properties,
      routing,
    ]
  }
}

# Example blob container (visible change)
resource "azurerm_storage_container" "example" {
  count                  = var.enable_storage && var.enable_example_container ? 1 : 0
  name                   = var.example_container_name
  storage_account_id     = var.create_storage_account ? azurerm_storage_account.sa[0].id : data.azurerm_storage_account.existing[0].id
  container_access_type  = var.example_container_access_type
}