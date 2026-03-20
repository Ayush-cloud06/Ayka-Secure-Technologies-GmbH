# 🏢 Enterprise Cloud Security Platform Architecture

This repository contains the full Infrastructure as Code (IaC), policy-as-code, and governance artifacts for our secure cloud platform. It is structured into distinct domains to ensure strict separation of duties, minimizing blast radius and enabling continuous compliance auditing.

## 📂 Repository Layout

platform/
├── README.md                              # Start here. High-level platform overview.
├── CONTROL-PLANE.md                       # Instructions for operating the terraform root modules.
├── architecture.md                        # Visual diagrams of the multi-account AWS environment.
#
# ============================================================================
# 1. FOUNDATION (The Concrete Slab)
# AWS Organizations, SCPs, and the core Landing Zone. Touched rarely.
# ============================================================================
├── foundation/
│   ├── README.md
│   ├── Platform_Compliance.md
│   ├── aws-organization/                  # Org structure and Service Control Policies (SCPs)
│   │   ├── main.tf
│   │   └── modules/
│   │       ├── ou-structure/              # Sandbox, Workloads, Security OUs
│   │       └── scp/                       # The absolute boundaries (deny-root, restrict-region)
│   ├── landing-zone/                      # Account baselines and vending
│   │   ├── main.tf
│   │   └── modules/
│   │       ├── core/                      # Org-level logging, cost controls, SIEM exports
│   │       ├── break_glass/               # Emergency baseline access
│   │       └── account_landing_zone/      # Baseline applied to every new child account
│   └── remote-state/                      # S3/DynamoDB setup for Terraform state locking
#
# ============================================================================
# 2. DOMAINS (The Business Logic & Security Controls)
# Modularized infrastructure. Deployed into specific accounts (e.g., Security Tooling).
# ============================================================================
├── domains/
│   ├── identity/                          # (Populated by User - IAM Center, EntraID, ABAC)
│   │   └── [Omitted for brevity]
│   │
│   ├── detection/                         # Continuous Visibility & Threat Intel
│   │   ├── README.md
│   │   ├── control-plane.tf               # Orchestrates detection modules
│   │   └── modules/
│   │       ├── guardduty/                 # Threat detection & trusted IP sets
│   │       ├── securityhub/               # CSPM, configuration policies, and aggregation
│   │       ├── macie/                     # PII/Data discovery in S3
│   │       ├── inspector/                 # Vulnerability management (EC2/ECR)
│   │       └── detective/                 # Graph-based investigation
│   │
│   ├── response/                          # Incident Response & Automation
│   │   ├── README.md
│   │   ├── eventbridge-router.tf          # Catches findings from detection domain
│   │   ├── auto-remediation/              # Instant Lambda fixes
│   │   │   ├── root_key_fix.py
│   │   │   ├── s3_public_fix.py
│   │   │   └── sg_ssh_fix.py
│   │   ├── orchestration/                 # Complex IR playbooks
│   │   │   ├── step-functions/
│   │   │   │   └── malware_containment.asl.json
│   │   │   └── ssm-automation/
│   │   │       └── quarantine_ec2.yaml
│   │   └── notification/                  # Paging & ChatOps (Slack/Teams)
│   │
│   └── network/                           # Infrastructure Security & Perimeters
│       ├── README.md
│       ├── network-foundation/            # VPCs, Subnets, Endpoints, Flow Logs
│       ├── centralized-egress/            # NAT, Network Firewall, Egress filtering
│       ├── microsegmentation/             # East-West control, strict NACLs/SGs
│       └── perimeter-defense/             # North-South: WAF, Shield, ALB, ACM
#
# ============================================================================
# 3. SHARED (The Utility Closet)
# Resources consumed globally by all domains (Encryption, Naming, Global Configs).
# ============================================================================
├── shared/
│   ├── kms/                               # Customer Managed Keys & Key Policies
│   ├── secrets/                           # Secrets Manager & Parameter Store baselines
│   ├── logging/                           # Standardized log retention policies
│   ├── naming/                            # Terraform naming convention modules
│   └── policies/                          # Reusable IAM policy documents
#
# ============================================================================
# 4. ENGINEERING (The Factory Floor)
# CI/CD pipelines, Policy-as-Code (OPA), and drift detection.
# ============================================================================
├── engineering/
│   ├── ci-cd/                             # GitHub Actions / GitLab CI workflows
│   │   ├── compliance-gates/              # OPA enforcement levels & approvals
│   │   └── pipelines/                     # tfsec, checkov, plan, apply, emergency-bypass
│   ├── policy-as-code/                    # Preventive Governance
│   │   ├── OPA/                           # Rego policies for Terraform validation
│   │   └── config-rules/                  # Reactive AWS Config Custom Rules
│   └── drift-detection/                   # Infrastructure state drift monitoring scripts
#
# ============================================================================
# 5. ASSURANCE (The Auditor's Dashboard)
# Evidence, reports, and compliance artifacts. Strictly read-only / generated data.
# ============================================================================
├── assurance/
│   ├── audit-support/                     # Walkthroughs and sample evidence for auditors
│   ├── evidence/                          # Auto-generated outputs (Plans, Reviews, Drift logs)
│   ├── integrity/                         # Rules for evidence immutability and retention
│   ├── metrics/                           # Security KPIs and compliance dashboard links
│   └── reports/                           # ISO27001 readiness, monthly incident summaries
#
# ============================================================================
# 6. OPERATIONS (The Day-To-Day)
# Human-driven processes, playbooks, and monitoring.
# ============================================================================
└── operations/
    ├── change-management/                 # Rollout strategies and change policies
    ├── incident-response/                 # Playbooks and tabletop exercise scenarios (Postsims)
    └── monitoring/                        # CloudWatch Dashboards and alerting strategies