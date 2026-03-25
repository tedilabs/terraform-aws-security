variable "region" {
  description = "(Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region."
  type        = string
  default     = null
  nullable    = true
}

variable "member_accounts" {
  description = <<EOF
  (Optional) A list of configurations for member accounts on the SecurityHub account. Each block of `member_accounts` as defined below.
    (Required) `account_id` - The AWS account ID for the account.
    (Optional) `type` - The type of the member account. Valid values are `ORGANIZATION` or `INVITATION`. Defaults to `ORGANIZATION`.
  EOF
  type = list(object({
    account_id = string
    type       = optional(string, "ORGANIZATION")
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

variable "organization_config" {
  description = <<EOF
  (Optional) The organization configurations for the SecurityHub account. `organization_config` as defined below.
    (Optional) `mode` - The organization configuration mode. Valid values are `CENTRAL` or `LOCAL`. Defaults to `CENTRAL`.
       `CENTRAL` - the delegated administrator can create configuration policies. Configuration policies can be used to configure Security Hub CSPM, security standards, and security controls in multiple accounts and Regions. If you want new organization accounts to use a specific configuration, you can create a configuration policy and associate it with the root or specific organizational units (OUs). New accounts will inherit the policy from the root or their assigned OU.
       `LOCAL` - the delegated administrator can set `auto_enable` to `true` and `auto_enable_default_standards` to `true`. This automatically enables Security Hub CSPM and default security standards in new organization accounts. These new account settings must be set separately in each AWS Region, and settings may be different in each Region.
    (Optional) `auto_enable` - Whether to automatically enable SecurityHub for new accounts in the organization. Defaults to `true`.
    (Optional) `auto_enable_default_standards` - Whether to automatically enable default security standards for new accounts in the organization. Defaults to `true`. This is only applicable when `mode` is `LOCAL`.
  EOF
  type = object({
    mode                          = optional(string, "CENTRAL")
    auto_enable                   = optional(bool, true)
    auto_enable_default_standards = optional(bool, true)
  })
  default  = {}
  nullable = false

  validation {
    condition = contains(["CENTRAL", "LOCAL"], var.organization_config.mode)

    error_message = "Valid values for `organization_config.mode` are `CENTRAL` or `LOCAL`."
  }
}

variable "auto_enable_controls" {
  description = "(Optional) Whether to automatically enable new controls when they are added to security standards that are enabled. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "control_finding" {
  description = <<EOF
  (Optional) A configuration for control finding of the SecurityHub account. `control_finding` as defined below.
    (Optional) `consolidation_enabled` - Whether to enable control finding consolidation for the account. If `true`, Security Hub generates a single finding for a control check even when the check applies to multiple enabled standards. Defaults to `true`."
    (Optional) `aggregator` - A configuration for finding aggregator of the account. `aggregator` as defined below.
      (Optional) `enabled` - Whether to enable finding aggregator for the account. Defaults to `false`. If `true`, a finding aggregator will be created to aggregate findings from other regions.
      (Optional) `mode` - A linking mode for the finding aggregator. This decide which regions the finding aggregator will aggregate findings from. Valid values are `ALL_REGIONS`, `ALL_REGIONS_EXCEPT_SPECIFIED`, `SPECIFIED_REGIONS`, or `NO_REGIONS`. The selected `mode` also determines how to use `regions` provided. Defaults to `ALL_REGIONS`.
        `ALL_REGIONS` - Aggregates findings from all of the Regions where Security Hub CSPM is enabled. When you choose this option, Security Hub CSPM also automatically aggregates findings from new Regions as Security Hub CSPM supports them and you opt into them.
        `ALL_REGIONS_EXCEPT_SPECIFIED` - Aggregates findings from all of the Regions where Security Hub CSPM is enabled, except for the Regions listed in the Regions parameter. When you choose this option, Security Hub CSPM also automatically aggregates findings from new Regions as Security Hub CSPM supports them and you opt into them.
        `SPECIFIED_REGIONS` - Aggregates findings only from the Regions listed in the Regions parameter. Security Hub CSPM does not automatically aggregate findings from new Regions.
        `NO_REGIONS` - Aggregates no data because no Regions are selected as linked Regions.
        (Optional) `regions` - The Regions to be aggregated. This is required when `mode` is `ALL_REGIONS_EXCEPT_SPECIFIED` or `SPECIFIED_REGIONS`. When `mode` is `ALL_REGIONS_EXCEPT_SPECIFIED`, the finding aggregator will aggregate findings from all enabled Regions except for the Regions listed here. When `mode` is `SPECIFIED_REGIONS`, the finding aggregator will only aggregate findings from the Regions listed here.
  EOF
  type = object({
    consolidation_enabled = optional(bool, true)
    aggregator = optional(object({
      enabled = optional(bool, false)
      mode    = optional(string, "ALL_REGIONS")
      regions = optional(set(string), [])
    }), {})
  })
  default  = {}
  nullable = false

  validation {
    condition = contains(["ALL_REGIONS", "ALL_REGIONS_EXCEPT_SPECIFIED", "SPECIFIED_REGIONS", "NO_REGIONS"], var.control_finding.aggregator.mode)

    error_message = "Valid values for `control_finding.aggregator.mode` are `ALL_REGIONS`, `ALL_REGIONS_EXCEPT_SPECIFIED`, `SPECIFIED_REGIONS`, or `NO_REGIONS`."
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
