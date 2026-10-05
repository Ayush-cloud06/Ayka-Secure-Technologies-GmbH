package policies.terraform.aws_iam_test

import data.policies.terraform.aws_iam

# Terraform cannot attach an MFA device to a user, so every IAM user is flagged.
test_every_iam_user_is_flagged_for_mfa {
	p := {"planned_values": {"root_module": {"resources": [
		{"address": "aws_iam_user.alice", "type": "aws_iam_user", "name": "alice", "values": {"name": "alice"}},
		{"address": "aws_iam_virtual_mfa_device.alice", "type": "aws_iam_virtual_mfa_device", "name": "alice", "values": {"virtual_mfa_device_name": "alice"}},
	]}}}
	{msg | aws_iam.deny[msg] with input as p; startswith(msg, "[IAM_USER_MFA_MISSING]")} == {"[IAM_USER_MFA_MISSING] IAM user aws_iam_user.alice cannot prove MFA in Terraform"}
}

test_no_users_no_mfa_finding {
	count(aws_iam.deny) == 0 with input as {"planned_values": {"root_module": {"resources": []}}}
}

policy(doc) = {"planned_values": {"root_module": {"resources": [
	{"address": "aws_iam_policy.p", "type": "aws_iam_policy", "name": "p", "values": {"policy": json.marshal(doc)}},
]}}}

wildcard_findings(doc) = {msg | aws_iam.deny[msg] with input as policy(doc); startswith(msg, "[IAM_WILDCARD_POLICY]")}

test_string_star_is_denied {
	count(wildcard_findings({"Statement": [{"Effect": "Allow", "Action": "*", "Resource": "*"}]})) == 1
}

test_list_star_is_denied {
	count(wildcard_findings({"Statement": [{"Effect": "Allow", "Action": ["s3:GetObject", "*"], "Resource": "arn:aws:s3:::b/*"}]})) == 1
}

test_star_colon_star_is_denied {
	count(wildcard_findings({"Statement": {"Effect": "Allow", "Action": "*:*", "Resource": "*"}})) == 1
}

test_service_wildcard_on_all_resources_is_denied {
	count(wildcard_findings({"Statement": [{"Effect": "Allow", "Action": "s3:*", "Resource": ["*"]}]})) == 1
}

test_service_wildcard_on_one_bucket_is_allowed {
	count(wildcard_findings({"Statement": [{"Effect": "Allow", "Action": "s3:*", "Resource": "arn:aws:s3:::b/*"}]})) == 0
}

test_allow_not_action_is_denied {
	count(wildcard_findings({"Statement": [{"Effect": "Allow", "NotAction": "iam:*", "Resource": "*"}]})) == 1
}

test_deny_star_is_allowed {
	count(wildcard_findings({"Statement": [{"Effect": "Deny", "Action": "*", "Resource": "*"}]})) == 0
}

test_unknown_policy_json_is_skipped {
	p := {"planned_values": {"root_module": {"resources": [{"address": "aws_iam_policy.p", "type": "aws_iam_policy", "name": "p", "values": {"policy": null}}]}}}
	count(aws_iam.deny) == 0 with input as p
}
