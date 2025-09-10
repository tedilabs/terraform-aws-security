variable "name" {
  description = "(Optional) The name of the recorder. Defaults to `default`. Changing it recreates the resource."
  type        = string
  default     = "default"
  nullable    = false
}

variable "enabled" {
  description = "(Optional) Whether the configuration recorder should be enabled or disabled. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "retention_period" {
  description = "(Optional) The number of days AWS Config stores historical information. Valid range is between a minimum period of 30 days and a maximum period of 7 years (2557 days).Defaults to `2557` (7 years)."
  type        = number
  default     = 2557
  nullable    = false

  validation {
    condition = alltrue([
      var.retention_period >= 30,
      var.retention_period <= 2557,
    ])
    error_message = "Valid range for `retention_period` is between 30 and 2557 days."
  }
}

variable "default_service_role" {
  description = <<EOF
  (Optional) A configuration for the default service role to use for Config recorder. Use `service_role` if `default_service_role.enabled` is `false`. `default_service_role` as defined below.
    (Optional) `enabled` - Whether to create the default service role. Defaults to `true`.
    (Optional) `name` - The name of the default service role. Defaults to `config-configuration-recorder-$${var.name}`.
    (Optional) `path` - The path of the default service role. Defaults to `/`.
    (Optional) `description` - The description of the default service role.
    (Optional) `policies` - A list of IAM policy ARNs to attach to the default service role. `AWS_ConfigRole` is always attached. Defaults to `[]`.
    (Optional) `inline_policies` - A Map of inline IAM policies to attach to the default service role. (`name` => `policy`).
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string)
    path        = optional(string, "/")
    description = optional(string, "Managed by Terraform.")

    policies        = optional(list(string), [])
    inline_policies = optional(map(string), {})
  })
  default  = {}
  nullable = false
}

variable "service_role" {
  description = <<EOF
  (Optional) The ARN (Amazon Resource Name) of the IAM Role that provides permissions for the Config Recorder. Only required if `default_service_role.enabled` is `false`.
  EOF
  type        = string
  default     = null
  nullable    = true
}

variable "default_organization_aggregator_role" {
  description = <<EOF
  (Optional) A configuration for the default service role to use for organization aggregator in Config. Use `organization_aggregator_role` if `default_organization_aggregator_role.enabled` is `false`. `default_organization_aggregator_role` as defined below.
    (Optional) `enabled` - Whether to create the default organization aggregator role. Defaults to `true`.
    (Optional) `name` - The name of the default organization aggregator role. Defaults to `config-configuration-aggregator-$${var.name}`.
    (Optional) `path` - The path of the default organization aggregator role. Defaults to `/`.
    (Optional) `description` - The description of the default organization aggregator role.
    (Optional) `policies` - A list of IAM policy ARNs to attach to the default organization aggregator role. `AWSConfigRoleForOrganizations` is always attached. Defaults to `[]`.
    (Optional) `inline_policies` - A Map of inline IAM policies to attach to the default organization aggregator role. (`name` => `policy`).
  EOF
  type = object({
    enabled     = optional(bool, true)
    name        = optional(string)
    path        = optional(string, "/")
    description = optional(string, "Managed by Terraform.")

    policies        = optional(list(string), [])
    inline_policies = optional(map(string), {})
  })
  default  = {}
  nullable = false
}

variable "organization_aggregator_role" {
  description = <<EOF
  (Optional) The ARN (Amazon Resource Name) of the IAM Role that provides permissions for the organization aggregator in Config. Only required if `default_organization_aggregator_role.enabled` is `false`.
  EOF
  type        = string
  default     = null
  nullable    = true
}

variable "recording_frequency" {
  description = <<EOF
  (Optional) A configuration for the recording frequency mode of AWS Config configuration recorder. `recording_frequency` as defined below.
    (Optional) `mode` - The recording frequency mode for the recorder. Valid values are `CONTINUOUS`, `DAILIY`. Defaults to `CONTINUOUS`.

      `CONTINUOUS`: Continuous recording allows you to record configuration changes continuously whenever a change occurs.
      `DAILY`: Daily recording allows you to receive a configuration item (CI) representing the most recent state of your resources over the last 24-hour period, only if it's different from the previous CI recorded.
    (Optional) `overrides` - A configurations to override the recording frequency for specific resource types. Each block of `overrides` as defined below.
      (Required) `resource_types` - A set of resource types to override the recording frequency mode. For example, `AWS::EC2::Instance` or `AWS::CloudTrail::Trail`.
      (Required) `mode` - The recording frequency mode to override to all the resource types specified in the `resource_types`. Valid values are `CONTINUOUS`, `DAILIY`.
      (Optional) `description` - The description of the override. Defaults to `Managed by Terraform.`
  EOF
  type = object({
    mode = optional(string, "CONTINUOUS")
    overrides = optional(list(object({
      resource_types = set(string)
      mode           = string
      description    = optional(string, "Managed by Terraform.")
    })), [])
  })
  default  = {}
  nullable = false

  validation {
    condition     = contains(["CONTINUOUS", "DAILY"], var.recording_frequency.mode)
    error_message = "Valid values for `mode` are `CONTINUOUS`, `DAILY`."
  }
  validation {
    condition = alltrue([
      for override in var.recording_frequency.overrides :
      contains(["CONTINUOUS", "DAILY"], override.mode)
    ])
    error_message = "Valid values for `mode` are `CONTINUOUS`, `DAILY`."
  }
}

