# Logging and Monitoring Standard

| Field | Value |
|---|---|
| Document ID | STD-LOG-01 |
| Classification | Internal |
| Owner | CISO |
| Approver | CISO |
| Version | 1.1 |
| Effective | On approval |
| Next review | 12 months after approval, or when a log source is added |
| Status | Draft. Not approved |

## 1. Purpose

Defines which events Ayka logs, how long logs are kept, how they are protected, and which events must raise an alert. It is a standard, not a policy: it sets concrete technical values that Terraform and the compliance gate can check.

## 2. Scope

AWS accounts in the organization, the `ayka-portal` workload, Entra ID, IAM Identity Center and the GitHub repository.

## 3. References

| Framework | Requirement |
|---|---|
| SOC 2 | CC7.2, CC7.3, CC4.1, A1.1 |
| ISO/IEC 27001:2022 | A.8.15, A.8.16, A.8.17 |
| GDPR | Art. 5(1)(c) and (e) for personal data in logs, Art. 32 |
| Controls | OP-03, OP-04, OP-05, AV-05 |

## 4. Log sources

| Source | What it records | Destination | Online retention | Status |
|---|---|---|---|---|
| AWS CloudTrail (multi-Region trail per account, log file validation; an organization trail is the target) | API calls and console logins | Dedicated, public-access-blocked trail bucket | 1 year, then archive 6 years | Designed ([`cloudtrail.tf`](../../Internal-IT/platform/foundation/landing-zone/modules/core/logging/cloudtrail.tf)) |
| VPC flow logs | Accepted and rejected network flows | CloudWatch Logs, KMS-encrypted | 365 days | Gated design |
| AWS WAF logs | Requests evaluated by the web ACL | CloudWatch Logs | 365 days | Gated design |
| ECS application logs | Application events, including authentication and authorisation decisions | CloudWatch Logs | 365 days | Gated design |
| ALB and S3 server access logs | HTTP requests; object access | S3 access-log bucket | 365 days | Gated design; noncurrent versions do not expire yet (readiness gap G13) |
| RDS PostgreSQL logs | Connections, errors, DDL | CloudWatch Logs | 90 days | Planned |
| Entra ID sign-in and audit logs | Sign-ins, MFA, directory changes | Export to the log archive | 1 year (Free tier keeps only 7 days in the portal) | Planned |
| GitHub audit log and Actions logs | Repository settings, ruleset and environment changes, workflow runs | Export to the log archive each month | 1 year | Planned |

Workload retention values are set in Terraform and checked by the gate through `VPC_FLOW_LOGS_MISSING`, `S3_LOGGING_DISABLED`, `WAF_LOGGING_DISABLED` and `CLOUDWATCH_LOG_GROUP_KMS_ENCRYPTION`.

## 5. Requirements

1. **Time.** Security records use UTC. The sources and the limit on that statement are in [section 5.1](#51-time-synchronization-a817).
2. **Integrity.** CloudTrail log file validation is on. The trail cannot be stopped, deleted or changed (SCP `deny-disable-cloudtrail`). The archive bucket uses Object Lock once it exists.
3. **Access.** Only Security Operations and the CISO can read the log archive; nobody can delete from it. Workload engineers read their own application logs.
4. **Content.** Application logs record who, what, when, from where and the outcome for: logins, failed logins, permission changes, data exports, and administrative actions. They never contain passwords, tokens, session cookies or the content of customer evidence files.
5. **Personal data.** IP addresses and user identifiers are personal data. They are kept only for the retention above and used only for security and operations (RoPA activity PA-03 in [Governance/GDPR](../GDPR/record-of-processing-activities.md)).

### 5.1 Time synchronization (A.8.17)

An earlier draft said that all systems use UTC from AWS-provided time sources. That sentence is withdrawn. GitHub-hosted runners are not an AWS time source, and no offset is measured.

| System | Clock this standard accepts | What is true on 2026-10-14 |
|---|---|---|
| GitHub-hosted Actions runners | The runner clock, timestamps stored in UTC | The gate uses these runners. Ayka does not configure NTP on them. Skew is not measured |
| Future EC2 instances Ayka operates | Amazon Time Sync Service (`169.254.169.123`), UTC | No instance is deployed. The workload plan does not set a different NTP server |
| ECS and other AWS-managed runtimes | The clock AWS provides for that service, UTC | Designed, not deployed |
| CloudTrail, ALB, S3 and CloudWatch log records | The clock of the AWS service that wrote the event, UTC | Designed. No delivered object has been compared with another source |
| Entra ID sign-in and audit logs | Microsoft's service time, UTC | Export is Planned in section 4. No export exists |
| Staff endpoints | The operating system's maintained time source, with security notes written in UTC | No device is enrolled ([endpoint policy](user-endpoint-device-policy.md)) |

A host Ayka operates that does not use Amazon Time Sync, or a documented equivalent, is a finding once the host exists. Incident notes state the offset when a source is not UTC. Comparing sources, and alerting when skew exceeds one second on a host Ayka operates, is required before a cross-source timeline is relied on. That comparison is not built. Provider logs stay on the provider's clock until a comparison exists. One second is a proposed threshold, not a measured result.

## 6. Alerting

The following events publish to the `security-alerts` SNS topic and page the on-call engineer. Each rule is tested when created and once a year, and the test is recorded.

| ID | Event | Severity | Source |
|---|---|---|---|
| ALR-01 | Root user activity in any account | SEV 1 | CloudTrail via EventBridge |
| ALR-02 | `BreakGlassRole` assumed | SEV 2 | CloudTrail via EventBridge |
| ALR-03 | CloudTrail stop, delete or update attempted (including denied attempts) | SEV 1 | CloudTrail via EventBridge |
| ALR-04 | IAM policy, role trust or permission boundary changed outside the pipeline role | SEV 2 | CloudTrail via EventBridge |
| ALR-05 | GuardDuty finding of severity medium or higher | Mapped from finding | GuardDuty |
| ALR-06 | Security group opened to `0.0.0.0/0` | SEV 2 | AWS Config rule or EventBridge |
| ALR-07 | Portal unavailable for 3 consecutive checks | SEV 1 if all customers | External uptime monitor |
| ALR-08 | Ruleset `protect-main` or an approval environment changed | SEV 2 | GitHub audit log |
| ALR-09 | Spike in WAF blocked requests or ALB 5xx above threshold | SEV 3 | CloudWatch alarm |

None of these rules exists yet. Today the topic and its e-mail subscription are designed in [`sns.tf`](../../Internal-IT/platform/foundation/landing-zone/modules/core/alerts/sns.tf), with no publisher.

## 7. Review

- Alerts are acknowledged within the response time for their severity in the [Incident Response Plan](incident-response-plan.md).
- Security Operations reviews a monthly summary of alerts, WAF trends and failed logins, and notes the review.
- The CISO reviews this standard yearly against new log sources and the threat scenarios catalogue.

## Revision history

| Version | Date | Change |
|---|---|---|
| 1.0 | 2026-10-06 | First issue |
| 1.1 | 2026-10-14 | Name each time source. Withdraw the claim that every system uses AWS time |
