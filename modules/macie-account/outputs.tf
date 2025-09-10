output "id" {
  description = "The ID of the macie account."
  value       = aws_macie2_account.this.id
}

output "name" {
  description = "The account ID of the macie account."
  value       = local.metadata.name
}

output "enabled" {
  description = "Whether the macie account is eanbled."
  value       = aws_macie2_account.this.status == "ENABLED"
}

output "update_frequency" {
  description = "How often to publish updates to policy findings for the macie account."
  value = {
    for k, v in local.update_frequency :
    v => k
  }[aws_macie2_account.this.finding_publishing_frequency]
}

output "service_role" {
  description = "The Amazon Resource Name (ARN) of the service-linked role that allows Macie to monitor and analyze data in AWS resources for the account."
  value       = aws_macie2_account.this.service_role
}

output "created_at" {
  description = "The date and time, in UTC and extended RFC 3339 format, when the Amazon Macie account was created."
  value       = aws_macie2_account.this.created_at
}

output "updated_at" {
  description = "The date and time, in UTC and extended RFC 3339 format, of the most recent change to the status of the Macie account."
  value       = aws_macie2_account.this.updated_at
}

output "member_accounts" {
  description = <<EOF
  The list of configruations for member accounts on the macie account.
  EOF
  value = {
    for id, account in aws_macie2_member.this :
    id => {
      id                  = account.id
      arn                 = account.arn
      email               = account.email
      enabled             = account.status == "ENABLED"
      relationship_status = account.relationship_status

      updated_at = account.updated_at
    }
  }
}

output "discovery_result_repository" {
  description = <<EOF
  The configuration for discovery result location and encryption of the macie account.
  EOF
  value = {
    s3_bucket = var.discovery_result_repository.s3_bucket
  }
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