variable "scope" {
  description = <<EOF
  (Optional) A configuration for the scope of AWS Config configuration recorder. `scope` as defined below.
    (Optional) `strategy` - The recording strategy for the configuration recorder. Valid values are `ALL_WITHOUT_GLOBAL`, `ALL`, `WHITELIST`, `BLACKLIST`. Defaults to `ALL_WITHOUT_GLOBAL`.
    (Optional) `resource_types` - A list of resource types to include/exclude for recording. For example, `AWS::EC2::Instance` or `AWS::CloudTrail::Trail`. Only need when `strategy` is confirued with value `WHITELIST` or `BLACKLIST`.
  EOF
  type = object({
    strategy       = optional(string, "ALL_WITHOUT_GLOBAL")
    resource_types = optional(set(string), [])
  })
  default  = {}
  nullable = false

  validation {
    condition     = contains(["ALL_WITHOUT_GLOBAL", "ALL", "WHITELIST", "BLACKLIST"], var.scope.strategy)
    error_message = "Valid values for `scope.strategy` are `ALL_WITHOUT_GLOBAL`, `ALL`, `WHITELIST`, `BLACKLIST`."
  }
}

variable "snapshot_delivery" {
  description = <<EOF
  (Optional) A configuration for the configuration snapshot delivery of the recorder. `snapshot_delivery` as defined below.
    (Optional) `enabled` - Whether to enable the configuration snapshot delivery. Defaults to `false`.
    (Optional) `frequency` - The frequency with which AWS Config recurringly delivers configuration snapshots. Valid values are `1h`, `3h`, `6h`, `12h`, or `24h`.
  EOF
  type = object({
    enabled   = optional(bool, false)
    frequency = optional(string, "24h")
  })
  default  = {}
  nullable = false

  validation {
    condition     = contains(["1h", "3h", "6h", "12h", "24h"], var.snapshot_delivery.frequency)
    error_message = "Valid values for `snapshot_delivery.frequency` are `1h`, `3h`, `6h`, `12h`, `24h`."
  }
}

variable "delivery_channels" {
  description = <<EOF
  (Required) A configuration for the delivery channels of the configuration recorder. `delivery_channels` as defined below.
    (Required) `s3_bucket` - A configuration for the S3 Bucket delivery channel. `s3_bucket` as defined below.
      (Required) `name` - The name of the S3 bucket used to store the configuration history.
      (Optional) `key_prefix` - The key prefix for the specified S3 bucket.
      (Optional) `sse_kms_key` - The ARN of the AWS KMS key used to encrypt objects delivered by AWS Config. Must belong to the same Region as the destination S3 bucket.
    (Optional) `sns_topic` - A configuration for the SNS Topic delivery channel. `sns_topic` as defined below.
      (Optional) `enabled` - Whether to enable the SNS Topic delivery channel. Defaults to `false`.
      (Optional) `arn` - The ARN of the SNS topic that AWS Config delivers notifications to.
  EOF
  type = object({
    s3_bucket = object({
      name        = string
      key_prefix  = optional(string)
      sse_kms_key = optional(string)
    })
    sns_topic = optional(object({
      enabled = optional(bool, false)
      arn     = optional(string)
    }), {})
  })
  nullable = false

  validation {
    condition = anytrue([
      !var.delivery_channels.sns_topic.enabled,
      var.delivery_channels.sns_topic.enabled && var.delivery_channels.sns_topic.arn != null,
    ])
    error_message = "`delivery_channels.sns_topic.arn` must be provided when `delivery_channels.sns_topic.enabled` is `true`."
  }
}

variable "authorized_aggregators" {
  description = <<EOF
  (Optional) A list of Authorized aggregators to allow an aggregator account and region to collect AWS Config configuration and compliance data. Each item of `authorized_aggregators` as defined below.
    (Required) `account` - The account ID of the account authorized to aggregate data.
    (Required) `region` - The region authorized to collect aggregated data.
    (Optional) `tags` - A map of tags to add to authorized aggregator resource.
  EOF
  type = list(object({
    account = string
    region  = string
    tags    = optional(map(string), {})
  }))
  default  = []
  nullable = false
}

variable "account_aggregations" {
  description = <<EOF
  (Optional) A list of configurations to aggregate config data from individual accounts. Each item of `account_aggregations` as defined below.
    (Required) `name` - The name of the account aggregation.
    (Required) `accounts` - A list of account IDs to be aggregated.
    (Optional) `regions` - A list of regions to aggregate data. Aggregate from all supported regions if `regions` is missing.
    (Optional) `tags` - A map of tags to add to the account aggregation resource.
  EOF
  type = list(object({
    name     = string
    accounts = set(string)
    regions  = optional(set(string), [])
    tags     = optional(map(string), {})
  }))
  default  = []
  nullable = false
}

variable "organization_aggregation" {
  description = <<EOF
  (Optional) A configuration to aggregate config data from organization accounts. `organization_aggregations` as defined below.
    (Optional) `enabled` - Whether to enable the organization aggregation. Defaults to `false`.
    (Optional) `name` - The name of the organization aggregation. Defaults to `organization`.
    (Optional) `regions` - A list of regions to aggregate data. Aggregate from all supported regions if `regions` is missing.
    (Optional) `tags` - A map of tags to add to the organization aggregation resource.
  EOF
  type = object({
    enabled = optional(bool, false)
    name    = optional(string, "organization")
    regions = optional(set(string), [])
    tags    = optional(map(string), {})
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
