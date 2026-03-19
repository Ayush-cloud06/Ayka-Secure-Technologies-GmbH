terraform {
  backend "s3" {
    bucket         = "ayka-terraform-state"
    key            = "aws-identity-center/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
