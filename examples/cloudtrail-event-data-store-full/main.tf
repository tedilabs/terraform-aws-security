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

  name = "management-event"

  level = "ACCOUNT"
  scope = "REGIONAL"


  ## Event Selector
  event_type = "CLOUDTRAIL_EVENTS"
  event_selectors = [
    {
      category        = "MANAGEMENT"
      scope           = "READ"
      exclude_sources = ["kms.amazonaws.com"]
    },
    {
      category      = "DATA"
      scope         = "ALL"
      resource_type = "AWS::S3::Object"
      selectors = [
        {
          field    = "resource_arn"
          operator = "ends_with"
          values   = ["hello"]
        }
      ]
    },
    {
      category      = "DATA"
      scope         = "WRITE"
      resource_type = "AWS::S3Outposts::Object"
      selectors = [
        {
          field    = "event_name"
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
