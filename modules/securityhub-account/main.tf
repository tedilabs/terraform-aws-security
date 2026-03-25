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
# Finding Aggregator of SecurityHub Account
###################################################

resource "aws_securityhub_finding_aggregator" "this" {
  count = var.control_finding.aggregator.enabled ? 1 : 0

  region = var.region

  linking_mode = var.control_finding.aggregator.mode
  specified_regions = (contains(["ALL_REGIONS_EXCEPT_SPECIFIED", "SPECIFIED_REGIONS"], var.control_finding.aggregator.mode)
    ? var.control_finding.aggregator.regions
    : null
  )

  depends_on = [aws_securityhub_account.this]
}
