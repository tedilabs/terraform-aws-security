# cloudtrail-event-data-store

This module creates following resources.

- `aws_cloudtrail_event_data_store`
- `aws_iam_role` (optional)
- `aws_iam_role_policy` (optional)
- `aws_iam_role_policy_attachment` (optional)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.53 |

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
| [aws_cloudtrail_event_data_store.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail_event_data_store) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the event data store. | `string` | n/a | yes |
| <a name="input_encryption_kms_key"></a> [encryption\_kms\_key](#input\_encryption\_kms\_key) | (Optional) Specify the KMS key ID to use to encrypt the events delivered by CloudTrail. The value can be an alias name prefixed by 'alias/', a fully specified ARN to an alias, a fully specified ARN to a key, or a globally unique identifier. By default, the event data store is encrypted with a KMS key that AWS owns and manages. | `string` | `null` | no |
| <a name="input_event_selectors"></a> [event\_selectors](#input\_event\_selectors) | (Optional) A configuration of event selectors to use to select the events for the event data store. Only used if `event_type` is `CLOUDTRAIL_EVENTS`. Each item of `event_selectors` as defined below.<br>    (Required) `category` - A category of the event. Valid values are `DATA` and `MANAGEMENT`.<br>      - `DATA`: Log the resource operations performed on or within a resource.<br>      - `MANAGEMENT`: Capture management operations performed on your AWS resources.<br>    (Optional) `scope` - A scope of events to log. Valid values are `ALL`, `READ` and `WRITE`. Defaults to `ALL`.<br>    (Optional) `exclude_sources` - A set of event sources to exclude. Valid values are `kms.amazonaws.com` and `rdsdata.amazonaws.com`. Only used if `category` is `MANAGEMENT`.<br>    (Optional) `resource_type` - The resource type to log data events to log. Required if `category` is `DATA`. Valid values are one of the following:<br>      - `AWS::S3::Object`<br>      - `AWS::Lambda::Function`<br>      - `AWS::DynamoDB::Table`<br>      - `AWS::S3Outposts::Object`<br>      - `AWS::ManagedBlockchain::Node`<br>      - `AWS::S3ObjectLambda::AccessPoint`<br>      - `AWS::EC2::Snapshot`<br>      - `AWS::S3::AccessPoint`<br>      - `AWS::CloudTrail::Channe`l<br>      - `AWS::DynamoDB::Stream`<br>      - `AWS::Glue::Table`<br>      - `AWS::FinSpace::Environmen`t<br>      - `AWS::SageMaker::ExperimentTrialComponen`t<br>      - `AWS::SageMaker::FeatureGrou`p<br>    (Optional) `selectors` - A configuration of field selectors to filter events by the ARN of resource and the event name. Each item of `selectors` as defined below.<br>      (Required) `field` - A field to compare by the field selector. Valid values are `event_name` and `resource_arn`.<br>      (Required) `operator` - An operator of the field selector. Valid values are `equals`, `not_equals`, `starts_with`, `not_starts_with`, `ends_with`, `not_ends_with`.<br>      (Required) `values` - A set of values of the field selector to compare. | <pre>list(object({<br>    category        = string<br>    scope           = optional(string, "ALL")<br>    exclude_sources = optional(set(string), [])<br>    resource_type   = optional(string)<br>    selectors = optional(list(object({<br>      field    = string<br>      operator = string<br>      values   = set(string)<br>    })), [])<br>  }))</pre> | <pre>[<br>  {<br>    "category": "MANAGEMENT"<br>  }<br>]</pre> | no |
| <a name="input_event_type"></a> [event\_type](#input\_event\_type) | (Required) A type of event to be collected by the event data store. Valid values are `CLOUDTRAIL_EVENTS`, `CONFIG_CONFIGURATION_ITEMS`. Defaults to `CLOUDTRAIL_EVENTS`. | `string` | `"CLOUDTRAIL_EVENTS"` | no |
| <a name="input_import_trail_events_iam_role"></a> [import\_trail\_events\_iam\_role](#input\_import\_trail\_events\_iam\_role) | (Optional) A configuration of IAM Role for importing CloudTrail events from S3 Bucket. `import_trail_events_iam_role` as defined below.<br>    (Optional) `enabled` - Indicates whether you want to create IAM Role to import trail events. Defaults to `true`.<br>    (Optional) `source_s3_buckets` - A list of source S3 buckets to import events from. Each item of `source_s3_buckets` as defined below.<br>      (Required) `name` - A name of source S3 bucket.<br>      (Optional) `key_prefix` - A key prefix of source S3 bucket. | <pre>object({<br>    enabled = optional(bool, true)<br>    source_s3_buckets = optional(list(object({<br>      name       = string<br>      key_prefix = optional(string, "/")<br>    })), [])<br>  })</pre> | `{}` | no |
| <a name="input_level"></a> [level](#input\_level) | (Optional) The level of the event data store to decide whether the event data store collects events logged for an organization in AWS Organizations. Can be created in the management account or delegated administrator account. Valid values are `ACCOUNT` and `ORGANIZATION`. Defaults to `ACCOUNT`. | `string` | `"ACCOUNT"` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | (Optional) The retention period of the event data store, in days. You can set a retention period of up to 2557 days. Defaults to `2555` days (7 years). | `number` | `2555` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | (Optional) The scope of the event data store to decide whether the event data store includes events from all regions, or only from the region in which the event data store is created. Supported values are `REGIONAL` or `ALL`. Defaults to `ALL`. | `string` | `"ALL"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_termination_protection_enabled"></a> [termination\_protection\_enabled](#input\_termination\_protection\_enabled) | (Optional) Whether termination protection is enabled for the event data store. If termination protection is enabled, you cannot delete the event data store until termination protection is disabled. Defaults to `true`. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of the event data store. |
| <a name="output_encryption"></a> [encryption](#output\_encryption) | The configuration for the encryption of the event data store. |
| <a name="output_event_selectors"></a> [event\_selectors](#output\_event\_selectors) | The event selectors to use to select the events for the event data store. |
| <a name="output_event_type"></a> [event\_type](#output\_event\_type) | The type of event to be collected by the event data store. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the event data store. |
| <a name="output_import_trail_events_iam_role"></a> [import\_trail\_events\_iam\_role](#output\_import\_trail\_events\_iam\_role) | A configuration of IAM Role for importing CloudTrail events from S3 Bucket. |
| <a name="output_level"></a> [level](#output\_level) | The level of the event data store to decide whether the event data store collects events logged for an organization in AWS Organizations. |
| <a name="output_name"></a> [name](#output\_name) | The name of the event data store. |
| <a name="output_retention_in_days"></a> [retention\_in\_days](#output\_retention\_in\_days) | The retention period of the event data store, in days. |
| <a name="output_scope"></a> [scope](#output\_scope) | The scope of the event data store to decide whether the event data store includes events from all regions, or only from the region in which the event data store is created. |
| <a name="output_termination_protection_enabled"></a> [termination\_protection\_enabled](#output\_termination\_protection\_enabled) | Whether termination protection is enabled for the event data store. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
