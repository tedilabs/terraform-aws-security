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
    "ALL" = {
      recording_strategy            = "ALL_SUPPORTED_RESOURCE_TYPES"
      all_supported                 = true
      include_global_resource_types = true
      resource_types                = null
      exclude_resource_types        = null
    }
    "ALL_WITHOUT_GLOBAL" = {
      recording_strategy            = "ALL_SUPPORTED_RESOURCE_TYPES"
      all_supported                 = true
      include_global_resource_types = false
      resource_types                = null
      exclude_resource_types        = null
    }
    "WHITELIST" = {
      recording_strategy            = "INCLUSION_BY_RESOURCE_TYPES"
      all_supported                 = false
      include_global_resource_types = false
      resource_types                = var.scope.resource_types
      exclude_resource_types        = null
    }
    "BLACKLIST" = {
      recording_strategy            = "EXCLUSION_BY_RESOURCE_TYPES"
      all_supported                 = false
      include_global_resource_types = true
      resource_types                = null
      exclude_resource_types        = var.scope.resource_types
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


###################################################
# Config Recorder
###################################################

resource "aws_config_configuration_recorder" "this" {
  name = var.name
  role_arn = (var.default_service_role.enabled
    ? module.role__recorder[0].arn
    : var.service_role
  )

  recording_mode {
    recording_frequency = var.recording_frequency.mode

    dynamic "recording_mode_override" {
      for_each = var.recording_frequency.overrides
      iterator = override

      content {
        resource_types      = override.value.resource_types
        recording_frequency = override.value.mode
        description         = override.value.description
      }
    }
  }

  recording_group {
    recording_strategy {
      use_only = local.recording_groups[var.scope.strategy].recording_strategy
    }

    all_supported                 = local.recording_groups[var.scope.strategy].all_supported
    include_global_resource_types = local.recording_groups[var.scope.strategy].include_global_resource_types
    resource_types                = local.recording_groups[var.scope.strategy].resource_types

    dynamic "exclusion_by_resource_types" {
      for_each = local.recording_groups[var.scope.strategy].exclude_resource_types != null ? ["go"] : []

      content {
        resource_types = local.recording_groups[var.scope.strategy].exclude_resource_types
      }
    }
  }
}

resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = var.enabled

  depends_on = [
    aws_config_delivery_channel.this,
  ]
}

resource "aws_config_retention_configuration" "this" {
  retention_period_in_days = var.retention_period
}


###################################################
# Delivery Channel
###################################################

resource "aws_config_delivery_channel" "this" {
  name = aws_config_configuration_recorder.this.name

  s3_bucket_name = var.delivery_channels.s3_bucket.name
  s3_key_prefix  = var.delivery_channels.s3_bucket.key_prefix
  s3_kms_key_arn = var.delivery_channels.s3_bucket.sse_kms_key

  sns_topic_arn = (var.delivery_channels.sns_topic.enabled
    ? var.delivery_channels.sns_topic.arn
    : null
  )

  dynamic "snapshot_delivery_properties" {
    for_each = var.snapshot_delivery.enabled ? ["go"] : []

    content {
      delivery_frequency = local.delivery_frequency[var.snapshot_delivery.frequency]
    }
  }
}
