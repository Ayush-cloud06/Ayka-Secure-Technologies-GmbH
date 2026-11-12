# Remote state (bootstrap step 1)

Creates the state backends every other root uses. See the bootstrap order in [../README.md](../README.md).

- AWS (`bootstrap.tf`): S3 bucket `ayka-terraform-state` (versioned, SSE-S3, public access blocked, TLS-only policy, noncurrent versions kept 365 days) and DynamoDB lock table `terraform-locks` (encrypted, point-in-time recovery), both in `eu-central-1`.
- Azure (`main.tf`): storage account and container `entra-id` for the Entra ID state (blob versioning, 30-day soft delete, no anonymous blob access).
- This root keeps **local** state on purpose. That state file holds secrets (Azure storage keys) and must never be committed.
- Gated in source mode only: planning it needs a real Azure login.
