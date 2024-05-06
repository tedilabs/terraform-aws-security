data "aws_partition" "this" {}
data "aws_region" "this" {}
data "aws_caller_identity" "this" {}
data "aws_organizations_organization" "this" {}


###################################################
# IAM Role for CloudTrail
###################################################

module "role" {
  count = var.delivery_channels.cloudwatch_log_group.enabled ? 1 : 0

  source  = "tedilabs/account/aws//modules/iam-role"
  version = "~> 0.29.0"

  name        = "cloudtrail-${local.metadata.name}"
  path        = "/"
  description = "Role for the CloudTrail trail(${local.metadata.name})"

  trusted_service_policies = [
    {
      services = ["cloudtrail.amazonaws.com"]
    }
  ]

  inline_policies = {
    "cloudwatch" = one(data.aws_iam_policy_document.cloudwatch[*].json)
  }

  force_detach_policies  = true
  resource_group_enabled = false
  module_tags_enabled    = false

  tags = merge(
    local.module_tags,
    var.tags,
  )
}


###################################################
# IAM Policy for CloudtWatch Logs
###################################################

locals {
  partition  = data.aws_partition.this.partition
  region     = data.aws_region.this.name
  account_id = data.aws_caller_identity.this.account_id
  org_id     = data.aws_organizations_organization.this.id

  cloudwatch_log_group_arn = var.delivery_channels.cloudwatch_log_group.enabled ? "arn:${local.partition}:logs:${local.region}:${local.account_id}:log-group:${var.delivery_channels.cloudwatch_log_group.name}" : null

}

data "aws_iam_policy_document" "cloudwatch" {
  count = var.delivery_channels.cloudwatch_log_group.enabled ? 1 : 0

  statement {
    sid = "CreateLogStream"

    effect  = "Allow"
    actions = ["logs:CreateLogStream"]
    resources = concat(
      ["${local.cloudwatch_log_group_arn}:log-stream:${local.account_id}_CloudTrail_${local.region}*"],
      var.level == "ORGANIZATION" ? ["${local.cloudwatch_log_group_arn}:log-stream:${local.org_id}_*"] : []
    )
  }

  statement {
    sid = "PutLogEvents"

    effect  = "Allow"
    actions = ["logs:PutLogEvents"]
    resources = concat(
      ["${local.cloudwatch_log_group_arn}:log-stream:${local.account_id}_CloudTrail_${local.region}*"],
      var.level == "ORGANIZATION" ? ["${local.cloudwatch_log_group_arn}:log-stream:${local.org_id}_*"] : []
    )
  }
}
