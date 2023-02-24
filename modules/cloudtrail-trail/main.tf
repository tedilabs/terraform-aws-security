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
  management_types = {
    "ALL"   = "All"
    "READ"  = "ReadOnly"
    "WRITE" = "WriteOnly"
  }
  insight_types = {
    "API_CALL_RATE"  = "ApiCallRateInsight"
    "API_ERROR_RATE" = "ApiErrorRateInsight"
  }
}


###################################################
# Trail on CloudTrail
###################################################

resource "aws_cloudtrail" "this" {
  name           = var.name
  enable_logging = var.enabled

  is_multi_region_trail         = var.scope == "ALL"
  is_organization_trail         = var.level == "ORGANIZATION"
  include_global_service_events = var.scope != "REGIONAL"

  ## Encryption
  # kms_key_id

  ## Delivery - S3
  s3_bucket_name             = var.delivery_s3_bucket
  s3_key_prefix              = var.delivery_s3_key_prefix
  enable_log_file_validation = var.delivery_s3_integrity_validation_enabled

  ## Delivery - SNS
  sns_topic_name = var.delivery_sns_topic

  ## Delivery - CloudWatch Logs
  cloud_watch_logs_group_arn = var.delivery_cloudwatch_logs_log_group != null ? "${local.cloudwatch_log_group_arn}:*" : null
  cloud_watch_logs_role_arn  = var.delivery_cloudwatch_logs_log_group != null ? one(module.role[*].arn) : null

  ## Event Selector - Management Events
  event_selector {
    include_management_events        = var.management_event.enabled
    read_write_type                  = local.management_types[var.management_event.scope]
    exclude_management_event_sources = var.management_event.exclude_event_sources
  }

  ## Event Selector - Data Events
  # advanced_event_selector

  ## Event Selector - Insight Events
  dynamic "insight_selector" {
    for_each = var.insight_event.enabled ? var.insight_event.scopes : []

    content {
      insight_type = local.insight_types[insight_selector.value]
    }
  }

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}
