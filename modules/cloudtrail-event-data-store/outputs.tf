output "arn" {
  description = "The Amazon Resource Name (ARN) of the event data store."
  value       = aws_cloudtrail_event_data_store.this.arn
}

output "id" {
  description = "The ID of the event data store."
  value       = aws_cloudtrail_event_data_store.this.id
}

output "name" {
  description = "The name of the event data store."
  value       = aws_cloudtrail_event_data_store.this.name
}

output "level" {
  description = "The level of the event data store to decide whether the event data store collects events logged for an organization in AWS Organizations."
  value       = aws_cloudtrail_event_data_store.this.organization_enabled ? "ORGANIZATION" : "ACCOUNT"
}

output "scope" {
  description = "The scope of the event data store to decide whether the event data store includes events from all regions, or only from the region in which the event data store is created."
  value       = aws_cloudtrail_event_data_store.this.multi_region_enabled ? "ALL" : "REGIONAL"
}

output "event_type" {
  description = "The type of event to be collected by the event data store."
  value       = var.event_type
}

output "management_event_selector" {
  description = "The event selector to use to select the management events for the event data store."
  value       = var.management_event_selector
}

output "data_event_selectors" {
  description = "The event selectors to use to select the data events for the event data store."
  value       = var.data_event_selectors
}

output "encryption" {
  description = "The configuration for the encryption of the event data store."
  value = {
    kms_key = aws_cloudtrail_event_data_store.this.kms_key_id
  }
}

output "retention_in_days" {
  description = "The retention period of the event data store, in days."
  value       = aws_cloudtrail_event_data_store.this.retention_period
}

output "termination_protection_enabled" {
  description = "Whether termination protection is enabled for the event data store."
  value       = aws_cloudtrail_event_data_store.this.termination_protection_enabled
}

output "import_trail_events_iam_role" {
  description = "A configuration of IAM Role for importing CloudTrail events from S3 Bucket."
  value = one([
    for role in module.role[*] : {
      arn         = role.arn
      name        = role.name
      description = role.description
    }
  ])
}
