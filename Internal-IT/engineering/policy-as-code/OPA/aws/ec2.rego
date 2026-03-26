package policies.aws.ec2

deny[msg] if {
    i := input.instances[_]
    i.imdsv2 == false

    msg := sprintf(
        "EC2 instance %s does not enforce IMDSv2",
        [i.id]
    )
}
