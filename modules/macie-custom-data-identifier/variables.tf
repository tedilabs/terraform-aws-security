variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "name" {
  description = "(Required) A name for the custom data identifier. The name can contain as many as 128 characters."
  type        = string
  nullable    = false
}

variable "description" {
  description = "(Optional) A description of the custom data identifier. Defaults to `Managed by Terraform.`."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}

variable "regex" {
  description = "(Required) The regular expression (regex) that defines the pattern to match. The expression can contain as many as 512 characters."
  type        = string
  nullable    = false
}

variable "keywords" {
  description = "(Optional) An array that lists specific character sequences (keywords), one of which must be within proximity (maximum_match_distance) of the regular expression to match. The array can contain as many as 50 keywords. Each keyword can contain 3 - 90 characters. Keywords aren't case sensitive."
  type        = set(string)
  default     = []
  nullable    = false
}

variable "ignore_words" {
  description = "(Optional) An array that lists specific character sequences (ignore words) to exclude from the results. If the text matched by the regular expression is the same as any string in this array, Amazon Macie ignores it. The array can contain as many as 10 ignore words. Each ignore word can contain 4 - 90 characters. Ignore words are case sensitive."
  type        = set(string)
  default     = []
  nullable    = false
}

variable "maximum_match_distance" {
  description = "(Optional) The maximum allowable distance between text that matches the regex pattern and the keywords. The distance can be 1 - 300 characters. Defaults to `50`."
  type        = number
  default     = 50
  nullable    = false

  validation {
    condition     = var.maximum_match_distance >= 1 && var.maximum_match_distance <= 300
    error_message = "Value for `maximum_match_distance` must be between 1 and 300."
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
