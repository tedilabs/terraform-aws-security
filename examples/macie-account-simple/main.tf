provider "aws" {
  region = "us-east-1"
}


###################################################
# Macie Account
###################################################

module "account" {
  source = "../../modules/macie-account"
  # source  = "tedilabs/security/aws//modules/macie-account"
  # version = "~> 0.5.0"

  enabled = true

  tags = {
    "project" = "terraform-aws-security-examples"
  }
}
