variable "name" {
  description = "(Required) The name of the trail. The name can only contain uppercase letters, lowercase letters, numbers, periods (.), hyphens (-), and underscores (_)."
  type        = string
  nullable    = false

  validation {
    condition     = can(regex("^[0-9A-Za-z-_\\.]+$", var.name))
    error_message = "For the name value only a-z, A-Z, 0-9, periods (.), hyphens (-) and underscores (_) are allowed."
  }
}

variable "enabled" {
  description = "(Optional) Whether the trail starts the recording of AWS API calls and log file delivery. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "level" {
  description = "(Optional) The level of the trail to decide whether the trail is an AWS Organizations trail. Organization trails log events for the master account and all member accounts. Can only be created in the organization master account. Valid values are `ACCOUNT` and `ORGANIZATION`. Use `ORGANIZATION` level in Organization master account. Defaults to `ACCOUNT`."
  type        = string
  default     = "ACCOUNT"
  nullable    = false

  validation {
    condition     = contains(["ACCOUNT", "ORGANIZATION"], var.level)
    error_message = "The level should be one of `ACCOUNT`, `ORGANIZATION`."
  }
}

variable "scope" {
  description = "(Optional) The scope of the trail to decide whether the trail is multi-region trail. Supported values are `REGIONAL_WITH_GLOBAL`, `REGIONAL` or `ALL`. Defaults to `REGIONAL_WITH_GLOBAL`."
  type        = string
  default     = "REGIONAL_WITH_GLOBAL"
  nullable    = false

  validation {
    condition     = contains(["REGIONAL_WITH_GLOBAL", "REGIONAL", "ALL"], var.scope)
    error_message = "The scope should be one of `REGIONAL_WITH_GLOBAL`, `REGIONAL`, `ALL`."
  }
}

variable "delivery_channels" {
  description = <<EOF
  (Required) A configuration for the delivery channels of the trail. `delivery_channels` as defined below.
    (Required) `s3_bucket` - A configuration for the S3 Bucket delivery channel. `s3_bucket` as defined below.
      (Required) `name` - The name of the S3 bucket used to publish log files.
      (Optional) `key_prefix` - The key prefix for the specified S3 bucket.
      (Optional) `integrity_validation_enabled` - To determine whether a log file was modified, deleted, or unchanged after AWS CloudTrail delivered it, use CloudTrail log file integrity validation. This feature is built using industry standard algorithms: SHA-256 for hashing and SHA-256 with RSA for digital signing. Defaults to `true`.
      (Optional) `sse_kms_key` - The ARN of the AWS KMS key used to encrypt objects delivered by AWS Config. Must belong to the same Region as the destination S3 bucket.
    (Optional) `sns_topic` - A configuration for the SNS Topic notifications for log file delivery. CloudTrail stores multiple events in a log file. When you enable this option, Amazon SNS notifications are sent for every log file delivery to your S3 bucket, not for every event. `sns_topic` as defined below.
      (Optional) `enabled` - Whether to enable the SNS Topic notifications for log file delivery. Defaults to `false`.
      (Optional) `name` - The name of the SNS topic for notification of log file delivery.
    (Optional) `cloudwatch_log_group` - A configuration for the log group of CloudWatch Logs to send events to CloudWatch Logs. `cloudwatch_log_group` as defined below.
      (Optional) `enabled` - Whether to send CloudTrail events to CloudWatch Logs. Defaults to `false`.
      (Optional) `name` - The name of the log group of CloudWatch Logs.
  EOF
  type = object({
    s3_bucket = object({
      name                         = string
      key_prefix                   = optional(string, "")
      integrity_validation_enabled = optional(bool, true)
      sse_kms_key                  = optional(string)
    })
    sns_topic = optional(object({
      enabled = optional(bool, false)
      name    = optional(string)
    }), {})
    cloudwatch_log_group = optional(object({
      enabled = optional(bool, false)
      name    = optional(string)
      # iam_role = optional(string)
    }), {})
  })
  nullable = false

  validation {
    condition = anytrue([
      !var.delivery_channels.sns_topic.enabled,
      var.delivery_channels.sns_topic.enabled && var.delivery_channels.sns_topic.name != null,
    ])
    error_message = "`delivery_channels.sns_topic.name` must be provided when `delivery_channels.sns_topic.enabled` is `true`."
  }
  validation {
    condition = anytrue([
      !var.delivery_channels.cloudwatch_log_group.enabled,
      var.delivery_channels.cloudwatch_log_group.enabled && var.delivery_channels.cloudwatch_log_group.name != null,
    ])
    error_message = "`delivery_channels.cloudwatch_log_group.name` must be provided when `delivery_channels.cloudwatch_log_group.enabled` is `true`."
  }
}

