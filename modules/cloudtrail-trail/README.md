# cloudtrail-trail

This module creates following resources.

- `aws_cloudtrail`
- `aws_iam_role` (optional)
- `aws_iam_role_policy` (optional)
- `aws_iam_role_policy_attachment` (optional)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.19.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.10.0 |
| <a name="module_role"></a> [role](#module\_role) | tedilabs/account/aws//modules/iam-role | ~> 0.23.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_organizations_organization.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_partition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_delivery_s3_bucket"></a> [delivery\_s3\_bucket](#input\_delivery\_s3\_bucket) | (Required) The name of the S3 bucket designated for publishing log files. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the trail. The name can only contain uppercase letters, lowercase letters, numbers, periods (.), hyphens (-), and underscores (\_). | `string` | n/a | yes |
| <a name="input_delivery_cloudwatch_logs_log_group"></a> [delivery\_cloudwatch\_logs\_log\_group](#input\_delivery\_cloudwatch\_logs\_log\_group) | (Optional) The name of the log group of CloudWatch Logs for log file delivery. | `string` | `null` | no |
| <a name="input_delivery_s3_integrity_validation_enabled"></a> [delivery\_s3\_integrity\_validation\_enabled](#input\_delivery\_s3\_integrity\_validation\_enabled) | (Optional) To determine whether a log file was modified, deleted, or unchanged after AWS CloudTrail delivered it, use CloudTrail log file integrity validation. This feature is built using industry standard algorithms: SHA-256 for hashing and SHA-256 with RSA for digital signing. | `bool` | `true` | no |
| <a name="input_delivery_s3_key_prefix"></a> [delivery\_s3\_key\_prefix](#input\_delivery\_s3\_key\_prefix) | (Optional) The key prefix for the specified S3 bucket. | `string` | `null` | no |
| <a name="input_delivery_sns_topic"></a> [delivery\_sns\_topic](#input\_delivery\_sns\_topic) | (Optional) The name of the SNS topic for notification of log file delivery. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | (Optional) Whether the trail starts the recording of AWS API calls and log file delivery. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_insight_event"></a> [insight\_event](#input\_insight\_event) | (Optional) A configuration block for insight events logging to identify unusual operational activity. `insight_event` block as defined below.<br>    (Required) `enabled` - Whether the trail to log insight events.<br>    (Optional) `scopes` - A set of insight types to log on the trail. Valid values are `API_CALL_RATE` and `API_ERROR_RATE`. | <pre>object({<br>    enabled = optional(bool, false)<br>    scopes  = optional(set(string), [])<br>  })</pre> | `{}` | no |
| <a name="input_level"></a> [level](#input\_level) | (Optional) The level of the trail to decide whether the trail is an AWS Organizations trail. Organization trails log events for the master account and all member accounts. Can only be created in the organization master account. Valid values are `ACCOUNT` and `ORGANIZATION`. Use `ORGANIZATION` level in Organization master account. Defaults to `ACCOUNT`. | `string` | `"ACCOUNT"` | no |
| <a name="input_management_event"></a> [management\_event](#input\_management\_event) | (Optional) A configuration block for management events logging to identify API activity for individual resources, or for all current and future resources in AWS account. `management_event` block as defined below.<br>    (Required) `enabled` - Whether the trail to log management events.<br>    (Optional) `scope` - The type of events to log. Valid values are `ALL`, `READ` and `WRITE`. Defaults to `ALL`.<br>    (Optional) `exclude_event_sources` - A set of event sources to exclude. Valid values are `kms.amazonaws.com` and `rdsdata.amazonaws.com`. `management_event.enabled` must be set to true to allow this. | <pre>object({<br>    enabled               = bool<br>    scope                 = string<br>    exclude_event_sources = list(string)<br>  })</pre> | <pre>{<br>  "enabled": true,<br>  "exclude_event_sources": [],<br>  "scope": "ALL"<br>}</pre> | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | (Optional) The scope of the trail to decide whether the trail is multi-region trail. Supported values are `REGIONAL_WITH_GLOBAL`, `REGIONAL` or `ALL`. Defaults to `REGIONAL_WITH_GLOBAL`. | `string` | `"REGIONAL_WITH_GLOBAL"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of the trail. |
| <a name="output_delivery_channels"></a> [delivery\_channels](#output\_delivery\_channels) | Delivery channels of the trail. |
| <a name="output_enabled"></a> [enabled](#output\_enabled) | Whether the trail is enabled. |
| <a name="output_home_region"></a> [home\_region](#output\_home\_region) | The region in which the trail was created. |
| <a name="output_iam_role"></a> [iam\_role](#output\_iam\_role) | The IAM Role for the CloudTrail trail. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the trail. |
| <a name="output_insight_event"></a> [insight\_event](#output\_insight\_event) | A configuration for insight events logging of the trail. |
| <a name="output_level"></a> [level](#output\_level) | The level of the trail to decide whether the trail is an AWS Organizations trail. |
| <a name="output_management_event"></a> [management\_event](#output\_management\_event) | A configuration for management events logging of the trail. |
| <a name="output_name"></a> [name](#output\_name) | The name of the trail. |
| <a name="output_scope"></a> [scope](#output\_scope) | The scope of the trail to decide whether the trail is multi-region trail. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
