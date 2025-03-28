# access-analyzer

This module creates following resources.

- `aws_accessanalyzer_analyzer`
- `aws_accessanalyzer_archive_rule` (optional)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.34 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.46.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.10.0 |

## Resources

| Name | Type |
|------|------|
| [aws_accessanalyzer_analyzer.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/accessanalyzer_analyzer) | resource |
| [aws_accessanalyzer_archive_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/accessanalyzer_archive_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the Analyzer. | `string` | n/a | yes |
| <a name="input_archive_rules"></a> [archive\_rules](#input\_archive\_rules) | (Optional) A list of archive rules for the AccessAnalyzer Analyzer. Each item of `archive_rules` block as defined below.<br>    (Required) `name` - The name of archive rule.<br>    (Required) `filters` - A list of filter criterias for the archive rule. Each item of `filters` block as defined below.<br>      (Required) `criteria` - The filter criteria.<br>      (Optional) `contains` - Contains comparator.<br>      (Optional) `exists` - Exists comparator (Boolean).<br>      (Optional) `eq` - Equal comparator.<br>      (Optional) `neq` - Not Equal comparator. | `any` | `[]` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | (Optional) A scope of Analyzer. Valid values are `ACCOUNT` or `ORGANIZATION`. Defaults to `ACCOUNT`. | `string` | `"ACCOUNT"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | (Optional) A finding type of Analyzer. Valid values are `EXTERNAL_ACCESS` or `UNUSED_ACCESS`. Defaults to `EXTERNAL_ACCESS`. | `string` | `"EXTERNAL_ACCESS"` | no |
| <a name="input_unused_access_tracking_period"></a> [unused\_access\_tracking\_period](#input\_unused\_access\_tracking\_period) | (Optional) A number of days for the tracking the period. Findings will be generated for access that hasn't been used in more than the specified number of days. Defaults to `90`. | `number` | `90` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_archive_rules"></a> [archive\_rules](#output\_archive\_rules) | A list of archive rules for the Analyzer. |
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of this Analyzer. |
| <a name="output_id"></a> [id](#output\_id) | The ID of this Analyzer. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Analyzer. |
| <a name="output_scope"></a> [scope](#output\_scope) | The scope of Analyzer. |
| <a name="output_type"></a> [type](#output\_type) | The finding type of Analyzer. |
| <a name="output_unused_access_tracking_period"></a> [unused\_access\_tracking\_period](#output\_unused\_access\_tracking\_period) | The scope of Analyzer. |
<!-- END_TF_DOCS -->
