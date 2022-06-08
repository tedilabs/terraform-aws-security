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
    arn  = one(module.role.*.arn)
    name = one(module.role.*.name)
  }
}

output "delivery_channels" {
  description = "Delivery channels of the trail."
  value = {
    s3 = {
      bucket     = var.delivery_s3_bucket
      key_prefix = var.delivery_s3_key_prefix

      delivery_s3_integrity_validation_enabled = var.delivery_s3_integrity_validation_enabled
    }
    sns = {
      topic = var.delivery_sns_topic
    }
    cloudwatch_logs = {
      log_group = var.delivery_cloudwatch_logs_log_group
    }
  }
}

output "management_event" {
  description = "A configuration for management events logging of the trail."
  value       = var.management_event
}

output "insight_event" {
  description = "A configuration for insight events logging of the trail."
  value       = var.insight_event
}
