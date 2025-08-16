output "resource_group_id" {
  value       = azurerm_resource_group.rg.id
  description = "Resource Group ID"
}

output "storage_account_id" {
  value       = azurerm_storage_account.sa.id
  description = "Storage Account ID"
}