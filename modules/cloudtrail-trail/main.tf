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

data "aws_cloudwatch_log_group" "this" {
  count = (var.delivery_channels.cloudwatch_log_group.enabled ? 1 : 0)

  name = var.delivery_channels.cloudwatch_log_group.name
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
  condition_fields = {
    "event_name"   = "eventName"
    "resource_arn" = "resources.ARN"
  }
}


###################################################
# Trail on CloudTrail
###################################################

# INFO: Not supported attributes
# - `event_selector`
resource "aws_cloudtrail" "this" {
  name           = var.name
  enable_logging = var.enabled

  is_multi_region_trail         = var.scope == "ALL"
  is_organization_trail         = var.level == "ORGANIZATION"
  include_global_service_events = var.scope != "REGIONAL"


  ## Delivery - S3
  s3_bucket_name             = var.delivery_channels.s3_bucket.name
  s3_key_prefix              = var.delivery_channels.s3_bucket.key_prefix
  enable_log_file_validation = var.delivery_channels.s3_bucket.integrity_validation_enabled
  kms_key_id                 = var.delivery_channels.s3_bucket.sse_kms_key


  ## Delivery - SNS
  sns_topic_name = (var.delivery_channels.sns_topic.enabled
    ? var.delivery_channels.sns_topic.name
    : null
  )


  ## Delivery - CloudWatch Logs
  cloud_watch_logs_group_arn = (var.delivery_channels.cloudwatch_log_group.enabled
    ? data.aws_cloudwatch_log_group.this[0].arn
    : null
  )
  cloud_watch_logs_role_arn = (var.delivery_channels.cloudwatch_log_group.enabled
    ? one(module.role[*].arn)
    : null
  )


  ## Event Selector - Management Events
  dynamic "advanced_event_selector" {
    for_each = var.management_event_selector.enabled ? [var.management_event_selector] : []
    iterator = selector

    content {
      name = "AWS CloudTrail Management Events"

      field_selector {
        field  = "eventCategory"
        equals = ["Management"]
      }

      dynamic "field_selector" {
        for_each = selector.value.scope != "ALL" ? ["go"] : []

        content {
          field = "readOnly"
          equals = [{
            "READ"  = "true"
            "WRITE" = "false"
          }[selector.value.scope]]
        }
      }

      dynamic "field_selector" {
        for_each = (length(selector.value.exclude_event_sources) > 0) ? ["go"] : []

        content {
          field      = "eventSource"
          not_equals = selector.value.exclude_event_sources
        }
      }
    }
  }


  ## Event Selector - Data Events
  dynamic "advanced_event_selector" {
    for_each = var.data_event_selectors
    iterator = selector

    content {
      name = coalesce(selector.value.name, "AWS CloudTrail Data Events ${selector.key}")

      field_selector {
        field  = "eventCategory"
        equals = ["Data"]
      }

      field_selector {
        field  = "resources.type"
        equals = [selector.value.resource_type]
      }

      dynamic "field_selector" {
        for_each = selector.value.scope != "ALL" ? ["go"] : []

        content {
          field = "readOnly"
          equals = [{
            "READ"  = "true"
            "WRITE" = "false"
          }[selector.value.scope]]
        }
      }

      dynamic "field_selector" {
        for_each = length(selector.value.conditions) > 0 ? selector.value.conditions : []
        iterator = condition

        content {
          field = local.condition_fields[condition.value.field]

          equals          = condition.value.operator == "equals" ? condition.value.values : null
          not_equals      = condition.value.operator == "not_equals" ? condition.value.values : null
          starts_with     = condition.value.operator == "starts_with" ? condition.value.values : null
          not_starts_with = condition.value.operator == "not_starts_with" ? condition.value.values : null
          ends_with       = condition.value.operator == "ends_with" ? condition.value.values : null
          not_ends_with   = condition.value.operator == "not_ends_with" ? condition.value.values : null
        }
      }
    }
  }


  ## Event Selector - Insight Events
  dynamic "insight_selector" {
    for_each = var.insight_event_selector.enabled ? var.insight_event_selector.scopes : []
    iterator = selector

    content {
      insight_type = local.insight_types[selector.value]
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
