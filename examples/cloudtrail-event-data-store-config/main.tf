provider "aws" {
  region = "us-east-1"
}


###################################################
# CloudTrail Event Data Store
###################################################

module "event_data_store" {
  source = "../../modules/cloudtrail-event-data-store"
  # source  = "tedilabs/security/aws//modules/cloudtrail-event-data-store"
  # version = "~> 0.6.0"

  name       = "config-configuration-items"
  event_type = "CONFIG_CONFIGURATION_ITEMS"

  termination_protection_enabled = false

  tags = {
    "project" = "terraform-aws-security-examples"
  }
}
