# config-managed-rule

This module creates following resources.

- `aws_config_config_rule` (optional)
- `aws_config_organization_managed_rule` (optional)

## Notes

- https://console.aws.amazon.com/config/service/managedRuleTemplate?region=ap-northeast-2


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.23 |

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
| [aws_config_config_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_config_rule) | resource |
| [aws_config_organization_managed_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_organization_managed_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_source_rule"></a> [source\_rule](#input\_source\_rule) | (Required) The identifier for AWS Config managed rule. Use the format like `root-account-mfa-enabled` instead of predefiend format like `ROOT_ACCOUNT_MFA_ENABLED`. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | (Optional) The description of the rule. Use default description if not provided. | `string` | `null` | no |
| <a name="input_evaluation_modes"></a> [evaluation\_modes](#input\_evaluation\_modes) | (Optional) A set of evaluation modes to enable for the Config rule. Valid values are `DETECTIVE`, `PROACTIVE`. Default value contains only `DETECTIVE`. | `set(string)` | <pre>[<br>  "DETECTIVE"<br>]</pre> | no |
| <a name="input_excluded_accounts"></a> [excluded\_accounts](#input\_excluded\_accounts) | (Optional) A list of AWS account identifiers to exclude from the rule. Only need when `level` is configured with value `ORGANIZATION`. | `list(string)` | `[]` | no |
| <a name="input_level"></a> [level](#input\_level) | (Optional) Choose to create a rule across all accounts in your Organization. Valid values are `ACCOUNT` and `ORGANIZATION`. Use `ORGANIZATION` level in Organization master account or delegated administrator accounts. | `string` | `"ACCOUNT"` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | (Optional) The name of the rule. Use default rule name if not provided. | `string` | `null` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | (Optional) A map of parameters that is passed to the AWS Config rule Lambda function. | `any` | `{}` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_resource_id"></a> [resource\_id](#input\_resource\_id) | (Optional) The ID of the only AWS resource that you want to trigger an evaluation for the rule. If you specify this, you must specify only one resource type for `resource_types`. Only need when `scope` is configured with value `RESOURCES`. | `string` | `null` | no |
| <a name="input_resource_tag"></a> [resource\_tag](#input\_resource\_tag) | (Optional) The tag that are applied to only those AWS resources that you want you want to trigger an evaluation for the rule. You can configure with only `key` or a set of `key` and `value`. Only need when `scope` is configured with value `TAGS`. | `map(string)` | `{}` | no |
| <a name="input_resource_types"></a> [resource\_types](#input\_resource\_types) | (Optional) A list of resource types of only those AWS resources that you want to trigger an evaluation for the rule. For example, `AWS::EC2::Instance` or `AWS::CloudTrail::Trail`. Only need when `scope` is configured with value `RESOURCES`. | `list(string)` | `[]` | no |
| <a name="input_schedule_frequency"></a> [schedule\_frequency](#input\_schedule\_frequency) | (Optional) The frequency with which AWS Config runs evaluations for a rule. Use default value if not provided. Valid values are `1h`, `3h`, `6h`, `12h`, or `24h`. | `string` | `null` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | (Optional) Choose when evaluations will occur. Valid values are `ALL_CHANGES`, `RESOURCES`, or `TAGS`. | `string` | `"RESOURCES"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of the rule. |
| <a name="output_description"></a> [description](#output\_description) | The description of the rule. |
| <a name="output_evaluation_modes"></a> [evaluation\_modes](#output\_evaluation\_modes) | A set of evaluation modes to enable for the Config rule. |
| <a name="output_excluded_accounts"></a> [excluded\_accounts](#output\_excluded\_accounts) | A list of AWS account identifiers excluded from the rule. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the rule. |
| <a name="output_level"></a> [level](#output\_level) | The level of the rule. `ACOUNT` or `ORGANIZATION`. The rule is for accounts in your Organization if the value is configured with `ORGANIZATION`. |
| <a name="output_name"></a> [name](#output\_name) | The name of the rule. |
| <a name="output_parameters"></a> [parameters](#output\_parameters) | The parameters of the rule. |
| <a name="output_source_rule"></a> [source\_rule](#output\_source\_rule) | The information of the managed rule used. |
| <a name="output_trigger_by_change"></a> [trigger\_by\_change](#output\_trigger\_by\_change) | The information of trigger by configuration changes. |
| <a name="output_trigger_by_schedule"></a> [trigger\_by\_schedule](#output\_trigger\_by\_schedule) | The information of trigger by schedule. |
<!-- END_TF_DOCS -->
