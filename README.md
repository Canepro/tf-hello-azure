
# Terraform: Azure Hello Cloud

> ⚠️ **Note:** This example is for learning/demo purposes. Public blob access is disabled by default. Do not use in production without review.


## Purpose

A minimal, secure-by-default Terraform example for Azure. Provisions

- An Azure Resource Group
- A Storage Account with secure settings


## What it creates

- **Resource Group**
- **Storage Account** with:
  - TLS 1.2 minimum
  - HTTPS-only
  - Blob public access disabled
  - Shared key access disabled by default


## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.5
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure subscription (with permissions to create resources)


## Getting Started

1. **Clone the repo**

  ```bash
  git clone https://github.com/Canepro/tf-hello-azure.git
  cd tf-hello-azure
  ```

1. **Login to Azure**

  ```bash
  az login
  az account set --subscription "<YOUR_SUBSCRIPTION_ID_OR_NAME>"
  ```

1. **Test deployment with defaults**

  You can use the provided example variable file:

  
  ```bash
  cp terraform.tfvars.example terraform.tfvars
  ```

  Or, just run with minimal required variables:

  
  ```bash
  terraform init
  terraform plan -var="resource_group_name=my-tf-rg" -var="storage_account_name=myuniquesa123"
  terraform apply -auto-approve -var="resource_group_name=my-tf-rg" -var="storage_account_name=myuniquesa123"
  ```

  **Tip:** `storage_account_name` must be globally unique, 3–24 lowercase letters/digits.

1. **Check your resources**

  Visit the [Azure Portal](https://portal.azure.com/) to see your new resource group and storage account.


## Optional: Remote State

Remote state stores Terraform state in an Azure Storage Account and enables locking to avoid team conflicts.

### A) Create a state resource group, storage account, and container (one time per environment)

```bash
az group create -n rg-tfstate -l eastus
az storage account create \
  -n <unique_sa_name> -g rg-tfstate -l eastus \
  --sku Standard_LRS --kind StorageV2 \
  --min-tls-version TLS1_2 --https-only true \
  --allow-blob-public-access false
az storage container create \
  --name tfstate \
  --account-name <unique_sa_name> \
  --auth-mode login
```

### B) Fill the backend config (do not commit secrets)

```bash
cp backend.hcl.example backend.hcl
# Edit backend.hcl and set:
# resource_group_name  = "rg-tfstate"
# storage_account_name = "<unique_sa_name>"
# container_name       = "tfstate"
# key                  = "global.tfstate"
```

### C) Re-init using backend config

```bash
terraform init -reconfigure -backend-config=backend.hcl
```

From now on, Terraform uses remote state with locking.


## Optional: GitHub Actions CI

This repo includes a workflow that:

- On pull requests: runs fmt, tflint, init, validate, and plan
- On manual dispatch: applies changes safely (after manual approval)

### Before enabling, add these GitHub repository secrets

- AZURE_CREDENTIALS: JSON output from:

  
  
  ```bash
  az ad sp create-for-rbac --name "tf-gha" --role Contributor \
    --scopes /subscriptions/<SUBSCRIPTION_ID> \
    --sdk-auth
  ```
-
- TF_STATE_RG: Resource group for state (e.g., rg-tfstate)
- TF_STATE_STORAGE_ACCOUNT: Storage account (e.g., <unique_sa_name>)
- TF_STATE_CONTAINER: Container (e.g., tfstate)
- TF_STATE_KEY: State key (e.g., global.tfstate)


## Inputs

- `resource_group_name` (string, required)
- `storage_account_name` (string, required)
- `location` (string, default: eastus)
- `public_network_access_enabled` (bool, default: true)
- `allow_shared_key_access` (bool, default: false)
- `tags` (map(string))


## Outputs

- `resource_group_id`
- `storage_account_id`


## Troubleshooting

- `storage_account_name` must be unique and match ^[a-z0-9]{3,24}$
- If plan/apply fails, check Azure login and permissions


## License

MIT
