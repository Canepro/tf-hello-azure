# tf-hello-azure

![Terraform CI](https://github.com/Canepro/tf-hello-azure/actions/workflows/terraform.yml/badge.svg?branch=main) ![Gitleaks](https://github.com/Canepro/tf-hello-azure/actions/workflows/gitleaks.yml/badge.svg?branch=main)

Minimal Terraform reference that provisions an Azure Resource Group and a Storage Account.

## Prerequisites
- Terraform >= 1.5
- Azure subscription and permissions
- Azure CLI logged in: z login

## Quickstart
`pwsh
# Clone
gh repo clone Canepro/tf-hello-azure
cd tf-hello-azure

# Initialize (no backend)
terraform init -backend=false

# Format & validate
terraform fmt -recursive
terraform validate

# Plan
terraform plan -var "resource_group_name=my-rg" -var "storage_account_name=mystorageacct123"

# Apply
terraform apply -auto-approve -var "resource_group_name=my-rg" -var "storage_account_name=mystorageacct123"

# Outputs
terraform output

# Destroy
terraform destroy -auto-approve -var "resource_group_name=my-rg" -var "storage_account_name=mystorageacct123"
`

## Notes
- Provider: hashicorp/azurerm ~> 3.100
- Location defaults to astus.
- State is local in this example; no backend configured.

## License
MIT