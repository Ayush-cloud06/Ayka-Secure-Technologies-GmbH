package policies.terraform.aws_vpc_test

import data.policies.terraform.aws_vpc

plan(resources) = {"planned_values": {"root_module": {"child_modules": [{"resources": resources}]}}}

# Shape copied from a real terraform 1.7.5 / aws 5.x plan of the NACL scenario.
open_nacl := {
	"address": "module.vpc_permissive_network_acl[0].aws_network_acl.permissive",
	"type": "aws_network_acl",
	"values": {"ingress": [{"action": "allow", "cidr_block": "0.0.0.0/0", "protocol": "-1", "rule_no": 100, "from_port": 0, "to_port": 0}]},
}

test_open_nacl_is_denied {
	some msg
	aws_vpc.deny[msg] with input as plan([open_nacl])
	startswith(msg, "[NETWORK_ACL_UNRESTRICTED_INGRESS]")
}
