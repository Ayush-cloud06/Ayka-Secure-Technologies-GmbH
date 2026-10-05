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
