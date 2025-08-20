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
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
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

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
  default = {
    project     = "tf-hello-azure"
    owner       = "example"
    environment = "dev"
  }
}