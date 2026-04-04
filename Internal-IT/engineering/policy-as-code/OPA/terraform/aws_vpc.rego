package policies.terraform.aws_vpc

# No default VPC allowed
deny[msg] {
    module := input.planned_values.root_module.child_modules[_]
    r := module.resources[_]
    r.type == "aws_default_vpc"

    msg := "[VPC_DEFAULT_PROHIBITED] Default VPC usage is not allowed. Create a custom VPC instead"
}

# VPC must have Flow Logs enabled
deny[msg] {
    module := input.planned_values.root_module.child_modules[_]
    vpc := module.resources[_]
    vpc.type == "aws_vpc"

    not vpc_has_flow_logs(vpc.values.id)

    msg := sprintf(
        "[VPC_FLOW_LOGS_MISSING] VPC %s does not have Flow Logs enabled",
        [vpc.values.cidr_block]
    )
}

vpc_has_flow_logs(vpc_id) {
    module := input.planned_values.root_module.child_modules[_]
    fl := module.resources[_]
    fl.type == "aws_flow_log"
    fl.values.resource_id == vpc_id
}

# No route table should expose 0.0.0.0/0 directly to Internet Gateway
deny[msg] {
    module := input.planned_values.root_module.child_modules[_]
    rt := module.resources[_]
    rt.type == "aws_route_table"

    route := rt.values.route[_]
    route.cidr_block == "0.0.0.0/0"
    route.gateway_id != null

    msg := sprintf(
        "[ROUTE_TABLE_PUBLIC_IGW] Route table %s has a direct route to Internet Gateway (0.0.0.0/0)",
        [rt.address]
    )
}

# No Network ACL should allow all traffic from 0.0.0.0/0
deny[msg] {
    module := input.planned_values.root_module.child_modules[_]
    acl := module.resources[_]
    acl.type == "aws_network_acl"

    entry := acl.values.ingress[_]
    entry.cidr_block == "0.0.0.0/0"
    entry.rule_action == "allow"

    msg := sprintf(
        "[NETWORK_ACL_UNRESTRICTED_INGRESS] Network ACL %s allows unrestricted ingress from the internet",
        [acl.address]
    )
}
