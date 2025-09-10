output "name" {
  description = "The name of the Analyzer."
  value       = aws_accessanalyzer_analyzer.this.analyzer_name
}

output "id" {
  description = "The ID of this Analyzer."
  value       = aws_accessanalyzer_analyzer.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of this Analyzer."
  value       = aws_accessanalyzer_analyzer.this.arn
}

output "type" {
  description = "The finding type of Analyzer."
  value       = var.type
}

output "scope" {
  description = "The scope of Analyzer."
  value       = var.scope
}

output "unused_access_tracking_period" {
  description = "The scope of Analyzer."
  value = (var.type == "UNUSED_ACCESS"
    ? one(aws_accessanalyzer_analyzer.this.configuration[0].unused_access[*].unused_access_age)
    : null
  )
}

output "archive_rules" {
  description = "A list of archive rules for the Analyzer."
  value = {
    for name, rule in aws_accessanalyzer_archive_rule.this :
    name => rule.filter
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
