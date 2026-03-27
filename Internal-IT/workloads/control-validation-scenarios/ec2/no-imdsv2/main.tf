resource "aws_instance" "bad_instance" {
  ami           = "ami-12345678"
  instance_type = "t3.micro"

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional" # Wrong: IMDSv2 is not enforced.
  }
}
