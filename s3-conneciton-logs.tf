resource "aws_s3_bucket" "connection_logs" {
  count = var.create_connection_logs_bucket ? 1 : 0

  bucket = var.connection_logs_bucket_name

  tags = var.tags
}

data "aws_iam_policy_document" "s3_connection_policy" {
  count = var.enable_connection_logs ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type = "AWS"
      # Fetch the account ID based on the region
      identifiers = ["arn:aws:iam::${local.access_log_account_id[var.region]}:root"]
    }

    actions = ["s3:PutObject"]

    # Use the ARN of the S3 bucket created by the resource if the flag is enabled
    # or use the ARN pattern if the name is provided
    resources = var.create_connection_logs_bucket ? ["${aws_s3_bucket.connection_logs[0].arn}/*"] : ["arn:aws:s3:::${var.existing_connection_logs_bucket}/*"]
  }
}

resource "aws_s3_bucket_policy" "connection_logs" {
  count = var.enable_access_logs ? 1 : 0

  bucket = var.create_access_logs_bucket ? aws_s3_bucket.connection_logs[0].id : var.existing_connection_logs_bucket

  policy = data.aws_iam_policy_document.s3_connection_policy[0].json
}