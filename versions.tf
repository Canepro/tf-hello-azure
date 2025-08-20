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
  # that do not have permission to register providers. Set to "none" to
  # skip registration. This is useful for demo/test environments.
  resource_provider_registrations = "none"
}