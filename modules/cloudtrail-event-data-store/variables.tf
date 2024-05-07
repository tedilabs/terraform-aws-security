variable "name" {
  description = "(Required) The name of the event data store."
  type        = string
  nullable    = false
}

variable "level" {
  description = "(Optional) The level of the event data store to decide whether the event data store collects events logged for an organization in AWS Organizations. Can be created in the management account or delegated administrator account. Valid values are `ACCOUNT` and `ORGANIZATION`. Defaults to `ACCOUNT`."
  type        = string
  default     = "ACCOUNT"
  nullable    = false

  validation {
    condition     = contains(["ACCOUNT", "ORGANIZATION"], var.level)
    error_message = "The level should be one of `ACCOUNT`, `ORGANIZATION`."
  }
}

variable "scope" {
  description = "(Optional) The scope of the event data store to decide whether the event data store includes events from all regions, or only from the region in which the event data store is created. Supported values are `REGIONAL` or `ALL`. Defaults to `ALL`."
  type        = string
  default     = "ALL"
  nullable    = false

  validation {
    condition     = contains(["REGIONAL", "ALL"], var.scope)
    error_message = "The scope should be one of `REGIONAL`, `ALL`."
  }
}

variable "event_type" {
  description = "(Required) A type of event to be collected by the event data store. Valid values are `CLOUDTRAIL_EVENTS`, `CONFIG_CONFIGURATION_ITEMS`. Defaults to `CLOUDTRAIL_EVENTS`."
  type        = string
  default     = "CLOUDTRAIL_EVENTS"
  nullable    = false

  validation {
    condition     = contains(["CLOUDTRAIL_EVENTS", "CONFIG_CONFIGURATION_ITEMS"], var.event_type)
    error_message = "The event type should be one of `CLOUDTRAIL_EVENTS`, `CONFIG_CONFIGURATION_ITEMS`."
  }
}

variable "management_event_selector" {
  description = <<EOF
  (Optional) A configuration of management event selector to use to select the events for the event data store. Only used if `event_type` is `CLOUDTRAIL_EVENTS`. `management_event_selector` block as defined below.
    (Optional) `enabled` - Whether to capture management events. Defaults to `false`.
    (Optional) `scope` - The type of events to log. Valid values are `ALL`, `READ` and `WRITE`. Defaults to `ALL`.
    (Optional) `exclude_event_sources` - A set of event sources to exclude. Valid values are `kms.amazonaws.com` and `rdsdata.amazonaws.com`. `management_event_selector.enabled` must be set to true to allow this.
  EOF
  type = object({
    enabled               = optional(bool, false)
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
  (Optional) A configuration of event selectors to use to select the data events for the event data store. Each item of `data_event_selectors` block as defined below.
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

variable "encryption" {
  description = <<EOF
  (Optional) A configuration to encrypt the events delivered by CloudTrail. By default, the event data store is encrypted with a KMS key that AWS owns and manages.`encryption` as defined below.
    (Optional) `kms_key` - The ID of AWS KMS key to use to encrypt the events delivered by CloudtTrail. The value can be an alias name prefixed by 'alias/', a fully specified ARN to an alias, a fully specified ARN to a key, or a globally unique identifier.
  EOF
  type = object({
    kms_key = optional(string)
  })
  default  = {}
  nullable = false
}

variable "retention_in_days" {
  description = "(Optional) The retention period of the event data store, in days. You can set a retention period of up to 2557 days. Defaults to `2555` days (7 years)."
  type        = number
  default     = 2555
  nullable    = false

  validation {
    condition = alltrue([
      var.retention_in_days <= 2557,
      var.retention_in_days >= 7,
    ])
    error_message = "The scope should be one of `REGIONAL`, `ALL`."
  }
}

variable "termination_protection_enabled" {
  description = "(Optional) Whether termination protection is enabled for the event data store. If termination protection is enabled, you cannot delete the event data store until termination protection is disabled. Defaults to `true`."
  type        = bool
  default     = true
  nullable    = false
}

variable "import_trail_events_iam_role" {
  description = <<EOF
  (Optional) A configuration of IAM Role for importing CloudTrail events from S3 Bucket. `import_trail_events_iam_role` as defined below.
    (Optional) `enabled` - Indicates whether you want to create IAM Role to import trail events. Defaults to `true`.
    (Optional) `source_s3_buckets` - A list of source S3 buckets to import events from. Each item of `source_s3_buckets` as defined below.
      (Required) `name` - A name of source S3 bucket.
      (Optional) `key_prefix` - A key prefix of source S3 bucket.
  EOF
  type = object({
    enabled = optional(bool, true)
    source_s3_buckets = optional(list(object({
      name       = string
      key_prefix = optional(string, "/")
    })), [])
  })
  default  = {}
  nullable = false
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
