variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "name" {
  description = "(Required) The name of the Analyzer."
  type        = string
  nullable    = false
}

variable "type" {
  description = "(Optional) A finding type of Analyzer. Valid values are `EXTERNAL_ACCESS`, `INTERNAL_ACCESS` or `UNUSED_ACCESS`. Defaults to `EXTERNAL_ACCESS`."
  type        = string
  default     = "EXTERNAL_ACCESS"
  nullable    = false

  validation {
    condition     = contains(["EXTERNAL_ACCESS", "INTERNAL_ACCESS", "UNUSED_ACCESS"], var.type)
    error_message = "The `type` should be one of `EXTERNAL_ACCESS`, `INTERNAL_ACCESS`, `UNUSED_ACCESS`."
  }
}

variable "scope" {
  description = "(Optional) A scope of Analyzer. Valid values are `ACCOUNT` or `ORGANIZATION`. Defaults to `ACCOUNT`."
  type        = string
  default     = "ACCOUNT"
  nullable    = false

  validation {
    condition     = contains(["ACCOUNT", "ORGANIZATION"], var.scope)
    error_message = "The `scope` should be one of `ACCOUNT`, `ORGANIZATION`."
  }
}

variable "internal_access_analysis" {
  description = <<EOF
  (Optional) A configurations for the `INTERNAL_ACCESS` type Analyzer. `internal_access_analysis` as defined below.
    (Optional) `rules` - A list of rules for internal access analyzer. Each item of `rules` block as defined below.
      (Required) `inclusion` - An inclusion rule to filter findings. `inclusion` as defined below.
        (Optional) `accounts` - A set of account IDs to include in the analysis. Account IDs can only be applied to the analysis rule criteria for organization-level analyzers.
        (Optional) `resource_arns` - A set of resource ARNs to include in the analysis. The analyzer will only generate findings for resources that match these ARNs.
        (Optional) `resource_types` - A set of resource types to include in the analysis. The analyzer will only generate findings for resources of these types
  EOF
  type = object({
    rules = optional(list(object({
      inclusion = object({
        accounts       = optional(set(string), [])
        resource_arns  = optional(set(string), [])
        resource_types = optional(set(string), [])
      })
    })), [])
  })
  default  = {}
  nullable = false
}

variable "unused_access_analysis" {
  description = <<EOF
  (Optional) A configurations for the `UNUSED_ACCESS` type Analyzer. `unused_access_analysis` as defined below.
    (Optional) `tracking_period` - A number of days for the tracking the period. Findings will be generated for access that hasn't been used in more than the specified number of days. Defaults to `90`.
    (Optional) `rules` - A list of rules for unused access analyzer. Each item of `rules` block as defined below.
      (Required) `exclusion` - An exclusion rule to filter findings. `exclusion` as defined below.
        (Optional) `accounts` - A set of account IDs to exclude from the analysis. Account IDs can only be applied to the analysis rule criteria for organization-level analyzers.
        (Optional) `resource_tags` - A list of tag key and value pairs to exclude from the analysis.
  EOF
  type = object({
    tracking_period = optional(number, 90)
    rules = optional(list(object({
      exclusion = object({
        accounts      = optional(set(string), [])
        resource_tags = optional(list(map(string)), [])
      })
    })), [])
  })
  default  = {}
  nullable = false

  validation {
    condition = alltrue([
      var.unused_access_analysis.tracking_period >= 1,
      var.unused_access_analysis.tracking_period <= 180
    ])
    error_message = "Valid value for `tracking_period` is between 1 and 180."
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
  type = list(object({
    name = string
    filters = list(object({
      criteria = string
      contains = optional(list(string))
      exists   = optional(bool)
      eq       = optional(list(string))
      neq      = optional(list(string))
    }))
  }))
  default  = []
  nullable = false

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

variable "resource_group" {
  description = <<EOF
  (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.
    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.
    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.
    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`.
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string, "")
    description = optional(string, "Managed by Terraform.")
  })
  default  = {}
  nullable = false
}
