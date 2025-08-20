# tf-hello-azure

Minimal Terraform example that creates a Resource Group and a Storage Account in Azure, with secure defaults.

## Prerequisites

- Terraform >= 1.5
- An Azure subscription
- Azure CLI logged in

```bash
az login
az account set --subscription "<SUBSCRIPTION_ID_OR_NAME>"
```

## Usage

Initialize and plan:

```bash
terraform init
terraform plan -var="resource_group_name=rg-hello" -var="storage_account_name=hellostorage123" -var="location=eastus"
```

Apply:

```bash
terraform apply -auto-approve   -var="resource_group_name=rg-hello"   -var="storage_account_name=hellostorage123"   -var="location=eastus"
```

> **Note:** Storage account names must be 3–24 characters, unique across Azure, and only lowercase letters and digits.

## Inputs

- `resource_group_name` (string, required)
- `storage_account_name` (string, required)
- `location` (string, default: `eastus`)
- `tags` (map(string), default includes `project` and `owner`)

## Outputs

- `resource_group_id`
- `storage_account_id`

## Secure Defaults

This example pins the provider version and sets explicit secure configuration on the Storage Account:

- `min_tls_version = "TLS1_2"`
- `https_traffic_only_enabled = true`
- `allow_blob_public_access = false`

## CI & Linting

This repo includes a GitHub Actions workflow that runs `terraform fmt`, `init`, and `validate`.
It also includes a basic `.tflint.hcl` and `.terraform-docs.yml` to generate inputs/outputs table (optional).

### Generate docs (optional)

```bash
terraform-docs markdown table . > README.md
```

## Next steps

- Try the same pattern using Azure Verified Modules (AVM) for larger, production-grade examples.
