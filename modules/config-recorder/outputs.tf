output "name" {
  description = "The name of the recorder."
  value       = aws_config_configuration_recorder.this.name
}

output "id" {
  description = "The ID of the recorder."
  value       = aws_config_configuration_recorder.this.id
}

output "enabled" {
  description = "Whether the configuration recorder is enabled."
  value       = aws_config_configuration_recorder_status.this.is_enabled
}

output "scope" {
  description = <<EOF
  A list that specifies the types of AWS resources for which AWS Config records configuration changes.
    `strategy` - The recording strategy for the configuration recorder.
    `resource_types` - A list of resource types to include/exclude for recording.
  EOF
  value = {
    strategy       = var.scope.strategy
    resource_types = var.scope.resource_types
  }
}

output "service_role" {
  description = "The Amazon Resource Name (ARN) of the IAM role for the recorder."
  value       = aws_config_configuration_recorder.this.role_arn
}

output "snapshot_delivery" {
  description = <<EOF
  The configuration for the configuration snapshot delivery of the recorder.
    `enabled` - Whether the configuration snapshot delivery is enabled.
    `frequency` - The frequency with which AWS Config recurringly delivers configuration snapshots.
  EOF
  value = {
    enabled   = var.snapshot_delivery.enabled
    frequency = var.snapshot_delivery.frequency
  }
}

output "delivery_channels" {
  description = <<EOF
  The configuration of delivery channels of the recorder.
    `s3_bucket` - The configuration for the S3 Bucket delivery channel.
    `sns_topic` - The configuration for the SNS Topic delivery channel.
  EOF
  value = {
    s3_bucket = {
      name        = aws_config_delivery_channel.this.s3_bucket_name
      key_prefix  = aws_config_delivery_channel.this.s3_key_prefix
      sse_kms_key = aws_config_delivery_channel.this.s3_kms_key_arn
    }
    sns = {
      topic = aws_config_delivery_channel.this.sns_topic_arn
    }
  }
}

output "authorized_aggregators" {
  description = "A list of Authorized aggregators allowed to collect AWS Config configuration and compliance data."
  value = [
    for id, aggregator in aws_config_aggregate_authorization.this : {
      id      = aggregator.id
      arn     = aggregator.arn
      account = aggregator.account_id
      region  = aggregator.region
    }
  ]
}

output "account_aggregations" {
  description = "A list of configurations to aggregate config data from individual accounts."
  value = [
    for name, aggregation in aws_config_configuration_aggregator.account : {
      arn         = aggregation.arn
      id          = aggregation.id
      name        = aggregation.name
      all_regions = aggregation.account_aggregation_source[0].all_regions
      regions     = aggregation.account_aggregation_source[0].regions
      accounts    = aggregation.account_aggregation_source[0].account_ids
    }
  ]
}

output "organization_aggregation" {
  description = "The configuration to aggregate config data from organization accounts."
  value = (var.organization_aggregation.enabled
    ? {
      arn          = aws_config_configuration_aggregator.organization[0].arn
      id           = aws_config_configuration_aggregator.organization[0].id
      name         = aws_config_configuration_aggregator.organization[0].name
      all_regions  = aws_config_configuration_aggregator.organization[0].organization_aggregation_source[0].all_regions
      regions      = aws_config_configuration_aggregator.organization[0].organization_aggregation_source[0].regions
      service_role = aws_config_configuration_aggregator.organization[0].organization_aggregation_source[0].role_arn
    }
    : null
  )
}