variable "management_event_selector" {
  description = <<EOF
  (Required) A configuration block for management events logging to identify API activity for individual resources, or for all current and future resources in AWS account. `management_event_selector` block as defined below.
    (Required) `enabled` - Whether the trail to log management events.
    (Optional) `scope` - The type of events to log. Valid values are `ALL`, `READ` and `WRITE`. Defaults to `ALL`.
    (Optional) `exclude_event_sources` - A set of event sources to exclude. Valid values are `kms.amazonaws.com` and `rdsdata.amazonaws.com`. `management_event_selector.enabled` must be set to true to allow this.
  EOF
  type = object({
    enabled               = bool
    scope                 = optional(string, "ALL")
    exclude_event_sources = optional(set(string), [])
  })
  nullable = false

  validation {
    condition     = contains(["ALL", "READ", "WRITE"], var.management_event_selector.scope)
    error_message = "Valid values for `management_event_selector.scope` are `ALL`, `READ`, `WRITE`."
  }

  validation {
    condition = alltrue([
      for source in var.management_event_selector.exclude_event_sources :
      contains(["kms.amazonaws.com", "rdsdata.amazonaws.com"], source)
    ])
    error_message = "Valid values for `management_event_selector.exclude_event_sources` are `kms.amazonaws.com`, `rdsdata.amazonaws.com`."
  }
}

