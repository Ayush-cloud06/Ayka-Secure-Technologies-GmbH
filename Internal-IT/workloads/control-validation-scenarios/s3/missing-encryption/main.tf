terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "unencrypted_bucket" {
  bucket = "control-validation-unencrypted-bucket-example"
}

resource "aws_s3_bucket_versioning" "disabled_versioning" {
  bucket = aws_s3_bucket.unencrypted_bucket.id

  versioning_configuration {
    status = "Disabled" # Wrong: versioning is disabled.
  }
}

# Wrong: there is no server-side encryption configuration for this bucket.
