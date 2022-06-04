data "aws_caller_identity" "this" {}

locals {
  account_id = data.aws_caller_identity.this.account_id
}


###################################################
# IAM Role
###################################################

module "role__recorder" {
  source  = "tedilabs/account/aws//modules/iam-role"
  version = "~> 0.20.0"

  name        = "config-configuration-recorder-${local.metadata.name}"
  path        = "/"
  description = "Role for the Configuration Recorder in Config."

  trusted_services = ["config.amazonaws.com"]

  policies = [
    "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole",
  ]
  inline_policies = {
    "delivery" = data.aws_iam_policy_document.delivery.json
  }

  resource_group_enabled = false
  module_tags_enabled    = false

  tags = merge(
    local.module_tags,
    var.tags,
  )
}

module "role__aggregator" {
  count = try(var.organization_aggregation.enabled, false) ? 1 : 0

  source  = "tedilabs/account/aws//modules/iam-role"
  version = "~> 0.20.0"

  name        = "config-configuration-aggregator-${local.metadata.name}"
  path        = "/"
  description = "Role for the Configuration Aggregator in Config."

  trusted_services = ["config.amazonaws.com"]

  policies = [
    "arn:aws:iam::aws:policy/service-role/AWSConfigRoleForOrganizations",
  ]
  inline_policies = {}

  resource_group_enabled = false
  module_tags_enabled    = false

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
      var.delivery_s3_key_prefix != null && var.delivery_s3_key_prefix != ""
      ? "arn:aws:s3:::${var.delivery_s3_bucket}/*/AWSLogs/${local.account_id}/*"
      : "arn:aws:s3:::${var.delivery_s3_bucket}/AWSLogs/${local.account_id}/*",
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
      "arn:aws:s3:::${var.delivery_s3_bucket}",
    ]
  }
  dynamic "statement" {
    for_each = var.delivery_s3_sse_kms_key != null ? ["go"] : []

    content {
      sid = "EnableS3Encryption"

      effect = "Allow"
      actions = [
        "kms:Decrypt",
        "kms:GenerateDataKey",
      ]
      resources = [
        var.delivery_s3_sse_kms_key,
      ]
    }
  }
  dynamic "statement" {
    for_each = var.delivery_sns_topic != null ? ["go"] : []

    content {
      sid = "PublishToSnsTopic"

      effect = "Allow"
      actions = [
        "sns:Publish",
      ]
      resources = [
        var.delivery_sns_topic,
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
      var.delivery_s3_key_prefix != null && var.delivery_s3_key_prefix != ""
      ? "arn:aws:s3:::${var.delivery_s3_bucket}/*/AWSLogs/${local.account_id}/*"
      : "arn:aws:s3:::${var.delivery_s3_bucket}/AWSLogs/${local.account_id}/*",
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
      "arn:aws:s3:::${var.delivery_s3_bucket}",
    ]
  }
  dynamic "statement" {
    for_each = var.delivery_s3_sse_kms_key != null ? ["go"] : []

    content {
      sid = "EnableS3Encryption"

      effect = "Allow"
      actions = [
        "kms:Decrypt",
        "kms:GenerateDataKey",
      ]
      resources = [
        var.delivery_s3_sse_kms_key,
      ]
    }
  }
  dynamic "statement" {
    for_each = var.delivery_sns_topic != null ? ["go"] : []

    content {
      sid = "PublishToSnsTopic"

      effect = "Allow"
      actions = [
        "sns:Publish",
      ]
      resources = [
        var.delivery_sns_topic,
      ]
    }
  }
}
