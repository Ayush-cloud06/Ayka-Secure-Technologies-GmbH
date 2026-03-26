package policies.terraform.aws_vpc

# No default VPC allowed

deny[msg] if {
    r := input.planned_values.root_module.resources[_] 
    r.type == "aws_default_vpc"

    msg := "Default VPC usage is not allowed. Create a custom VPC instead"
}

# VPC must have Flow Logs enabled

deny[msg] if {
    vpc := input.planned_values.root_module.resources[_]
    vpc.type == "aws_vpc"

    not vpc_has_flow_logs(vpc.values.id)

    msg := sprintf(
        "VPC %s does not have Flow Logs enabled",
        [vpc.vlaues.cidr_block]
    )
}
  # Helper: Check if flow logs exist for VPC

  vpc_has_flow_logs(vpc_id) if {
    fl := input.planned_values.root_module.resources[_]
    fl.type == "aws_flow_log"
    fl.values.resource_id == vpc_id
  }

# No route table should expose 0.0.0.0/0 directly to Internet Gateway

deny[msg] if {
    rt := input.planned_values.root_module.resources[_]
    rt.type == "aws_route_table"

    route := rt.values.route[_]
    route.cidr_block == "0.0.0.0/0"
    route.gateway_id != null

    msg := sprintf(
        "Route table %s has a direct route to Internet Gateway (0.0.0.0/0)",
        [rt.address]
    )
}

# No Network ACL shoudl allow all traffic from 0.0.0.0/0

deny[msg] if {
    acl := input.planned_values.root_module.resources[_]
    acl.type == "aws_network_acl"

    entry := acl.values.ingress[_]
    entry.cidr_block == "0.0.0.0/0"
    entry.rule_action == "allow"

    msg := sprintf(
        "Network ACl %s allows unrestricted ingress from the internet",
        [acl.address]
    )
}