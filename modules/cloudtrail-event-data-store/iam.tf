data "aws_caller_identity" "this" {}

locals {
  account_id = data.aws_caller_identity.this.account_id
}


###################################################
# IAM Role for CloudTrail Event Data Store
###################################################

module "role" {
  count = var.import_trail_events_iam_role.enabled ? 1 : 0

  source  = "tedilabs/account/aws//modules/iam-role"
  version = "~> 0.33.0"

  name = coalesce(
    var.import_trail_events_iam_role.name,
    "cloudtrail-event-data-store-${local.metadata.name}",
  )
  path        = var.import_trail_events_iam_role.path
  description = var.import_trail_events_iam_role.description

  trusted_service_policies = [
    {
      services = ["cloudtrail.amazonaws.com"]
    }
  ]
  conditions = [
    {
      key       = "aws:SourceAccount"
      condition = "StringEquals"
      values    = [local.account_id]
    },
    {
      key       = "aws:SourceArn"
      condition = "StringEquals"
      values    = [aws_cloudtrail_event_data_store.this.arn]
    },
  ]

  policies = var.import_trail_events_iam_role.policies
  inline_policies = merge(
    {
      "s3" = one(data.aws_iam_policy_document.s3[*].json)
    },
    var.import_trail_events_iam_role.inline_policies
  )
  permissions_boundary = var.import_trail_events_iam_role.permissions_boundary

  force_detach_policies = true
  resource_group = {
    enabled = false
  }
  module_tags_enabled = false

  tags = merge(
    local.module_tags,
    var.tags,
  )
}


###################################################
# IAM Policy to Import CloudTrail Events
###################################################

locals {
  default_s3_bucket = {
    name       = "you-should-configure-source-s3-buckets-to-import"
    key_prefix = ""
  }
  source_s3_buckets = [
    for bucket in coalescelist(var.import_trail_events_iam_role.source_s3_buckets, [local.default_s3_bucket]) : {
      name       = bucket.name
      key_prefix = trim(bucket.key_prefix, "/")

    }
  ]
}

data "aws_iam_policy_document" "s3" {
  count = var.import_trail_events_iam_role.enabled ? 1 : 0

  statement {
    sid = "AWSCloudTrailImportBucketAccess"

    effect  = "Allow"
    actions = ["s3:ListBucket", "s3:GetBucketAcl"]
    resources = [
      for bucket in local.source_s3_buckets :
      "arn:aws:s3:::${bucket.name}"
    ]
  }

  statement {
    sid = "AWSCloudTrailImportObjectAccess"

    effect  = "Allow"
    actions = ["s3:GetObject"]
    resources = flatten([
      for bucket in local.source_s3_buckets : [
        join("/", compact(["arn:aws:s3:::${bucket.name}", bucket.key_prefix])),
        join("/", compact(["arn:aws:s3:::${bucket.name}", bucket.key_prefix, "*"])),
      ]
    ])
  }
}
