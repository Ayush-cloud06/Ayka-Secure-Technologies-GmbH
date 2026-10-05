package policies.terraform.aws_ec2

import data.policies.terraform.lib
import future.keywords.in

# Public SSH open to the internet
deny[msg] {
    rule := ingress_rules[_]
    exposes_port(rule, 22)

    msg := sprintf(
        "[EC2_OPEN_SSH] Security group %s allows SSH (22) from the internet",
        [rule.address]
    )
}

# HTTP open to the internet
deny[msg] {
    rule := ingress_rules[_]
    exposes_port(rule, 80)

    msg := sprintf(
        "[EC2_HTTP_OPEN] Security group %s allows HTTP (80) from the internet",
        [rule.address]
    )
}

# Ingress rules from all three ways Terraform can declare them, in one shape:
# {address, protocol, from_port, to_port, cidrs}.

# Inline ingress blocks on aws_security_group.
ingress_rules[rule] {
    sg := lib.resources_of_type("aws_security_group")[_]
    block := object.get(sg.values, "ingress", [])[_]
    rule := {
        "address": sg.address,
        "protocol": lower(sprintf("%v", [block.protocol])),
        "from_port": object.get(block, "from_port", null),
        "to_port": object.get(block, "to_port", null),
        "cidrs": cidrs(block, "cidr_blocks", "ipv6_cidr_blocks"),
    }
}

# Legacy standalone aws_security_group_rule (type = "ingress").
ingress_rules[rule] {
    r := lib.resources_of_type("aws_security_group_rule")[_]
    r.values.type == "ingress"
    rule := {
        "address": r.address,
        "protocol": lower(sprintf("%v", [r.values.protocol])),
        "from_port": object.get(r.values, "from_port", null),
        "to_port": object.get(r.values, "to_port", null),
        "cidrs": cidrs(r.values, "cidr_blocks", "ipv6_cidr_blocks"),
    }
}

# Current standalone aws_vpc_security_group_ingress_rule.
ingress_rules[rule] {
    r := lib.resources_of_type("aws_vpc_security_group_ingress_rule")[_]
    rule := {
        "address": r.address,
        "protocol": lower(sprintf("%v", [r.values.ip_protocol])),
        "from_port": object.get(r.values, "from_port", null),
        "to_port": object.get(r.values, "to_port", null),
        "cidrs": {c | c := [object.get(r.values, "cidr_ipv4", null), object.get(r.values, "cidr_ipv6", null)][_]; is_string(c)},
    }
}

cidrs(obj, v4, v6) = {c | c := array.concat(list_or_empty(obj, v4), list_or_empty(obj, v6))[_]}

list_or_empty(obj, key) = value {
    value := obj[key]
    is_array(value)
} else = []

internet := {"0.0.0.0/0", "::/0"}

all_protocols := {"-1", "all"}

tcp := {"tcp", "6"}

# All traffic: ports do not matter.
exposes_port(rule, port) {
    rule.protocol in all_protocols
    rule.cidrs[_] in internet
}

# TCP range that contains the port.
exposes_port(rule, port) {
    rule.protocol in tcp
    rule.cidrs[_] in internet
    rule.from_port <= port
    port <= rule.to_port
}

# EC2 must enforce IMDSv2 (http_tokens = "required")
deny[msg] {
    r := lib.resources[_]
    r.type == "aws_instance"

    metadata := r.values.metadata_options[_]
    metadata.http_tokens != "required"

    msg := sprintf(
        "[EC2_MISSING_IMDSV2] EC2 instance %s does not enforce IMDSv2 (http_tokens must be 'required')",
        [r.address]
    )
}

deny[msg] {
    r := lib.resources[_]
    r.type == "aws_instance"
    count(r.values.metadata_options) == 0

    msg := sprintf(
        "[EC2_MISSING_IMDSV2] EC2 instance %s does not define metadata_options and cannot prove IMDSv2 enforcement",
        [r.address]
    )
}

# Instance root volume must be encrypted when root block devices are explicitly defined
deny[msg] {
    r := lib.resources[_]
    r.type == "aws_instance"

    disk := r.values.root_block_device[_]
    not disk.encrypted

    msg := sprintf(
        "[EC2_ROOT_VOLUME_UNENCRYPTED] EC2 instance %s has an unencrypted root volume",
        [r.address]
    )
}

# EC2 instances must have mandatory tags: Environment, Owner, CostCenter
deny[msg] {
    r := lib.resources[_]
    r.type == "aws_instance"

    missing := missing_tags(r.values.tags)
    count(missing) > 0

    msg := sprintf(
        "[EC2_MISSING_TAGS] EC2 instance %s is missing mandatory tags: %v",
        [r.address, missing]
    )
}

missing_tags(tags) = missing {
    tags == null
    missing := {"Environment", "Owner", "CostCenter"}
}

missing_tags(tags) = missing {
    required := {"Environment", "Owner", "CostCenter"}
    present := {k | tags[k]}
    missing := required - present
}

# Small instance types not allowed in Production
deny[msg] {
    r := lib.resources[_]
    r.type == "aws_instance"

    r.values.tags != null
    lower(object.get(r.values.tags, "Environment", "")) == "prod"

    small_types := {"t2.micro", "t3.micro", "t3a.micro"}
    r.values.instance_type in small_types

    msg := sprintf(
        "[EC2_PROD_UNDERSIZED_INSTANCE] EC2 instance %s uses undersized instance type %s in production",
        [r.address, r.values.instance_type]
    )
}

# No Spot instances allowed in Production
deny[msg] {
    r := lib.resources[_]
    r.type == "aws_instance"

    r.values.tags != null
    lower(object.get(r.values.tags, "Environment", "")) == "prod"
    r.values.instance_market_options != null
    object.get(r.values.instance_market_options, "market_type", "") == "spot"

    msg := sprintf(
        "[EC2_PROD_SPOT_USAGE] EC2 instance %s uses Spot pricing in production",
        [r.address]
    )
}
