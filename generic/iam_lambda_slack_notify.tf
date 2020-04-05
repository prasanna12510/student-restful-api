##############locals############
locals {

  lambda_role_name       = "lambda-slack-role-${terraform.workspace}"
  lambda_policy_name     = "lambda-slack-policy-${terraform.workspace}"
  s3_bucket_name         = "lambda-slack-notify-${terraform.workspace}"
  write_object_to_s3     = [{
                          source = data.archive_file.notify_slack[0].output_path
                          key = "notify_slack-${var.commit_sha}.zip"
                          }]
}

#####set IAM policy for lambda function###
data "aws_iam_policy_document" "lambda_assume_role_policy_document" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "lambda_notify_slack_policy_document" {
  // allow logging to cloudwatch
  statement {
    sid       = "AllowWriteToCloudwatchLogs"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "logs:*",
      "cloudwatch:*",
      "ssm:GetParameter"
    ]
  }

  // allow to access s3 bucket
  statement {
    sid       = "AllowAccessToS3Bucket"
    effect    = "Allow"
    resources = [
                "arn:aws:s3:::${local.s3_bucket_name}",
                "arn:aws:s3:::${local.s3_bucket_name}/*"]
    actions   = ["s3:*"]
  }

}

module "lambda_slack_notify_s3_bucket" {
  source = "../../modules/terraform/aws/s3/bucket/v1.0"
  name          = local.s3_bucket_name
  acl           = var.acl
  force_destroy = var.force-destroy
  tags          = local.tags
  versioning = {
    enabled = var.versioning
  }
  s3_tags = {
    Name = local.s3_bucket_name
  }
}

module "lambda_role" {
  source = "../../modules/terraform/aws/iam/role_policy/role/v1.0"
  role_name                   = local.lambda_role_name
  iam_assume_role_policy_data = data.aws_iam_policy_document.lambda_assume_role_policy_document.json
}

module "lambda_policy" {
  source = "../../modules/terraform/aws/iam/role_policy/policy/custom/v1.0"

  iam_custom_policy_name      = local.lambda_policy_name
  iam_custom_role_policy_data = data.aws_iam_policy_document.lambda_notify_slack_policy_document.json
  role_name                   = [local.lambda_role_name]
}


#####create archive for lambda function #######
data "null_data_source" "lambda_file" {
  inputs = {
    filename = "${path.module}/notify_slack_function/notify_slack.py"
  }
}

data "null_data_source" "lambda_archive" {
  inputs = {
    filename = "${path.module}/notify_slack_function/notify_slack.zip"
  }
}

data "archive_file" "notify_slack" {
  count = 1

  type        = "zip"
  source_file = data.null_data_source.lambda_file.outputs.filename
  output_path = data.null_data_source.lambda_archive.outputs.filename
}

module  "lambda_source_upload" {
  source = "../../modules/terraform/aws/s3/object/v1.0"
  bucket_name = module.lambda_slack_notify_s3_bucket.bucket_id
  write_objects = local.write_object_to_s3
}

#######################outputs###############

output "lambda_slack_notify_role_name" {
  value = module.lambda_role.role_name
}

output "lambda_slack_notify_role_arn" {
  value = module.lambda_role.role_arn
}

output "lambda_slack_notify_s3_bucket_name" {
  value = module.lambda_slack_notify_s3_bucket.bucket_id
}

output "lambda_slack_notify_s3_bucket_key" {
  value = module.lambda_source_upload.id
}

output "lambda_slack_notify_binary_hash" {
  value = base64sha256(data.archive_file.notify_slack[0].output_path)
}
