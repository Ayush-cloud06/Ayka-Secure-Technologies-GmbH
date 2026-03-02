# -------- VARIABLES --------

variable "aws_reply_urls" {
  description = "AWS Identity Center ACS URLs (populated after AWS side is created)"
  type        = list(string)
  default     = []
}

variable "aws_entity_ids" {
  description = "AWS Identity Center Entity IDs (populated after AWS side is created)"
  type        = list(string)
  default     = []
}


# ------- APPLICATION REGISTRATION -------


resource "azuread_application" "aws_sso" {
  display_name = "AWS Identity Center (Ayka Cloud)"

  web {
    redirect_uris = var.aws_reply_urls
  }

  identifier_uris = var.aws_entity_ids

  feature_tags {
    enterprise = true
  }
}


# ------- ENTERPRISE APPLICATION (SERVICE PRINCIPAL) -------

resource "azuread_service_principal" "aws_sso" {
  client_id = azuread_application.aws_sso.client_id
}


# ------- GROUP ACCESS ASSIGNMENTS -------

resource "azuread_app_role_assignment" "tier_access" {
  for_each = module.core.tier_groups

  # Default access role for enterprise applications
  app_role_id         = "00000000-0000-0000-0000-000000000000"
  principal_object_id = each.value.id
  resource_object_id  = azuread_service_principal.aws_sso.object_id
}


# ------- OUTPUTS -------


output "saml_metadata_url" {
  description = "Metadata URL to configure in AWS Identity Center"
  value       = "https://login.microsoftonline.com/${var.tenant_id}/federationmetadata/2007-06/federationmetadata.xml?appid=${azuread_application.aws_sso.client_id}"
}

output "application_client_id" {
  description = "Client ID of the AWS SAML Application"
  value       = azuread_application.aws_sso.client_id
}

output "service_principal_object_id" {
  description = "Object ID of the Enterprise Application"
  value       = azuread_service_principal.aws_sso.object_id
}
