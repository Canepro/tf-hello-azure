# Contributing

Thanks for your interest in contributing!

Local development
1) Install Terraform >= 1.5 and Azure CLI
2) az login
3) terraform init
4) terraform validate && terraform plan

Remote state (optional)
- Copy backend.hcl.example to backend.hcl, fill values, run:
  ```bash
  terraform init -reconfigure -backend-config=backend.hcl
  ```

GitHub Actions CI (optional)
- Add these repo secrets:
  - AZURE_CREDENTIALS
  - TF_STATE_RG
  - TF_STATE_STORAGE_ACCOUNT
  - TF_STATE_CONTAINER
  - TF_STATE_KEY
- Open a pull request to see plan in CI
- Trigger “Apply (manual)” via Actions tab to deploy

Style and lint
- Run `terraform fmt -recursive`
- Run `tflint`