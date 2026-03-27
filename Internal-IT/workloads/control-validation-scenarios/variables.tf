variable "enabled_scenarios" {
  description = "Scenario modules to instantiate for selective validation runs."
  type        = set(string)

  default = [
    "ec2_imdsv2",
    "ec2_openssh",
    "s3_encryption",
    "s3_public",
    "vpc_permissive_network_acl",
  ]

  validation {
    condition = length(setsubtract(var.enabled_scenarios, toset([
      "ec2_imdsv2",
      "ec2_openssh",
      "s3_encryption",
      "s3_public",
      "vpc_permissive_network_acl",
    ]))) == 0
    error_message = "enabled_scenarios contains unsupported names. Allowed values: ec2_imdsv2, ec2_openssh, s3_encryption, s3_public, vpc_permissive_network_acl."
  }
}
