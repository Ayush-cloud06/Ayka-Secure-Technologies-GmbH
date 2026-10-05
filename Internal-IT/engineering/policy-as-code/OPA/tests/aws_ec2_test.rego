package policies.terraform.aws_ec2_test

import data.policies.terraform.aws_ec2

# A plan with one child module holding the given resources.
plan(resources) = {"planned_values": {"root_module": {"child_modules": [{"resources": resources}]}}}

open_ssh_sg := {
	"address": "module.x.aws_security_group.bad",
	"type": "aws_security_group",
	"values": {"ingress": [{"from_port": 22, "to_port": 22, "protocol": "tcp", "cidr_blocks": ["0.0.0.0/0"]}]},
}

office_ssh_sg := {
	"address": "module.x.aws_security_group.ok",
	"type": "aws_security_group",
	"values": {"ingress": [{"from_port": 22, "to_port": 22, "protocol": "tcp", "cidr_blocks": ["10.0.0.0/8"]}]},
}

test_open_ssh_is_denied {
	some msg
	aws_ec2.deny[msg] with input as plan([open_ssh_sg])
	startswith(msg, "[EC2_OPEN_SSH]")
}

test_ssh_from_private_range_is_allowed {
	denied := {msg | aws_ec2.deny[msg] with input as plan([office_ssh_sg]); startswith(msg, "[EC2_OPEN_SSH]")}
	count(denied) == 0
}

# Resources in the root module are inspected (issue #10).
test_root_module_is_inspected {
	root_only := {"planned_values": {"root_module": {"resources": [open_ssh_sg]}}}
	some msg
	aws_ec2.deny[msg] with input as root_only
	startswith(msg, "[EC2_OPEN_SSH]")
}

# Resources in nested modules (module.a.module.b) are inspected (issue #10).
test_nested_module_is_inspected {
	nested := {"planned_values": {"root_module": {"child_modules": [{
		"address": "module.a",
		"resources": [],
		"child_modules": [{"address": "module.a.module.b", "resources": [open_ssh_sg]}],
	}]}}}
	some msg
	aws_ec2.deny[msg] with input as nested
	startswith(msg, "[EC2_OPEN_SSH]")
}
