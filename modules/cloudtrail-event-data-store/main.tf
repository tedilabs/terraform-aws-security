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
}


###################################################
# Event Data Store on CloudTrail
###################################################

resource "aws_cloudtrail_event_data_store" "this" {
  region = var.region

  name    = var.name
  suspend = !var.enabled

  organization_enabled = var.level == "ORGANIZATION"
  multi_region_enabled = var.scope == "ALL"


  ## Encryption
  kms_key_id = var.encryption.kms_key


  ## Event Selector - AWS CloudTrail Events (Management)
  dynamic "advanced_event_selector" {
    for_each = var.event_type == "CLOUDTRAIL_EVENTS" && var.management_event_selector.enabled ? [var.management_event_selector] : []
    iterator = selector

    content {
      name = "AWS CloudTrail Events - Management"

      field_selector {
        field  = "eventCategory"
        equals = ["Management"]
      }

      dynamic "field_selector" {
        for_each = selector.value.scope != "ALL" ? ["go"] : []

        content {
          field = "readOnly"
          equals = [{
            "READ"  = "true"
            "WRITE" = "false"
          }[selector.value.scope]]
        }
      }

      dynamic "field_selector" {
        for_each = (length(selector.value.exclude_event_sources) > 0) ? ["go"] : []

        content {
          field      = "eventSource"
          not_equals = selector.value.exclude_event_sources
        }
      }
    }
  }


  ## Event Selector - AWS CloudTrail Events (Data)
  dynamic "advanced_event_selector" {
    for_each = var.event_type == "CLOUDTRAIL_EVENTS" ? var.data_event_selectors : []
    iterator = selector

    content {
      name = coalesce(selector.value.name, "AWS CloudTrail Events - Data ${selector.key}")

      field_selector {
        field  = "eventCategory"
        equals = ["Data"]
      }

      field_selector {
        field  = "resources.type"
        equals = [selector.value.resource_type]
      }

      dynamic "field_selector" {
        for_each = selector.value.scope != "ALL" ? ["go"] : []

        content {
          field = "readOnly"
          equals = [{
            "READ"  = "true"
            "WRITE" = "false"
          }[selector.value.scope]]
        }
      }

      dynamic "field_selector" {
        for_each = length(selector.value.conditions) > 0 ? selector.value.conditions : []
        iterator = condition

        content {
          field = condition.value.field

          equals          = condition.value.operator == "equals" ? condition.value.values : null
          not_equals      = condition.value.operator == "not_equals" ? condition.value.values : null
          starts_with     = condition.value.operator == "starts_with" ? condition.value.values : null
          not_starts_with = condition.value.operator == "not_starts_with" ? condition.value.values : null
          ends_with       = condition.value.operator == "ends_with" ? condition.value.values : null
          not_ends_with   = condition.value.operator == "not_ends_with" ? condition.value.values : null
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
  billing_mode                   = var.billing_mode
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
