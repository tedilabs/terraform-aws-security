variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "enabled" {
  description = "(Optional) Whether to enable Amazon Macie and start all Macie activities for the account. Defaults to `true`. Set `false` to suspend Macie, it stops monitoring your AWS environment and does not generate new findings. The existing findings remain intact and are not affected. Delete `aws_macie2_account` resource to disable Macie, it permanently deletes all of your existing findings, classification jobs, and other Macie resources."
  type        = bool
  default     = true
  nullable    = false
}

variable "update_frequency" {
  description = "(Optional) How often to publish updates to policy findings for the account. This includes publishing updates to AWS Security Hub and Amazon EventBridge (formerly called Amazon CloudWatch Events). Valid values are `15m`, `1h` or `6h`. Defaults to `15m`."
  type        = string
  default     = "15m"
  nullable    = false

  validation {
    condition     = contains(["15m", "1h", "6h"], var.update_frequency)
    error_message = "Valid values for `update_frequency` are `15m`, `1h` or `6h`."
  }
}

variable "member_accounts" {
  description = <<EOF
  (Optional) A list of configurations for member accounts on the macie account. Each block of `member_accounts` as defined below.
    (Required) `account_id` - The AWS account ID for the account.
    (Required) `email` -  The email address for the account.
    (Optional) `type` - The type of the member account. Valid values are `ORGANIZATION` or `INVITATION`. Defaults to `ORGANIZATION`.
    (Optional) `enabled` - Whether to enable Amazon Macie and start all Macie activities for the member account. Defaults to `true`.
    (Optional) `tags` - A map of key-value pairs that specifies the tags to associate with the account in Amazon Macie.
    (Optional) `invitation` - A configuration for invitation to the member account. `invitation` as defined below.
      (Optional) `message` - A custom message to include in the invitation to the account.
      (Optional) `email_notification_enabled` - Whether to send an email notification to the account when you invite it to become a member of your Macie account. This notification is in addition to an alert that the root user receives in AWS Personal Health Dashboard. Defaults to `false`.
  EOF
  type = list(object({
    account_id = string
    email      = string
    type       = optional(string, "ORGANIZATION")
    enabled    = optional(bool, true)
    tags       = optional(map(string), {})
    invitation = optional(object({
      message                    = optional(string, "")
      email_notification_enabled = optional(bool, false)
    }), {})
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for member in var.member_accounts :
      contains(["ORGANIZATION", "INVITATION"], member.type)
    ])

    error_message = "Valid values for `type` in `member_accounts` are `ORGANIZATION` or `INVITATION`."
  }
}

variable "discovery_result_repository" {
  description = <<EOF
  (Optional) The configuration for discovery result location and encryption of the macie account. A `discovery_result_repository` block as defined below.
    (Optional) `s3_bucket` - A configuration for the S3 bucket in which Amazon Macie exports the data discovery results. `s3_bucket` as defined below.
      (Required) `name` - The name of the S3 bucket in which Amazon Macie exports the data classification results.
      (Optional) `key_prefix` - The key prefix for the specified S3 bucket.
      (Required) `sse_kms_key` - The ARN of the AWS KMS key to be used to encrypt the data.
  EOF
  type = object({
    s3_bucket = optional(object({
      name        = string
      key_prefix  = optional(string, "")
      sse_kms_key = string
    }))
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
