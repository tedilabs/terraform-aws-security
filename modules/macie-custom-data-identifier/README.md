# macie-custom-data-identifier

This module creates following resources.

- `aws_macie2_custom_data_identifier`

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
| [aws_macie2_custom_data_identifier.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/macie2_custom_data_identifier) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) A name for the custom data identifier. The name can contain as many as 128 characters. | `string` | n/a | yes |
| <a name="input_regex"></a> [regex](#input\_regex) | (Required) The regular expression (regex) that defines the pattern to match. The expression can contain as many as 512 characters. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | (Optional) A description of the custom data identifier. Defaults to `Managed by Terraform.`. | `string` | `"Managed by Terraform."` | no |
| <a name="input_ignore_words"></a> [ignore\_words](#input\_ignore\_words) | (Optional) An array that lists specific character sequences (ignore words) to exclude from the results. If the text matched by the regular expression is the same as any string in this array, Amazon Macie ignores it. The array can contain as many as 10 ignore words. Each ignore word can contain 4 - 90 characters. Ignore words are case sensitive. | `set(string)` | `[]` | no |
| <a name="input_keywords"></a> [keywords](#input\_keywords) | (Optional) An array that lists specific character sequences (keywords), one of which must be within proximity (maximum\_match\_distance) of the regular expression to match. The array can contain as many as 50 keywords. Each keyword can contain 3 - 90 characters. Keywords aren't case sensitive. | `set(string)` | `[]` | no |
| <a name="input_maximum_match_distance"></a> [maximum\_match\_distance](#input\_maximum\_match\_distance) | (Optional) The maximum allowable distance between text that matches the regex pattern and the keywords. The distance can be 1 - 300 characters. Defaults to `50`. | `number` | `50` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region. | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.<br/>    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.<br/>    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.<br/>    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`. | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string, "")<br/>    description = optional(string, "Managed by Terraform.")<br/>  })</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN (Amazon Resource Name) for the macie custom data identifier. For example: `arn:aws:cloudfront::123456789012:distribution/EDFDVBD632BHDS5`. |
| <a name="output_created_at"></a> [created\_at](#output\_created\_at) | The date and time, in UTC and extended RFC 3339 format, when the Amazon Macie custom data identifier was created. |
| <a name="output_description"></a> [description](#output\_description) | The description of the macie custom data identifier. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the macie custom data identifier. |
| <a name="output_ignore_words"></a> [ignore\_words](#output\_ignore\_words) | An array that lists specific character sequences (ignore words) to exclude from the results. |
| <a name="output_keywords"></a> [keywords](#output\_keywords) | An array that lists specific character sequences (keywords), one of which must be within proximity (maximum\_match\_distance) of the regular expression to match. |
| <a name="output_maximum_match_distance"></a> [maximum\_match\_distance](#output\_maximum\_match\_distance) | The maximum number of characters that can exist between text that matches the regex pattern and the character sequences specified by the keywords array. |
| <a name="output_name"></a> [name](#output\_name) | The name of the macie custom data identifier. |
| <a name="output_regex"></a> [regex](#output\_regex) | The regular expression (regex) that defines the pattern to match. |
| <a name="output_region"></a> [region](#output\_region) | The AWS region this module resources resides in. |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | The resource group created to manage resources in this module. |
<!-- END_TF_DOCS -->
