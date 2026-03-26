package policies.terraform.aws_ec2

# Public SSH open to the internet

deny[msg] if {
    sg := input.planned_values.root_module.resources[_]
    sg.type == "aws_security_group"

    rule := sg.values.ingress[_]
    rule.from_port == 22
    rule.to_port == 22
    rule.protocol == "tcp"
    rule.cidr_blocks[_] == "0.0.0.0/0"

    msg := sprintf(
        "Security group %s allows SSH (22) from the internet",
        [sg.values.name]
    )
}

# HTTP open to the internet

deny[msg] if {
    sg := input.planned_values.root_module.resources[_]
    sg.type == "aws_security_group"

    rule := sg.values.ingress[_]
    rule.from_port == 80
    rule.to_port == 80
    rule.protocol == "tcp"
    rule.cidr_blocks[_] == "0.0.0.0/0"

    msg := sprintf(
        "Security group %s allows HTTP (80) from the internet",
        [sg.values.name]
    )
}

# EC2 must enforce IMDSv2 (http_tokens = "required")

deny[msg] if {
    r := input.planned_values.root_module.resources[_]
    r.type == "aws_instance"

    # metadata_options missing or http_tokens not set to required
    not r.values.metadata_options.http_tokens == "required"

    msg := sprintf(
        "EC2 instance %s does not enforce IMDSv2 (http_token must be 'required')",
        [r.address]
    )
}

# Instance root volume must be encrypted
# NOTE:
# Root volume encryption is enforced at Terraform module level.
# This rule is intentionally disabled because plan does not expose
# disk encryption reliably in planned_values.

deny[msg] if {
    r := input.planned_values.root_module.resources[_]
    r.type == "aws_instance"

    disk := r.values.root_block_devices[_]
    not disk.encrypted

    msg := sprintf(
        "EC2 instance %s has an unencrypted root volume",
        [r.address]
    )
}

# EC2 instances must have mandatory tags: Environment, Owner, CostCenter

deny[msg] if {
    r := input.planned_values.root_module.resources[_]
    r.type == "aws_instance"

    missing := missing_tags(r.values.tags)
    count(missing) > 0

    msg := sprintf(
        "EC2 instance %s is missing mandatory tags: %v",
        [r.address, missing]
    )
}

# Helper function to find missing tags
missing_tags(tags) = missing if {
    required := {"Environment", "Owner", "CostCenter"}
    present := {k | tags[k]}
    missing := required - present
}

# Small instance types not allowed in Production

deny[msg] if {
    r := input.planned_values.root_module.resources[_]
    r.type == "aws_instance"

    lower(r.values.tags.Environment) == "prod"

    small_types := {"t2.micro", "t3.micro", "t3a.micro"}
    r.values.instance_type in small_types

    msg := sprintf(
        "EC2 instance %s uses undersized instance type %s in production",
        [r.address, r.values.instance_type]
    )
}

# No Spot instances allowed in Production

deny[msg] if {
    r := input.planned_values.root_module.resources[_]
    r.type == "aws_instance"

    lower(r.values.tags.Environment) == "prod"
    r.values.instance_market_options.market_type == "spot"

    msg := sprintf(
        "EC2 instance %s uses Spot pricing in production",
        [r.address]
    )
}
