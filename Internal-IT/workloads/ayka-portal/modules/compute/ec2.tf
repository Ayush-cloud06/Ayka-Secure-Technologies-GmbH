resource "aws_instance" "ops" {
  ami                         = var.ec2_ami_id
  instance_type               = var.ec2_instance_type
  subnet_id                   = var.private_subnet_ids[0]
  vpc_security_group_ids      = [var.ec2_security_group_id]
  iam_instance_profile        = var.ec2_instance_profile_name
  associate_public_ip_address = false

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = true
    volume_size = var.ec2_root_volume_size
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.name_prefix}-ops"
    Role = "operations"
  }
}
