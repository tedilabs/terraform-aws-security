output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_cloudtrail.this.region
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the trail."
  value       = aws_cloudtrail.this.arn
}
output "id" {
  description = "The ID of the trail."
  value       = aws_cloudtrail.this.id
}

output "name" {
  description = "The name of the trail."
  value       = aws_cloudtrail.this.name
}

output "enabled" {
  description = "Whether the trail is enabled."
  value       = aws_cloudtrail.this.enable_logging
}

output "home_region" {
  description = "The region in which the trail was created."
  value       = aws_cloudtrail.this.home_region
}

output "level" {
  description = "The level of the trail to decide whether the trail is an AWS Organizations trail."
  value       = var.level
}

output "scope" {
  description = "The scope of the trail to decide whether the trail is multi-region trail."
  value       = var.scope
}

output "iam_role" {
  description = "The IAM Role for the CloudTrail trail."
  value = {
    arn  = one(module.role[*].arn)
    name = one(module.role[*].name)
  }
}

output "delivery_channels" {
  description = "The configurations for the delivery channels of the trail."
  value = {
    s3_bucket = {
      name                         = aws_cloudtrail.this.s3_bucket_name
      key_prefix                   = aws_cloudtrail.this.s3_key_prefix
      integrity_validation_enabled = aws_cloudtrail.this.enable_log_file_validation
      sse_kms_key                  = var.delivery_channels.s3_bucket.sse_kms_key
    }
    sns_topic = {
      enabled = var.delivery_channels.sns_topic.enabled
      name    = var.delivery_channels.sns_topic.name
    }
    cloudwatch_log_group = {
      enabled = var.delivery_channels.cloudwatch_log_group.enabled
      arn     = aws_cloudtrail.this.cloud_watch_logs_group_arn
      name    = var.delivery_channels.cloudwatch_log_group.name
    }
  }
}

output "management_event" {
  description = "A selector for management events of the trail."
  value       = var.management_event_selector
}

output "data_event" {
  description = "A list of selectors for data events of the trail."
  value       = var.data_event_selectors
}

output "insight_event" {
  description = "A selector for insight events of the trail."
  value       = var.insight_event_selector
}

output "resource_group" {
  description = "The resource group created to manage resources in this module."
  value = merge(
    {
      enabled = var.resource_group.enabled && var.module_tags_enabled
    },
    (var.resource_group.enabled && var.module_tags_enabled
      ? {
        arn  = module.resource_group[0].arn
        name = module.resource_group[0].name
      }
      : {}
    )
  )
}

# output "debug" {
#   value = {
#     for k, v in aws_cloudtrail.this :
#     k => v
#     if !contains(["id", "arn", "name", "enable_logging", "home_region", "s3_bucket_name", "s3_key_prefix", "enable_log_file_validation", "kms_key_id", "sns_topic_name", "cloud_watch_logs_group_arn", "tags", "tags_all", "is_multi_region_trail", "is_organization_trail", "include_global_service_events", "insight_selector", "event_selector", "advanced_event_selector"], k)
#   }
# }
