variable "name" {
  description = "The name of the recorder. Defaults to `default`. Changing it recreates the resource."
  type        = string
  default     = "default"
}

variable "enabled" {
  description = "Whether the configuration recorder should be enabled or disabled."
  type        = bool
  default     = true
}

variable "scope" {
  description = "Specifies the scope of AWS Config configuration recorder. Supported values are `REGIONAL_WITH_GLOBAL`, `REGIONAL`, or `CUSTOM`."
  type        = string
  default     = "REGIONAL"
}

variable "custom_resource_types" {
  description = "A list that specifies the types of AWS resources for which AWS Config records configuration changes. For example, `AWS::EC2::Instance` or `AWS::CloudTrail::Trail`. Only need when `scope` is confirued with value `CUSTOM`."
  type        = list(string)
  default     = []
}

variable "delivery_s3_bucket" {
  description = "The name of the S3 bucket used to store the configuration history."
  type        = string
}

variable "delivery_s3_key_prefix" {
  description = "The key prefix for the specified S3 bucket."
  type        = string
  default     = null
}

variable "delivery_s3_sse_kms_key" {
  description = "The ARN of the AWS KMS key used to encrypt objects delivered by AWS Config. Must belong to the same Region as the destination S3 bucket."
  type        = string
  default     = null
}

variable "delivery_sns_topic" {
  description = "The ARN of the SNS topic that AWS Config delivers notifications to."
  type        = string
  default     = null
}

variable "delivery_frequency" {
  description = "The frequency with which AWS Config recurringly delivers configuration snapshots. Valid values are `1h`, `3h`, `6h`, `12h`, or `24h`."
  type        = string
  default     = null
}

variable "authorized_aggregators" {
  description = "A list of Authorized aggregators to allow an aggregator account and region to collect AWS Config configuration and compliance data."
  type = list(object({
    account_id = string
    region     = string
  }))
  default = []
}

variable "account_aggregations" {
  description = "A list of configurations to aggregate config data from individual accounts. Supported properties for each configuration are `name`, `account_ids` and `regions`. Aggregate from all supported regions if `regions` is missing."
  type        = list(any)
  default     = []
}

variable "organization_aggregation" {
  description = "The configuration to aggregate config data from organization accounts. Supported properties are `enabled` and `regions`. Aggregate from all supported regions if `regions` is missing."
  type        = any
  default     = {}
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
