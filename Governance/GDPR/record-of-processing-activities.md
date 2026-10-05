# Record of Processing Activities (RoPA)

- **Organization:** Ayka Secure Technologies GmbH (simulated case study), Stuttgart, Germany
- **Framework:** GDPR Art. 30(1) (controller) and Art. 30(2) (processor)
- **Owner:** GDPR Lead role (EMP-004, fictional), reporting to the CISO role
- **Version:** 1.0
- **Last updated:** 2026-10-05
- **Status:** Draft. Not approved: no approval record exists.

## 1. Reality column

Each activity says whether it is real today:

- **Real**: personal data is actually processed now, by this repository or its hosting.
- **Simulated**: the activity belongs to the fictional company; the data is invented.
- **Planned**: the system that would process the data is design-only; nothing is processed.

Real processing is small but not zero: see PA-01 and PA-02.

## 2. Controller activities (Art. 30(1))

### PA-01 Employee identity and access management

| Field | Entry |
|---|---|
| Reality | **Simulated, with one real record.** 47 entries in [`personnel.json`](../../Internal-IT/platform/domains/identity/entra-id/modules/core/personnel.json); EMP-001 is the real repository owner. The file is public on GitHub, so it is really disclosed |
| Purpose | Create staff accounts, department and tier groups, and AWS access from one personnel source |
| Data subjects | Employees |
| Data categories | First and last name, display name, role, secondary role, department, employment type, line manager, security role, privilege tier, privileged flag, start date |
| Special categories (Art. 9) | None |
| Legal basis | Art. 6(1)(b) employment contract, with § 26 BDSG for employee data (to verify against the current BDSG after the 2023 CJEU ruling C‑34/21) |
| Recipients | Microsoft (Entra ID), AWS (IAM Identity Center): both planned; GitHub (repository hosting): real |
| Third-country transfer | GitHub: yes, United States (real). Microsoft and AWS: none intended once in `eu-central-1` |
| Retention | Not defined. Planned: delete within a defined period after leaving; see data retention schedule (planned) |
| TOMs | [Identity and access TOMs](technical-and-organization-measures/identity-and-access-toms.md) |

### PA-02 Source control and CI

| Field | Entry |
|---|---|
| Reality | **Real** |
| Purpose | Version control, code review and the compliance gate |
| Data subjects | Repository contributors |
| Data categories | Git author name and e-mail address, GitHub username, pull-request comments, CI workflow logs |
| Legal basis | Art. 6(1)(f) legitimate interest in traceable changes |
| Recipients | GitHub (processor for private data; commit metadata in a public repository is public) |
| Third-country transfer | United States (GitHub) |
| Retention | Git history: kept indefinitely by design. CI artifacts: no `retention-days` is set in [`.github/`](../../.github/), so the repository default applies (inferred: 90 days) |
| TOMs | Repository access through GitHub accounts; [segregation of duties](technical-and-organization-measures/segregation-of-duties.md) |

### PA-03 Security logging

| Field | Entry |
|---|---|
| Reality | **Planned** |
| Purpose | Detect and investigate security events |
| Data subjects | Staff and customer users whose actions or requests are logged |
| Data categories | IP address, user/role identifier, request metadata, timestamps |
| Legal basis | Art. 6(1)(f) legitimate interest in security; Art. 32 obligation |
| Recipients | AWS (CloudTrail, S3, CloudWatch) |
| Third-country transfer | None intended (`eu-central-1`) |
| Retention | Not defined |
| Source | CloudTrail in the landing zone ([`landing-zone/modules/core/logging/`](../../Internal-IT/platform/foundation/landing-zone/modules/core/logging/)); ALB and S3 access logs in [`ayka-portal`](../../Internal-IT/workloads/ayka-portal/). Delivery never tested (RISK-006) |

### PA-04 Personnel administration and training records

| Field | Entry |
|---|---|
| Reality | **Simulated**: [`personnel-register.md`](../../organization/personnel-register.md) and [`training-and-awareness.md`](../../organization/training-and-awareness.md) describe fictional staff; no training record exists |
| Purpose | Role assignment, onboarding, awareness training |
| Data subjects | Employees |
| Data categories | Name, role, manager, start date, training completion |
| Legal basis | Art. 6(1)(b); § 26 BDSG (to verify) |
| Recipients | None outside Ayka |
| Retention | Not defined |

## 3. Processor activities (Art. 30(2))

### PP-01 Customer compliance data in the SaaS platform

| Field | Entry |
|---|---|
| Reality | **Planned**: [`ayka-portal`](../../Internal-IT/workloads/ayka-portal/) is plan-only with mock credentials; no customer exists |
| Controllers | Ayka's customers (EU SMEs and automotive suppliers, per [`business-model.md`](../../organization/business-model.md)) |
| Processing | Store and display customer users' accounts and the compliance evidence they upload |
| Data categories | Customer user name, e-mail, role; any personal data inside uploaded evidence |
| Sub-processors | AWS; see [processor register](processor-register.md) |
| Third-country transfer | None intended (`eu-central-1`); current Terraform uses `ap-south-1` ([`dev.tfvars`](../../Internal-IT/workloads/ayka-portal/envs/dev.tfvars)), which would be a transfer to India |
| TOMs | Storage, network and encryption controls that the gate checks on the Terraform plan (Implemented at plan time; nothing deployed), in [`control-mapping.yaml`](../../Internal-IT/engineering/policy-as-code/metadata/control-mapping.yaml) |

## 4. Gaps

1. The real public disclosure in PA-01 should be minimized: replace `personnel.json` entries with clearly fictional data, or accept it as the owner's own choice, and record the decision.
2. No retention period is defined for any activity (planned slice G-10).
3. Legal bases are proposed, not reviewed (planned slice G-11).
4. Region mismatch for PA-03 and PP-01 until the Terraform moves to `eu-central-1`.

## 5. Review

Review when a new data flow, system, processor or Region enters scope, and at least annually.
