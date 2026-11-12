# SIM-OPS-001 Capacity, clock and network design review

> **SIMULATED RECORD.** Tabletop walk-through of a written procedure. No such event took place. See ADR-0006.

| Field | Value |
|---|---|
| Record ID | SIM-OPS-001 |
| Authored | 2026-11-10 |
| Scenario date | 2026-10-28 (design review meeting) |
| Participants | EMP-003 (Cloud Platform Engineer, owner of the design), EMP-013 (DevOps, CI and Terraform), EMP-014 (Security Engineer, reviewer), EMP-005 (Incident Coordinator, monitoring view), EMP-002 (CISO, decisions) |
| Procedure exercised | [Business continuity and disaster recovery plan POL-BCDR-01](../../../policies/business-continuity-and-disaster-recovery-plan.md) section 5 (resilience in the design, capacity row); [Logging and monitoring standard STD-LOG-01](../../../policies/logging-and-monitoring-standard.md#51-time-synchronization-a817) section 5.1; [Cloud security policy POL-CLD-01](../../../policies/cloud-security-policy.md) sections 4.6 and 4.7 (configuration baseline, network row) |
| Controls | ISO/IEC 27001:2022 Annex A A.8.22 (raised); A.8.6 and A.8.17 (looked at, not raised); A.8.20 and A.8.21 (observed, status unchanged). SOC 2 AV-05, OP-03 |

## 0. How to read this record

This is a **review of code**, so two kinds of statement are mixed and must not be confused.

- **[R] Real observation.** A fact about the repository on the Authored date (2026-11-10), found by reading the files named. It is true whether or not the scenario happened. Checkable with `grep` and a file viewer. No Terraform was applied. No plan was newly run for this record.
- **[S] Scenario.** The meeting, who said what, the decisions and any number that is not in a file. Not a fact.

All paths are relative to `Internal-IT/workloads/ayka-portal/` unless stated. The workload has never been deployed and its only environment file is `envs/dev.tfvars` ([R]). The Region in source is `eu-central-1` since 2026-11-10; the review does not claim what the source said on 2026-10-28.

## 1. Capacity (A.8.6)

**What the design says.** POL-BCDR-01 section 5, one row: "ALB and ECS across availability zones; CPU autoscaling | Zone loss, load peaks | `compute/` | Gated design". Nothing else in the plan or in STD-LOG-01 defines capacity, thresholds, forecasts or tests ([R], read in full).

**What the code does.**

| Item | Observation [R] | File |
|---|---|---|
| ECS task size | 256 CPU units, 512 MB memory | `modules/compute/variables.tf` (`ecs_cpu`, `ecs_memory`) |
| ECS count | desired 1, minimum 1, maximum 2 | same (`ecs_desired_count`, `ecs_min_capacity`, `ecs_max_capacity`) |
| Scaling rule | One target-tracking policy on average CPU, target 70 %. No memory metric, no request-count metric | `modules/compute/autoscaling.tf` |
| Database | `db.t3.micro`, 20 GB, storage can grow to 100 GB, Multi-AZ, Performance Insights on, enhanced monitoring 60 s | root `variables.tf` (`db_instance_class`, `db_allocated_storage`, `db_max_allocated_storage`); `modules/database/main.tf` |
| Operations host | One `t3.micro`, 20 GB root volume, in a private subnet | `modules/compute/ec2.tf` |
| Outbound path | **One NAT gateway**, placed in public subnet 0; both private subnets share one route table that sends `0.0.0.0/0` to it | `modules/networking/main.tf` (`aws_nat_gateway.this`, `aws_route_table.private`) |
| Alarms | **No `aws_cloudwatch_metric_alarm` and no other alarm resource anywhere under `Internal-IT/`.** The alert topic exists in the landing-zone design (`Internal-IT/platform/foundation/landing-zone/modules/core/alerts/sns.tf`) with no publisher | `grep` over `Internal-IT/` |
| Service quotas | Not mentioned in any file | `grep` |

**Scenario review [S].** EMP-003 and EMP-014 asked: what is the largest request the service must survive, and what would tell us before it fails? The only worked load was the audit-log export of [SIM-SDL-001](../sdlc/SIM-SDL-001-feature-security-lifecycle.md): a row cap of 1,000,000 rows at roughly 300 bytes per row is about 300 MB of data. In a 512 MB task with the runtime and web server, a version that holds the rows in memory has no room. SIM-SDL-001 found that a first version was killed at 512 MB (scenario). The fix there was streaming. Nobody can say what happens with two exports at once on a task with 256 CPU units, because no load test exists and no threshold is defined. Whether the single task survives while the second starts is not known.

Decision [S] by EMP-002: write capacity thresholds (CPU, memory, database connections, free storage, NAT bytes) and an alarm for each before first deployment; run one load test on the first environment. Owner EMP-003, due before first deployment (no date: no deployment is planned).

**Why A.8.6 is not raised.** The design is one row. It sets no threshold and defines no monitoring, forecast or test. Nothing is exercised by the review except finding that there is nothing to exercise. The row stays **Designed**.

## 2. Clock synchronisation (A.8.17)

**What the standard says.** STD-LOG-01 section 5.1 (withdrawn earlier statement; per-system table): runners use their own clock; future EC2 instances use Amazon Time Sync (`169.254.169.123`); ECS and managed runtimes use the clock AWS provides; log records use the writing service's clock; Entra export is Planned; endpoints use the operating system's time source. Skew above one second on a host Ayka operates should alert; "that comparison is not built".

**What the code does [R].**

- No file under the workload sets or mentions `ntp`, `chrony`, `169.254.169.123` or a time-sync setting. `grep` for those terms returns nothing.
- The only host Ayka would operate is the `t3.micro` in `modules/compute/ec2.tf`. Its image is `ec2_ami_id`, set in `envs/dev.tfvars` to `ami-1234567890abcdef0`, an obvious placeholder. **Which time source the image uses is unknowable from the repository.** The standard's own test, "a host that does not use Amazon Time Sync or a documented equivalent is a finding once the host exists", cannot be run.
- ECS tasks use `launch_type = "FARGATE"` (`modules/compute/ecs.tf`): the time source is the managed one, as the standard says. No offset can be read from code.
- No skew alert exists. There is no alarm of any kind (section 1).

**Scenario [S].** EMP-005 asked for the offset check "for the incident timeline": which timestamp can I trust when GitHub, CloudTrail and a laptop disagree? The answer from the standard is: UTC, each source's own clock, offset noted by the writer. It was accepted for the pilot. Decision by EMP-002: choose a real image (Amazon Linux or similar) before the host exists and record its time source. Owner EMP-013.

**Why A.8.17 is not raised.** The check the standard requires cannot be run (placeholder image, no comparison built). The review can restate the table but cannot test any row. The row stays **Designed**.

## 3. Network separation (A.8.22)

**What the policy says.** POL-CLD-01 section 4.7: network baseline "No SSH or HTTP from the internet; no unrestricted NACL ingress; no default VPC; only the ALB is public, behind WAF". Section 4.1 table row: "Least exposure; only the ALB is public". No document lists the zones, the permitted flows or the tests.

**Zones in the code [R]** (`modules/networking/main.tf`, `modules/security/main.tf`; subnet ranges in `envs/dev.tfvars`)

- Public subnets (2): internet gateway route; hold the ALB and the NAT gateway.
- Private subnets (2): default route through the NAT gateway; hold the ECS tasks and the operations host.
- Database subnets (2): a route table with **no routes** beyond the local VPC range, so no path to or from the internet.
- The VPC's default security group has its rules removed (`aws_default_security_group.this`).
- VPC flow logs (all traffic) to an encrypted CloudWatch log group with 365-day retention (`aws_flow_log.vpc`).

**Permitted flows derived from the security-group rules [R]**

| From | To | Port | Rule resource in `modules/security/main.tf` |
|---|---|---|---|
| Internet (`0.0.0.0/0`) | ALB | 443 | `alb_https_from_internet` |
| ALB | ECS tasks | app port | `alb_to_ecs` (egress) and `ecs_from_alb` (ingress) |
| ECS tasks | Database | db port | `ecs_to_rds` and `rds_from_ecs` |
| Operations host | Database | db port | `ec2_to_rds` and `rds_from_ec2` |
| ECS tasks | Internet (`0.0.0.0/0`) | 443 | `ecs_https_outbound` ("image pulls and telemetry") |
| Operations host | Internet (`0.0.0.0/0`) | 443 | `ec2_https_outbound` ("updates and systems management") |

Not permitted by any rule: anything into the operations host (the group's description says "no inbound access"); ALB to database; internet to ECS or database directly.

**Observations that the policy does not mention [R]**

- No network ACL resource and no VPC endpoint exists in the workload (`grep`). Traffic to S3, the container registry, CloudWatch, KMS and Secrets Manager leaves through the NAT gateway to public endpoints on 443. The gate rule `NETWORK_ACL_UNRESTRICTED_INGRESS` can only judge ACLs that exist; the default ACL, which allows everything, is not examined.
- Egress to `0.0.0.0/0` on 443 is open from both ECS tasks and the operations host. A compromised task can send data to any internet host on 443.
- The operations host has no inbound path and no instruction for how an administrator reaches it: no systems-management permission is attached to its role (no `ssm` anywhere in the workload; its role `aws_iam_role.ec2` has no attached policy, and neither does the ECS task role). The group description says "updates and systems management" for its outbound rule, but the host cannot register for either.
- The ECS tasks and the operations host reach the database with the same group rule and port. No separation between application access and administrator access exists at network level.

**Scenario paper test [S].** EMP-014 and EMP-013 wrote six flow tests from the table and ran them **on paper** (read the rules and predict):

| # | Flow | Predicted | Matches the policy statement |
|---|---|---|---|
| 1 | Internet to ECS task directly | Denied (private subnet, security group admits only the ALB group) | Yes |
| 2 | Internet to database | Denied (no route, no rule) | Yes |
| 3 | ALB to database | Denied (no rule) | Yes |
| 4 | ECS task to internet on 22 | Denied (egress only 443) | Yes |
| 5 | Operations host to ECS task app port | Denied (ECS ingress only from the ALB group) | Yes |
| 6 | ECS task to an arbitrary internet host on 443 | **Permitted** | The policy has no statement about egress, so nothing to match |

None was executed. No environment exists. The result is a flow matrix that agrees with the policy sentence "only the ALB is public" and shows the egress and endpoint gaps.

Decision [S] by EMP-002: accept the matrix as the design record; add an egress and endpoint item to the first-deployment checklist; do not change the policy until a decision on VPC endpoints is taken (cost against exposure).

**Why A.8.22 is raised.** The control is separation of trust zones. The design defines three zones and the rules between them in code. The review derived the permitted and denied flows and compared them with the policy statement on paper. That is the core step of the control and it could be completed. It is a read of source, so the status is **Simulated operation** only; the gated-design status of the related rows A.8.20 and A.8.21 is unchanged.

## 4. Results

| Row | Outcome | Reason |
|---|---|---|
| A.8.6 Capacity management | Stays Designed | One row of design, no thresholds, no alarms, no test |
| A.8.17 Clock synchronisation | Stays Designed | The standard's check cannot be run: placeholder image, no comparison built |
| A.8.22 Network separation | Raised to Simulated operation | Flow matrix derived and compared with the policy on paper |

## Findings

1. **POL-BCDR-01 has no capacity requirement.** Section 5 names "CPU autoscaling". Define the resources to be watched, the thresholds, who is told and the test. Without them A.8.6 has nothing to check.
2. **No alarm of any kind exists in the workload.** The standard's alert table (STD-LOG-01 section 6) has no capacity or availability alarm other than ALR-07 (uptime) and ALR-09 (WAF and 5xx). CPU, memory, database storage, connections and NAT use are unmonitored. (Real defect of the Terraform design.)
3. **Single NAT gateway.** Both private subnets use one NAT in one availability zone. A zone loss cuts outbound traffic from tasks in the other zone, even though POL-BCDR-01 says ALB and ECS span zones. (Real defect of the design, not stated in the plan.)
4. **The autoscaling rule watches CPU only.** A memory-bound or database-bound load will not scale the tasks. The task has 512 MB. A 300 MB export is a concern (scenario sizing; the numbers come from SIM-SDL-001).
5. **STD-LOG-01 section 5.1 cannot be tested for the one host.** The AMI is a placeholder. Require a real image name and record its time source in the change that creates the host.
6. **POL-CLD-01 has no statement on egress and no statement on endpoints.** Open egress on 443 from tasks and the operations host is the largest unmentioned flow. State the intent (open, restricted by domain, or private endpoints) and the exception.
7. **The default network ACL is not examined.** The gate rule only judges ACLs that exist. Either define explicit ACLs or state that the default is accepted.
8. **The operations host has no way to be administered.** No permission is attached to its role and no inbound path exists. The design and the group description disagree. The same holds for the ECS task role (see SIM-SDL-001 finding 4).
9. **No document lists the network zones and permitted flows.** POL-CLD-01 gives one baseline sentence. The matrix in section 3 was assembled by reading rules. Keep it as a design record next to the code, generated from the plan if possible.
10. **No test of separation is defined.** There is no rule for how denied flows are tested once an environment exists. Name the tests (the six paper tests are a start) and when they run.

## What this does not show

- No plan, apply or network test was run for this record. [R] statements are a read of source files. The Terraform has never been applied; behaviour of AWS services is not demonstrated.
- That the load figures, task sizes or decisions are right. The only number outside the files is the export sizing, which is scenario.
- That the reviewers met on 2026-10-28.
- That a flow predicted denied is denied in AWS. It is a prediction from rules.
- Any statement by AWS. No service behaviour is quoted from AWS documentation.
