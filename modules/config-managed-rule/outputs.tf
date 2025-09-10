output "id" {
  description = "The ID of the rule."
  value = try(
    aws_config_config_rule.this[0].rule_id,
    split("/", aws_config_organization_managed_rule.this[0].arn)[1]
  )
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the rule."
  value = try(
    aws_config_config_rule.this[0].arn,
    aws_config_organization_managed_rule.this[0].arn
  )
}

output "name" {
  description = "The name of the rule."
  value = try(
    aws_config_config_rule.this[0].name,
    aws_config_organization_managed_rule.this[0].name
  )
}

output "description" {
  description = "The description of the rule."
  value = try(
    aws_config_config_rule.this[0].description,
    aws_config_organization_managed_rule.this[0].description
  )
}

output "source_rule" {
  description = "The information of the managed rule used."
  value = {
    id         = local.rule.id
    name       = var.source_rule
    parameters = local.rule.parameters
    labels     = local.rule.labels
  }
}

output "parameters" {
  description = "The parameters of the rule."
  value = try(
    jsondecode(aws_config_config_rule.this[0].input_parameters),
    jsondecode(aws_config_organization_managed_rule.this[0].input_parameters),
  )
}

output "level" {
  description = "The level of the rule. `ACOUNT` or `ORGANIZATION`. The rule is for accounts in your Organization if the value is configured with `ORGANIZATION`."
  value       = var.level
}

output "evaluation_modes" {
  description = "A set of evaluation modes to enable for the Config rule."
  value       = var.evaluation_modes
}

output "trigger_by_change" {
  description = "The information of trigger by configuration changes."
  value = {
    enabled        = local.rule.trigger_by_change.enabled
    scope          = var.scope
    resource_types = local.scope[var.scope].resource_types
    resource_id    = local.scope[var.scope].resource_id
    resource_tag = {
      key   = local.scope[var.scope].tag_key
      value = local.scope[var.scope].tag_value
    }
  }
}

output "trigger_by_schedule" {
  description = "The information of trigger by schedule."
  value = {
    enabled = local.rule.trigger_by_schedule.enabled
    frequency = (local.rule.trigger_by_schedule.enabled
      ? local.frequency[coalesce(var.schedule_frequency, local.rule.trigger_by_schedule.max_frequency)]
    : null)
  }
}

output "excluded_accounts" {
  description = "A list of AWS account identifiers excluded from the rule."
  value       = try(aws_config_organization_managed_rule.this[0].excluded_accounts, [])
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
