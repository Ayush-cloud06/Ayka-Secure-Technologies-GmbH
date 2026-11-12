# Evidence archive

> **Scanned design, never applied.** Planned offline with mock credentials and scanned by the `Platform Gate` job in `test.yml` (not yet a required check). No bucket exists.

Closes the design half of SOC 2 readiness gap G7: GitHub keeps CI artifacts for at most 90 days, while a Type II period plus reporting needs about 18 months.

| Property | Design |
|---|---|
| Bucket | `ayka-evidence-archive-<security account>` in `eu-central-1` |
| Retention | S3 Object Lock, **COMPLIANCE** mode, 548 days (18 months) default retention on every object. Cannot be shortened or bypassed, root included |
| Deletion | Lifecycle expires objects after 549 days; locked versions are only removed once their lock has passed |
| Encryption | SSE-KMS with a dedicated key, rotation on; TLS-only bucket policy |
| Write path | Role `evidence-archive-writer`, assumed through GitHub OIDC from `refs/heads/main` only; `s3:PutObject` under `runs/` and nothing else. The bucket policy denies `PutObject` to every other principal |

Not built:
- No workflow step uploads to the bucket. The pipeline has no OIDC permission today and plan-only CI stays credential-free (root README, "No cloud credentials in plan-only CI"); adding the upload is a separate change.
- No server access logging or replication for this bucket (see `exceptions.yaml`).
- A COMPLIANCE-mode lock cannot be undone. Applying this in a test account creates objects that nobody can delete for 18 months.

Run locally: `bash Internal-IT/engineering/ci-cd/scripts/run-local-chain.sh Internal-IT/platform/foundation/evidence-archive`.
