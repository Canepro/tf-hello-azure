# Terraform: Azure Hello Cloud

Purpose
This repo is a minimal, secure-by-default Terraform example that provisions:
- An Azure Resource Group
- A Storage Account with secure settings

It’s designed as an easy starting point for learning Infrastructure as Code (IaC) on Azure with Terraform while showing good practices like version pinning, tagging, linting, and optional remote state with locking.

What it creates
- Resource Group
- Storage Account with:
  - TLS 1.2 minimum
  - HTTPS-only
  - Blob public access disabled
  - Shared key access disabled by default (safer: use RBAC or SAS)

Repo contents
- Terraform config: main.tf, variables.tf, outputs.tf, versions.tf
- Optional remote state: backend.tf, backend.hcl.example
- Examples: terraform.tfvars.example
- CI: .github/workflows/terraform.yml (optional; plan on PR, manual apply)
- Tooling: .tflint.hcl, .terraform-docs.yml, Makefile, .gitignore
- Docs: CONTRIBUTING.md, LICENSE

Quick start (local)
Prerequisites:
- Terraform >= 1.5
- Azure CLI
- Logged in to Azure and selected your subscription:
  ```bash
  az login
  az account set --subscription "<SUBSCRIPTION_ID_OR_NAME>"
  ```

Steps:
1) Clone and enter the repo
   ```bash
   git clone <your-repo-url>
   cd <your-repo-folder>
   ```

2) Set variables (optional)
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars to update names, location, and tags
   ```

3) Initialize and plan
   ```bash
   terraform init
   terraform plan
   ```

4) Apply
   ```bash
   terraform apply -auto-approve
   ```

You can now see your resources in the Azure Portal.

Optional: Remote state with Azure Storage (recommended for teams)
Remote state stores Terraform state in an Azure Storage Account and enables locking to avoid team conflicts.

A) Create a state resource group, storage account, and container (one time per environment)
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

B) Fill the backend config (do not commit secrets)
```bash
cp backend.hcl.example backend.hcl
# Edit backend.hcl and set:
# resource_group_name  = "rg-tfstate"
# storage_account_name = "<unique_sa_name>"
# container_name       = "tfstate"
# key                  = "global.tfstate"
```

C) Re-init using backend config
```bash
terraform init -reconfigure -backend-config=backend.hcl
```

From now on, Terraform uses remote state with locking.

GitHub Actions CI (optional)
This repo includes a workflow that:
- On pull requests: runs fmt, tflint, init, validate, and plan
- On manual dispatch: applies changes safely (after manual approval)

Before enabling, add these GitHub repository secrets:
- AZURE_CREDENTIALS: JSON output from:
  ```bash
  az ad sp create-for-rbac --name "tf-gha" --role Contributor \
    --scopes /subscriptions/<SUBSCRIPTION_ID> \
    --sdk-auth
  ```
- TF_STATE_RG: Resource group for state (e.g., rg-tfstate)
- TF_STATE_STORAGE_ACCOUNT: Storage account (e.g., <unique_sa_name>)
- TF_STATE_CONTAINER: Container (e.g., tfstate)
- TF_STATE_KEY: State key (e.g., global.tfstate)

Inputs (variables)
- resource_group_name (string, required): Name for the Resource Group
- storage_account_name (string, required): 3–24 lowercase letters/digits; must be globally unique
- location (string, default: eastus): Azure region (e.g., eastus, westeurope)
- public_network_access_enabled (bool, default: true): Set to false if you plan to use Private Endpoints
- allow_shared_key_access (bool, default: false): Disable shared key access for better security
- tags (map(string)): Common tags applied to all resources

Outputs
- resource_group_id
- storage_account_id

Security defaults in this example
- TLS 1.2 minimum for Storage Account
- HTTPS-only enforced
- Blob public access disabled
- Shared key access disabled by default

Tips and next steps
- Commit the lock file after first init:
  ```bash
  git add .terraform.lock.hcl
  git commit -m "chore: lock provider checksums"
  ```
- Use Azure Verified Modules (AVM) as you scale
- Consider adding a Key Vault module and least-privilege RBAC for production

Troubleshooting
- storage_account_name must be unique and match ^[a-z0-9]{3,24}$
- If you disable public_network_access and don’t use private endpoints, data-plane access may fail
- If plan/apply fails in CI, verify AZURE_CREDENTIALS and TF_STATE_* secrets

License
MIT