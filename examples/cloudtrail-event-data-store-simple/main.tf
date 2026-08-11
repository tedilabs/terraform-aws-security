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

  name = "management-event"

  management_event_selector = {
    enabled = true
  }

  termination_protection_enabled = false

  tags = {
    "project" = "terraform-aws-security-examples"
  }
}
