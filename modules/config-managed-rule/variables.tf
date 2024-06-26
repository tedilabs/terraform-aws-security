variable "source_rule" {
  description = "(Required) The identifier for AWS Config managed rule. Use the format like `root-account-mfa-enabled` instead of predefiend format like `ROOT_ACCOUNT_MFA_ENABLED`."
  type        = string
  nullable    = false
}

variable "name" {
  description = "(Optional) The name of the rule. Use default rule name if not provided."
  type        = string
  default     = null
  nullable    = true
}

variable "description" {
  description = "(Optional) The description of the rule. Use default description if not provided."
  type        = string
  default     = null
  nullable    = true
}

variable "parameters" {
  description = "(Optional) A map of parameters that is passed to the AWS Config rule Lambda function."
  type        = any
  default     = {}
  nullable    = false
}

variable "level" {
  description = "(Optional) Choose to create a rule across all accounts in your Organization. Valid values are `ACCOUNT` and `ORGANIZATION`. Use `ORGANIZATION` level in Organization master account or delegated administrator accounts."
  type        = string
  default     = "ACCOUNT"
  nullable    = false

  validation {
    condition     = contains(["ACCOUNT", "ORGANIZATION"], var.level)
    error_message = "The level should be one of `ACCOUNT`, `ORGANIZATION`."
  }
}

variable "evaluation_modes" {
  description = "(Optional) A set of evaluation modes to enable for the Config rule. Valid values are `DETECTIVE`, `PROACTIVE`. Default value contains only `DETECTIVE`."
  type        = set(string)
  default     = ["DETECTIVE"]
  nullable    = false

  validation {
    condition = alltrue([
      for mode in var.evaluation_modes :
      contains(["DETECTIVE", "PROACTIVE"], mode)
    ])
    error_message = "Valid values for `evaluation_modes` should be one of `DETECTIVE`, `PROACTIVE`."
  }
}

variable "scope" {
  description = "(Optional) Choose when evaluations will occur. Valid values are `ALL_CHANGES`, `RESOURCES`, or `TAGS`."
  type        = string
  default     = "RESOURCES"
  nullable    = false

  validation {
    condition     = contains(["ALL_CHANGES", "RESOURCES", "TAGS"], var.scope)
    error_message = "The scope should be one of `ALL_CHANGES`, `RESOURCES`, and `TAGS`."
  }
}

variable "resource_types" {
  description = "(Optional) A list of resource types of only those AWS resources that you want to trigger an evaluation for the rule. For example, `AWS::EC2::Instance` or `AWS::CloudTrail::Trail`. Only need when `scope` is configured with value `RESOURCES`."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "resource_id" {
  description = "(Optional) The ID of the only AWS resource that you want to trigger an evaluation for the rule. If you specify this, you must specify only one resource type for `resource_types`. Only need when `scope` is configured with value `RESOURCES`."
  type        = string
  default     = null
  nullable    = true
}

variable "resource_tag" {
  description = "(Optional) The tag that are applied to only those AWS resources that you want you want to trigger an evaluation for the rule. You can configure with only `key` or a set of `key` and `value`. Only need when `scope` is configured with value `TAGS`."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "schedule_frequency" {
  description = "(Optional) The frequency with which AWS Config runs evaluations for a rule. Use default value if not provided. Valid values are `1h`, `3h`, `6h`, `12h`, or `24h`."
  type        = string
  default     = null
  nullable    = true
}

variable "excluded_accounts" {
  description = "(Optional) A list of AWS account identifiers to exclude from the rule. Only need when `level` is configured with value `ORGANIZATION`."
  type        = list(string)
  default     = []
  nullable    = false
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
