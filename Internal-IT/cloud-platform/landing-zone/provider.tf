provider "aws" {
  alias  = "security"
  region = "ap-south-1"

  assume_role {
    role_arn = local.security_role_arn
  }
}

provider "aws" {
  alias  = "dev"
  region = "ap-south-1"

  assume_role {
    role_arn = local.security_role_arn
  }
}

provider "aws" {
  alias  = "prod"
  region = "ap-south-1"

  assume_role {
    role_arn = local.security_role_arn
  }
}
