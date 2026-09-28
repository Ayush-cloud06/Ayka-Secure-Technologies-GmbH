# Intentionally flawed network ACL for control validation.
# Expected: NETWORK_ACL_UNRESTRICTED_INGRESS (HIGH).
resource "aws_vpc" "scenario" {
  cidr_block = "10.42.0.0/16"
}

resource "aws_network_acl" "permissive" {
  vpc_id = aws_vpc.scenario.id

  ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0" # Wrong: every protocol and port from the whole internet.
    from_port  = 0
    to_port    = 0
  }
}
