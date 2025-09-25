locals {
  metadata = {
    package = "terraform-aws-security"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
  }
  module_tags = var.module_tags_enabled ? {
    "module.terraform.io/package"   = local.metadata.package
    "module.terraform.io/version"   = local.metadata.version
    "module.terraform.io/name"      = local.metadata.module
    "module.terraform.io/full-name" = "${local.metadata.package}/${local.metadata.module}"
    "module.terraform.io/instance"  = local.metadata.name
  } : {}
}


###################################################
# Custom Data Identifier for Macie Account
###################################################

# INFO: Not supported attributes
# - `name_prefix`
resource "aws_macie2_custom_data_identifier" "this" {
  region = var.region

  name        = var.name
  description = var.description

  regex                  = var.regex
  keywords               = length(var.keywords) > 0 ? var.keywords : null
  ignore_words           = length(var.ignore_words) > 0 ? var.ignore_words : null
  maximum_match_distance = var.maximum_match_distance

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}
