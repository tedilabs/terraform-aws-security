output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_securityhub_account.this.region
}

output "id" {
  description = "The ID of the SecurityHub account."
  value       = aws_securityhub_account.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of this SecurityHub account."
  value       = aws_securityhub_account.this.arn
}

output "name" {
  description = "The account ID of the SecurityHub account."
  value       = local.metadata.name
}

output "member_accounts" {
  description = <<EOF
  The list of configruations for member accounts on the SecurityHub account.
  EOF
  value = {
    for id, account in aws_securityhub_member.this :
    id => {
      id      = account.id
      type    = !account.invite ? "ORGANIZATION" : "INVITATION"
      enabled = account.member_status == "Enabled"

      debug = {
        for k, v in account :
        k => v
        if !contains(["region", "id", "email", "account_id", "master_id", "member_status"], k)
      }
    }
  }
}

output "organization_config" {
  description = <<EOF
  The organization configurations for the SecurityHub account.
    `mode` - The organization configuration mode. Valid values are `CENTRAL` or `LOCAL`.
    `auto_enable` - Whether to automatically enable SecurityHub for new accounts in the organization.
  EOF
  value = (length(aws_securityhub_organization_configuration.this) > 0
    ? {
      mode                          = aws_securityhub_organization_configuration.this[0].organization_configuration[0].configuration_type
      auto_enable                   = aws_securityhub_organization_configuration.this[0].auto_enable
      auto_enable_default_standards = aws_securityhub_organization_configuration.this[0].auto_enable_standards == "DEFAULT"
    }
    : null
  )
}

output "auto_enable_controls" {
  description = "Whether to automatically enable new controls when they are added to security standards that are enabled."
  value       = aws_securityhub_account.this.auto_enable_controls
}

output "control_finding" {
  description = <<EOF
  The configuration for control finding of the SecurityHub account.
    `consolidation_enabled` - Whether to enable control finding consolidation for the account.
  EOF
  value = {
    consolidation_enabled = aws_securityhub_account.this.control_finding_generator == "SECURITY_CONTROL"
    aggregator = (length(aws_securityhub_finding_aggregator.this) > 0
      ? {
        id      = aws_securityhub_finding_aggregator.this[0].id
        mode    = aws_securityhub_finding_aggregator.this[0].linking_mode
        regions = aws_securityhub_finding_aggregator.this[0].specified_regions
      }
      : null
    )
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

# output "debug" {
#   value = {
#     account = {
#       for k, v in aws_securityhub_account.this :
#       k => v
#       if !contains(["region", "id", "arn", "control_finding_generator", "enable_default_standards", "auto_enable_controls"], k)
#     }
#     aggregator = (length(aws_securityhub_finding_aggregator.this) > 0
#       ? {
#         for k, v in aws_securityhub_finding_aggregator.this[0] :
#         k => v
#         if !contains(["region", "id", "linking_mode", "specified_regions"], k)
#       }
#       : null
#     )
#   }
# }
