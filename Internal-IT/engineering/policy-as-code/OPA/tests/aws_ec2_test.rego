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

sg_with(ingress) = {
	"address": "module.x.aws_security_group.sg",
	"type": "aws_security_group",
	"values": {"ingress": [ingress]},
}

ssh_findings(resources) = {msg | aws_ec2.deny[msg] with input as plan(resources); startswith(msg, "[EC2_OPEN_SSH]")}

test_port_range_containing_22_is_denied {
	count(ssh_findings([sg_with({"from_port": 0, "to_port": 65535, "protocol": "tcp", "cidr_blocks": ["0.0.0.0/0"]})])) == 1
}

test_range_not_containing_22_is_allowed {
	count(ssh_findings([sg_with({"from_port": 443, "to_port": 443, "protocol": "tcp", "cidr_blocks": ["0.0.0.0/0"]})])) == 0
}

test_all_protocols_is_denied {
	count(ssh_findings([sg_with({"from_port": 0, "to_port": 0, "protocol": "-1", "cidr_blocks": ["0.0.0.0/0"]})])) == 1
}

test_ipv6_any_is_denied {
	count(ssh_findings([sg_with({"from_port": 22, "to_port": 22, "protocol": "tcp", "cidr_blocks": [], "ipv6_cidr_blocks": ["::/0"]})])) == 1
}

test_udp_22_is_allowed {
	count(ssh_findings([sg_with({"from_port": 22, "to_port": 22, "protocol": "udp", "cidr_blocks": ["0.0.0.0/0"]})])) == 0
}

test_legacy_security_group_rule_is_denied {
	r := {"address": "module.x.aws_security_group_rule.ssh", "type": "aws_security_group_rule", "values": {"type": "ingress", "from_port": 22, "to_port": 22, "protocol": "tcp", "cidr_blocks": ["0.0.0.0/0"]}}
	ssh_findings([r]) == {"[EC2_OPEN_SSH] Security group module.x.aws_security_group_rule.ssh allows SSH (22) from the internet"}
}

test_legacy_egress_rule_is_ignored {
	r := {"address": "module.x.aws_security_group_rule.out", "type": "aws_security_group_rule", "values": {"type": "egress", "from_port": 22, "to_port": 22, "protocol": "tcp", "cidr_blocks": ["0.0.0.0/0"]}}
	count(ssh_findings([r])) == 0
}

# Shape copied from the ayka-portal plan (terraform 1.7.5, aws provider 5.x).
test_vpc_ingress_rule_resource_is_denied {
	r := {"address": "module.x.aws_vpc_security_group_ingress_rule.ssh", "type": "aws_vpc_security_group_ingress_rule", "values": {"from_port": 22, "to_port": 22, "ip_protocol": "tcp", "cidr_ipv4": "0.0.0.0/0", "cidr_ipv6": null}}
	count(ssh_findings([r])) == 1
}

test_vpc_ingress_rule_all_traffic_ipv6_is_denied {
	r := {"address": "module.x.aws_vpc_security_group_ingress_rule.any", "type": "aws_vpc_security_group_ingress_rule", "values": {"from_port": null, "to_port": null, "ip_protocol": "-1", "cidr_ipv4": null, "cidr_ipv6": "::/0"}}
	count(ssh_findings([r])) == 1
}

test_vpc_ingress_rule_https_only_is_allowed {
	r := {"address": "module.x.aws_vpc_security_group_ingress_rule.https", "type": "aws_vpc_security_group_ingress_rule", "values": {"from_port": 443, "to_port": 443, "ip_protocol": "tcp", "cidr_ipv4": "0.0.0.0/0", "cidr_ipv6": null}}
	count(aws_ec2.deny) == 0 with input as plan([r])
}

test_http_range_is_denied {
	some msg
	aws_ec2.deny[msg] with input as plan([sg_with({"from_port": 80, "to_port": 8080, "protocol": "tcp", "cidr_blocks": ["0.0.0.0/0"]})])
	startswith(msg, "[EC2_HTTP_OPEN]")
}
