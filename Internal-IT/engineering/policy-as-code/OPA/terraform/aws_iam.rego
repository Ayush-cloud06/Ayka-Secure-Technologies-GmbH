package policies.terraform.aws_iam

import data.policies.terraform.lib
import future.keywords.in

# No IAM policy should allow wildcard permissions.
# Action may be a string or a list; Statement may be an object or a list.
deny[msg] {
    r := lib.resources_of_type(policy_types[_])[_]
    stmt := statements(r)[_]
    stmt.Effect == "Allow"
    wildcard_grant(stmt)

    msg := sprintf(
        "[IAM_WILDCARD_POLICY] IAM policy %s allows wildcard action '*'",
        [r.address]
    )
}

policy_types := {"aws_iam_policy", "aws_iam_role_policy", "aws_iam_user_policy", "aws_iam_group_policy"}

# Policy JSON that is unknown at plan time (null) cannot be judged here; Checkov is mapped too.
statements(r) = s {
    is_string(r.values.policy)
    doc := json.unmarshal(r.values.policy)
    s := as_list(doc.Statement)
}

as_list(x) = x {
    is_array(x)
} else = [x]

# "*" or "*:*" in Action.
wildcard_grant(stmt) {
    action := as_list(stmt.Action)[_]
    action in {"*", "*:*"}
}

# A whole service ("s3:*") on every resource.
wildcard_grant(stmt) {
    action := as_list(stmt.Action)[_]
    endswith(action, ":*")
    as_list(stmt.Resource)[_] == "*"
}

# Allow + NotAction grants everything except the listed actions.
wildcard_grant(stmt) {
    stmt.NotAction
}

# No inline IAM policies allowed
deny[msg] {
    r := lib.resources[_]
    r.type in {"aws_iam_role_policy", "aws_iam_user_policy"}

    msg := sprintf(
        "[IAM_INLINE_POLICY_USAGE] Inline IAM policy %s is not allowed. Use managed IAM policies instead",
        [r.address]
    )
}

# No IAM users allowed (role-only organization)
deny[msg] {
    r := lib.resources[_]
    r.type == "aws_iam_user"

    msg := sprintf(
        "[IAM_USER_PROHIBITED] IAM user %s is not allowed. Use federated access with IAM role instead",
        [r.address]
    )
}

# IAM users must have MFA enabled.
# aws_iam_virtual_mfa_device has no user argument (user_name is read-only), so
# Terraform cannot prove MFA for a user; any IAM user is flagged. IAM users are
# prohibited outright by IAM_USER_PROHIBITED above.
deny[msg] {
    user := lib.resources_of_type("aws_iam_user")[_]

    msg := sprintf(
        "[IAM_USER_MFA_MISSING] IAM user %s cannot prove MFA in Terraform",
        [user.address]
    )
}
