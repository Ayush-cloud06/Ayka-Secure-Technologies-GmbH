# 🚀 Ayka Customer Portal (Workload)

## 📖 Overview
The **Ayka Customer Portal** is a Tier-1 customer-facing web application workload. It is designed to securely process and store customer inquiries and user profile data. 

In alignment with Ayka Secure Technologies GmbH's internal IT policies, this workload is fully decoupled from foundational infrastructure. It does not provision its own networking or core identity components; instead, it securely inherits these resources from the central Platform Control Plane via data sources.

## 🏗️ Architecture Specs
This workload implements a highly available, 3-tier architecture (SAA-Standard):
* **Routing & Ingress:** Application Load Balancer (ALB) across multiple public subnets, protected by AWS WAF.
* **Compute:** Containerized application running on Amazon ECS (Fargate) across private subnets.
* **Storage (Primary):** Amazon RDS for PostgreSQL deployed in Multi-AZ configuration within isolated database subnets.
* **Analytics (Event-Driven):** Application event logs are streamed via Amazon Kinesis Data Firehose into an S3 Data Lake for querying via Amazon Athena.

## 🛡️ GRC & Compliance Boundaries
This workload processes **Confidential** data (including Customer PII). It is strictly mapped to our ISMS and GDPR frameworks.

| Domain | Implementation | ISO 27001 / GDPR Mapping |
| :--- | :--- | :--- |
| **Access Control** | ECS Execution Roles assumed via central IAM Platform. Least privilege enforced. | A.9.1.2, GDPR Art. 32(1)(b) |
| **Data at Rest** | RDS and S3 buckets encrypted using Platform-managed AWS KMS CMKs. | A.10.1.1, GDPR Art. 32(1)(a) |
| **Data in Transit** | TLS 1.2+ enforced on ALB. Internal ALB-to-ECS traffic encrypted. | A.10.1.1, A.13.2.1 |
| **Traceability** | All infrastructure changes require PR approvals. CloudWatch logs centralized. | A.12.4.1, A.14.2.7 |
| **Segregation** | Workload state is isolated from Platform state. Network boundaries enforced via SGs. | A.13.1.3 |

## 🧩 Module Layout
To maintain DRY principles and blast-radius isolation, this workload is split into functional modules:
* `/modules/compute/` - ALB, Target Groups, ECS Cluster, Task Definitions, and Auto-scaling.
* `/modules/database/` - RDS Instances, Subnet Groups, and Secrets Manager integration.
* `/modules/analytics/` - Kinesis Delivery Streams, S3 Data Lake, and Athena Workgroups.

## 🔌 Platform Dependencies (Inheritance)
This workload expects the following resources to be pre-provisioned by the Platform team. These are fetched dynamically via `data.tf`:
1. `ayka-prod-vpc` and associated Private/Public/DB subnets.
2. `WorkloadOperatorRole` (Execution IAM Role).
3. `ayka-central-kms-key` (For encryption at rest).
4. Centralized CloudWatch Log Destinations.

## 🎮 Deployment Guide
This infrastructure is managed via our Compliance-Gated CI/CD Pipeline. 

**Local Validation (Dry-Run):**
```bash
terraform init
terraform validate
terraform plan -var-file="envs/dev.tfvars"