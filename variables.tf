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

variable "tags" {
  description = "Common resource tags."
  type        = map(string)
  default     = {
    project = "tf-hello-azure"
    owner   = "example"
  }
}
