# macie-account

This module creates following resources.

- `aws_macie2_account`
- `aws_macie2_member` (optional)
- `aws_macie2_classification_export_configuration` (optional)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.48.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.10.0 |

## Resources

| Name | Type |
|------|------|
| [aws_macie2_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/macie2_account) | resource |
| [aws_macie2_classification_export_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/macie2_classification_export_configuration) | resource |
| [aws_macie2_member.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/macie2_member) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_discovery_result_repository"></a> [discovery\_result\_repository](#input\_discovery\_result\_repository) | (Optional) The configuration for discovery result location and encryption of the macie account. A `discovery_result_repository` block as defined below.<br>    (Optional) `s3_bucket` - A configuration for the S3 bucket in which Amazon Macie exports the data discovery results. `s3_bucket` as defined below.<br>      (Required) `name` - The name of the S3 bucket in which Amazon Macie exports the data classification results.<br>      (Optional) `key_prefix` - The key prefix for the specified S3 bucket.<br>      (Required) `sse_kms_key` - The ARN of the AWS KMS key to be used to encrypt the data. | <pre>object({<br>    s3_bucket = optional(object({<br>      name        = string<br>      key_prefix  = optional(string, "")<br>      sse_kms_key = string<br>    }))<br>  })</pre> | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | (Optional) Whether to enable Amazon Macie and start all Macie activities for the account. Defaults to `true`. Set `false` to suspend Macie, it stops monitoring your AWS environment and does not generate new findings. The existing findings remain intact and are not affected. Delete `aws_macie2_account` resource to disable Macie, it permanently deletes all of your existing findings, classification jobs, and other Macie resources. | `bool` | `true` | no |
| <a name="input_member_accounts"></a> [member\_accounts](#input\_member\_accounts) | (Optional) A list of configurations for member accounts on the macie account. Each block of `member_accounts` as defined below.<br>    (Required) `account_id` - The AWS account ID for the account.<br>    (Required) `email` -  The email address for the account.<br>    (Optional) `enabled` - Whether to enable Amazon Macie and start all Macie activities for the member account. Defaults to `true`.<br>    (Optional) `tags` - A map of key-value pairs that specifies the tags to associate with the account in Amazon Macie. | <pre>list(object({<br>    account_id = string<br>    email      = string<br>    enabled    = optional(bool, true)<br>    tags       = optional(map(string), {})<br>  }))</pre> | `[]` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_update_frequency"></a> [update\_frequency](#input\_update\_frequency) | (Optional) How often to publish updates to policy findings for the account. This includes publishing updates to AWS Security Hub and Amazon EventBridge (formerly called Amazon CloudWatch Events). Valid values are `15m`, `1h` or `6h`. Defaults to `15m`. | `string` | `"15m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_created_at"></a> [created\_at](#output\_created\_at) | The date and time, in UTC and extended RFC 3339 format, when the Amazon Macie account was created. |
| <a name="output_discovery_result_repository"></a> [discovery\_result\_repository](#output\_discovery\_result\_repository) | The configuration for discovery result location and encryption of the macie account. |
| <a name="output_enabled"></a> [enabled](#output\_enabled) | Whether the macie account is eanbled. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the macie account. |
| <a name="output_member_accounts"></a> [member\_accounts](#output\_member\_accounts) | The list of configruations for member accounts on the macie account. |
| <a name="output_name"></a> [name](#output\_name) | The account ID of the macie account. |
| <a name="output_service_role"></a> [service\_role](#output\_service\_role) | The Amazon Resource Name (ARN) of the service-linked role that allows Macie to monitor and analyze data in AWS resources for the account. |
| <a name="output_update_frequency"></a> [update\_frequency](#output\_update\_frequency) | How often to publish updates to policy findings for the macie account. |
| <a name="output_updated_at"></a> [updated\_at](#output\_updated\_at) | The date and time, in UTC and extended RFC 3339 format, of the most recent change to the status of the Macie account. |
<!-- END_TF_DOCS -->
