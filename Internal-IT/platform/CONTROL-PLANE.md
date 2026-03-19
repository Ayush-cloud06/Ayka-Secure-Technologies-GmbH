# Platform Control Planes

The platform is structured into independent control planes:

## Identity (Tier-0)
Responsible for authentication, authorization, and access governance.

## Network
Controls traffic flow, segmentation, and egress restrictions.

## Detection
Provides centralized visibility and threat detection.

## Response
Automates remediation and incident handling.

## Design Principles
- Domain isolation via separate Terraform states
- Least privilege between domains
- Centralized logging and auditability