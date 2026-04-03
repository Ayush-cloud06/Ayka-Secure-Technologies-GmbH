package policies.terraform.aws_ec2

import future.keywords.in

# Public SSH open to the internet
deny[msg] {
    module := input.planned_values.root_module.child_modules[_]
    sg := module.resources[_]
    sg.type == "aws_security_group"

    rule := sg.values.ingress[_]
    rule.from_port == 22
    rule.to_port == 22
    rule.protocol == "tcp"
    rule.cidr_blocks[_] == "0.0.0.0/0"

    msg := sprintf(
        "[EC2_OPEN_SSH] Security group %s allows SSH (22) from the internet",
        [sg.address]
    )
}

# HTTP open to the internet
deny[msg] {
    module := input.planned_values.root_module.child_modules[_]
    sg := module.resources[_]
    sg.type == "aws_security_group"

    rule := sg.values.ingress[_]
    rule.from_port == 80
    rule.to_port == 80
    rule.protocol == "tcp"
    rule.cidr_blocks[_] == "0.0.0.0/0"

    msg := sprintf(
        "[EC2_HTTP_OPEN] Security group %s allows HTTP (80) from the internet",
        [sg.address]
    )
}

# EC2 must enforce IMDSv2 (http_tokens = "required")
deny[msg] {
    module := input.planned_values.root_module.child_modules[_]
    r := module.resources[_]
    r.type == "aws_instance"

    metadata := r.values.metadata_options[_]
    metadata.http_tokens != "required"

    msg := sprintf(
        "[EC2_MISSING_IMDSV2] EC2 instance %s does not enforce IMDSv2 (http_tokens must be 'required')",
        [r.address]
    )
}

deny[msg] {
    module := input.planned_values.root_module.child_modules[_]
    r := module.resources[_]
    r.type == "aws_instance"
    count(r.values.metadata_options) == 0

    msg := sprintf(
        "[EC2_MISSING_IMDSV2] EC2 instance %s does not define metadata_options and cannot prove IMDSv2 enforcement",
        [r.address]
    )
}

# Instance root volume must be encrypted when root block devices are explicitly defined
deny[msg] {
    module := input.planned_values.root_module.child_modules[_]
    r := module.resources[_]
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
    module := input.planned_values.root_module.child_modules[_]
    r := module.resources[_]
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
    module := input.planned_values.root_module.child_modules[_]
    r := module.resources[_]
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
    module := input.planned_values.root_module.child_modules[_]
    r := module.resources[_]
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
