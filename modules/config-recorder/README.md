# config-recorder

This module creates following resources.

- `aws_config_configuration_recorder`
- `aws_config_configuration_recorder_status`
- `aws_config_delivery_channel`
- `aws_config_aggregate_authorization` (optional)
- `aws_config_configuration_aggregator` (optional)
- `aws_config_retention_configuration`
- `aws_iam_role`
- `aws_iam_role_policy`
- `aws_iam_role_policy_attachment`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.39 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.48.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.10.0 |
| <a name="module_role__aggregator"></a> [role\_\_aggregator](#module\_role\_\_aggregator) | tedilabs/account/aws//modules/iam-role | ~> 0.28.0 |
| <a name="module_role__recorder"></a> [role\_\_recorder](#module\_role\_\_recorder) | tedilabs/account/aws//modules/iam-role | ~> 0.28.0 |

## Resources

| Name | Type |
|------|------|
| [aws_config_aggregate_authorization.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_aggregate_authorization) | resource |
| [aws_config_configuration_aggregator.account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_aggregator) | resource |
| [aws_config_configuration_aggregator.organization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_aggregator) | resource |
| [aws_config_configuration_recorder.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder) | resource |
| [aws_config_configuration_recorder_status.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_configuration_recorder_status) | resource |
| [aws_config_delivery_channel.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_delivery_channel) | resource |
| [aws_config_retention_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/config_retention_configuration) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.aggregation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.delivery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_delivery_channels"></a> [delivery\_channels](#input\_delivery\_channels) | (Required) A configuration for the delivery channels of the configuration recorder. `delivery_channels` as defined below.<br>    (Required) `s3_bucket` - A configuration for the S3 Bucket delivery channel. `s3_bucket` as defined below.<br>      (Required) `name` - The name of the S3 bucket used to store the configuration history.<br>      (Optional) `key_prefix` - The key prefix for the specified S3 bucket.<br>      (Optional) `sse_kms_key` - The ARN of the AWS KMS key used to encrypt objects delivered by AWS Config. Must belong to the same Region as the destination S3 bucket.<br>    (Optional) `sns_topic` - A configuration for the SNS Topic delivery channel. `sns_topic` as defined below.<br>      (Optional) `enabled` - Whether to enable the SNS Topic delivery channel. Defaults to `false`.<br>      (Optional) `arn` - The ARN of the SNS topic that AWS Config delivers notifications to. | <pre>object({<br>    s3_bucket = object({<br>      name        = string<br>      key_prefix  = optional(string)<br>      sse_kms_key = optional(string)<br>    })<br>    sns_topic = optional(object({<br>      enabled = optional(bool, false)<br>      arn     = optional(string)<br>    }), {})<br>  })</pre> | n/a | yes |
| <a name="input_account_aggregations"></a> [account\_aggregations](#input\_account\_aggregations) | (Optional) A list of configurations to aggregate config data from individual accounts. Each item of `account_aggregations` as defined below.<br>    (Required) `name` - The name of the account aggregation.<br>    (Required) `accounts` - A list of account IDs to be aggregated.<br>    (Optional) `regions` - A list of regions to aggregate data. Aggregate from all supported regions if `regions` is missing.<br>    (Optional) `tags` - A map of tags to add to the account aggregation resource. | <pre>list(object({<br>    name     = string<br>    accounts = set(string)<br>    regions  = optional(set(string), [])<br>    tags     = optional(map(string), {})<br>  }))</pre> | `[]` | no |
| <a name="input_authorized_aggregators"></a> [authorized\_aggregators](#input\_authorized\_aggregators) | (Optional) A list of Authorized aggregators to allow an aggregator account and region to collect AWS Config configuration and compliance data. Each item of `authorized_aggregators` as defined below.<br>    (Required) `account` - The account ID of the account authorized to aggregate data.<br>    (Required) `region` - The region authorized to collect aggregated data.<br>    (Optional) `tags` - A map of tags to add to authorized aggregator resource. | <pre>list(object({<br>    account = string<br>    region  = string<br>    tags    = optional(map(string), {})<br>  }))</pre> | `[]` | no |
| <a name="input_default_organization_aggregator_role"></a> [default\_organization\_aggregator\_role](#input\_default\_organization\_aggregator\_role) | (Optional) A configuration for the default service role to use for organization aggregator in Config. Use `organization_aggregator_role` if `default_organization_aggregator_role.enabled` is `false`. `default_organization_aggregator_role` as defined below.<br>    (Optional) `enabled` - Whether to create the default organization aggregator role. Defaults to `true`.<br>    (Optional) `name` - The name of the default organization aggregator role. Defaults to `config-configuration-aggregator-${var.name}`.<br>    (Optional) `path` - The path of the default organization aggregator role. Defaults to `/`.<br>    (Optional) `description` - The description of the default organization aggregator role.<br>    (Optional) `policies` - A list of IAM policy ARNs to attach to the default organization aggregator role. `AWSConfigRoleForOrganizations` is always attached. Defaults to `[]`.<br>    (Optional) `inline_policies` - A Map of inline IAM policies to attach to the default organization aggregator role. (`name` => `policy`). | <pre>object({<br>    enabled     = optional(bool, true)<br>    name        = optional(string)<br>    path        = optional(string, "/")<br>    description = optional(string, "Managed by Terraform.")<br><br>    policies        = optional(list(string), [])<br>    inline_policies = optional(map(string), {})<br>  })</pre> | `{}` | no |
| <a name="input_default_service_role"></a> [default\_service\_role](#input\_default\_service\_role) | (Optional) A configuration for the default service role to use for Config recorder. Use `service_role` if `default_service_role.enabled` is `false`. `default_service_role` as defined below.<br>    (Optional) `enabled` - Whether to create the default service role. Defaults to `true`.<br>    (Optional) `name` - The name of the default service role. Defaults to `config-configuration-recorder-${var.name}`.<br>    (Optional) `path` - The path of the default service role. Defaults to `/`.<br>    (Optional) `description` - The description of the default service role.<br>    (Optional) `policies` - A list of IAM policy ARNs to attach to the default service role. `AWS_ConfigRole` is always attached. Defaults to `[]`.<br>    (Optional) `inline_policies` - A Map of inline IAM policies to attach to the default service role. (`name` => `policy`). | <pre>object({<br>    enabled     = optional(bool, true)<br>    name        = optional(string)<br>    path        = optional(string, "/")<br>    description = optional(string, "Managed by Terraform.")<br><br>    policies        = optional(list(string), [])<br>    inline_policies = optional(map(string), {})<br>  })</pre> | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | (Optional) Whether the configuration recorder should be enabled or disabled. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | (Optional) The name of the recorder. Defaults to `default`. Changing it recreates the resource. | `string` | `"default"` | no |
| <a name="input_organization_aggregation"></a> [organization\_aggregation](#input\_organization\_aggregation) | (Optional) A configuration to aggregate config data from organization accounts. `organization_aggregations` as defined below.<br>    (Optional) `enabled` - Whether to enable the organization aggregation. Defaults to `false`.<br>    (Optional) `name` - The name of the organization aggregation. Defaults to `organization`.<br>    (Optional) `regions` - A list of regions to aggregate data. Aggregate from all supported regions if `regions` is missing.<br>    (Optional) `tags` - A map of tags to add to the organization aggregation resource. | <pre>object({<br>    enabled = optional(bool, false)<br>    name    = optional(string, "organization")<br>    regions = optional(set(string), [])<br>    tags    = optional(map(string), {})<br>  })</pre> | `{}` | no |
| <a name="input_organization_aggregator_role"></a> [organization\_aggregator\_role](#input\_organization\_aggregator\_role) | (Optional) The ARN (Amazon Resource Name) of the IAM Role that provides permissions for the organization aggregator in Config. Only required if `default_organization_aggregator_role.enabled` is `false`. | `string` | `null` | no |
| <a name="input_recording_frequency"></a> [recording\_frequency](#input\_recording\_frequency) | (Optional) A configuration for the recording frequency mode of AWS Config configuration recorder. `recording_frequency` as defined below.<br>    (Optional) `mode` - The recording frequency mode for the recorder. Valid values are `CONTINUOUS`, `DAILIY`. Defaults to `CONTINUOUS`.<br><br>      `CONTINUOUS`: Continuous recording allows you to record configuration changes continuously whenever a change occurs.<br>      `DAILY`: Daily recording allows you to receive a configuration item (CI) representing the most recent state of your resources over the last 24-hour period, only if it's different from the previous CI recorded.<br>    (Optional) `overrides` - A configurations to override the recording frequency for specific resource types. Each block of `overrides` as defined below.<br>      (Required) `resource_types` - A set of resource types to override the recording frequency mode. For example, `AWS::EC2::Instance` or `AWS::CloudTrail::Trail`.<br>      (Required) `mode` - The recording frequency mode to override to all the resource types specified in the `resource_types`. Valid values are `CONTINUOUS`, `DAILIY`.<br>      (Optional) `description` - The description of the override. Defaults to `Managed by Terraform.` | <pre>object({<br>    mode = optional(string, "CONTINUOUS")<br>    overrides = optional(list(object({<br>      resource_types = set(string)<br>      mode           = string<br>      description    = optional(string, "Managed by Terraform.")<br>    })), [])<br>  })</pre> | `{}` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_retention_period"></a> [retention\_period](#input\_retention\_period) | (Optional) The number of days AWS Config stores historical information. Valid range is between a minimum period of 30 days and a maximum period of 7 years (2557 days).Defaults to `2557` (7 years). | `number` | `2557` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | (Optional) A configuration for the scope of AWS Config configuration recorder. `scope` as defined below.<br>    (Optional) `strategy` - The recording strategy for the configuration recorder. Valid values are `ALL_WITHOUT_GLOBAL`, `ALL`, `WHITELIST`, `BLACKLIST`. Defaults to `ALL_WITHOUT_GLOBAL`.<br>    (Optional) `resource_types` - A list of resource types to include/exclude for recording. For example, `AWS::EC2::Instance` or `AWS::CloudTrail::Trail`. Only need when `strategy` is confirued with value `WHITELIST` or `BLACKLIST`. | <pre>object({<br>    strategy       = optional(string, "ALL_WITHOUT_GLOBAL")<br>    resource_types = optional(set(string), [])<br>  })</pre> | `{}` | no |
| <a name="input_service_role"></a> [service\_role](#input\_service\_role) | (Optional) The ARN (Amazon Resource Name) of the IAM Role that provides permissions for the Config Recorder. Only required if `default_service_role.enabled` is `false`. | `string` | `null` | no |
| <a name="input_snapshot_delivery"></a> [snapshot\_delivery](#input\_snapshot\_delivery) | (Optional) A configuration for the configuration snapshot delivery of the recorder. `snapshot_delivery` as defined below.<br>    (Optional) `enabled` - Whether to enable the configuration snapshot delivery. Defaults to `false`.<br>    (Optional) `frequency` - The frequency with which AWS Config recurringly delivers configuration snapshots. Valid values are `1h`, `3h`, `6h`, `12h`, or `24h`. | <pre>object({<br>    enabled   = optional(bool, false)<br>    frequency = optional(string, "24h")<br>  })</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_aggregations"></a> [account\_aggregations](#output\_account\_aggregations) | A list of configurations to aggregate config data from individual accounts. |
| <a name="output_authorized_aggregators"></a> [authorized\_aggregators](#output\_authorized\_aggregators) | A list of Authorized aggregators allowed to collect AWS Config configuration and compliance data. |
| <a name="output_delivery_channels"></a> [delivery\_channels](#output\_delivery\_channels) | The configuration of delivery channels of the recorder.<br>    `s3_bucket` - The configuration for the S3 Bucket delivery channel.<br>    `sns_topic` - The configuration for the SNS Topic delivery channel. |
| <a name="output_enabled"></a> [enabled](#output\_enabled) | Whether the configuration recorder is enabled. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the recorder. |
| <a name="output_name"></a> [name](#output\_name) | The name of the recorder. |
| <a name="output_organization_aggregation"></a> [organization\_aggregation](#output\_organization\_aggregation) | The configuration to aggregate config data from organization accounts. |
| <a name="output_recording_frequency"></a> [recording\_frequency](#output\_recording\_frequency) | The configuration for the recording frequency mode of the recorder.<br>    `mode` - The recording frequency mode for the recorder.<br>    `overrides` - The configurations to override the recording frequency for specific resource types. |
| <a name="output_retention_period"></a> [retention\_period](#output\_retention\_period) | The number of days AWS Config stores historical information |
| <a name="output_scope"></a> [scope](#output\_scope) | A list that specifies the types of AWS resources for which AWS Config records configuration changes.<br>    `strategy` - The recording strategy for the configuration recorder.<br>    `resource_types` - A list of resource types to include/exclude for recording. |
| <a name="output_service_role"></a> [service\_role](#output\_service\_role) | The Amazon Resource Name (ARN) of the IAM role for the recorder. |
| <a name="output_snapshot_delivery"></a> [snapshot\_delivery](#output\_snapshot\_delivery) | The configuration for the configuration snapshot delivery of the recorder.<br>    `enabled` - Whether the configuration snapshot delivery is enabled.<br>    `frequency` - The frequency with which AWS Config recurringly delivers configuration snapshots. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
