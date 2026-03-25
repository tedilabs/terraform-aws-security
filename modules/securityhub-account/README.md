# securityhub-account

This module creates following resources.

- `aws_securityhub_account`
- `aws_securityhub_finding_aggregator` (optional)
- `aws_securityhub_member` (optional)
- `aws_securityhub_organization_configuration` (optional)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.37 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.13.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.12.0 |

## Resources

| Name | Type |
|------|------|
| [aws_securityhub_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_account) | resource |
| [aws_securityhub_finding_aggregator.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_finding_aggregator) | resource |
| [aws_securityhub_member.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_member) | resource |
| [aws_securityhub_organization_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/securityhub_organization_configuration) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_enable_controls"></a> [auto\_enable\_controls](#input\_auto\_enable\_controls) | (Optional) Whether to automatically enable new controls when they are added to security standards that are enabled. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_control_finding"></a> [control\_finding](#input\_control\_finding) | (Optional) A configuration for control finding of the SecurityHub account. `control_finding` as defined below.<br/>    (Optional) `consolidation_enabled` - Whether to enable control finding consolidation for the account. If `true`, Security Hub generates a single finding for a control check even when the check applies to multiple enabled standards. Defaults to `true`."<br/>    (Optional) `aggregator` - A configuration for finding aggregator of the account. `aggregator` as defined below.<br/>      (Optional) `enabled` - Whether to enable finding aggregator for the account. Defaults to `false`. If `true`, a finding aggregator will be created to aggregate findings from other regions.<br/>      (Optional) `mode` - A linking mode for the finding aggregator. This decide which regions the finding aggregator will aggregate findings from. Valid values are `ALL_REGIONS`, `ALL_REGIONS_EXCEPT_SPECIFIED`, `SPECIFIED_REGIONS`, or `NO_REGIONS`. The selected `mode` also determines how to use `regions` provided. Defaults to `ALL_REGIONS`.<br/>        `ALL_REGIONS` - Aggregates findings from all of the Regions where Security Hub CSPM is enabled. When you choose this option, Security Hub CSPM also automatically aggregates findings from new Regions as Security Hub CSPM supports them and you opt into them.<br/>        `ALL_REGIONS_EXCEPT_SPECIFIED` - Aggregates findings from all of the Regions where Security Hub CSPM is enabled, except for the Regions listed in the Regions parameter. When you choose this option, Security Hub CSPM also automatically aggregates findings from new Regions as Security Hub CSPM supports them and you opt into them.<br/>        `SPECIFIED_REGIONS` - Aggregates findings only from the Regions listed in the Regions parameter. Security Hub CSPM does not automatically aggregate findings from new Regions.<br/>        `NO_REGIONS` - Aggregates no data because no Regions are selected as linked Regions.<br/>        (Optional) `regions` - The Regions to be aggregated. This is required when `mode` is `ALL_REGIONS_EXCEPT_SPECIFIED` or `SPECIFIED_REGIONS`. When `mode` is `ALL_REGIONS_EXCEPT_SPECIFIED`, the finding aggregator will aggregate findings from all enabled Regions except for the Regions listed here. When `mode` is `SPECIFIED_REGIONS`, the finding aggregator will only aggregate findings from the Regions listed here. | <pre>object({<br/>    consolidation_enabled = optional(bool, true)<br/>    aggregator = optional(object({<br/>      enabled = optional(bool, false)<br/>      mode    = optional(string, "ALL_REGIONS")<br/>      regions = optional(set(string), [])<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_member_accounts"></a> [member\_accounts](#input\_member\_accounts) | (Optional) A list of configurations for member accounts on the SecurityHub account. Each block of `member_accounts` as defined below.<br/>    (Required) `account_id` - The AWS account ID for the account.<br/>    (Optional) `type` - The type of the member account. Valid values are `ORGANIZATION` or `INVITATION`. Defaults to `ORGANIZATION`. | <pre>list(object({<br/>    account_id = string<br/>    type       = optional(string, "ORGANIZATION")<br/>  }))</pre> | `[]` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_organization_config"></a> [organization\_config](#input\_organization\_config) | (Optional) The organization configurations for the SecurityHub account. `organization_config` as defined below.<br/>    (Optional) `mode` - The organization configuration mode. Valid values are `CENTRAL` or `LOCAL`. Defaults to `CENTRAL`.<br/>       `CENTRAL` - the delegated administrator can create configuration policies. Configuration policies can be used to configure Security Hub CSPM, security standards, and security controls in multiple accounts and Regions. If you want new organization accounts to use a specific configuration, you can create a configuration policy and associate it with the root or specific organizational units (OUs). New accounts will inherit the policy from the root or their assigned OU.<br/>       `LOCAL` - the delegated administrator can set `auto_enable` to `true` and `auto_enable_default_standards` to `true`. This automatically enables Security Hub CSPM and default security standards in new organization accounts. These new account settings must be set separately in each AWS Region, and settings may be different in each Region.<br/>    (Optional) `auto_enable` - Whether to automatically enable SecurityHub for new accounts in the organization. Defaults to `true`.<br/>    (Optional) `auto_enable_default_standards` - Whether to automatically enable default security standards for new accounts in the organization. Defaults to `true`. This is only applicable when `mode` is `LOCAL`. | <pre>object({<br/>    mode                          = optional(string, "CENTRAL")<br/>    auto_enable                   = optional(bool, true)<br/>    auto_enable_default_standards = optional(bool, true)<br/>  })</pre> | `{}` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region. | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.<br/>    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.<br/>    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.<br/>    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`. | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string, "")<br/>    description = optional(string, "Managed by Terraform.")<br/>  })</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of this SecurityHub account. |
| <a name="output_auto_enable_controls"></a> [auto\_enable\_controls](#output\_auto\_enable\_controls) | Whether to automatically enable new controls when they are added to security standards that are enabled. |
| <a name="output_control_finding"></a> [control\_finding](#output\_control\_finding) | The configuration for control finding of the SecurityHub account.<br/>    `consolidation_enabled` - Whether to enable control finding consolidation for the account. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the SecurityHub account. |
| <a name="output_member_accounts"></a> [member\_accounts](#output\_member\_accounts) | The list of configruations for member accounts on the SecurityHub account. |
| <a name="output_name"></a> [name](#output\_name) | The account ID of the SecurityHub account. |
| <a name="output_organization_config"></a> [organization\_config](#output\_organization\_config) | The organization configurations for the SecurityHub account.<br/>    `mode` - The organization configuration mode. Valid values are `CENTRAL` or `LOCAL`.<br/>    `auto_enable` - Whether to automatically enable SecurityHub for new accounts in the organization. |
| <a name="output_region"></a> [region](#output\_region) | The AWS region this module resources resides in. |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | The resource group created to manage resources in this module. |
<!-- END_TF_DOCS -->
