package policies.terraform.aws_vpc

import data.policies.terraform.lib

# No default VPC allowed
deny[msg] {
    r := lib.resources[_]
    r.type == "aws_default_vpc"

    msg := "[VPC_DEFAULT_PROHIBITED] Default VPC usage is not allowed. Create a custom VPC instead"
}

# VPC must have Flow Logs enabled
deny[msg] {
    vpc := lib.resources[_]
    vpc.type == "aws_vpc"

    not vpc_has_flow_logs(vpc.values.id)

    msg := sprintf(
        "[VPC_FLOW_LOGS_MISSING] VPC %s does not have Flow Logs enabled",
        [vpc.values.cidr_block]
    )
}

vpc_has_flow_logs(vpc_id) {
    fl := lib.resources[_]
    fl.type == "aws_flow_log"
    fl.values.resource_id == vpc_id
}

# No route table should expose 0.0.0.0/0 directly to Internet Gateway
deny[msg] {
    rt := lib.resources[_]
    rt.type == "aws_route_table"

    route := rt.values.route[_]
    route.cidr_block == "0.0.0.0/0"
    startswith(object.get(route, "gateway_id", ""), "igw-")

    msg := sprintf(
        "[ROUTE_TABLE_PUBLIC_IGW] Route table %s has a direct route to Internet Gateway (0.0.0.0/0)",
        [rt.address]
    )
}

# No Network ACL should allow all traffic from 0.0.0.0/0
deny[msg] {
    acl := lib.resources[_]
    acl.type == "aws_network_acl"

    entry := acl.values.ingress[_]
    entry.cidr_block == "0.0.0.0/0"
    entry.action == "allow"

    msg := sprintf(
        "[NETWORK_ACL_UNRESTRICTED_INGRESS] Network ACL %s allows unrestricted ingress from the internet",
        [acl.address]
    )
}
