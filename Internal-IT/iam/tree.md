Internal-IT/
└── iam/
    ├── README.md
    │
    ├── governance/
    │
    │   ├── 00-architecture/
    │   │   ├── identity-architecture.md
    │   │   ├── federation-model.md
    │   │   ├── authentication-flow-diagrams.md
    │   │   ├── trust-boundary-definition.md
    │   │   └── identity-data-flow.md
    │   │
    │   ├── 01-policies-and-models/
    │   │   ├── rbac-abac-strategy.md
    │   │   ├── least-privilege-principle.md
    │   │   ├── segregation-of-duties-matrix.md
    │   │   ├── privileged-access-management.md
    │   │   ├── zero-trust-alignment.md
    │   │   └── access-control-mapping-to-iso-controls.md
    │   │
    │   ├── 02-human-identity-lifecycle/
    │   │   ├── joiner-mover-leaver-process.md
    │   │   ├── onboarding-checklist.md
    │   │   ├── offboarding-checklist.md
    │   │   ├── access-request-process.md
    │   │   └── temporary-access-policy.md
    │   │
    │   ├── 03-entra-id-idp/
    │   │   ├── configuration-notes.md
    │   │   ├── conditional-access-policies.md
    │   │   ├── mfa-enforcement-strategy.md
    │   │   ├── passwordless-strategy.md
    │   │   ├── group-structure-design.md
    │   │   └── scim-provisioning-model.md
    │   │
    │   ├── 04-aws-identity-center/
    │   │   ├── permission-set-design.md
    │   │   ├── role-mapping-matrix.md
    │   │   ├── cross-account-access-model.md
    │   │   ├── break-glass-procedure.md
    │   │   ├── session-control-policy.md
    │   │   └── mfa-enforcement-at-aws-layer.md
    │   │
    │   ├── 05-machine-identities/
    │   │   ├── service-account-policy.md
    │   │   ├── workload-identity-model.md
    │   │   ├── key-rotation-procedure.md
    │   │   ├── short-lived-credential-strategy.md
    │   │   └── ci-cd-identity-governance.md
    │   │
    │   ├── 06-access-review-and-certification/
    │   │   ├── quarterly-access-review-process.md
    │   │   ├── certification-workflow.md
    │   │   ├── review-criteria.md
    │   │   └── revocation-timelines.md
    │   │
    │   └── 07-monitoring-and-response/
    │       ├── identity-logging-strategy.md
    │       ├── anomaly-detection-rules.md
    │       ├── suspicious-login-response-playbook.md
    │       ├── privilege-escalation-detection.md
    │       └── emergency-access-monitoring.md
    │
    ├── terraform/
    │
    │   ├── entra-id/               # Optional – only if managing via Terraform
    │   │   ├── groups.tf
    │   │   ├── app-registrations.tf
    │   │   ├── scim-integration.tf
    │   │   └── conditional-access.tf
    │   │
    │   ├── aws-identity-center/
    │   │   ├── main.tf
    │   │   ├── permission-sets.tf
    │   │   ├── assignments.tf
    │   │   ├── sso-settings.tf
    │   │   └── variables.tf
    │   │
    │   ├── aws-iam-core/
    │   │   ├── break-glass-role.tf
    │   │   ├── cross-account-roles.tf
    │   │   ├── permission-boundaries.tf
    │   │   ├── custom-policies.tf
    │   │   └── trust-policies.tf
    │   │
    │   └── testing/
    │       ├── access-validation-tests.md
    │       └── federation-validation.md
    │
    └── evidence/
        ├── access-reviews/
        │   ├── 2026-Q1/
        │   ├── 2026-Q2/
        │   └── 2026-Q3/
        │
        ├── federation-and-scim-logs/
        │
        ├── mfa-enforcement-proof/
        │
        ├── break-glass-audit-logs/
        │
        ├── incident-related-identity-events/
        │
        └── external-audit-evidence-pack/