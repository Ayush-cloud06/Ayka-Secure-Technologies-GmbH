data "terraform_remote_state" "entra" {
  backend = "s3"

  config = {
    bucket = "ayka-terraform-state-$"
    key    = "entra-id/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "http" "entra_metadata" {
  url = data.terraform_remote_state.entra.outputs.saml_metadata_url
}

resource "aws_ssoadmin_identity_provider" "entra" {
  instance_arn = data.aws_ssoadmin_instances.this.arns[0]
  type         = "SAML"

  saml_metadata_document = data.http.entra_metadata.response_body
}
