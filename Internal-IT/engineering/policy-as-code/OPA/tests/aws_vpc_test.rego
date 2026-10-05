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

vpc(name) = {"address": sprintf("module.net.aws_vpc.%s", [name]), "type": "aws_vpc", "name": name, "values": {"cidr_block": "10.0.0.0/16"}}

flow_log(name) = {"address": sprintf("module.net.aws_flow_log.%s", [name]), "type": "aws_flow_log", "name": name, "values": {"traffic_type": "ALL"}}

flow_log_config(name, target) = {
	"address": sprintf("aws_flow_log.%s", [name]), "type": "aws_flow_log", "name": name,
	"expressions": {"vpc_id": {"references": [sprintf("aws_vpc.%s.id", [target]), sprintf("aws_vpc.%s", [target])]}},
}

net_plan(planned, configured) = {
	"planned_values": {"root_module": {"child_modules": [{"address": "module.net", "resources": planned}]}},
	"configuration": {"root_module": {"module_calls": {"net": {"module": {"resources": configured}}}}},
}

flow_log_findings(p) = {msg | aws_vpc.deny[msg] with input as p; startswith(msg, "[VPC_FLOW_LOGS_MISSING]")}

test_vpc_with_its_own_flow_log_passes {
	count(flow_log_findings(net_plan([vpc("main"), flow_log("main")], [flow_log_config("main", "main")]))) == 0
}

# One flow log must not satisfy a second VPC (ids are null at plan time).
test_flow_log_does_not_cover_other_vpc {
	flow_log_findings(net_plan([vpc("main"), vpc("other"), flow_log("main")], [flow_log_config("main", "main")])) == {"[VPC_FLOW_LOGS_MISSING] VPC module.net.aws_vpc.other does not have Flow Logs enabled"}
}
