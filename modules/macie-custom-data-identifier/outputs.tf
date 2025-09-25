output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_macie2_custom_data_identifier.this.region
}

output "arn" {
  description = "The ARN (Amazon Resource Name) for the macie custom data identifier. For example: `arn:aws:cloudfront::123456789012:distribution/EDFDVBD632BHDS5`."
  value       = aws_macie2_custom_data_identifier.this.arn
}

output "id" {
  description = "The ID of the macie custom data identifier."
  value       = aws_macie2_custom_data_identifier.this.id
}

output "name" {
  description = "The name of the macie custom data identifier."
  value       = local.metadata.name
}

output "description" {
  description = "The description of the macie custom data identifier."
  value       = aws_macie2_custom_data_identifier.this.description
}

output "regex" {
  description = "The regular expression (regex) that defines the pattern to match."
  value       = aws_macie2_custom_data_identifier.this.regex
}

output "keywords" {
  description = "An array that lists specific character sequences (keywords), one of which must be within proximity (maximum_match_distance) of the regular expression to match."
  value       = aws_macie2_custom_data_identifier.this.keywords
}

output "ignore_words" {
  description = "An array that lists specific character sequences (ignore words) to exclude from the results."
  value       = aws_macie2_custom_data_identifier.this.ignore_words
}

output "maximum_match_distance" {
  description = "The maximum number of characters that can exist between text that matches the regex pattern and the character sequences specified by the keywords array."
  value       = aws_macie2_custom_data_identifier.this.maximum_match_distance
}

output "created_at" {
  description = "The date and time, in UTC and extended RFC 3339 format, when the Amazon Macie custom data identifier was created."
  value       = aws_macie2_custom_data_identifier.this.created_at
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