variable "data_event_selectors" {
  description = <<EOF
  (Optional) A list of configurations for data events logging the resource operations performed on or within a resource. Each item of `data_event_selectors` block as defined below.
    (Optional) `name` - A name of the advanced event selector.
    (Optional) `resource_type` - A resource type to log data events to log. Valid values are one of the following:
    - `AWS::DynamoDB::Table`
    - `AWS::Lambda::Function`
    - `AWS::S3::Object`
    - `AWS::AppConfig::Configuration`
    - `AWS::B2BI::Transformer`
    - `AWS::Bedrock::AgentAlias`
    - `AWS::Bedrock::KnowledgeBase`
    - `AWS::Cassandra::Table`
    - `AWS::CloudFront::KeyValueStore`
    - `AWS::CloudTrail::Channel`
    - `AWS::CodeWhisperer::Customization`
    - `AWS::CodeWhisperer::Profile`
    - `AWS::Cognito::IdentityPool`
    - `AWS::DynamoDB::Stream`
    - `AWS::EC2::Snapshot`
    - `AWS::EMRWAL::Workspace`
    - `AWS::FinSpace::Environment`
    - `AWS::Glue::Table`
    - `AWS::GreengrassV2::ComponentVersion`
    - `AWS::GreengrassV2::Deployment`
    - `AWS::GuardDuty::Detector`
    - `AWS::IoT::Certificate`
    - `AWS::IoT::Thing`
    - `AWS::IoTSiteWise::Asset`
    - `AWS::IoTSiteWise::TimeSeries`
    - `AWS::IoTTwinMaker::Entity`
    - `AWS::IoTTwinMaker::Workspace`
    - `AWS::KendraRanking::ExecutionPlan`
    - `AWS::KinesisVideo::Stream`
    - `AWS::ManagedBlockchain::Network`
    - `AWS::ManagedBlockchain::Node`
    - `AWS::MedicalImaging::Datastore`
    - `AWS::NeptuneGraph::Graph`
    - `AWS::PCAConnectorAD::Connector`
    - `AWS::QBusiness::Application`
    - `AWS::QBusiness::DataSource`
    - `AWS::QBusiness::Index`
    - `AWS::QBusiness::WebExperience`
    - `AWS::RDS::DBCluster`
    - `AWS::S3::AccessPoint`
    - `AWS::S3ObjectLambda::AccessPoint`
    - `AWS::S3Outposts::Object`
    - `AWS::SageMaker::Endpoint`
    - `AWS::SageMaker::ExperimentTrialComponent`
    - `AWS::SageMaker::FeatureGroup`
    - `AWS::ServiceDiscovery::Namespace`
    - `AWS::ServiceDiscovery::Service`
    - `AWS::SCN::Instance`
    - `AWS::SNS::PlatformEndpoint`
    - `AWS::SNS::Topic`
    - `AWS::SWF::Domain`
    - `AWS::SQS::Queue`
    - `AWS::SSMMessages::ControlChannel`
    - `AWS::ThinClient::Device`
    - `AWS::ThinClient::Environment`
    - `AWS::Timestream::Database`
    - `AWS::Timestream::Table`
    - `AWS::VerifiedPermissions::PolicyStore`
    (Optional) `scope` - The type of events to log. Valid values are `ALL`, `READ` and `WRITE`. Defaults to `WRITE`.
    (Optional) `conditions` - A configuration of field conditions to filter events by the ARN of resource and the event name. Each item of `conditions` as defined below.
      (Required) `field` - A field to compare by the field condition. Valid values are `event_name` and `resource_arn`.
      (Required) `operator` - An operator of the field condition. Valid values are `equals`, `not_equals`, `starts_with`, `not_starts_with`, `ends_with`, `not_ends_with`.
      (Required) `values` - A set of values of the field condition to compare.
  EOF
  type = list(object({
    name          = optional(string)
    resource_type = string
    scope         = optional(string, "WRITE")
    conditions = optional(list(object({
      field    = string
      operator = string
      values   = set(string)
    })), [])
  }))
  default  = []
  nullable = false

  validation {
    condition = alltrue([
      for selector in var.data_event_selectors :
      contains(["ALL", "READ", "WRITE"], selector.scope)
    ])
    error_message = "Valid values for `scope` are `ALL`, `READ`, `WRITE`."
  }
  validation {
    condition = alltrue([
      for selector in var.data_event_selectors :
      alltrue([
        for condition in selector.conditions :
        contains(["event_name", "resource_arn"], condition.field)
      ])
    ])
    error_message = "Valid values for `field` of each condition are `event_name`, `resource_arn`."
  }
  validation {
    condition = alltrue([
      for selector in var.data_event_selectors :
      alltrue([
        for condition in selector.conditions :
        contains(["equals", "not_equals", "starts_with", "not_starts_with", "ends_with", "not_ends_with"], condition.operator)
      ])
    ])
    error_message = "Valid values for `operator` of each condition are `equals`, `not_equals`, `starts_with`, `not_starts_with`, `ends_with`, `not_ends_with`."
  }
}

variable "insight_event_selector" {
  description = <<EOF
  (Optional) A configuration block for insight events logging to identify unusual operational activity. `insight_event_selector` block as defined below.
    (Optional) `enabled` - Whether the trail to log insight events. Defaults to `false`.
    (Optional) `scopes` - A set of insight types to log on the trail. Valid values are `API_CALL_RATE` and `API_ERROR_RATE`.
  EOF
  type = object({
    enabled = optional(bool, false)
    scopes  = optional(set(string), [])
  })
  default  = {}
  nullable = false

  validation {
    condition = alltrue([
      for scope in var.insight_event_selector.scopes :
      contains(["API_CALL_RATE", "API_ERROR_RATE"], scope)
    ])
    error_message = "Valid values for `insight_event_selector.scopes` are `API_CALL_RATE`, `API_ERROR_RATE`."
  }
}

variable "tags" {
  description = "(Optional) A map of tags to add to all resources."
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "module_tags_enabled" {
  description = "(Optional) Whether to create AWS Resource Tags for the module informations."
  type        = bool
  default     = true
  nullable    = false
}


###################################################
# Resource Group
###################################################

variable "resource_group_enabled" {
  description = "(Optional) Whether to create Resource Group to find and group AWS resources which are created by this module."
  type        = bool
  default     = true
  nullable    = false
}

variable "resource_group_name" {
  description = "(Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`."
  type        = string
  default     = ""
  nullable    = false
}

variable "resource_group_description" {
  description = "(Optional) The description of Resource Group."
  type        = string
  default     = "Managed by Terraform."
  nullable    = false
}
