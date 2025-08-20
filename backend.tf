terraform {
  # Remote state using Azure Storage (recommended for teams).
  # Do not hard-code values here. Pass them via a local backend.hcl file (untracked)
  # or via CI secrets. See README for instructions.
  backend "azurerm" {
    # Example keys (values supplied at init time):
    # resource_group_name  = ""
    # storage_account_name = ""
    # container_name       = ""
    # key                  = "global.tfstate"
  }
}