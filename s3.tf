
data "aws_caller_identity" "current" {
  count = var.enable_access_logs ? 1 : 0
}

resource "aws_s3_bucket" "access_logs" {
  count = var.create_access_logs_bucket ? 1 : 0

  bucket = var.access_logs_bucket_name

  tags = var.tags
}

data "aws_iam_policy_document" "s3_access_policy" {
  count = var.enable_access_logs ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current[0].account_id}:root"]
    }

    actions = ["s3:PutObject"]

    # Use the ARN of the S3 bucket created by the resource if the flag is enabled
    # or use the ARN pattern if the name is provided
    resources = var.create_access_logs_bucket ? [aws_s3_bucket.access_logs[0].arn] : ["arn:aws:s3:::${var.existing_access_logs_bucket}/*"]
  }
}

resource "aws_s3_bucket_policy" "access_logs" {
  count = var.enable_access_logs ? 1 : 0

  bucket = var.create_access_logs_bucket ? aws_s3_bucket.access_logs[0].id : var.existing_access_logs_bucket

  policy = data.aws_iam_policy_document.s3_access_policy[0].json
}