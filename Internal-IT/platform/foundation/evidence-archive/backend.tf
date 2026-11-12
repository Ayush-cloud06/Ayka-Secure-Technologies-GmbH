# Remote state created by ../remote-state (bootstrap step 1, see foundation/README.md).
# Same bucket, lock table and Region for every AWS root; only the key differs.
# Plan-only CI replaces this with a throw-away local backend (ci_backend_override.tf).
terraform {
  backend "s3" {
    bucket         = "ayka-terraform-state"
    key            = "evidence-archive/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
