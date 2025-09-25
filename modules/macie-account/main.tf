locals {
  metadata = {
    package = "terraform-aws-security"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = data.aws_caller_identity.this.account_id
  }
  module_tags = var.module_tags_enabled ? {
    "module.terraform.io/package"   = local.metadata.package
    "module.terraform.io/version"   = local.metadata.version
    "module.terraform.io/name"      = local.metadata.module
    "module.terraform.io/full-name" = "${local.metadata.package}/${local.metadata.module}"
    "module.terraform.io/instance"  = local.metadata.name
  } : {}
}

data "aws_caller_identity" "this" {}

locals {
  update_frequency = {
    "15m" = "FIFTEEN_MINUTES"
    "1h"  = "ONE_HOUR"
    "6h"  = "SIX_HOURS"
  }
}


###################################################
# Macie Account
###################################################

resource "aws_macie2_account" "this" {
  region = var.region

  status                       = var.enabled ? "ENABLED" : "PAUSED"
  finding_publishing_frequency = local.update_frequency[var.update_frequency]
}


###################################################
# Member Accounts of Macie Account
###################################################

# TODO: Cannot delete member account from AWS Organization
# https://github.com/hashicorp/terraform-provider-aws/issues/26219
# INFO: Not supported attributes
# - `invite`
# - `invitation_message`
# - `invitation_disable_email_notification`
resource "aws_macie2_member" "this" {
  for_each = {
    for account in var.member_accounts :
    account.account_id => account
  }

  region = aws_macie2_account.this.region

  account_id = each.key
  email      = each.value.email
  status     = each.value.enabled ? "ENABLED" : "PAUSED"


  ## Invitation
  invite                                = each.value.type == "INVITATION" ? true : null
  invitation_message                    = each.value.invitation.message
  invitation_disable_email_notification = !each.value.invitation.email_notification_enabled


  tags = merge(
    {
      "Name" = each.key
    },
    local.module_tags,
    var.tags,
    try(each.value.tags, {}),
  )

  # TODO: Bug for `email` parameter only when member is from organization
  # https://github.com/hashicorp/terraform-provider-aws/issues/26218
  lifecycle {
    ignore_changes = [
      email,
    ]
  }
}

###################################################
# Organization Configurations for Macie Account
###################################################

resource "aws_macie2_organization_configuration" "this" {
  region = aws_macie2_account.this.region

  auto_enable = var.organization_config.auto_enable
}


###################################################
# S3 Bucket for Sensitive Data Discovery Results
###################################################

resource "aws_macie2_classification_export_configuration" "this" {
  count = var.discovery_result_repository.s3_bucket != null ? 1 : 0

  region = aws_macie2_account.this.region

  s3_destination {
    bucket_name = var.discovery_result_repository.s3_bucket.name
    key_prefix  = var.discovery_result_repository.s3_bucket.key_prefix
    kms_key_arn = var.discovery_result_repository.s3_bucket.sse_kms_key
  }
}
