# terraform-aws-security

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/tedilabs/terraform-aws-security?color=blue&sort=semver&style=flat-square)
![GitHub](https://img.shields.io/github/license/tedilabs/terraform-aws-security?color=blue&style=flat-square)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white&style=flat-square)](https://github.com/pre-commit/pre-commit)

Terraform module which creates security related resources on AWS.

- [access-analyzer](./modules/access-analyzer)
- [cloudtrail-event-data-store](./modules/cloudtrail-event-data-store)
- [cloudtrail-trail](./modules/cloudtrail-trail)
- [config-managed-rule](./modules/config-managed-rule)
- [config-recorder](./modules/config-recorder)
- [macie-account](./modules/macie-account)


## Target AWS Services

Terraform Modules from [this package](https://github.com/tedilabs/terraform-aws-security) were written to manage the following AWS Services with Terraform.

- **AWS IAM**
  - Access Analyzer
- **AWS CloudTrail**
  - Event Data Store
  - Trail
- **AWS Config**
  - Recorder
  - Rules
    - Managed Rules
- **AWS Macie**
  - Account


## Usage

### CloudTrail

```tf
module "event_data_store" {
  source  = "tedilabs/security/aws//modules/cloudtrail-event-data-store"
  version = "~> 0.5.0"

  name = "management-event"

  level = "ACCOUNT"
  scope = "REGIONAL"


  ## Event Selector
  event_type = "CLOUDTRAIL_EVENTS"
  event_selectors = [
    {
      category        = "MANAGEMENT"
      scope           = "READ"
      exclude_sources = ["kms.amazonaws.com"]
    },
    {
      category      = "DATA"
      scope         = "ALL"
      resource_type = "AWS::S3::Object"
      selectors = [
        {
          field    = "resource_arn"
          operator = "ends_with"
          values   = ["hello"]
        }
      ]
    },
    {
      category      = "DATA"
      scope         = "WRITE"
      resource_type = "AWS::S3Outposts::Object"
      selectors = [
        {
          field    = "event_name"
          operator = "starts_with"
          values   = ["Put"]
        }
      ]
    },
  ]


  ## IAM Role
  import_trail_events_iam_role = {
    enabled = true
    source_s3_buckets = [
      {
        name = "helloworld"
        key_prefix = "asdf/"
      },
      {
        name = "foo"
        key_prefix = "bar/"
      },
      {
        name = "demo"
        key_prefix = ""
      },
    ]
  }


  ## Attributes
  retention_in_days              = 365 * 7
  termination_protection_enabled = false

  tags = {
    "project" = "terraform-aws-security-examples"
  }
}
```


## Examples

### CloudTrail

- [Simple Event Data Store in CloudTrail](./examples/cloudtrail-event-data-store-simple)
- [Event Data Store in CloudTrail with Config Configuration Items](./examples/cloudtrail-event-data-store-config)
- [Full Event Data Store in CloudTrail](./examples/cloudtrail-event-data-store-full)

### Macie

- [Simple Macie Account](./examples/macie-account-simple)


## Self Promotion

Like this project? Follow the repository on [GitHub](https://github.com/tedilabs/terraform-aws-security). And if you're feeling especially charitable, follow **[posquit0](https://github.com/posquit0)** on GitHub.


## License

Provided under the terms of the [Apache License](LICENSE).

Copyright © 2021-2023, [Byungjin Park](https://www.posquit0.com).
