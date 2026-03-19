variable "root_id" {
  type = string
}

resource "aws_organizations_organizational_unit" "Security" {
  name      = "Security"
  parent_id = var.root_id
}
resource "aws_organizations_organizational_unit" "Infrastructure" {
  name      = "Infrastructure"
  parent_id = var.root_id
}

resource "aws_organizations_organizational_unit" "Workloads" {
  name      = "Workloads"
  parent_id = var.root_id
}
