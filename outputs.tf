output "resource_group_id" {
  description = "ID of the created Resource Group."
  value       = azurerm_resource_group.rg.id
}

output "storage_account_id" {
  description = "ID of the created Storage Account."
  value       = azurerm_storage_account.sa.id
}
