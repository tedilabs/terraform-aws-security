data "aws_caller_identity" "this" {}

locals {
  account_id = data.aws_caller_identity.this.account_id
}


###################################################
# IAM Role
###################################################

module "role__recorder" {
  count = var.default_service_role.enabled ? 1 : 0

  source  = "tedilabs/account/aws//modules/iam-role"
  version = "~> 0.32.0"

  name = coalesce(
    var.default_service_role.name,
    "config-configuration-recorder-${local.metadata.name}",
  )
  path        = var.default_service_role.path
  description = var.default_service_role.description

  trusted_service_policies = [
    {
      services = ["config.amazonaws.com"]
    },
  ]

  policies = concat(
    ["arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"],
    var.default_service_role.policies,
  )
  inline_policies = merge(
    {
      "delivery" = data.aws_iam_policy_document.delivery.json
    },
    var.default_service_role.inline_policies
  )
  permissions_boundary = var.default_service_role.permissions_boundary

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

module "role__aggregator" {
  count = var.organization_aggregation.enabled && var.default_organization_aggregator_role.enabled ? 1 : 0

  source  = "tedilabs/account/aws//modules/iam-role"
  version = "~> 0.32.0"

  name = coalesce(
    var.default_organization_aggregator_role.name,
    "config-configuration-aggregator-${local.metadata.name}",
  )
  path        = var.default_organization_aggregator_role.path
  description = var.default_organization_aggregator_role.description

  trusted_service_policies = [
    {
      services = ["config.amazonaws.com"]
    },
  ]

  policies = concat(
    ["arn:aws:iam::aws:policy/service-role/AWSConfigRoleForOrganizations"],
    var.default_organization_aggregator_role.policies,
  )
  inline_policies      = var.default_organization_aggregator_role.inline_policies
  permissions_boundary = var.default_organization_aggregator_role.permissions_boundary

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
# IAM Policies
###################################################

data "aws_iam_policy_document" "delivery" {
  statement {
    sid = "DeliverToS3Bucket"

    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]
    resources = [
      var.delivery_channels.s3_bucket.key_prefix != null
      ? "arn:aws:s3:::${var.delivery_channels.s3_bucket.name}/*/AWSLogs/${local.account_id}/*"
      : "arn:aws:s3:::${var.delivery_channels.s3_bucket.name}/AWSLogs/${local.account_id}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
  statement {
    sid = "CheckS3BucektPermission"

    effect = "Allow"
    actions = [
      "s3:GetBucketAcl",
    ]
    resources = [
      "arn:aws:s3:::${var.delivery_channels.s3_bucket.name}",
    ]
  }
  dynamic "statement" {
    for_each = var.delivery_channels.s3_bucket.sse_kms_key != null ? ["go"] : []

    content {
      sid = "EnableS3Encryption"

      effect = "Allow"
      actions = [
        "kms:Decrypt",
        "kms:GenerateDataKey",
      ]
      resources = [
        var.delivery_channels.s3_bucket.sse_kms_key,
      ]
    }
  }
  dynamic "statement" {
    for_each = var.delivery_channels.sns_topic.arn != null ? ["go"] : []

    content {
      sid = "PublishToSnsTopic"

      effect = "Allow"
      actions = [
        "sns:Publish",
      ]
      resources = [
        var.delivery_channels.sns_topic.arn,
      ]
    }
  }
}

data "aws_iam_policy_document" "aggregation" {
  statement {
    sid = "DeliverToS3Bucket"

    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]
    resources = [
      var.delivery_channels.s3_bucket.key_prefix != null && var.delivery_channels.s3_bucket.key_prefix != ""
      ? "arn:aws:s3:::${var.delivery_channels.s3_bucket.name}/*/AWSLogs/${local.account_id}/*"
      : "arn:aws:s3:::${var.delivery_channels.s3_bucket.name}/AWSLogs/${local.account_id}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
  statement {
    sid = "CheckS3BucektPermission"

    effect = "Allow"
    actions = [
      "s3:GetBucketAcl",
    ]
    resources = [
      "arn:aws:s3:::${var.delivery_channels.s3_bucket.name}",
    ]
  }
  dynamic "statement" {
    for_each = var.delivery_channels.s3_bucket.sse_kms_key != null ? ["go"] : []

    content {
      sid = "EnableS3Encryption"

      effect = "Allow"
      actions = [
        "kms:Decrypt",
        "kms:GenerateDataKey",
      ]
      resources = [
        var.delivery_channels.s3_bucket.sse_kms_key,
      ]
    }
  }
  dynamic "statement" {
    for_each = var.delivery_channels.sns_topic.arn != null ? ["go"] : []

    content {
      sid = "PublishToSnsTopic"

      effect = "Allow"
      actions = [
        "sns:Publish",
      ]
      resources = [
        var.delivery_channels.sns_topic.arn,
      ]
    }
  }
}
