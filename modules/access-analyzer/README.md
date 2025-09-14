# access-analyzer

This module creates following resources.

- `aws_accessanalyzer_analyzer`
- `aws_accessanalyzer_archive_rule` (optional)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.12 |

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
| [aws_accessanalyzer_analyzer.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/accessanalyzer_analyzer) | resource |
| [aws_accessanalyzer_archive_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/accessanalyzer_archive_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the Analyzer. | `string` | n/a | yes |
| <a name="input_archive_rules"></a> [archive\_rules](#input\_archive\_rules) | (Optional) A list of archive rules for the AccessAnalyzer Analyzer. Each item of `archive_rules` block as defined below.<br/>    (Required) `name` - The name of archive rule.<br/>    (Required) `filters` - A list of filter criterias for the archive rule. Each item of `filters` block as defined below.<br/>      (Required) `criteria` - The filter criteria.<br/>      (Optional) `contains` - Contains comparator.<br/>      (Optional) `exists` - Exists comparator (Boolean).<br/>      (Optional) `eq` - Equal comparator.<br/>      (Optional) `neq` - Not Equal comparator. | <pre>list(object({<br/>    name = string<br/>    filters = list(object({<br/>      criteria = string<br/>      contains = optional(list(string))<br/>      exists   = optional(bool)<br/>      eq       = optional(list(string))<br/>      neq      = optional(list(string))<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_internal_access_analysis"></a> [internal\_access\_analysis](#input\_internal\_access\_analysis) | (Optional) A configurations for the `INTERNAL_ACCESS` type Analyzer. `internal_access_analysis` as defined below.<br/>    (Optional) `rules` - A list of rules for internal access analyzer. Each item of `rules` block as defined below.<br/>      (Required) `inclusion` - An inclusion rule to filter findings. `inclusion` as defined below.<br/>        (Optional) `accounts` - A set of account IDs to include in the analysis. Account IDs can only be applied to the analysis rule criteria for organization-level analyzers.<br/>        (Optional) `resource_arns` - A set of resource ARNs to include in the analysis. The analyzer will only generate findings for resources that match these ARNs.<br/>        (Optional) `resource_types` - A set of resource types to include in the analysis. The analyzer will only generate findings for resources of these types | <pre>object({<br/>    rules = optional(list(object({<br/>      inclusion = object({<br/>        accounts       = optional(set(string), [])<br/>        resource_arns  = optional(set(string), [])<br/>        resource_types = optional(set(string), [])<br/>      })<br/>    })), [])<br/>  })</pre> | `{}` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region. | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.<br/>    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.<br/>    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.<br/>    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`. | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string, "")<br/>    description = optional(string, "Managed by Terraform.")<br/>  })</pre> | `{}` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | (Optional) A scope of Analyzer. Valid values are `ACCOUNT` or `ORGANIZATION`. Defaults to `ACCOUNT`. | `string` | `"ACCOUNT"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | (Optional) A finding type of Analyzer. Valid values are `EXTERNAL_ACCESS`, `INTERNAL_ACCESS` or `UNUSED_ACCESS`. Defaults to `EXTERNAL_ACCESS`. | `string` | `"EXTERNAL_ACCESS"` | no |
| <a name="input_unused_access_analysis"></a> [unused\_access\_analysis](#input\_unused\_access\_analysis) | (Optional) A configurations for the `UNUSED_ACCESS` type Analyzer. `unused_access_analysis` as defined below.<br/>    (Optional) `tracking_period` - A number of days for the tracking the period. Findings will be generated for access that hasn't been used in more than the specified number of days. Defaults to `90`.<br/>    (Optional) `rules` - A list of rules for unused access analyzer. Each item of `rules` block as defined below.<br/>      (Required) `exclusion` - An exclusion rule to filter findings. `exclusion` as defined below.<br/>        (Optional) `accounts` - A set of account IDs to exclude from the analysis. Account IDs can only be applied to the analysis rule criteria for organization-level analyzers.<br/>        (Optional) `resource_tags` - A list of tag key and value pairs to exclude from the analysis. | <pre>object({<br/>    tracking_period = optional(number, 90)<br/>    rules = optional(list(object({<br/>      exclusion = object({<br/>        accounts      = optional(set(string), [])<br/>        resource_tags = optional(list(map(string)), [])<br/>      })<br/>    })), [])<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_archive_rules"></a> [archive\_rules](#output\_archive\_rules) | A list of archive rules for the Analyzer. |
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of this Analyzer. |
| <a name="output_id"></a> [id](#output\_id) | The ID of this Analyzer. |
| <a name="output_internal_access_analysis"></a> [internal\_access\_analysis](#output\_internal\_access\_analysis) | The configurations for the `INTERNAL_ACCESS` type Analyzer. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Analyzer. |
| <a name="output_region"></a> [region](#output\_region) | The AWS region this module resources resides in. |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | The resource group created to manage resources in this module. |
| <a name="output_scope"></a> [scope](#output\_scope) | The scope of Analyzer. |
| <a name="output_type"></a> [type](#output\_type) | The finding type of Analyzer. |
| <a name="output_unused_access_analysis"></a> [unused\_access\_analysis](#output\_unused\_access\_analysis) | The configurations for the `UNUSED_ACCESS` type Analyzer. |
<!-- END_TF_DOCS -->
