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


###################################################
# Access Analyzer
###################################################

resource "aws_accessanalyzer_analyzer" "this" {
  region = var.region

  analyzer_name = var.name
  type          = "${var.scope}${var.type == "EXTERNAL_ACCESS" ? "" : "_${var.type}"}"

  dynamic "configuration" {
    for_each = contains(["INTERNAL_ACCESS", "UNUSED_ACCESS"], var.type) ? ["go"] : []

    content {
      dynamic "internal_access" {
        for_each = var.type == "INTERNAL_ACCESS" ? ["go"] : []

        content {
          dynamic "analysis_rule" {
            for_each = length(var.internal_access_analysis.rules) > 0 ? ["go"] : []
            iterator = rule

            content {
              dynamic "inclusion" {
                for_each = var.internal_access_analysis.rules[*].inclusion

                content {
                  account_ids = (length(inclusion.value.accounts) > 0
                    ? inclusion.value.accounts
                    : null
                  )
                  resource_arns = (length(inclusion.value.resource_arns) > 0
                    ? inclusion.value.resource_arns
                    : null
                  )
                  resource_types = (length(inclusion.value.resource_types) > 0
                    ? inclusion.value.resource_types
                    : null
                  )
                }
              }
            }
          }
        }
      }

      dynamic "unused_access" {
        for_each = var.type == "UNUSED_ACCESS" ? ["go"] : []

        content {
          unused_access_age = var.unused_access_analysis.tracking_period

          dynamic "analysis_rule" {
            for_each = length(var.unused_access_analysis.rules) > 0 ? ["go"] : []
            iterator = rule

            content {
              dynamic "exclusion" {
                for_each = var.unused_access_analysis.rules[*].exclusion

                content {
                  account_ids = (length(exclusion.value.accounts) > 0
                    ? exclusion.value.accounts
                    : null
                  )
                  resource_tags = (length(exclusion.value.resource_tags) > 0
                    ? exclusion.value.resource_tags
                    : null
                  )
                }
              }
            }
          }
        }
      }
    }
  }

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}

resource "aws_accessanalyzer_archive_rule" "this" {
  for_each = {
    for rule in var.archive_rules :
    rule.name => rule
  }

  region = var.region

  analyzer_name = aws_accessanalyzer_analyzer.this.analyzer_name
  rule_name     = each.key

  dynamic "filter" {
    for_each = each.value.filters

    content {
      criteria = filter.value.criteria

      contains = try(filter.value.contains, null)
      exists   = try(filter.value.exists, null)
      eq       = try(filter.value.eq, null)
      neq      = try(filter.value.neq, null)
    }
  }
}
