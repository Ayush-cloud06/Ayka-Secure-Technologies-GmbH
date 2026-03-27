resource "aws_security_group" "open_ssh" {
  name        = "control-validation-open-ssh"
  description = "Intentionally flawed security group for control validation"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Wrong: SSH is open to the entire internet.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
