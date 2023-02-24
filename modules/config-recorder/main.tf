locals {
  metadata = {
    package = "terraform-aws-security"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
  }
  module_tags = var.module_tags_enabled ? {
    "module.terraform.io/package"   = local.metadata.package
    "module.terraform.io/version"   = local.metadata.version
    "module.terraform.io/name"      = local.metadata.module
    "module.terraform.io/full-name" = "${local.metadata.package}/${local.metadata.module}"
    "module.terraform.io/instance"  = local.metadata.name
  } : {}
}

locals {
  recording_groups = {
    "REGIONAL_WITH_GLOBAL" = {
      all_supported                 = true
      include_global_resource_types = true
    }
    "REGIONAL" = {
      all_supported = true
    }
    "CUSTOM" = {
      resource_types = var.custom_resource_types
    }
  }
  delivery_frequency = {
    "1h"  = "One_Hour"
    "3h"  = "Three_Hours"
    "6h"  = "Six_Hours"
    "12h" = "Twelve_Hours"
    "24h" = "TwentyFour_Hours"
  }
}

resource "aws_config_configuration_recorder" "this" {
  name     = var.name
  role_arn = module.role__recorder.arn

  recording_group {
    all_supported                 = try(local.recording_groups[var.scope].all_supported, false)
    include_global_resource_types = try(local.recording_groups[var.scope].include_global_resource_types, false)
    resource_types                = try(local.recording_groups[var.scope].resource_types, null)
  }
}

resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = var.enabled

  depends_on = [
    aws_config_delivery_channel.this,
  ]
}


###################################################
# Delivery Channel
###################################################

resource "aws_config_delivery_channel" "this" {
  name = aws_config_configuration_recorder.this.name

  s3_bucket_name = var.delivery_s3_bucket
  s3_key_prefix  = var.delivery_s3_key_prefix
  s3_kms_key_arn = var.delivery_s3_sse_kms_key

  sns_topic_arn = var.delivery_sns_topic

  dynamic "snapshot_delivery_properties" {
    for_each = try(local.delivery_frequency[var.delivery_frequency] != null, false) ? ["go"] : []

    content {
      delivery_frequency = local.delivery_frequency[var.delivery_frequency]
    }
  }
}


###################################################
# Authorization for Aggregators
###################################################

resource "aws_config_aggregate_authorization" "this" {
  for_each = {
    for aggregator in var.authorized_aggregators :
    "${aggregator.account_id}:${aggregator.region}" => aggregator
  }

  account_id = each.value.account_id
  region     = each.value.region

  tags = merge(
    local.module_tags,
    var.tags,
  )
}


###################################################
# Aggregators
###################################################

resource "aws_config_configuration_aggregator" "account" {
  for_each = {
    for aggregation in var.account_aggregations :
    aggregation.name => aggregation
  }

  name = each.key

  account_aggregation_source {
    all_regions = try(length(each.value.regions) < 1, true)
    regions     = try(each.value.regions, null)
    account_ids = each.value.account_ids
  }

  tags = merge(
    local.module_tags,
    var.tags,
  )
}

resource "aws_config_configuration_aggregator" "organization" {
  count = try(var.organization_aggregation.enabled, false) ? 1 : 0

  name = "organization"

  organization_aggregation_source {
    all_regions = try(length(var.organization_aggregation.regions) < 1, true)
    regions     = try(var.organization_aggregation.regions, null)
    role_arn    = module.role__aggregator[0].arn
  }

  tags = merge(
    local.module_tags,
    var.tags,
  )
}
