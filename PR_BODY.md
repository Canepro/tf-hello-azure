## Summary

This PR makes the example more secure-by-default, easier for beginners, and ready for team use with optional remote state and a simple CI workflow.

### Key changes
- Newbie-friendly README with step-by-step local usage and optional remote state (Azure Storage backend with locking)
- Secure defaults on the Storage Account (TLS 1.2, HTTPS-only, blob public access disabled, shared key disabled by default)
- Provider and Terraform version pinning
- Basic CI workflow: fmt, tflint, init, validate, plan on PR; manual apply via workflow_dispatch
- Tooling config: TFLint rules for Azure, terraform-docs config, Makefile helpers
- Examples: backend.hcl.example and terraform.tfvars.example
- .gitignore hardened for Terraform artifacts

### CI prerequisites
Add the following GitHub repository secrets to enable CI and remote state initialization:
- AZURE_CREDENTIALS (from `az ad sp create-for-rbac ... --sdk-auth`)
- TF_STATE_RG
- TF_STATE_STORAGE_ACCOUNT
- TF_STATE_CONTAINER
- TF_STATE_KEY

### Notes
- After the first `terraform init` locally, commit `.terraform.lock.hcl` to lock provider checksums.
- If you set `public_network_access_enabled = false`, plan to use Private Endpoints for data-plane access.