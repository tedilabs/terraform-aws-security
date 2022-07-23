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
  description = "The type of Analyzer."
  value       = aws_accessanalyzer_analyzer.this.type
}

output "archive_rules" {
  description = "A list of archive rules for the Analyzer."
  value = {
    for name, rule in aws_accessanalyzer_archive_rule.this :
    name => rule.filter
  }
}
