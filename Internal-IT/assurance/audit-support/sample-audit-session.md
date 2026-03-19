Internal-IT/
└── assurance/
    ├── README.md
    # 👉 Purpose of assurance: evidence, auditability, verification layer
    #
    ├── evidence/
    │   ├── README.md
    │   # 👉 Explains evidence lifecycle: generation → transfer → storage → retention
    │
    │   ├── pipeline/
    │   │   ├── plan-outputs/
    │   │   ├── policy-results/
    │   │   └── approval-records/
    │   │   # 👉 From CI/CD (export-evidence.sh)
    │
    │   ├── detection/
    │   │   ├── guardduty-findings/
    │   │   ├── securityhub-findings/
    │   │   └── alert-snapshots/
    │   │   # 👉 Runtime security signals
    │
    │   ├── response/
    │   │   ├── remediation-logs/
    │   │   ├── playbook-executions/
    │   │   └── incident-records/
    │   │   # 👉 What actions were taken after detection
    │
    │   ├── drift/
    │   │   ├── drift-reports/
    │   │   └── deviation-logs/
    │   │   # 👉 Infra drift vs expected state
    │
    │   └── access-reviews/
    │       ├── quarterly-reviews/
    │       └── certification-records/
    │       # 👉 IAM governance proof (NOT policy, only results)
    #
    ├── audit-support/
    │   ├── audit-logs-index.md
    │   # 👉 Where each type of evidence lives
    │
    │   ├── evidence-guide.md
    │   # 👉 “How to retrieve proof for X control”
    │
    │   ├── auditor-requests/
    │   │   ├── access-control-sample.md
    │   │   ├── encryption-control-sample.md
    │   │   └── incident-response-sample.md
    │   # 👉 Simulated auditor questions + your answers
    │
    │   └── walkthrough.md
    │   # 👉 Step-by-step: how an audit session would go
    #
    ├── reports/
    │   ├── compliance-reports/
    │   │   ├── iso27001-readiness.md
    │   │   └── control-effectiveness.md
    │   │
    │   ├── security-reports/
    │   │   ├── monthly-security-summary.md
    │   │   └── incident-summary.md
    │   │
    │   └── drift-reports/
    │       └── infra-drift-summary.md
    │   # 👉 Human-readable summaries derived from evidence
    #
    ├── metrics/
    │   ├── security-kpis.md
    │   └── compliance-dashboard.md
    │   # 👉 “Are we actually secure?” in numbers
    #
    └── integrity/
        ├── evidence-handling.md
        ├── retention-policy.md
        └── immutability-notes.md
        # 👉 Shows evidence cannot be tampered with (auditor candy 🍬)