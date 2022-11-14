provider "aws" {
  alias  = "testing"
  region = "eu-west-2"
  assume_role {
    role_arn = local.assume_role
  }
}

provider "aws" {
  alias  = "automation"
  region = "eu-west-2"
}