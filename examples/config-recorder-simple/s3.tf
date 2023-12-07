data "aws_iam_policy_document" "config" {
  statement {
    sid = "AWSConfigBucketExistenceAndPermissionsCheck"

    effect = "Allow"
    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket",
    ]
    resources = [
      module.bucket.arn,
    ]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
  statement {
    sid = "AWSConfigBucketDelivery"

    effect = "Allow"
    actions = [
      "s3:PutObject",
    ]
    resources = [
      module.bucket.arn,
      "${module.bucket.arn}/AWSLogs/*/Config/*",
    ]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}


###################################################
# S3 Bucket
###################################################

resource "random_string" "this" {
  length  = 32
  special = false
  numeric = false
  upper   = false
}

locals {
  bucket_name = random_string.this.id
}

module "bucket" {
  source  = "tedilabs/data/aws//modules/s3-bucket"
  version = "~> 0.6.0"

  name          = local.bucket_name
  force_destroy = true

  policy = data.aws_iam_policy_document.config.json

  tags = {
    "project" = "terraform-aws-data-examples"
  }
}


