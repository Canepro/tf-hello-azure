output "resource_group_id" {
  description = "ID of the effective Resource Group."
  value       = var.use_existing_resource_group ? data.azurerm_resource_group.existing[0].id : azurerm_resource_group.rg[0].id
}

output "storage_account_id" {
  description = "ID of the Storage Account (created or existing)."
  value       = var.enable_storage ? (var.create_storage_account ? azurerm_storage_account.sa[0].id : data.azurerm_storage_account.existing[0].id) : null
}

output "static_website_primary_endpoint" {
  description = "Primary web endpoint for static website (null if disabled or using existing SA)."
  value       = var.enable_storage && var.create_storage_account && var.enable_static_website ? azurerm_storage_account.sa[0].primary_web_endpoint : null
}