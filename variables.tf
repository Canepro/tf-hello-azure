variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "eastus"
  validation {
    condition     = can(regex("^[a-z]+[a-z0-9]+$", var.location))
    error_message = "Location must be a valid Azure region string (e.g., eastus, westeurope)."
  }
}

variable "resource_group_name" {
  description = "Name of the Resource Group."
  type        = string
}

variable "storage_account_name" {
  description = "Globally-unique storage account name (3-24 lowercase alphanumeric)."
  type        = string
  validation {
  condition     = var.enable_storage ? can(regex("^[a-z0-9]{3,24}$", var.storage_account_name)) : true
  error_message = "Storage account name must be 3-24 chars of lowercase letters and digits."
  }
}

variable "public_network_access_enabled" {
  description = "Controls public network access to the Storage Account. For stricter security, set this to false and use Private Endpoints."
  type        = bool
  default     = true
}

variable "allow_shared_key_access" {
  description = "Whether to allow Shared Key access to the Storage Account. For better security, keep this false and use RBAC/SAS."
  type        = bool
  default     = false
}

variable "use_existing_resource_group" {
  description = "If true, use an existing Azure Resource Group instead of creating a new one."
  type        = bool
  default     = false
}

variable "existing_resource_group_name" {
  description = "Name of the existing Resource Group to use when use_existing_resource_group is true."
  type        = string
  default     = ""
  validation {
    condition     = var.use_existing_resource_group ? length(var.existing_resource_group_name) > 0 : true
    error_message = "existing_resource_group_name must be provided when use_existing_resource_group is true."
  }
}

variable "create_storage_account" {
  description = "If false, skip creating the Storage Account (useful in restricted environments)."
  type        = bool
  default     = true
}

variable "enable_storage" {
  description = "When false, skip all storage resources entirely (no create or lookup)."
  type        = bool
  default     = true
}

variable "storage_account_replication_type" {
  description = "Replication type for the storage account (e.g., LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS). If null, defaults to LRS."
  type        = string
  default     = null
  validation {
    condition = (
      var.storage_account_replication_type == null ||
      contains(["LRS","GRS","RAGRS","ZRS","GZRS","RAGZRS"], var.storage_account_replication_type)
    )
    error_message = "storage_account_replication_type must be one of LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS or null."
  }
}

variable "storage_account_location" {
  description = "Location for the storage account. When null, defaults to the resource group's location. Set this to the existing account's region after import to avoid replacement (e.g., eastus)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
  default = {
    project     = "tf-hello-azure"
    owner       = "example"
    environment = "dev"
  }
}