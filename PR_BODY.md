## Summary

This PR makes the example more reproducible and secure-by-default, and adds basic CI.

### Key changes
- Add `versions.tf` with Terraform and `azurerm` provider pinning
- Harden `azurerm_storage_account` (TLS 1.2, HTTPS-only, no public blob access)
- Add input validations and common `tags`
- Output stable resource IDs
- Fix/clarify README (encoding artifacts, usage examples, name rules)
- Add GitHub Actions workflow for `fmt/init/validate`
- Add TFLint config and terraform-docs config (optional)

### Notes
- After merging, run `terraform init` locally and commit the generated `.terraform.lock.hcl` to lock provider checksums.
- If you prefer Private Endpoints, set `public_network_access_enabled = false` and extend the example accordingly.

---

Happy to tweak anything you’d like (location defaults, CI scope, etc.).
