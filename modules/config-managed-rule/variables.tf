variable "source_rule" {
  description = "The identifier for AWS Config managed rule. Use the format like `root-account-mfa-enabled` instead of predefiend format like `ROOT_ACCOUNT_MFA_ENABLED`."
  type        = string
}

variable "name" {
  description = "The name of the rule. Use default rule name if not provided."
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the rule. Use default description if not provided."
  type        = string
  default     = null
}

variable "parameters" {
  description = "A map of parameters that is passed to the AWS Config rule Lambda function."
  type        = any
  default     = {}
}

variable "level" {
  description = "Choose to create a rule across all accounts in your Organization. Valid values are `ACCOUNT` and `ORGANIZATION`. Use `ORGANIZATION` level in Organization master account or delegated administrator accounts."
  type        = string
  default     = "ACCOUNT"

  validation {
    condition     = contains(["ACCOUNT", "ORGANIZATION"], var.level)
    error_message = "The level should be one of `ACCOUNT`, `ORGANIZATION`."
  }
}

variable "scope" {
  description = "Choose when evaluations will occur. Valid values are `ALL_CHANGES`, `RESOURCES`, or `TAGS`."
  type        = string
  default     = "RESOURCES"

  validation {
    condition     = contains(["ALL_CHANGES", "RESOURCES", "TAGS"], var.scope)
    error_message = "The scope should be one of `ALL_CHANGES`, `RESOURCES`, and `TAGS`."
  }
}

variable "resource_types" {
  description = "A list of resource types of only those AWS resources that you want to trigger an evaluation for the rule. For example, `AWS::EC2::Instance` or `AWS::CloudTrail::Trail`. Only need when `scope` is configured with value `RESOURCES`."
  type        = list(string)
  default     = []
}

variable "resource_id" {
  description = "The ID of the only AWS resource that you want to trigger an evaluation for the rule. If you specify this, you must specify only one resource type for `resource_types`. Only need when `scope` is configured with value `RESOURCES`."
  type        = string
  default     = null
}

variable "resource_tag" {
  description = "The tag that are applied to only those AWS resources that you want you want to trigger an evaluation for the rule. You can configure with only `key` or a set of `key` and `value`. Only need when `scope` is configured with value `TAGS`."
  type        = map(string)
  default     = {}
}

variable "schedule_frequency" {
  description = "The frequency with which AWS Config runs evaluations for a rule. Use default value if not provided. Valid values are `1h`, `3h`, `6h`, `12h`, or `24h`."
  type        = string
  default     = null
}

variable "excluded_accounts" {
  description = "A list of AWS account identifiers to exclude from the rule. Only need when `level` is configured with value `ORGANIZATION`."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "module_tags_enabled" {
  description = "Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
}


###################################################
# Resource Group
###################################################

variable "resource_group_enabled" {
  description = "Whether to create Resource Group to find and group AWS resources which are created by this module."
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`."
  type        = string
  default     = ""
}

variable "resource_group_description" {
  description = "The description of Resource Group."
  type        = string
  default     = "Managed by Terraform."
}
