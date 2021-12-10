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
  description = "The scope of the recorder."
  value       = var.scope
}

output "custom_resource_types" {
  description = "A list that specifies the types of AWS resources for which AWS Config records configuration changes."
  value       = var.custom_resource_types
}

output "role_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM role."
  value       = aws_config_configuration_recorder.this.role_arn
}

output "delivery_channels" {
  description = "Delivery channels of the recorder."
  value = {
    s3 = {
      bucket      = var.delivery_s3_bucket
      key_prefix  = var.delivery_s3_key_prefix
      sse_kms_key = var.delivery_s3_sse_kms_key
    }
    sns = {
      topic = var.delivery_sns_topic
    }
  }
}

output "authorized_aggregators" {
  description = "A list of Authorized aggregators allowed to collect AWS Config configuration and compliance data."
  value = [
    for id, aggregator in aws_config_aggregate_authorization.this : {
      id         = aggregator.id
      arn        = aggregator.arn
      account_id = aggregator.account_id
      region     = aggregator.region
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
      account_ids = aggregation.account_aggregation_source[0].account_ids
    }
  ]
}

output "organization_aggregation" {
  description = "The configuration to aggregate config data from organization accounts."
  value = try({
    arn         = aws_config_configuration_aggregator.organization.*.arn[0]
    id          = aws_config_configuration_aggregator.organization.*.id[0]
    name        = aws_config_configuration_aggregator.organization.*.name[0]
    all_regions = aws_config_configuration_aggregator.organization.*.organization_aggregation_source[0][0].all_regions
    regions     = aws_config_configuration_aggregator.organization.*.organization_aggregation_source[0][0].regions
    role_arn    = aws_config_configuration_aggregator.organization.*.organization_aggregation_source[0][0].role_arn
  }, null)
}
