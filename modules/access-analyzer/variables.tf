variable "name" {
  description = "(Required) The name of the Analyzer."
  type        = string
}

variable "type" {
  description = "(Optional) Type of Analyzer. Valid values are `ACCOUNT` or `ORGANIZATION`. Defaults to `ACCOUNT`."
  type        = string
  default     = "ACCOUNT"
  nullable    = false

  validation {
    condition     = contains(["ACCOUNT", "ORGANIZATION"], var.type)
    error_message = "The `type` should be one of `ACCOUNT`, `ORGANIZATION`."
  }
}

variable "archive_rules" {
  description = <<EOF
  (Optional) A list of archive rules for the AccessAnalyzer Analyzer. Each item of `archive_rules` block as defined below.
    (Required) `name` - The name of archive rule.
    (Required) `filters` - A list of filter criterias for the archive rule. Each item of `filters` block as defined below.
      (Required) `criteria` - The filter criteria.
      (Optional) `contains` - Contains comparator.
      (Optional) `exists` - Exists comparator (Boolean).
      (Optional) `eq` - Equal comparator.
      (Optional) `neq` - Not Equal comparator.
  EOF
  type        = any
  default     = []
  nullable    = false

  validation {
    condition = alltrue([
      for rule in var.archive_rules :
      length(rule.filters) > 0
    ])
    error_message = "`filters` of each item of `archive_rules` must have one or more filters."
  }
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "module_tags_enabled" {
  description = "(Optional) Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
  nullable    = false
}


###################################################
# Resource Group
###################################################

variable "resource_group_enabled" {
  description = "(Optional) Whether to create Resource Group to find and group AWS resources which are created by this module."
  type        = bool
  default     = true
  nullable    = false
}

variable "resource_group_name" {
  description = "(Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`."
  type        = string
  default     = ""
  nullable    = false
}

variable "resource_group_description" {
  description = "(Optional) The description of Resource Group."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}
