output "name" {
  description = "The name of the Analyzer."
  value       = aws_accessanalyzer_analyzer.this.analyzer_name
}

output "id" {
  description = "The ID of this Analyzer."
  value       = aws_accessanalyzer_analyzer.this.id
}

output "type" {
  description = "The type of Analyzer."
  value       = aws_accessanalyzer_analyzer.this.type
}
