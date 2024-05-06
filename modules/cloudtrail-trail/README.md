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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.25 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.48.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | tedilabs/misc/aws//modules/resource-group | ~> 0.10.0 |
| <a name="module_role"></a> [role](#module\_role) | tedilabs/account/aws//modules/iam-role | ~> 0.29.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudtrail.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudwatch_log_group) | data source |
| [aws_iam_policy_document.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_organizations_organization.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_partition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_delivery_channels"></a> [delivery\_channels](#input\_delivery\_channels) | (Required) A configuration for the delivery channels of the trail. `delivery_channels` as defined below.<br>    (Required) `s3_bucket` - A configuration for the S3 Bucket delivery channel. `s3_bucket` as defined below.<br>      (Required) `name` - The name of the S3 bucket used to publish log files.<br>      (Optional) `key_prefix` - The key prefix for the specified S3 bucket.<br>      (Optional) `integrity_validation_enabled` - To determine whether a log file was modified, deleted, or unchanged after AWS CloudTrail delivered it, use CloudTrail log file integrity validation. This feature is built using industry standard algorithms: SHA-256 for hashing and SHA-256 with RSA for digital signing. Defaults to `true`.<br>      (Optional) `sse_kms_key` - The ARN of the AWS KMS key used to encrypt objects delivered by AWS Config. Must belong to the same Region as the destination S3 bucket.<br>    (Optional) `sns_topic` - A configuration for the SNS Topic notifications for log file delivery. CloudTrail stores multiple events in a log file. When you enable this option, Amazon SNS notifications are sent for every log file delivery to your S3 bucket, not for every event. `sns_topic` as defined below.<br>      (Optional) `enabled` - Whether to enable the SNS Topic notifications for log file delivery. Defaults to `false`.<br>      (Optional) `name` - The name of the SNS topic for notification of log file delivery.<br>    (Optional) `cloudwatch_log_group` - A configuration for the log group of CloudWatch Logs to send events to CloudWatch Logs. `cloudwatch_log_group` as defined below.<br>      (Optional) `enabled` - Whether to send CloudTrail events to CloudWatch Logs. Defaults to `false`.<br>      (Optional) `name` - The name of the log group of CloudWatch Logs. | <pre>object({<br>    s3_bucket = object({<br>      name                         = string<br>      key_prefix                   = optional(string, "")<br>      integrity_validation_enabled = optional(bool, true)<br>      sse_kms_key                  = optional(string)<br>    })<br>    sns_topic = optional(object({<br>      enabled = optional(bool, false)<br>      name    = optional(string)<br>    }), {})<br>    cloudwatch_log_group = optional(object({<br>      enabled = optional(bool, false)<br>      name    = optional(string)<br>      # iam_role = optional(string)<br>    }), {})<br>  })</pre> | n/a | yes |
| <a name="input_management_event_selector"></a> [management\_event\_selector](#input\_management\_event\_selector) | (Required) A configuration block for management events logging to identify API activity for individual resources, or for all current and future resources in AWS account. `management_event_selector` block as defined below.<br>    (Required) `enabled` - Whether the trail to log management events.<br>    (Optional) `scope` - The type of events to log. Valid values are `ALL`, `READ` and `WRITE`. Defaults to `ALL`.<br>    (Optional) `exclude_event_sources` - A set of event sources to exclude. Valid values are `kms.amazonaws.com` and `rdsdata.amazonaws.com`. `management_event_selector.enabled` must be set to true to allow this. | <pre>object({<br>    enabled               = bool<br>    scope                 = optional(string, "ALL")<br>    exclude_event_sources = optional(set(string), [])<br>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the trail. The name can only contain uppercase letters, lowercase letters, numbers, periods (.), hyphens (-), and underscores (\_). | `string` | n/a | yes |
| <a name="input_data_event_selectors"></a> [data\_event\_selectors](#input\_data\_event\_selectors) | (Optional) A list of configurations for data events logging the resource operations performed on or within a resource. Each item of `data_event_selectors` block as defined below.<br>    (Optional) `name` - A name of the advanced event selector.<br>    (Optional) `resource_type` - A resource type to log data events to log. Valid values are one of the following:<br>    - `AWS::DynamoDB::Table`<br>    - `AWS::Lambda::Function`<br>    - `AWS::S3::Object`<br>    - `AWS::AppConfig::Configuration`<br>    - `AWS::B2BI::Transformer`<br>    - `AWS::Bedrock::AgentAlias`<br>    - `AWS::Bedrock::KnowledgeBase`<br>    - `AWS::Cassandra::Table`<br>    - `AWS::CloudFront::KeyValueStore`<br>    - `AWS::CloudTrail::Channel`<br>    - `AWS::CodeWhisperer::Customization`<br>    - `AWS::CodeWhisperer::Profile`<br>    - `AWS::Cognito::IdentityPool`<br>    - `AWS::DynamoDB::Stream`<br>    - `AWS::EC2::Snapshot`<br>    - `AWS::EMRWAL::Workspace`<br>    - `AWS::FinSpace::Environment`<br>    - `AWS::Glue::Table`<br>    - `AWS::GreengrassV2::ComponentVersion`<br>    - `AWS::GreengrassV2::Deployment`<br>    - `AWS::GuardDuty::Detector`<br>    - `AWS::IoT::Certificate`<br>    - `AWS::IoT::Thing`<br>    - `AWS::IoTSiteWise::Asset`<br>    - `AWS::IoTSiteWise::TimeSeries`<br>    - `AWS::IoTTwinMaker::Entity`<br>    - `AWS::IoTTwinMaker::Workspace`<br>    - `AWS::KendraRanking::ExecutionPlan`<br>    - `AWS::KinesisVideo::Stream`<br>    - `AWS::ManagedBlockchain::Network`<br>    - `AWS::ManagedBlockchain::Node`<br>    - `AWS::MedicalImaging::Datastore`<br>    - `AWS::NeptuneGraph::Graph`<br>    - `AWS::PCAConnectorAD::Connector`<br>    - `AWS::QBusiness::Application`<br>    - `AWS::QBusiness::DataSource`<br>    - `AWS::QBusiness::Index`<br>    - `AWS::QBusiness::WebExperience`<br>    - `AWS::RDS::DBCluster`<br>    - `AWS::S3::AccessPoint`<br>    - `AWS::S3ObjectLambda::AccessPoint`<br>    - `AWS::S3Outposts::Object`<br>    - `AWS::SageMaker::Endpoint`<br>    - `AWS::SageMaker::ExperimentTrialComponent`<br>    - `AWS::SageMaker::FeatureGroup`<br>    - `AWS::ServiceDiscovery::Namespace`<br>    - `AWS::ServiceDiscovery::Service`<br>    - `AWS::SCN::Instance`<br>    - `AWS::SNS::PlatformEndpoint`<br>    - `AWS::SNS::Topic`<br>    - `AWS::SWF::Domain`<br>    - `AWS::SQS::Queue`<br>    - `AWS::SSMMessages::ControlChannel`<br>    - `AWS::ThinClient::Device`<br>    - `AWS::ThinClient::Environment`<br>    - `AWS::Timestream::Database`<br>    - `AWS::Timestream::Table`<br>    - `AWS::VerifiedPermissions::PolicyStore`<br>    (Optional) `scope` - The type of events to log. Valid values are `ALL`, `READ` and `WRITE`. Defaults to `WRITE`.<br>    (Optional) `conditions` - A configuration of field conditions to filter events by the ARN of resource and the event name. Each item of `conditions` as defined below.<br>      (Required) `field` - A field to compare by the field condition. Valid values are `event_name` and `resource_arn`.<br>      (Required) `operator` - An operator of the field condition. Valid values are `equals`, `not_equals`, `starts_with`, `not_starts_with`, `ends_with`, `not_ends_with`.<br>      (Required) `values` - A set of values of the field condition to compare. | <pre>list(object({<br>    name          = optional(string)<br>    resource_type = string<br>    scope         = optional(string, "WRITE")<br>    conditions = optional(list(object({<br>      field    = string<br>      operator = string<br>      values   = set(string)<br>    })), [])<br>  }))</pre> | `[]` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | (Optional) Whether the trail starts the recording of AWS API calls and log file delivery. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_insight_event_selector"></a> [insight\_event\_selector](#input\_insight\_event\_selector) | (Optional) A configuration block for insight events logging to identify unusual operational activity. `insight_event_selector` block as defined below.<br>    (Optional) `enabled` - Whether the trail to log insight events. Defaults to `false`.<br>    (Optional) `scopes` - A set of insight types to log on the trail. Valid values are `API_CALL_RATE` and `API_ERROR_RATE`. | <pre>object({<br>    enabled = optional(bool, false)<br>    scopes  = optional(set(string), [])<br>  })</pre> | `{}` | no |
| <a name="input_level"></a> [level](#input\_level) | (Optional) The level of the trail to decide whether the trail is an AWS Organizations trail. Organization trails log events for the master account and all member accounts. Can only be created in the organization master account. Valid values are `ACCOUNT` and `ORGANIZATION`. Use `ORGANIZATION` level in Organization master account. Defaults to `ACCOUNT`. | `string` | `"ACCOUNT"` | no |
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
| <a name="output_data_event"></a> [data\_event](#output\_data\_event) | A list of selectors for data events of the trail. |
| <a name="output_delivery_channels"></a> [delivery\_channels](#output\_delivery\_channels) | The configurations for the delivery channels of the trail. |
| <a name="output_enabled"></a> [enabled](#output\_enabled) | Whether the trail is enabled. |
| <a name="output_home_region"></a> [home\_region](#output\_home\_region) | The region in which the trail was created. |
| <a name="output_iam_role"></a> [iam\_role](#output\_iam\_role) | The IAM Role for the CloudTrail trail. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the trail. |
| <a name="output_insight_event"></a> [insight\_event](#output\_insight\_event) | A selector for insight events of the trail. |
| <a name="output_level"></a> [level](#output\_level) | The level of the trail to decide whether the trail is an AWS Organizations trail. |
| <a name="output_management_event"></a> [management\_event](#output\_management\_event) | A selector for management events of the trail. |
| <a name="output_name"></a> [name](#output\_name) | The name of the trail. |
| <a name="output_scope"></a> [scope](#output\_scope) | The scope of the trail to decide whether the trail is multi-region trail. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
