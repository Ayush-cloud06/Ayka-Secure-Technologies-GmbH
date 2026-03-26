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

resource "aws_s3_bucket" "public_bucket" {
  bucket = "control-validation-public-bucket-example"
}

resource "aws_s3_bucket_acl" "public_read" {
  bucket = aws_s3_bucket.public_bucket.id
  acl    = "public-read" # Wrong: bucket contents are publicly readable.
}
