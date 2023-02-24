variable "name" {
  description = "(Required) The name of the trail. The name can only contain uppercase letters, lowercase letters, numbers, periods (.), hyphens (-), and underscores (_)."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[0-9A-Za-z-_\\.]+$", var.name))
    error_message = "For the name value only a-z, A-Z, 0-9, periods (.), hyphens (-) and underscores (_) are allowed."
  }
}

variable "enabled" {
  description = "(Optional) Whether the trail starts the recording of AWS API calls and log file delivery. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "level" {
  description = "(Optional) The level of the trail to decide whether the trail is an AWS Organizations trail. Organization trails log events for the master account and all member accounts. Can only be created in the organization master account. Valid values are `ACCOUNT` and `ORGANIZATION`. Use `ORGANIZATION` level in Organization master account. Defaults to `ACCOUNT`."
  type        = string
  default     = "ACCOUNT"
  nullable    = false

  validation {
    condition     = contains(["ACCOUNT", "ORGANIZATION"], var.level)
    error_message = "The level should be one of `ACCOUNT`, `ORGANIZATION`."
  }
}

variable "scope" {
  description = "(Optional) The scope of the trail to decide whether the trail is multi-region trail. Supported values are `REGIONAL_WITH_GLOBAL`, `REGIONAL` or `ALL`. Defaults to `REGIONAL_WITH_GLOBAL`."
  type        = string
  default     = "REGIONAL_WITH_GLOBAL"
  nullable    = false

  validation {
    condition     = contains(["REGIONAL_WITH_GLOBAL", "REGIONAL", "ALL"], var.scope)
    error_message = "The scope should be one of `REGIONAL_WITH_GLOBAL`, `REGIONAL`, `ALL`."
  }
}

variable "delivery_s3_bucket" {
  description = "(Required) The name of the S3 bucket designated for publishing log files."
  type        = string
}

variable "delivery_s3_key_prefix" {
  description = "(Optional) The key prefix for the specified S3 bucket."
  type        = string
  default     = null
}

variable "delivery_s3_integrity_validation_enabled" {
  description = "(Optional) To determine whether a log file was modified, deleted, or unchanged after AWS CloudTrail delivered it, use CloudTrail log file integrity validation. This feature is built using industry standard algorithms: SHA-256 for hashing and SHA-256 with RSA for digital signing."
  type        = bool
  default     = true
  nullable    = false
}

variable "delivery_sns_topic" {
  description = "(Optional) The name of the SNS topic for notification of log file delivery."
  type        = string
  default     = null
}

variable "delivery_cloudwatch_logs_log_group" {
  description = "(Optional) The name of the log group of CloudWatch Logs for log file delivery."
  type        = string
  default     = null
}

variable "management_event" {
  description = <<EOF
  (Optional) A configuration block for management events logging to identify API activity for individual resources, or for all current and future resources in AWS account. `management_event` block as defined below.
    (Required) `enabled` - Whether the trail to log management events.
    (Optional) `scope` - The type of events to log. Valid values are `ALL`, `READ` and `WRITE`. Defaults to `ALL`.
    (Optional) `exclude_event_sources` - A set of event sources to exclude. Valid values are `kms.amazonaws.com` and `rdsdata.amazonaws.com`. `management_event.enabled` must be set to true to allow this.
  EOF
  type = object({
    enabled               = bool
    scope                 = string
    exclude_event_sources = list(string)
  })
  default = {
    enabled               = true
    scope                 = "ALL"
    exclude_event_sources = []
  }
  nullable = false

  validation {
    condition     = contains(["ALL", "READ", "WRITE"], var.management_event.scope)
    error_message = "Valid values for `management_event.scope` are `ALL`, `READ`, `WRITE`."
  }

  validation {
    condition = alltrue([
      for source in try(var.management_event.exclude_event_sources, []) :
      contains(["kms.amazonaws.com", "rdsdata.amazonaws.com"], source)
    ])
    error_message = "Valid values for `management_event.exclude_event_sources` are `kms.amazonaws.com`, `rdsdata.amazonaws.com`."
  }
}

variable "insight_event" {
  description = <<EOF
  (Optional) A configuration block for insight events logging to identify unusual operational activity. `insight_event` block as defined below.
    (Required) `enabled` - Whether the trail to log insight events.
    (Optional) `scopes` - A set of insight types to log on the trail. Valid values are `API_CALL_RATE` and `API_ERROR_RATE`.
  EOF
  type = object({
    enabled = optional(bool, false)
    scopes  = optional(set(string), [])
  })
  default  = {}
  nullable = false

  validation {
    condition = alltrue([
      for scope in var.insight_event.scopes :
      contains(["API_CALL_RATE", "API_ERROR_RATE"], scope)
    ])
    error_message = "Valid values for `insight_event.scopes` are `API_CALL_RATE`, `API_ERROR_RATE`."
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
