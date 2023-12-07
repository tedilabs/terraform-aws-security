provider "aws" {
  region = "us-east-1"
}


###################################################
# Config Recorder
###################################################

module "recorder" {
  source = "../../modules/config-recorder"
  # source  = "tedilabs/security/aws//modules/config-recorder"
  # version = "~> 0.6.0"

  name    = "test"
  enabled = true

  scope = {
    strategy = "ALL_WITHOUT_GLOBAL"
  }

  delivery_channels = {
    s3_bucket = {
      name = module.bucket.name
    }
  }

  tags = {
    "project" = "terraform-aws-security-examples"
  }
}
