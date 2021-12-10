# config-recorder

This module creates following resources.

- `aws_config_configuration_recorder`
- `aws_config_configuration_recorder_status`
- `aws_config_delivery_channel`
- `aws_config_aggregate_authorization` (optional)
- `aws_config_configuration_aggregator` (optional)
- `aws_iam_role`
- `aws_iam_role_policy`
- `aws_iam_role_policy_attachment`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.65 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.69.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_role__aggregator"></a> [role\_\_aggregator](#module\_role\_\_aggregator) | tedilabs/account/aws//modules/iam-role | 0.18.3 |
| <a name="module_role__recorder"></a> [role\_\_recorder](#module\_role\_\_recorder) | tedilabs/account/aws//modules/iam-role | 0.18.3 |

## Resources

| Name | Type |
|------|------|
| [aws_config_aggregate_authorization.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_aggregate_authorization) | resource |
| [aws_config_configuration_aggregator.account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_aggregator) | resource |
| [aws_config_configuration_aggregator.organization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_aggregator) | resource |
| [aws_config_configuration_recorder.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder) | resource |
| [aws_config_configuration_recorder_status.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder_status) | resource |
| [aws_config_delivery_channel.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_delivery_channel) | resource |
| [aws_resourcegroups_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_group) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.aggregation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.delivery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_delivery_s3_bucket"></a> [delivery\_s3\_bucket](#input\_delivery\_s3\_bucket) | The name of the S3 bucket used to store the configuration history. | `string` | n/a | yes |
| <a name="input_account_aggregations"></a> [account\_aggregations](#input\_account\_aggregations) | A list of configurations to aggregate config data from individual accounts. Supported properties for each configuration are `name`, `account_ids` and `regions`. Aggregate from all supported regions if `regions` is missing. | `list(any)` | `[]` | no |
| <a name="input_authorized_aggregators"></a> [authorized\_aggregators](#input\_authorized\_aggregators) | A list of Authorized aggregators to allow an aggregator account and region to collect AWS Config configuration and compliance data. | <pre>list(object({<br>    account_id = string<br>    region     = string<br>  }))</pre> | `[]` | no |
| <a name="input_custom_resource_types"></a> [custom\_resource\_types](#input\_custom\_resource\_types) | A list that specifies the types of AWS resources for which AWS Config records configuration changes. For example, `AWS::EC2::Instance` or `AWS::CloudTrail::Trail`. Only need when `scope` is confirued with value `CUSTOM`. | `list(string)` | `[]` | no |
| <a name="input_delivery_frequency"></a> [delivery\_frequency](#input\_delivery\_frequency) | The frequency with which AWS Config recurringly delivers configuration snapshots. Valid values are `1h`, `3h`, `6h`, `12h`, or `24h`. | `string` | `null` | no |
| <a name="input_delivery_s3_key_prefix"></a> [delivery\_s3\_key\_prefix](#input\_delivery\_s3\_key\_prefix) | The key prefix for the specified S3 bucket. | `string` | `null` | no |
| <a name="input_delivery_s3_sse_kms_key"></a> [delivery\_s3\_sse\_kms\_key](#input\_delivery\_s3\_sse\_kms\_key) | The ARN of the AWS KMS key used to encrypt objects delivered by AWS Config. Must belong to the same Region as the destination S3 bucket. | `string` | `null` | no |
| <a name="input_delivery_sns_topic"></a> [delivery\_sns\_topic](#input\_delivery\_sns\_topic) | The ARN of the SNS topic that AWS Config delivers notifications to. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether the configuration recorder should be enabled or disabled. | `bool` | `true` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the recorder. Defaults to `default`. Changing it recreates the resource. | `string` | `"default"` | no |
| <a name="input_organization_aggregation"></a> [organization\_aggregation](#input\_organization\_aggregation) | The configuration to aggregate config data from organization accounts. Supported properties are `enabled` and `regions`. Aggregate from all supported regions if `regions` is missing. | `any` | `{}` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | Specifies the scope of AWS Config configuration recorder. Supported values are `REGIONAL_WITH_GLOBAL`, `REGIONAL`, or `CUSTOM`. | `string` | `"REGIONAL"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_aggregations"></a> [account\_aggregations](#output\_account\_aggregations) | A list of configurations to aggregate config data from individual accounts. |
| <a name="output_authorized_aggregators"></a> [authorized\_aggregators](#output\_authorized\_aggregators) | A list of Authorized aggregators allowed to collect AWS Config configuration and compliance data. |
| <a name="output_custom_resource_types"></a> [custom\_resource\_types](#output\_custom\_resource\_types) | A list that specifies the types of AWS resources for which AWS Config records configuration changes. |
| <a name="output_delivery_channels"></a> [delivery\_channels](#output\_delivery\_channels) | Delivery channels of the recorder. |
| <a name="output_enabled"></a> [enabled](#output\_enabled) | Whether the configuration recorder is enabled. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the recorder. |
| <a name="output_name"></a> [name](#output\_name) | The name of the recorder. |
| <a name="output_organization_aggregation"></a> [organization\_aggregation](#output\_organization\_aggregation) | The configuration to aggregate config data from organization accounts. |
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | The Amazon Resource Name (ARN) of the IAM role. |
| <a name="output_scope"></a> [scope](#output\_scope) | The scope of the recorder. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
