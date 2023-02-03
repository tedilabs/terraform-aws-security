locals {
  metadata = {
    package = "terraform-aws-security"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
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
  event_categories = {
    "DATA"       = "Data"
    "MANAGEMENT" = "Management"
  }
  event_scopes = {
    "ALL"   = "All"
    "READ"  = "ReadOnly"
    "WRITE" = "WriteOnly"
  }
  event_selector_fields = {
    "event_name"   = "eventName"
    "resource_arn" = "resources.ARN"
  }
}


###################################################
# Event Data Store on CloudTrail
###################################################

resource "aws_cloudtrail_event_data_store" "this" {
  name = var.name

  organization_enabled = var.level == "ORGANIZATION"
  multi_region_enabled = var.scope == "ALL"


  ## Encryption
  # TODO: Not supported yet in aws provider
  # kms_key_id = var.encryption_kms_key


  ## Event Selector - AWS CloudTrail Events
  dynamic "advanced_event_selector" {
    for_each = var.event_type == "CLOUDTRAIL_EVENTS" ? var.event_selectors : []
    iterator = event

    content {
      name = "AWS CloudTrail Events - ${local.event_categories[event.value.category]}"

      field_selector {
        field  = "eventCategory"
        equals = [local.event_categories[event.value.category]]
      }

      dynamic "field_selector" {
        for_each = event.value.scope != "ALL" ? ["go"] : []

        content {
          field = "readOnly"
          equals = [{
            "READ"  = "true"
            "WRITE" = "false"
          }[event.value.scope]]
        }
      }

      dynamic "field_selector" {
        for_each = (event.value.category == "MANAGEMENT" && length(event.value.exclude_sources) > 0) ? ["go"] : []

        content {
          field      = "eventSource"
          not_equals = event.value.exclude_sources
        }
      }

      dynamic "field_selector" {
        for_each = event.value.category == "DATA" ? ["go"] : []

        content {
          field  = "resources.type"
          equals = [event.value.resource_type]
        }
      }

      dynamic "field_selector" {
        for_each = length(event.value.selectors) > 0 ? event.value.selectors : []
        iterator = selector

        content {
          field = local.event_selector_fields[selector.value.field]

          equals          = selector.value.operator == "equals" ? selector.value.values : null
          not_equals      = selector.value.operator == "not_equals" ? selector.value.values : null
          starts_with     = selector.value.operator == "starts_with" ? selector.value.values : null
          not_starts_with = selector.value.operator == "not_starts_with" ? selector.value.values : null
          ends_with       = selector.value.operator == "ends_with" ? selector.value.values : null
          not_ends_with   = selector.value.operator == "not_ends_with" ? selector.value.values : null
        }
      }
    }
  }

  ## Event Selector - AWS Config Configuration Items
  dynamic "advanced_event_selector" {
    for_each = var.event_type == "CONFIG_CONFIGURATION_ITEMS" ? ["go"] : []

    content {
      name = "AWS Config Configuration Items"

      field_selector {
        field  = "eventCategory"
        equals = ["ConfigurationItem"]
      }
    }
  }


  ## Attributes
  retention_period               = var.retention_in_days
  termination_protection_enabled = var.termination_protection_enabled

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}
