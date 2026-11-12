# Landing Zone

Applies baseline security configuration to the security, dev and prod accounts (one module instance each, through `OrganizationAccountAccessRole`). Region `eu-central-1`; a us-east-1 provider alias per account only carries EventBridge forwarding rules for global-service events.

Includes:
- Root protection, IAM baseline roles, automation permission boundary
- Logging: multi-Region CloudTrail with log-file validation, KMS-encrypted log bucket with **S3 Object Lock (COMPLIANCE, 548 days = 18 months)** and matching lifecycle expiry
- Detection (`modules/detection`): GuardDuty, Security Hub (FSBP and CIS 1.4), AWS Config recorder, and EventBridge rules for root activity, break-glass role assumption, CloudTrail stop/delete/update, IAM policy changes and GuardDuty findings (severity 4+), all publishing to the KMS-encrypted `security-alerts` SNS topic
- Break-glass role, cost controls, quotas, SIEM delivery stream

Status: scanned design (the `Platform Gate` job is not yet a required check). Planned offline with mock credentials and scanned by the `Platform Gate` job; never applied. No alert rule has fired or been tested.

Known limits (design facts, not verified against a live account):
- IAM, root console sign-in and global-STS events reach EventBridge only in us-east-1; they are forwarded to `eu-central-1`, which needs the us-east-1 EventBridge carve-out in the region SCP.
- AssumeRole through a regional STS endpoint outside `eu-central-1`/`us-east-1` is denied by the SCP rather than detected.
- The SNS email subscription must be confirmed by the recipient before any alert is delivered.
