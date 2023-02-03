variable "name" {
  description = "(Required) The name of the event data store."
  type        = string
  nullable    = false
}

variable "level" {
  description = "(Optional) The level of the event data store to decide whether the event data store collects events logged for an organization in AWS Organizations. Can be created in the management account or delegated administrator account. Valid values are `ACCOUNT` and `ORGANIZATION`. Defaults to `ACCOUNT`."
  type        = string
  default     = "ACCOUNT"
  nullable    = false

  validation {
    condition     = contains(["ACCOUNT", "ORGANIZATION"], var.level)
    error_message = "The level should be one of `ACCOUNT`, `ORGANIZATION`."
  }
}

variable "scope" {
  description = "(Optional) The scope of the event data store to decide whether the event data store includes events from all regions, or only from the region in which the event data store is created. Supported values are `REGIONAL` or `ALL`. Defaults to `ALL`."
  type        = string
  default     = "ALL"
  nullable    = false

  validation {
    condition     = contains(["REGIONAL", "ALL"], var.scope)
    error_message = "The scope should be one of `REGIONAL`, `ALL`."
  }
}

variable "event_type" {
  description = "(Required) A type of event to be collected by the event data store. Valid values are `CLOUDTRAIL_EVENTS`, `CONFIG_CONFIGURATION_ITEMS`. Defaults to `CLOUDTRAIL_EVENTS`."
  type        = string
  default     = "CLOUDTRAIL_EVENTS"
  nullable    = false

  validation {
    condition     = contains(["CLOUDTRAIL_EVENTS", "CONFIG_CONFIGURATION_ITEMS"], var.event_type)
    error_message = "The event type should be one of `CLOUDTRAIL_EVENTS`, `CONFIG_CONFIGURATION_ITEMS`."
  }
}

variable "event_selectors" {
  description = <<EOF
  (Optional) A configuration of event selectors to use to select the events for the event data store. Only used if `event_type` is `CLOUDTRAIL_EVENTS`. Each item of `event_selectors` as defined below.
    (Required) `category` - A category of the event. Valid values are `DATA` and `MANAGEMENT`.
      - `DATA`: Log the resource operations performed on or within a resource.
      - `MANAGEMENT`: Capture management operations performed on your AWS resources.
    (Optional) `scope` - A scope of events to log. Valid values are `ALL`, `READ` and `WRITE`. Defaults to `ALL`.
    (Optional) `exclude_sources` - A set of event sources to exclude. Valid values are `kms.amazonaws.com` and `rdsdata.amazonaws.com`. Only used if `category` is `MANAGEMENT`.
    (Optional) `resource_type` - The resource type to log data events to log. Required if `category` is `DATA`. Valid values are one of the following:
      - `AWS::S3::Object`
      - `AWS::Lambda::Function`
      - `AWS::DynamoDB::Table`
      - `AWS::S3Outposts::Object`
      - `AWS::ManagedBlockchain::Node`
      - `AWS::S3ObjectLambda::AccessPoint`
      - `AWS::EC2::Snapshot`
      - `AWS::S3::AccessPoint`
      - `AWS::CloudTrail::Channe`l
      - `AWS::DynamoDB::Stream`
      - `AWS::Glue::Table`
      - `AWS::FinSpace::Environmen`t
      - `AWS::SageMaker::ExperimentTrialComponen`t
      - `AWS::SageMaker::FeatureGrou`p
    (Optional) `selectors` - A configuration of field selectors to filter events by the ARN of resource and the event name. Each item of `selectors` as defined below.
      (Required) `field` - A field to compare by the field selector. Valid values are `event_name` and `resource_arn`.
      (Required) `operator` - An operator of the field selector. Valid values are `equals`, `not_equals`, `starts_with`, `not_starts_with`, `ends_with`, `not_ends_with`.
      (Required) `values` - A set of values of the field selector to compare.
  EOF
  type = list(object({
    category        = string
    scope           = optional(string, "ALL")
    exclude_sources = optional(set(string), [])
    resource_type   = optional(string)
    selectors = optional(list(object({
      field    = string
      operator = string
      values   = set(string)
    })), [])
  }))
  default = [{
    category = "MANAGEMENT"
  }]
  nullable = false

  validation {
    condition = alltrue([
      for event in var.event_selectors :
      contains(["DATA", "MANAGEMENT"], event.category)
    ])
    error_message = "Valid values for `category` are `DATA`, `MANAGEMENT`."
  }

  validation {
    condition = alltrue([
      for event in var.event_selectors :
      contains(["ALL", "READ", "WRITE"], event.scope)
    ])
    error_message = "Valid values for `scope` are `ALL`, `READ`, `WRITE`."
  }

  validation {
    condition = alltrue([
      for event in var.event_selectors :
      alltrue([
        for source in event.exclude_sources :
        contains(["kms.amazonaws.com", "rdsdata.amazonaws.com"], source)
      ])
      if event.category == "MANAGEMENT"
    ])
    error_message = "Valid values for `exclude_sources` should be defined if `category` is `DATA`."
  }

  validation {
    condition = alltrue([
      for event in var.event_selectors :
      event.resource_type != null
      if event.category == "DATA"
    ])
    error_message = "`resource_type` should be defined if `category` is `DATA`."
  }

  validation {
    condition = alltrue([
      for event in var.event_selectors :
      alltrue([
        for selector in event.selectors :
        contains(["event_name", "resource_arn"], selector.field)
      ])
      if event.category == "DATA"
    ])
    error_message = "Valid values for `field` of each selector are `event_name`, `resource_arn`."
  }

  validation {
    condition = alltrue([
      for event in var.event_selectors :
      alltrue([
        for selector in event.selectors :
        contains(["equals", "not_equals", "starts_with", "not_starts_with", "ends_with", "not_ends_with"], selector.operator)
      ])
      if event.category == "DATA"
    ])
    error_message = "Valid values for `operator` of each selector are `equals`, `not_equals`, `starts_with`, `not_starts_with`, `ends_with`, `not_ends_with`."
  }
}

