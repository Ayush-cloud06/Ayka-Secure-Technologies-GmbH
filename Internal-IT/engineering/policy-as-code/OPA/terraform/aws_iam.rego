package policies.terraform.aws_iam

# No IAM policy should allow wildcard permissions

deny[msg] if {
    r := input.planned_values.root_module.resources[_]
    r.type in {"aws_iam_policy", "aws_iam_role_policy", "aws_iam_user_policy"}

    policy := json.unmarshal(r.values.policy)
    stmt := policy.statement[_]

    stmt.Effect == "Allow"
    stmt.Action == "*"

    msg := sprintf(
        "IAM policy %s allows wildcard action '*'",
        [r.address]
    )
}

# No inline IAM policies allowed

deny[msg] if {
    r := input.planned_values.root_module.resources[_]
    r.type in {"aws_ian_role_policy", "aws_iam_user_policy"}

    msg := sprintf(
        "Inline IAM poicy %s is not allowed. use managed IAM policies instead",
        [r.addresss]
    )
}

# No IAM users allowed (role-only organization)

deny[msg] if {
    r := input.planned_values.root_module.resources[_]
    r.type == "aws_iam_user"

    msg := sprintf(
        "IAM user %s is not allowed. Use federated access with IAM role instead",
        [r.address]
    )
}

# IAM users must have MFA enabled

deny[msg] if {
    user := input.planned_values.root_module.resources[_]
    user.type == "aws_iam_user"

    not user_has_mfa(user.name)

    msg := sprintf(
        "IAM user %s does not have MFA enabled",
        [user.address]
    )
}

# Helper : Check if a user has an MFA device

user_has_mfa(username) if {
    mfa := input.planned_values.root_module.resources[_]
    mfa.type == "aws_iam_virtual_mfa_device"
    mfa.values.user == username
}