package policies.terraform.aws_iam

import future.keywords.in

# No IAM policy should allow wildcard permissions
deny[msg] {
    module := input.planned_values.root_module.child_modules[_]
    r := module.resources[_]
    r.type in {"aws_iam_policy", "aws_iam_role_policy", "aws_iam_user_policy"}

    policy := json.unmarshal(r.values.policy)
    stmt := policy.Statement[_]

    stmt.Effect == "Allow"
    stmt.Action == "*"

    msg := sprintf(
        "IAM policy %s allows wildcard action '*'",
        [r.address]
    )
}

# No inline IAM policies allowed
deny[msg] {
    module := input.planned_values.root_module.child_modules[_]
    r := module.resources[_]
    r.type in {"aws_iam_role_policy", "aws_iam_user_policy"}

    msg := sprintf(
        "Inline IAM policy %s is not allowed. Use managed IAM policies instead",
        [r.address]
    )
}

# No IAM users allowed (role-only organization)
deny[msg] {
    module := input.planned_values.root_module.child_modules[_]
    r := module.resources[_]
    r.type == "aws_iam_user"

    msg := sprintf(
        "IAM user %s is not allowed. Use federated access with IAM role instead",
        [r.address]
    )
}

# IAM users must have MFA enabled
deny[msg] {
    module := input.planned_values.root_module.child_modules[_]
    user := module.resources[_]
    user.type == "aws_iam_user"

    not user_has_mfa(user.name)

    msg := sprintf(
        "IAM user %s does not have MFA enabled",
        [user.address]
    )
}

user_has_mfa(username) {
    module := input.planned_values.root_module.child_modules[_]
    mfa := module.resources[_]
    mfa.type == "aws_iam_virtual_mfa_device"
    mfa.values.user == username
}
