terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
  # Disable automatic resource provider registration for tenants/users
  # that do not have permission to register providers. This is useful for demo/test environments.
  skip_provider_registration = true
}