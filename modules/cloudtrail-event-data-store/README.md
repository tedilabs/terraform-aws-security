# cloudtrail-event-data-store

This module creates following resources.

- `aws_cloudtrail_event_data_store`
- `aws_iam_role` (optional)
- `aws_iam_role_policy` (optional)
- `aws_iam_role_policy_attachment` (optional)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.33.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.12.0 |
| <a name="module_role"></a> [role](#module\_role) | tedilabs/account/aws//modules/iam-role | ~> 0.33.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail_event_data_store.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail_event_data_store) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_management_event_selector"></a> [management\_event\_selector](#input\_management\_event\_selector) | (Optional) A configuration of management event selector to use to select the events for the event data store. Only used if `event_type` is `CLOUDTRAIL_EVENTS`. `management_event_selector` block as defined below.<br/>    (Optional) `enabled` - Whether to capture management events. Defaults to `false`.<br/>    (Optional) `scope` - The type of events to log. Valid values are `ALL`, `READ` and `WRITE`. Defaults to `ALL`.<br/>    (Optional) `exclude_event_sources` - A set of event sources to exclude. Valid values are `kms.amazonaws.com` and `rdsdata.amazonaws.com`. `management_event_selector.enabled` must be set to true to allow this. | <pre>object({<br/>    enabled               = optional(bool, false)<br/>    scope                 = optional(string, "ALL")<br/>    exclude_event_sources = optional(set(string), [])<br/>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the event data store. | `string` | n/a | yes |
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | (Optional) The billing mode for the event data store. Valid values are `EXTENDABLE_RETENTION_PRICING` and `FIXED_RETENTION_PRICING`. Defaults to `EXTENDABLE_RETENTION_PRICING`. | `string` | `"EXTENDABLE_RETENTION_PRICING"` | no |
| <a name="input_data_event_selectors"></a> [data\_event\_selectors](#input\_data\_event\_selectors) | (Optional) A configuration of event selectors to use to select the data events for the event data store. Each item of `data_event_selectors` block as defined below.<br/>    (Optional) `name` - A name of the advanced event selector.<br/>    (Optional) `resource_type` - A resource type to log data events to log. Valid values are one of the following:<br/>    - `AWS::DynamoDB::Table`<br/>    - `AWS::Lambda::Function`<br/>    - `AWS::S3::Object`<br/>    - `AWS::AppConfig::Configuration`<br/>    - `AWS::B2BI::Transformer`<br/>    - `AWS::Bedrock::AgentAlias`<br/>    - `AWS::Bedrock::KnowledgeBase`<br/>    - `AWS::Cassandra::Table`<br/>    - `AWS::CloudFront::KeyValueStore`<br/>    - `AWS::CloudTrail::Channel`<br/>    - `AWS::CodeWhisperer::Customization`<br/>    - `AWS::CodeWhisperer::Profile`<br/>    - `AWS::Cognito::IdentityPool`<br/>    - `AWS::DynamoDB::Stream`<br/>    - `AWS::EC2::Snapshot`<br/>    - `AWS::EMRWAL::Workspace`<br/>    - `AWS::FinSpace::Environment`<br/>    - `AWS::Glue::Table`<br/>    - `AWS::GreengrassV2::ComponentVersion`<br/>    - `AWS::GreengrassV2::Deployment`<br/>    - `AWS::GuardDuty::Detector`<br/>    - `AWS::IoT::Certificate`<br/>    - `AWS::IoT::Thing`<br/>    - `AWS::IoTSiteWise::Asset`<br/>    - `AWS::IoTSiteWise::TimeSeries`<br/>    - `AWS::IoTTwinMaker::Entity`<br/>    - `AWS::IoTTwinMaker::Workspace`<br/>    - `AWS::KendraRanking::ExecutionPlan`<br/>    - `AWS::KinesisVideo::Stream`<br/>    - `AWS::ManagedBlockchain::Network`<br/>    - `AWS::ManagedBlockchain::Node`<br/>    - `AWS::MedicalImaging::Datastore`<br/>    - `AWS::NeptuneGraph::Graph`<br/>    - `AWS::PCAConnectorAD::Connector`<br/>    - `AWS::QBusiness::Application`<br/>    - `AWS::QBusiness::DataSource`<br/>    - `AWS::QBusiness::Index`<br/>    - `AWS::QBusiness::WebExperience`<br/>    - `AWS::RDS::DBCluster`<br/>    - `AWS::S3::AccessPoint`<br/>    - `AWS::S3ObjectLambda::AccessPoint`<br/>    - `AWS::S3Outposts::Object`<br/>    - `AWS::SageMaker::Endpoint`<br/>    - `AWS::SageMaker::ExperimentTrialComponent`<br/>    - `AWS::SageMaker::FeatureGroup`<br/>    - `AWS::ServiceDiscovery::Namespace`<br/>    - `AWS::ServiceDiscovery::Service`<br/>    - `AWS::SCN::Instance`<br/>    - `AWS::SNS::PlatformEndpoint`<br/>    - `AWS::SNS::Topic`<br/>    - `AWS::SWF::Domain`<br/>    - `AWS::SQS::Queue`<br/>    - `AWS::SSMMessages::ControlChannel`<br/>    - `AWS::ThinClient::Device`<br/>    - `AWS::ThinClient::Environment`<br/>    - `AWS::Timestream::Database`<br/>    - `AWS::Timestream::Table`<br/>    - `AWS::VerifiedPermissions::PolicyStore`<br/>    (Optional) `scope` - The type of events to log. Valid values are `ALL`, `READ` and `WRITE`. Defaults to `WRITE`.<br/>    (Optional) `conditions` - A configuration of field conditions to filter events by the ARN of resource and the event name. Each item of `conditions` as defined below.<br/>      (Required) `field` - A field to compare by the field condition. Valid values are `eventName`, `eventSource`, `eventType`, `resources.ARN`, `sessionCredentialFromConsole` and `userIdentity.arn`.<br/>      (Required) `operator` - An operator of the field condition. Valid values are `equals`, `not_equals`, `starts_with`, `not_starts_with`, `ends_with`, `not_ends_with`.<br/>      (Required) `values` - A set of values of the field condition to compare. | <pre>list(object({<br/>    name          = optional(string)<br/>    resource_type = string<br/>    scope         = optional(string, "WRITE")<br/>    conditions = optional(list(object({<br/>      field    = string<br/>      operator = string<br/>      values   = set(string)<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | (Optional) Whether to enable ingesting new events into the event data store. If set to `false`, ingestion is suspended while maintaining the ability to query existing events. If set to `true`, ingestion is active. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_encryption"></a> [encryption](#input\_encryption) | (Optional) A configuration to encrypt the events delivered by CloudTrail. By default, the event data store is encrypted with a KMS key that AWS owns and manages.`encryption` as defined below.<br/>    (Optional) `kms_key` - The ID of AWS KMS key to use to encrypt the events delivered by CloudtTrail. The value can be an alias name prefixed by 'alias/', a fully specified ARN to an alias, a fully specified ARN to a key, or a globally unique identifier. | <pre>object({<br/>    kms_key = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_event_type"></a> [event\_type](#input\_event\_type) | (Required) A type of event to be collected by the event data store. Valid values are `CLOUDTRAIL_EVENTS`, `CONFIG_CONFIGURATION_ITEMS`. Defaults to `CLOUDTRAIL_EVENTS`. | `string` | `"CLOUDTRAIL_EVENTS"` | no |
| <a name="input_import_trail_events_iam_role"></a> [import\_trail\_events\_iam\_role](#input\_import\_trail\_events\_iam\_role) | (Optional) A configuration of IAM Role for importing CloudTrail events from S3 Bucket. `import_trail_events_iam_role` as defined below.<br/>    (Optional) `enabled` - Indicates whether you want to create IAM Role to import trail events. Defaults to `true`.<br/>    (Optional) `name` - The name of the iam role. Defaults to `cloudtrail-event-data-store-${name}`.<br/>    (Optional) `path` - The path of the iam role. Defaults to `/`.<br/>    (Optional) `description` - The description of the iam role.<br/>    (Optional) `policies` - A list of IAM policy ARNs to attach to the iam role. Defaults to `[]`.<br/>    (Optional) `inline_policies` - A Map of inline IAM policies to attach to the iam role. (`name` => `policy`).<br/>    (Optional) `permissions_boundary` - The ARN of the IAM policy to use as permissions boundary for the iam role.<br/>    (Optional) `source_s3_buckets` - A list of source S3 buckets to import events from. Each item of `source_s3_buckets` as defined below.<br/>      (Required) `name` - A name of source S3 bucket.<br/>      (Optional) `key_prefix` - A key prefix of source S3 bucket. | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string)<br/>    path        = optional(string, "/")<br/>    description = optional(string, "Managed by Terraform.")<br/><br/>    policies             = optional(list(string), [])<br/>    inline_policies      = optional(map(string), {})<br/>    permissions_boundary = optional(string)<br/><br/>    source_s3_buckets = optional(list(object({<br/>      name       = string<br/>      key_prefix = optional(string, "/")<br/>    })), [])<br/>  })</pre> | `{}` | no |
| <a name="input_level"></a> [level](#input\_level) | (Optional) The level of the event data store to decide whether the event data store collects events logged for an organization in AWS Organizations. Can be created in the management account or delegated administrator account. Valid values are `ACCOUNT` and `ORGANIZATION`. Defaults to `ACCOUNT`. | `string` | `"ACCOUNT"` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) The region in which to create the module resources. If not provided, the module resources will be created in the provider's configured region. | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Optional) A configurations of Resource Group for this module. `resource_group` as defined below.<br/>    (Optional) `enabled` - Whether to create Resource Group to find and group AWS resources which are created by this module. Defaults to `true`.<br/>    (Optional) `name` - The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. If not provided, a name will be generated using the module name and instance name.<br/>    (Optional) `description` - The description of Resource Group. Defaults to `Managed by Terraform.`. | <pre>object({<br/>    enabled     = optional(bool, true)<br/>    name        = optional(string, "")<br/>    description = optional(string, "Managed by Terraform.")<br/>  })</pre> | `{}` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | (Optional) The retention period of the event data store, in days. You can set a retention period of up to 2557 days. Defaults to `2555` days (7 years). | `number` | `2555` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | (Optional) The scope of the event data store to decide whether the event data store includes events from all regions, or only from the region in which the event data store is created. Supported values are `REGIONAL` or `ALL`. Defaults to `ALL`. | `string` | `"ALL"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_termination_protection_enabled"></a> [termination\_protection\_enabled](#input\_termination\_protection\_enabled) | (Optional) Whether termination protection is enabled for the event data store. If termination protection is enabled, you cannot delete the event data store until termination protection is disabled. Defaults to `true`. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of the event data store. |
| <a name="output_billing_mode"></a> [billing\_mode](#output\_billing\_mode) | The billing mode for the event data store. |
| <a name="output_data_event_selectors"></a> [data\_event\_selectors](#output\_data\_event\_selectors) | The event selectors to use to select the data events for the event data store. |
| <a name="output_enabled"></a> [enabled](#output\_enabled) | Whether the event data store is enabled. |
| <a name="output_encryption"></a> [encryption](#output\_encryption) | The configuration for the encryption of the event data store. |
| <a name="output_event_type"></a> [event\_type](#output\_event\_type) | The type of event to be collected by the event data store. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the event data store. |
| <a name="output_import_trail_events_iam_role"></a> [import\_trail\_events\_iam\_role](#output\_import\_trail\_events\_iam\_role) | A configuration of IAM Role for importing CloudTrail events from S3 Bucket. |
| <a name="output_level"></a> [level](#output\_level) | The level of the event data store to decide whether the event data store collects events logged for an organization in AWS Organizations. |
| <a name="output_management_event_selector"></a> [management\_event\_selector](#output\_management\_event\_selector) | The event selector to use to select the management events for the event data store. |
| <a name="output_name"></a> [name](#output\_name) | The name of the event data store. |
| <a name="output_region"></a> [region](#output\_region) | The AWS region this module resources resides in. |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | The resource group created to manage resources in this module. |
| <a name="output_retention_in_days"></a> [retention\_in\_days](#output\_retention\_in\_days) | The retention period of the event data store, in days. |
| <a name="output_scope"></a> [scope](#output\_scope) | The scope of the event data store to decide whether the event data store includes events from all regions, or only from the region in which the event data store is created. |
| <a name="output_termination_protection_enabled"></a> [termination\_protection\_enabled](#output\_termination\_protection\_enabled) | Whether termination protection is enabled for the event data store. |
<!-- END_TF_DOCS -->
