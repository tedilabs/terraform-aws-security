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


###################################################
# SecurityHub Account
###################################################

resource "aws_securityhub_account" "this" {
  region = var.region

  enable_default_standards  = false
  auto_enable_controls      = var.auto_enable_controls
  control_finding_generator = var.control_finding.consolidation_enabled ? "SECURITY_CONTROL" : "STANDARD_CONTROL"
}


###################################################
# Member Accounts of SecurityHub Account
###################################################

# INFO: Not supported attributes
# - `email`
resource "aws_securityhub_member" "this" {
  for_each = {
    for account in var.member_accounts :
    account.account_id => account
  }

  region = aws_securityhub_account.this.region

  account_id = each.key

  invite = each.value.type == "INVITATION"

  # TODO: Bug for `email` and `invite` parameter
  # https://github.com/hashicorp/terraform-provider-aws/issues/24320
  lifecycle {
    ignore_changes = [
      email,
      invite,
    ]
  }
}


###################################################
# Finding Aggregator of SecurityHub Account
###################################################

resource "aws_securityhub_finding_aggregator" "this" {
  count = var.control_finding.aggregator.enabled ? 1 : 0

  region = aws_securityhub_account.this.region

  linking_mode = var.control_finding.aggregator.mode
  specified_regions = (contains(["ALL_REGIONS_EXCEPT_SPECIFIED", "SPECIFIED_REGIONS"], var.control_finding.aggregator.mode)
    ? var.control_finding.aggregator.regions
    : null
  )
}


###################################################
# Organization Configurations for SecurityHub Account
###################################################

resource "aws_securityhub_organization_configuration" "this" {
  count = anytrue([
    for account in var.member_accounts :
    account.type == "ORGANIZATION"
  ]) ? 1 : 0

  region = aws_securityhub_finding_aggregator.this[0].region

  auto_enable = (var.organization_config.mode == "CENTRAL"
    ? false
    : var.organization_config.auto_enable
  )
  auto_enable_standards = (var.organization_config.mode == "CENTRAL"
    ? "NONE"
    : (var.organization_config.auto_enable_default_standards
      ? "DEFAULT"
      : "NONE"
    )
  )

  organization_configuration {
    configuration_type = var.organization_config.mode
  }

  lifecycle {
    precondition {
      condition     = var.control_finding.aggregator.enabled
      error_message = "`aws_securityhub_organization_configuration` resource requires `aws_securityhub_finding_aggregator` to be enabled. Please enable finding aggregator by setting `control_finding.aggregator.enabled` to `true`."
    }
  }
}
