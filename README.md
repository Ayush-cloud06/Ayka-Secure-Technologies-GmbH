# Compliance-Oriented Cloud Security Platform

## Overview

This repository implements a comprehensive, compliance-oriented cloud security platform for **Ayka Secure Technologies GmbH**, a simulated cloud-native SaaS startup based in the EU. It serves as both the company's internal security infrastructure and a reference implementation for regulated organizations seeking to achieve and maintain compliance across multiple frameworks.

The platform demonstrates practical implementation of security controls, governance models, and automated compliance enforcement in cloud environments, with a focus on AWS as the primary cloud provider.

## Key Components

### 1. Governance
- **Compliance Frameworks**: Mappings and controls for ISO 27001, NIST Cybersecurity Framework (CSF) 2.0, AWS CIS Benchmarks, SOC 2, and GDPR
- **Security Architecture**: Detailed documentation of security operating models, identity architecture, and control hierarchies
- **Audit & Evidence**: Structured audit evidence trails, control mapping, and compliance documentation
- **Organizational Governance**: Roles, responsibilities, and security policies aligned with industry best practices

### 2. Internal-IT (Infrastructure as Code)
- **AWS Organization Setup**: Multi-account architecture with organizational units (OUs), Service Control Policies (SCPs), and delegated administration
- **Landing Zone**: Core security foundations including:
  - Identity and Access Management (IAM) with role-based access control (RBAC) and attribute-based access control (ABAC)
  - CloudTrail logging and monitoring
  - S3 public access blocking
  - Break-glass emergency access procedures
  - Security Information and Event Management (SIEM) integration
- **Security Automation**: CI/CD pipelines, incident response workflows, policy-as-code enforcement, and drift detection

### 3. Organization
- **Governance Structure**: Organizational hierarchy with Chief Information Security Officer (CISO) independence
- **Personnel Management**: Security training programs, personnel registers, and background checks
- **Vendor Management**: Third-party risk assessment and management processes

## Compliance Frameworks Supported

- **ISO 27001**: Information Security Management Systems
- **NIST CSF 2.0**: Cybersecurity Framework
- **AWS CIS Benchmarks**: Center for Internet Security controls for AWS
- **SOC 2**: Service Organization Control 2 (Security, Availability, Processing Integrity, Confidentiality, Privacy)
- **GDPR**: General Data Protection Regulation compliance mappings

## Architecture Highlights

### Identity Architecture
The platform implements a multi-tier identity model:
- **Tier 0**: Security Administration
- **Tier 1**: Infrastructure Operators
- **Tier 2**: Developers

Flow: HR Dataset → Microsoft Entra ID → SCIM Provisioning → AWS Identity Center → Tier Groups → Permission Sets → IAM Roles → ABAC Policies → Resource Access

### Multi-Account AWS Organization
- Root account isolation
- Dedicated security and logging accounts
- Workload accounts with automated controls
- Cross-account access via IAM roles and permission boundaries

## Goals and Objectives

- Establish an **ISO 27001-aligned security foundation** for cloud operations
- Enforce **automated compliance controls** across multiple regulatory frameworks
- Provide **audit-ready evidence** and documentation for certification audits
- Implement **zero-trust principles** with least-privilege access
- Enable **continuous compliance monitoring** and automated remediation
- Serve as a **reference architecture** for compliance-focused cloud deployments

## Technology Stack

- **Infrastructure as Code**: Terraform, Terragrunt
- **Cloud Provider**: Amazon Web Services (AWS)
- **Identity Provider**: Microsoft Entra ID (Azure AD)
- **Policy Engine**: Open Policy Agent (OPA)
- **CI/CD**: GitHub Actions
- **Documentation**: Markdown, Mermaid diagrams

