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
  status = var.enabled ? "ENABLED" : "PAUSED"

  finding_publishing_frequency = local.update_frequency[var.update_frequency]
}


###################################################
# Member Accounts of Macie Account
###################################################

# TODO: Cannot delete member account from AWS Organization
# https://github.com/hashicorp/terraform-provider-aws/issues/26219
resource "aws_macie2_member" "this" {
  for_each = {
    for account in var.member_accounts :
    account.account_id => account
  }

  account_id = each.key
  email      = each.value.email
  status     = try(each.value.enabled, true) ? "ENABLED" : "PAUSED"

  ## Invitation
  # invite                                = true
  # invitation_message                    = "Message of the invitation"
  # invitation_disable_email_notification = true

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

  depends_on = [
    aws_macie2_account.this
  ]
}


###################################################
# S3 Bucket for Sensitive Data Discovery Results
###################################################

resource "aws_macie2_classification_export_configuration" "this" {
  count = var.discovery_result != null ? 1 : 0

  s3_destination {
    bucket_name = var.discovery_result.s3_bucket
    key_prefix  = try(var.discovery_result.s3_key_prefix, "")
    kms_key_arn = var.discovery_result.encryption_kms_key
  }

  depends_on = [
    aws_macie2_account.this,
  ]
}
