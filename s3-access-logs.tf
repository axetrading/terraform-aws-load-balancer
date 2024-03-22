resource "aws_s3_bucket" "access_logs" {
  count = var.create_access_logs_bucket ? 1 : 0

  bucket = var.access_logs_bucket_name

  tags = var.tags
}

data "aws_iam_policy_document" "s3_access_policy" {
  count = var.enable_access_logs ? 1 : 0

  dynamic "statement" {
    for_each = var.enable_access_logs && var.load_balancer_type == "application" ? [1] : []
    content {
      effect = "Allow"

      principals {
        type = "AWS"
        # Fetch the account ID based on the region
        identifiers = ["arn:aws:iam::${local.access_log_account_id[var.region]}:root"]
      }

      actions = statement.value.actions

      # Use the ARN of the S3 bucket created by the resource if the flag is enabled
      # or use the ARN pattern if the name is provided
      resources = var.create_access_logs_bucket ? ["${aws_s3_bucket.access_logs[0].arn}/*"] : ["arn:aws:s3:::${var.existing_access_logs_bucket}/*"]
    }
  }

  dynamic "statement" {
    for_each = var.enable_access_logs && var.load_balancer_type == "network" ? [1] : []
    content {
      sid    = "AWSLogDeliveryAclCheck"
      effect = "Allow"
      principals {
        type        = "Service"
        identifiers = ["delivery.logs.amazonaws.com"]
      }
      actions   = ["s3:GetBucketAcl"]
      resources = [aws_s3_bucket.access_logs[0].arn]
      condition {
        test     = "StringEquals"
        variable = "aws:SourceAccount"
        values   = [data.aws_caller_identity.current.account_id]
      }
      condition {
        test     = "ArnLike"
        variable = "aws:SourceArn"
        values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
      }
    }
  }
  dynamic "statement" {
    for_each = var.enable_access_logs && var.load_balancer_type == "network" ? [1] : []
    content {
      sid = "AWSLogDeliveryWrite"
      actions = [
        "s3:PutObject",
      ]
      effect = "Allow"
      principals {
        type        = "Service"
        identifiers = ["delivery.logs.amazonaws.com"]
      }
      resources = ["${aws_s3_bucket.access_logs[0].arn}/*"]
      condition {
        test     = "StringEquals"
        variable = "s3:x-amz-acl"
        values   = ["bucket-owner-full-control"]
      }
      condition {
        test     = "StringEquals"
        variable = "aws:SourceAccount"
        values   = [data.aws_caller_identity.current.account_id]
      }
      condition {
        test     = "ArnLike"
        variable = "aws:SourceArn"
        values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
      }
    }
  }
}

resource "aws_s3_bucket_policy" "access_logs" {
  count = var.enable_access_logs ? 1 : 0

  bucket = var.create_access_logs_bucket ? aws_s3_bucket.access_logs[0].id : var.existing_access_logs_bucket

  policy = data.aws_iam_policy_document.s3_access_policy[0].json
}
