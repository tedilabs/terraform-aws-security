provider "aws" {
  region = "us-east-1"
}


###################################################
# CloudTrail Event Data Store
###################################################

module "event_data_store" {
  source = "../../modules/cloudtrail-event-data-store"
  # source  = "tedilabs/security/aws//modules/cloudtrail-event-data-store"
  # version = "~> 0.10.0"

  name       = "config-configuration-items"
  event_type = "CONFIG_CONFIGURATION_ITEMS"

  # Not used when `event_type` is `CONFIG_CONFIGURATION_ITEMS`, but the variable
  # is currently required by the module.
  management_event_selector = {}

  termination_protection_enabled = false

  tags = {
    "project" = "terraform-aws-security-examples"
  }
}
