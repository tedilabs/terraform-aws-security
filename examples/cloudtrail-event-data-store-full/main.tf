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

  level = "ACCOUNT"
  scope = "REGIONAL"


  ## Event Selector
  event_type = "CLOUDTRAIL_EVENTS"
  management_event_selector = {
    enabled               = true
    scope                 = "READ"
    exclude_event_sources = ["kms.amazonaws.com"]
  }
  data_event_selectors = [
    {
      resource_type = "AWS::S3::Object"
      scope         = "ALL"
      conditions = [
        {
          field    = "resources.ARN"
          operator = "ends_with"
          values   = ["hello"]
        }
      ]
    },
    {
      resource_type = "AWS::S3Outposts::Object"
      scope         = "WRITE"
      conditions = [
        {
          field    = "eventName"
          operator = "starts_with"
          values   = ["Put"]
        }
      ]
    },
  ]


  ## Attributes
  retention_in_days              = 365 * 7
  termination_protection_enabled = false


  ## IAM Role
  import_trail_events_iam_role = {
    enabled = true
    source_s3_buckets = [
      {
        name       = "helloworld"
        key_prefix = "asdf/"
      },
      {
        name       = "foo"
        key_prefix = "bar/"
      },
      {
        name       = "demo"
        key_prefix = ""
      },
    ]
  }

  tags = {
    "project" = "terraform-aws-security-examples"
  }
}