variable "encryption_kms_key" {
  description = "(Optional) Specify the KMS key ID to use to encrypt the events delivered by CloudTrail. The value can be an alias name prefixed by 'alias/', a fully specified ARN to an alias, a fully specified ARN to a key, or a globally unique identifier. By default, the event data store is encrypted with a KMS key that AWS owns and manages."
  type        = string
  default     = null
}

variable "retention_in_days" {
  description = "(Optional) The retention period of the event data store, in days. You can set a retention period of up to 2557 days. Defaults to `2555` days (7 years)."
  type        = number
  default     = 2555
  nullable    = false

  validation {
    condition = alltrue([
      var.retention_in_days <= 2557,
      var.retention_in_days >= 7,
    ])
    error_message = "The scope should be one of `REGIONAL`, `ALL`."
  }
}

variable "termination_protection_enabled" {
  description = "(Optional) Whether termination protection is enabled for the event data store. If termination protection is enabled, you cannot delete the event data store until termination protection is disabled. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "import_trail_events_iam_role" {
  description = <<EOF
  (Optional) A configuration of IAM Role for importing CloudTrail events from S3 Bucket. `import_trail_events_iam_role` as defined below.
    (Optional) `enabled` - Indicates whether you want to create IAM Role to import trail events. Defaults to `true`.
    (Optional) `source_s3_buckets` - A list of source S3 buckets to import events from. Each item of `source_s3_buckets` as defined below.
      (Required) `name` - A name of source S3 bucket.
      (Optional) `key_prefix` - A key prefix of source S3 bucket.
  EOF
  type = object({
    enabled = optional(bool, true)
    source_s3_buckets = optional(list(object({
      name       = string
      key_prefix = optional(string, "/")
    })), [])
  })
  default  = {}
  nullable = false
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
