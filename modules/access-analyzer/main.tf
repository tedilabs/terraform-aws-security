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

resource "aws_accessanalyzer_analyzer" "this" {
  analyzer_name = var.name
  type          = var.type

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
