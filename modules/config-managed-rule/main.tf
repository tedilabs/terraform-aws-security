locals {
  metadata = {
    package = "terraform-aws-security"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = coalesce(var.name, local.rule.default_name)
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
  managed_rules = jsondecode(file("${path.module}/rules.json"))
  rule          = local.managed_rules[var.source_rule]

  frequency = {
    "1h"  = "One_Hour"
    "3h"  = "Three_Hours"
    "6h"  = "Six_Hours"
    "12h" = "Twelve_Hours"
    "24h" = "TwentyFour_Hours"
  }

  scope = {
    "ALL_CHANGES" = {
      resource_types = null
      resource_id    = null
      tag_key        = null
      tag_value      = null
    }
    "RESOURCES" = {
      resource_types = concat(var.resource_types, try(local.rule.trigger_by_change.scope.resource_types, []))
      resource_id    = var.resource_id
      tag_key        = null
      tag_value      = null
    }
    "TAGS" = {
      resource_types = null
      resource_id    = null
      tag_key        = try(var.resource_tag.key, null)
      tag_value      = try(var.resource_tag.value, null)
    }
  }
}


###################################################
# Managed Rule for Account
###################################################

resource "aws_config_config_rule" "this" {
  count = var.level == "ACCOUNT" ? 1 : 0

  name        = local.metadata.name
  description = coalesce(var.description, local.rule.description)

  source {
    owner             = "AWS"
    source_identifier = local.rule.id
  }

  input_parameters = jsonencode(var.parameters)

  ### Trigger by configuration change
  ## Scope: ALL_CHANGES
  dynamic "scope" {
    for_each = local.rule.trigger_by_change.enabled && var.scope == "ALL_CHANGES" ? ["go"] : []

    content {}
  }
  ## Scope: RESOURCES
  dynamic "scope" {
    for_each = local.rule.trigger_by_change.enabled && var.scope == "RESOURCES" ? ["go"] : []

    content {
      compliance_resource_types = local.scope["RESOURCES"].resource_types
      compliance_resource_id    = local.scope["RESOURCES"].resource_id
    }
  }
  ## Scope: TAGS
  dynamic "scope" {
    for_each = local.rule.trigger_by_change.enabled && var.scope == "TAGS" ? ["go"] : []

    content {
      tag_key   = local.scope["TAGS"].tag_key
      tag_value = local.scope["TAGS"].tag_value
    }
  }

  ### Trigger by schedule
  maximum_execution_frequency = (local.rule.trigger_by_schedule.enabled
    ? local.frequency[coalesce(var.schedule_frequency, local.rule.trigger_by_schedule.max_frequency)]
  : null)

  tags = merge(
    local.module_tags,
    var.tags,
  )
}


###################################################
# Managed Rule for Organization
###################################################

resource "aws_config_organization_managed_rule" "this" {
  count = var.level == "ORGANIZATION" ? 1 : 0

  name        = local.metadata.name
  description = coalesce(var.description, local.rule.description)

  rule_identifier = local.rule.id

  input_parameters = jsonencode(var.parameters)

  ### Trigger by configuration change
  resource_types_scope = (local.rule.trigger_by_change.enabled
    ? local.scope[var.scope].resource_types
  : null)
  resource_id_scope = (local.rule.trigger_by_change.enabled
    ? local.scope[var.scope].resource_id
  : null)
  tag_key_scope = (local.rule.trigger_by_change.enabled
    ? local.scope[var.scope].tag_key
  : null)
  tag_value_scope = (local.rule.trigger_by_change.enabled
    ? local.scope[var.scope].tag_value
  : null)

  ### Trigger by schedule
  maximum_execution_frequency = (local.rule.trigger_by_schedule.enabled
    ? local.frequency[coalesce(var.schedule_frequency, local.rule.trigger_by_schedule.max_frequency)]
  : null)

  excluded_accounts = var.excluded_accounts
}
