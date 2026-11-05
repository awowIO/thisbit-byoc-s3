# Thisbit Corporate (BYOC): AWS S3 bucket and least-privilege IAM credentials for voice walkthroughs.
#
# Repository: https://github.com/awowIO/thisbit-byoc-s3
# Docs:       https://thisbit.ai/docs/#data-flow
#
# Provisions:
# - Private S3 bucket (`aws_s3_bucket.thisbit`) with `prevent_destroy = true`
# - Full public access block (`aws_s3_bucket_public_access_block.thisbit`)
# - Server-side encryption (`AES256` or KMS)
# - Least-privilege IAM user + inline policy scoped exclusively to `studio-media/*` and `voice-reviews/*`

terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "thisbit" {
  bucket = var.bucket_name
  tags   = var.tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "thisbit" {
  bucket                  = aws_s3_bucket.thisbit.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "thisbit" {
  bucket = aws_s3_bucket.thisbit.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_iam_user" "thisbit_connector" {
  count = var.create_iam_user ? 1 : 0
  name  = var.iam_user_name != "" ? var.iam_user_name : "thisbit-byoc-${var.bucket_name}"
  tags  = var.tags
}

resource "aws_iam_user_policy" "thisbit_connector_s3" {
  count = var.create_iam_user ? 1 : 0
  name  = "thisbit-voice-storage-data-plane"
  user  = aws_iam_user.thisbit_connector[0].name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ThisbitVoicePrefixesOnly"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "${aws_s3_bucket.thisbit.arn}/studio-media/*",
          "${aws_s3_bucket.thisbit.arn}/voice-reviews/*"
        ]
      }
    ]
  })
}

resource "aws_iam_access_key" "thisbit_connector" {
  count = var.create_iam_user ? 1 : 0
  user  = aws_iam_user.thisbit_connector[0].name
}
