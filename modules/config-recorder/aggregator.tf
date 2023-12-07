###################################################
# Authorization for Aggregators
###################################################

resource "aws_config_aggregate_authorization" "this" {
  for_each = {
    for aggregator in var.authorized_aggregators :
    "${aggregator.account}:${aggregator.region}" => aggregator
  }

  account_id = each.value.account
  region     = each.value.region

  tags = merge(
    local.module_tags,
    var.tags,
    each.value.tags,
  )
}


###################################################
# Aggregators
###################################################

resource "aws_config_configuration_aggregator" "account" {
  for_each = {
    for aggregation in var.account_aggregations :
    aggregation.name => aggregation
  }

  name = each.key

  account_aggregation_source {
    all_regions = length(each.value.regions) < 1
    regions = (length(each.value.regions) < 1
      ? null
      : each.value.regions
    )
    account_ids = each.value.accounts
  }

  tags = merge(
    {
      "Name" = each.key
    },
    local.module_tags,
    var.tags,
    each.value.tags,
  )
}

resource "aws_config_configuration_aggregator" "organization" {
  count = var.organization_aggregation.enabled ? 1 : 0

  name = var.organization_aggregation.name

  organization_aggregation_source {
    all_regions = length(var.organization_aggregation.regions) < 1
    regions = (length(var.organization_aggregation.regions) < 1
      ? null
      : var.organization_aggregation.regions
    )
    role_arn = (var.default_organization_aggregator_role.enabled
      ? module.role__aggregator[0].arn
      : var.organization_aggregator_role
    )
  }

  tags = merge(
    {
      "Name" = var.organization_aggregation.name
    },
    local.module_tags,
    var.tags,
    var.organization_aggregation.tags,
  )
}
