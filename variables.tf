variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to create"
}

variable "storage_account_name" {
  type        = string
  description = "Globally unique name for the Storage Account (3-24 lowercase alphanumeric)"
}

variable "location" {
  type        = string
  description = "Azure region for resources"
  default     = "eastus"
}

variable "tags" {
  type        = map(string)
  description = "Common resource tags"
  default = {
    project = "tf-hello-azure"
  }
}